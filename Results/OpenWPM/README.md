# OpenWPM Results

## datadir

The `datadir` directory contains the results of the OpenWPM analysis. Because of its size, the database is not included in this repository as it is. But, several dump files were generated from its content and the database can be recreated by running the `create-sqlite3-db.sh` script. For example to recreate the database with the name `crawl-data.sqlite`, run:

```sh
sh create-sqlite3-db.sh crawl-data.sqlite crawl-data.tables.sqlite3
```

Also, it is left the `dump-sqlite3-db.sh` script, which was used in the process of generating the dump files. I should note that, althrough the `create-sqlite3-db.sh` script should be POSIX compliant and could be executed in non *nix systems, such as FreeBSD, the `dump-sqlite3-db.sh` script uses the GNU coreutils' utility `split` to split the dump files in smaller parts. So, please consider this if you are using it in, for example, FreeBSD, where the `split` command do not have the `-C` option.

### License

The LevelDB database, under the `datadir/crawl-data.leveldb` directory; all the SQL dump files, under the `datadir/crawl-data.tables.sqlite3` directory; and the results of executing these dump files; © 2024 are licensed under [CC BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/) license.

## sqlqueries

The `sqlqueries` directory constains the queries used to retrieve the data from the `analysis_results` table.
