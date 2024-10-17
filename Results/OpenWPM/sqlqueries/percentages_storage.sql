SELECT FORMAT('%3.2f%%', COUNT(DISTINCT CASE WHEN LocalStorage > 0.0 THEN visit_id END) / 732.0 * 100.0, 2) AS LocalStorage,
		FORMAT('%3.2f%%', COUNT(DISTINCT CASE WHEN SessionStorage > 0.0 THEN visit_id END) / 732.0 * 100.0, 2) AS SessionStorage,
		FORMAT('%3.2f%%', COUNT(DISTINCT CASE WHEN IndexedDB > 0.0 THEN visit_id END) / 732.0 * 100.0, 2) AS IndexedDB
FROM analysis_results
WHERE visit_id NOT IN (SELECT visit_id FROM crawl_history WHERE command == "GetCommand" AND command_status != "ok")