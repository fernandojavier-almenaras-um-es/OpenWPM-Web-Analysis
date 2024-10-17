PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE task (
    task_id INTEGER PRIMARY KEY AUTOINCREMENT,
    start_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    manager_params TEXT NOT NULL,
    openwpm_version TEXT NOT NULL,
    browser_version TEXT NOT NULL);
INSERT INTO task VALUES(2980280373,'2024-04-06 13:39:18','{"_failure_limit":null,"data_directory":"./datadir","log_path":"./openwpm.log","logger_address":["127.0.0.1",40559],"memory_watchdog":false,"num_browsers":1,"process_watchdog":false,"screenshot_path":"./datadir/screenshots","source_dump_path":"./datadir/sources","storage_controller_address":["127.0.0.1",42221],"testing":false}','v0.28.0','121.0');
COMMIT;
