WITH temp_table AS (
	SELECT MAX(CASE WHEN AudioContext == 1.0 OR Canvas == 1.0 OR CanvasFont == 1.0 OR WebGL == 1.0 OR WebRTC == 1.0 OR JSEnum == 1.0 THEN 1.0 ELSE 0.0 END) AS Fingerprinting,
			MAX(CASE WHEN GoogleAnalytics == 1.0 OR MetaPixel == 1.0 OR MicrosoftUET == 1.0 OR Hotjar == 1.0 THEN 1.0 ELSE 0.0 END) AS Analytics,
			MAX(CASE WHEN CookieFirstPartyTotal > 0.0 OR CookieThirdPartyTotal > 0.0 THEN 1.0 ELSE 0.0 END) AS Cookies,
			MAX(CASE WHEN LocalStorage > 0.0 OR SessionStorage > 0.0 OR IndexedDB > 0.0 THEN 1.0 ELSE 0.0 END) AS Storage
	FROM analysis_results
	WHERE visit_id NOT IN (SELECT visit_id FROM crawl_history WHERE command == "GetCommand" AND command_status != "ok")
	GROUP BY visit_id
)
SELECT FORMAT('%3.2f%%', COUNT(CASE WHEN (Fingerprinting + Analytics + Cookies + Storage) == 0.0 THEN 1.0 END) / 732.0 * 100.0, 2) AS ZeroTrackers,
		FORMAT('%3.2f%%', COUNT(CASE WHEN (Fingerprinting + Analytics + Cookies + Storage) == 1.0 THEN 1.0 END) / 732.0 * 100.0, 2) AS OneTracker,
		FORMAT('%3.2f%%', COUNT(CASE WHEN (Fingerprinting + Analytics + Cookies + Storage) == 2.0 THEN 1.0 END) / 732.0 * 100.0, 2) AS TwoTrackers,
		FORMAT('%3.2f%%', COUNT(CASE WHEN (Fingerprinting + Analytics + Cookies + Storage) == 3.0 THEN 1.0 END) / 732.0 * 100.0, 2) AS ThreeTrackers,
		FORMAT('%3.2f%%', COUNT(CASE WHEN (Fingerprinting + Analytics + Cookies + Storage) == 4.0 THEN 1.0 END) / 732.0 * 100.0, 2) AS FourTrackers
FROM temp_table