SELECT FORMAT('%3.2f%%', COUNT(DISTINCT CASE WHEN GoogleAnalytics == 1.0 THEN visit_id END) / 732.0 * 100.0, 2) AS GoogleAnalytics,
		FORMAT('%3.2f%%', COUNT(DISTINCT CASE WHEN MetaPixel == 1.0 THEN visit_id END) / 732.0 * 100.0, 2) AS MetaPixel,
		FORMAT('%3.2f%%', COUNT(DISTINCT CASE WHEN MicrosoftUET == 1.0 THEN visit_id END) / 732.0 * 100.0, 2) AS MicrosoftUET,
		FORMAT('%3.2f%%', COUNT(DISTINCT CASE WHEN Hotjar == 1.0 THEN visit_id END) / 732.0 * 100.0, 2) AS Hotjar
FROM analysis_results
WHERE visit_id NOT IN (SELECT visit_id FROM crawl_history WHERE command == "GetCommand" AND command_status != "ok")