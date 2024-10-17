SELECT COUNT(DISTINCT CASE WHEN command_status == "ok" THEN visit_id END) AS ok,
		COUNT(DISTINCT CASE WHEN command_status != "ok" THEN visit_id END) AS error
FROM crawl_history
WHERE command == "GetCommand"
