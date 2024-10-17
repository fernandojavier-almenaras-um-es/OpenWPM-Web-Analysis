SELECT FORMAT('%3.2f%%', COUNT(DISTINCT CASE WHEN AudioContext == 1.0 OR Canvas == 1.0 OR CanvasFont == 1.0 OR WebGL == 1.0 OR WebRTC == 1.0 OR JSEnum == 1.0 THEN visit_id END) / 732.0 * 100.0, 2) AS Fingeprinting,
		FORMAT('%3.2f%%', COUNT(DISTINCT CASE WHEN GoogleAnalytics == 1.0 OR MetaPixel == 1.0 OR MicrosoftUET == 1.0 OR Hotjar == 1.0 THEN visit_id END) / 732.0 * 100.0, 2) AS Analytics,
		FORMAT('%3.2f%%', COUNT(DISTINCT CASE WHEN CookieFirstPartyTotal > 0.0 OR CookieThirdPartyTotal > 0.0 THEN visit_id END) / 732.0 * 100.0, 2) AS Cookies,
		FORMAT('%3.2f%%', COUNT(DISTINCT CASE WHEN LocalStorage > 0.0 OR SessionStorage > 0.0 OR IndexedDB > 0.0 THEN visit_id END) / 732.0 * 100.0, 2) AS Storage
FROM analysis_results
WHERE visit_id NOT IN (SELECT visit_id FROM crawl_history WHERE command == "GetCommand" AND command_status != "ok")