#! /bin/sh

# Function to print error messages
printerr() {
	printf "Error: %s\nUsage: %s <output_database> <sql_files_directory>\n" "$1" "$0" >&2
}

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
	printerr 'Invalid number of arguments.'
	exit 1

fi

OUTPUT_DB="$1"
SQL_FILES_DIR="$(realpath -m -s "$2")"

# Check if the output database file already exists
if [ -f "$OUTPUT_DB" ]; then
	printerr 'Output database file already exists.'
	exit 2

fi

# Check if the SQL files directory exists and is readable
if [ ! -d "$SQL_FILES_DIR" ] || [ ! -r "$SQL_FILES_DIR" ]; then
	printerr 'SQL files directory not found or readable.'
	exit 3

fi

# Create the SQLite3 database
# Iterate over each SQL file in the directory and execute it
for SQL_FILE in $(find "$SQL_FILES_DIR"/*.sql | sort); do

	if [ -f "$SQL_FILE" ] && [ -r "$SQL_FILE" ]; then
		sqlite3 "$OUTPUT_DB" <<-EOF
			BEGIN TRANSACTION;
			.read "$SQL_FILE"
			COMMIT;
		EOF
	fi
done

printf "Database %s created from SQL files in %s\n" "$OUTPUT_DB" "$SQL_FILES_DIR"

exit 0