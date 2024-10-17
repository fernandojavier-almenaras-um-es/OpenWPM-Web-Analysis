WITH temp_table AS (
	SELECT MAX(CASE WHEN AudioContext == 1.0 OR Canvas == 1.0 OR CanvasFont == 1.0 OR WebGL == 1.0 OR WebRTC == 1.0 OR JSEnum == 1.0 THEN 1.0 ELSE 0.0 END) AS Fingerprinting,
			MAX(CASE WHEN GoogleAnalytics == 1.0 OR MetaPixel == 1.0 OR MicrosoftUET == 1.0 OR Hotjar == 1.0 THEN 1.0 ELSE 0.0 END) AS Analytics,
			MAX(CASE WHEN CookieFirstPartyTotal > 0.0 OR CookieThirdPartyTotal > 0.0 THEN 1.0 ELSE 0.0 END) AS Cookies,
			MAX(CASE WHEN LocalStorage > 0.0 OR SessionStorage > 0.0 OR IndexedDB > 0.0 THEN 1.0 ELSE 0.0 END) AS Storage
	FROM analysis_results
	WHERE visit_id NOT IN (SELECT visit_id FROM crawl_history WHERE command == "GetCommand" AND command_status != "ok")
	GROUP BY visit_id
)
-- SELECT FORMAT('%3.2f%%', COUNT(CASE WHEN Fingerprinting == 1.0 AND Analytics != 1.0 AND Cookies != 1.0 AND Storage != 1.0 THEN 1 END) / 732.0 * 100.0) AS FingerprintingOnly,
-- 		FORMAT('%3.2f%%', COUNT(CASE WHEN Fingerprinting != 1.0 AND Analytics == 1.0 AND Cookies != 1.0 AND Storage != 1.0 THEN 1 END) / 732.0 * 100.0) AS AnalyticsOnly,
-- 		FORMAT('%3.2f%%', COUNT(CASE WHEN Fingerprinting != 1.0 AND Analytics != 1.0 AND Cookies == 1.0 AND Storage != 1.0 THEN 1 END) / 732.0 * 100.0) AS CookiesOnly,
-- 		FORMAT('%3.2f%%', COUNT(CASE WHEN Fingerprinting != 1.0 AND Analytics != 1.0 AND Cookies != 1.0 AND Storage == 1.0 THEN 1 END) / 732.0 * 100.0) AS StorageOnly,
-- 		FORMAT('%3.2f%%', COUNT(CASE WHEN Fingerprinting == 1.0 AND Analytics == 1.0 AND Cookies != 1.0 AND Storage != 1.0 THEN 1 END) / 732.0 * 100.0) AS FingerprintingAndAnalytics,
-- 		FORMAT('%3.2f%%', COUNT(CASE WHEN Fingerprinting == 1.0 AND Analytics != 1.0 AND Cookies == 1.0 AND Storage != 1.0 THEN 1 END) / 732.0 * 100.0) AS FingerprintingAndCookies,
-- 		FORMAT('%3.2f%%', COUNT(CASE WHEN Fingerprinting == 1.0 AND Analytics != 1.0 AND Cookies != 1.0 AND Storage == 1.0 THEN 1 END) / 732.0 * 100.0) AS FingerprintingAndStorage,
-- 		FORMAT('%3.2f%%', COUNT(CASE WHEN Fingerprinting != 1.0 AND Analytics == 1.0 AND Cookies == 1.0 AND Storage != 1.0 THEN 1 END) / 732.0 * 100.0) AS AnalyticsAndCookies,
-- 		FORMAT('%3.2f%%', COUNT(CASE WHEN Fingerprinting != 1.0 AND Analytics == 1.0 AND Cookies != 1.0 AND Storage == 1.0 THEN 1 END) / 732.0 * 100.0) AS AnalyticsAndStorage,
-- 		FORMAT('%3.2f%%', COUNT(CASE WHEN Fingerprinting != 1.0 AND Analytics != 1.0 AND Cookies == 1.0 AND Storage == 1.0 THEN 1 END) / 732.0 * 100.0) AS CookiesAndStorage,
-- 		FORMAT('%3.2f%%', COUNT(CASE WHEN Fingerprinting == 1.0 AND Analytics == 1.0 AND Cookies == 1.0 AND Storage != 1.0 THEN 1 END) / 732.0 * 100.0) AS FingerprintingAndAnalyticsAndCookies,
-- 		FORMAT('%3.2f%%', COUNT(CASE WHEN Fingerprinting == 1.0 AND Analytics == 1.0 AND Cookies != 1.0 AND Storage == 1.0 THEN 1 END) / 732.0 * 100.0) AS FingerprintingAndAnalyticsAndStorage,
-- 		FORMAT('%3.2f%%', COUNT(CASE WHEN Fingerprinting == 1.0 AND Analytics != 1.0 AND Cookies == 1.0 AND Storage == 1.0 THEN 1 END) / 732.0 * 100.0) AS FingerprintingAndCookiesAndStorage,
-- 		FORMAT('%3.2f%%', COUNT(CASE WHEN Fingerprinting != 1.0 AND Analytics == 1.0 AND Cookies == 1.0 AND Storage == 1.0 THEN 1 END) / 732.0 * 100.0) AS AnalyticsAndCookiesAndStorage,
-- 		FORMAT('%3.2f%%', COUNT(CASE WHEN Fingerprinting == 1.0 AND Analytics == 1.0 AND Cookies == 1.0 AND Storage == 1.0 THEN 1 END) / 732.0 * 100.0) AS AllTrackers
-- FROM temp_table
, RawPercentages AS (
    SELECT 
        'FingerprintingOnly' AS TrackerType,
        COUNT(CASE WHEN Fingerprinting == 1.0 AND Analytics != 1.0 AND Cookies != 1.0 AND Storage != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'AnalyticsOnly' AS TrackerType,
        COUNT(CASE WHEN Fingerprinting != 1.0 AND Analytics == 1.0 AND Cookies != 1.0 AND Storage != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'CookiesOnly' AS TrackerType,
        COUNT(CASE WHEN Fingerprinting != 1.0 AND Analytics != 1.0 AND Cookies == 1.0 AND Storage != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'StorageOnly' AS TrackerType,
        COUNT(CASE WHEN Fingerprinting != 1.0 AND Analytics != 1.0 AND Cookies != 1.0 AND Storage == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'AllTrackers' AS TrackerType,
        COUNT(CASE WHEN Fingerprinting == 1.0 AND Analytics == 1.0 AND Cookies == 1.0 AND Storage == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'FingerprintingAndAnalytics' AS TrackerType,
        COUNT(CASE WHEN Fingerprinting == 1.0 AND Analytics == 1.0 AND Cookies != 1.0 AND Storage != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'FingerprintingAndCookies' AS TrackerType,
        COUNT(CASE WHEN Fingerprinting == 1.0 AND Analytics != 1.0 AND Cookies == 1.0 AND Storage != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'FingerprintingAndStorage' AS TrackerType,
        COUNT(CASE WHEN Fingerprinting == 1.0 AND Analytics != 1.0 AND Cookies != 1.0 AND Storage == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'AnalyticsAndCookies' AS TrackerType,
        COUNT(CASE WHEN Fingerprinting != 1.0 AND Analytics == 1.0 AND Cookies == 1.0 AND Storage != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'AnalyticsAndStorage' AS TrackerType,
        COUNT(CASE WHEN Fingerprinting != 1.0 AND Analytics == 1.0 AND Cookies != 1.0 AND Storage == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'CookiesAndStorage' AS TrackerType,
        COUNT(CASE WHEN Fingerprinting != 1.0 AND Analytics != 1.0 AND Cookies == 1.0 AND Storage == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'FingerprintingAndAnalyticsAndCookies' AS TrackerType,
        COUNT(CASE WHEN Fingerprinting == 1.0 AND Analytics == 1.0 AND Cookies == 1.0 AND Storage != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'FingerprintingAndAnalyticsAndStorage' AS TrackerType,
        COUNT(CASE WHEN Fingerprinting == 1.0 AND Analytics == 1.0 AND Cookies != 1.0 AND Storage == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'FingerprintingAndCookiesAndStorage' AS TrackerType,
        COUNT(CASE WHEN Fingerprinting == 1.0 AND Analytics != 1.0 AND Cookies == 1.0 AND Storage == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'AnalyticsAndCookiesAndStorage' AS TrackerType,
        COUNT(CASE WHEN Fingerprinting != 1.0 AND Analytics == 1.0 AND Cookies == 1.0 AND Storage == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
)
SELECT 
    TrackerType, 
    FORMAT('%3.2f%%', Percentage) AS Percentage
FROM RawPercentages
ORDER BY CAST(Percentage AS REAL) DESC
