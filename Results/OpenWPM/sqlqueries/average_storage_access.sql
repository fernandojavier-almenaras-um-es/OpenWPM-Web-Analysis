SELECT FORMAT('%.2f', AVG(LocalStorage)) AS LocalStorage,
		FORMAT('%.2f', AVG(SessionStorage)) AS SessionStorage,
		FORMAT('%.2f', AVG(IndexedDB)) AS IndexedDB
FROM (
	SELECT FORMAT('%f', SUM(LocalStorage)) AS LocalStorage,
			FORMAT('%f', SUM(SessionStorage)) AS SessionStorage,
			FORMAT('%f', SUM(IndexedDB)) AS IndexedDB
	FROM analysis_results
	WHERE visit_id NOT IN (SELECT visit_id FROM crawl_history WHERE command == "GetCommand" AND command_status != "ok")
	GROUP BY visit_id
)