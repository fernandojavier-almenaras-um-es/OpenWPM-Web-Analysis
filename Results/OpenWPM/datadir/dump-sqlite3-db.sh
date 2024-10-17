#! /bin/sh

printerr () {
	printf "Error: %s\nUsage: %s <input_database> <output_directory>\n" "$1" "$0" >&2
}

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
	printerr 'Invalid number of arguments.'
	exit 1

fi

INPUT_DB="$1"
INPUT_DB_PREFIX=$(basename "$INPUT_DB" | cut -d'.' -f1)
OUTPUT_DIR="$(realpath -m -s "$2")"

# Check if the input database file exists and is readable
if [ ! -f "$INPUT_DB" ] || [ ! -r "$INPUT_DB" ]; then
	printerr 'Input database file not found or readable.'
	exit 2

fi

# Check if the output directory exists, if not create it
if [ ! -d "$OUTPUT_DIR" ]; then
	mkdir -p "$OUTPUT_DIR"

fi

# Get the list of tables in the database
TABLES=$(sqlite3 -readonly "$INPUT_DB" <<-EOF | tr '\n' ' ' | tr -s ' '
	.tables
EOF
)

# Dump each table into a separate file
for TABLE in $TABLES; do
	OUTPUT_FILE="$OUTPUT_DIR/$INPUT_DB_PREFIX-$TABLE"

	sqlite3 -readonly "$INPUT_DB" <<-EOF
		.output "$OUTPUT_FILE.sql"
		.dump "$TABLE"
	EOF

	if [ "$(stat -c%s "$OUTPUT_FILE.sql")" -gt $((49 * 1024 * 1024)) ]; then
		split -C 49M -d --additional-suffix='.sql' "$OUTPUT_FILE.sql" "$OUTPUT_FILE"
		rm "$OUTPUT_FILE.sql"

	fi
done

printf "Database %s tables dumped to %s\n" "$INPUT_DB" "$OUTPUT_DIR"

exit 0
