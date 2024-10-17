SELECT FORMAT('%3.2f%%', COUNT(DISTINCT CASE WHEN CookieFirstPartyTotal > 0.0 THEN visit_id END) / 732.0 * 100.0, 2) AS CookieFirstPartyTotal,
		FORMAT('%3.2f%%', COUNT(DISTINCT CASE WHEN CookieThirdPartyTotal > 0.0 THEN visit_id END) / 732.0 * 100.0, 2) AS CookieThirdPartyTotal
FROM analysis_results
WHERE visit_id NOT IN (SELECT visit_id FROM crawl_history WHERE command == "GetCommand" AND command_status != "ok")