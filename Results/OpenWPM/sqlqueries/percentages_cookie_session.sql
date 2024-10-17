SELECT FORMAT('%3.2f%%', COUNT(DISTINCT CASE WHEN CookieFirstPartySession > 0.0 THEN visit_id END) / 732.0 * 100.0, 2) AS CookieFirstPartySession,
		FORMAT('%3.2f%%', COUNT(DISTINCT CASE WHEN CookieThirdPartySession > 0.0 THEN visit_id END) / 732.0 * 100.0, 2) AS CookieThirdPartySession
FROM analysis_results
WHERE visit_id NOT IN (SELECT visit_id FROM crawl_history WHERE command == "GetCommand" AND command_status != "ok")