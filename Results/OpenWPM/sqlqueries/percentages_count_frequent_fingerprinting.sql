WITH temp_table AS (
	SELECT MAX(AudioContext) AS AudioContext,
			MAX(Canvas) AS Canvas,
			MAX(CanvasFont) AS CanvasFont,
			MAX(WebGL) AS WebGL,
			MAX(WebRTC) AS WebRTC,
			MAX(JSEnum) AS JSEnum
	FROM analysis_results
	WHERE visit_id NOT IN (SELECT visit_id FROM crawl_history WHERE command == "GetCommand" AND command_status != "ok")
	GROUP BY visit_id
)
, RawPercentages AS (
    SELECT 
        'AudioContextOnly' AS TrackerType,
        COUNT(CASE WHEN AudioContext == 1.0 AND Canvas != 1.0 AND CanvasFont != 1.0 AND WebGL != 1.0 AND WebRTC != 1.0 AND JSEnum != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'CanvasOnly' AS TrackerType,
        COUNT(CASE WHEN AudioContext != 1.0 AND Canvas == 1.0 AND CanvasFont != 1.0 AND WebGL != 1.0 AND WebRTC != 1.0 AND JSEnum != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'CanvasFontOnly' AS TrackerType,
        COUNT(CASE WHEN AudioContext != 1.0 AND Canvas != 1.0 AND CanvasFont == 1.0 AND WebGL != 1.0 AND WebRTC != 1.0 AND JSEnum != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'WebGLOnly' AS TrackerType,
        COUNT(CASE WHEN AudioContext != 1.0 AND Canvas != 1.0 AND CanvasFont != 1.0 AND WebGL == 1.0 AND WebRTC != 1.0 AND JSEnum != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'WebRTCOnly' AS TrackerType,
        COUNT(CASE WHEN AudioContext != 1.0 AND Canvas != 1.0 AND CanvasFont != 1.0 AND WebGL != 1.0 AND WebRTC == 1.0 AND JSEnum != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'JSEnumOnly' AS TrackerType,
        COUNT(CASE WHEN AudioContext != 1.0 AND Canvas != 1.0 AND CanvasFont != 1.0 AND WebGL != 1.0 AND WebRTC != 1.0 AND JSEnum == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'AudioContextAndCanvas' AS TrackerType,
        COUNT(CASE WHEN AudioContext == 1.0 AND Canvas == 1.0 AND CanvasFont != 1.0 AND WebGL != 1.0 AND WebRTC != 1.0 AND JSEnum != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'AudioContextAndCanvasFont' AS TrackerType,
        COUNT(CASE WHEN AudioContext == 1.0 AND Canvas != 1.0 AND CanvasFont == 1.0 AND WebGL != 1.0 AND WebRTC != 1.0 AND JSEnum != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'AudioContextAndWebGL' AS TrackerType,
        COUNT(CASE WHEN AudioContext == 1.0 AND Canvas != 1.0 AND CanvasFont != 1.0 AND WebGL == 1.0 AND WebRTC != 1.0 AND JSEnum != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'AudioContextAndWebRTC' AS TrackerType,
        COUNT(CASE WHEN AudioContext == 1.0 AND Canvas != 1.0 AND CanvasFont != 1.0 AND WebGL != 1.0 AND WebRTC == 1.0 AND JSEnum != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'AudioContextAndJSEnum' AS TrackerType,
        COUNT(CASE WHEN AudioContext == 1.0 AND Canvas != 1.0 AND CanvasFont != 1.0 AND WebGL != 1.0 AND WebRTC != 1.0 AND JSEnum == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'CanvasAndCanvasFont' AS TrackerType,
        COUNT(CASE WHEN AudioContext != 1.0 AND Canvas == 1.0 AND CanvasFont == 1.0 AND WebGL != 1.0 AND WebRTC != 1.0 AND JSEnum != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'CanvasAndWebGL' AS TrackerType,
        COUNT(CASE WHEN AudioContext != 1.0 AND Canvas == 1.0 AND CanvasFont != 1.0 AND WebGL == 1.0 AND WebRTC != 1.0 AND JSEnum != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'CanvasAndWebRTC' AS TrackerType,
        COUNT(CASE WHEN AudioContext != 1.0 AND Canvas == 1.0 AND CanvasFont != 1.0 AND WebGL != 1.0 AND WebRTC == 1.0 AND JSEnum != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'CanvasAndJSEnum' AS TrackerType,
        COUNT(CASE WHEN AudioContext != 1.0 AND Canvas == 1.0 AND CanvasFont != 1.0 AND WebGL != 1.0 AND WebRTC != 1.0 AND JSEnum == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'CanvasFontAndWebGL' AS TrackerType,
        COUNT(CASE WHEN AudioContext != 1.0 AND Canvas != 1.0 AND CanvasFont == 1.0 AND WebGL == 1.0 AND WebRTC != 1.0 AND JSEnum != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'CanvasFontAndWebRTC' AS TrackerType,
        COUNT(CASE WHEN AudioContext != 1.0 AND Canvas != 1.0 AND CanvasFont == 1.0 AND WebGL != 1.0 AND WebRTC == 1.0 AND JSEnum != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'CanvasFontAndJSEnum' AS TrackerType,
        COUNT(CASE WHEN AudioContext != 1.0 AND Canvas != 1.0 AND CanvasFont == 1.0 AND WebGL != 1.0 AND WebRTC != 1.0 AND JSEnum == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'WebGLAndWebRTC' AS TrackerType,
        COUNT(CASE WHEN AudioContext != 1.0 AND Canvas != 1.0 AND CanvasFont != 1.0 AND WebGL == 1.0 AND WebRTC == 1.0 AND JSEnum != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'WebGLAndJSEnum' AS TrackerType,
        COUNT(CASE WHEN AudioContext != 1.0 AND Canvas != 1.0 AND CanvasFont != 1.0 AND WebGL == 1.0 AND WebRTC != 1.0 AND JSEnum == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'WebRTCAndJSEnum' AS TrackerType,
        COUNT(CASE WHEN AudioContext != 1.0 AND Canvas != 1.0 AND CanvasFont != 1.0 AND WebGL != 1.0 AND WebRTC == 1.0 AND JSEnum == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'AudioContextAndCanvasAndCanvasFont' AS TrackerType,
        COUNT(CASE WHEN AudioContext == 1.0 AND Canvas == 1.0 AND CanvasFont == 1.0 AND WebGL != 1.0 AND WebRTC != 1.0 AND JSEnum != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'AudioContextAndCanvasAndWebGL' AS TrackerType,
        COUNT(CASE WHEN AudioContext == 1.0 AND Canvas == 1.0 AND CanvasFont != 1.0 AND WebGL == 1.0 AND WebRTC != 1.0 AND JSEnum != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'AudioContextAndCanvasAndWebRTC' AS TrackerType,
        COUNT(CASE WHEN AudioContext == 1.0 AND Canvas == 1.0 AND CanvasFont != 1.0 AND WebGL != 1.0 AND WebRTC == 1.0 AND JSEnum != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'AudioContextAndCanvasAndJSEnum' AS TrackerType,
        COUNT(CASE WHEN AudioContext == 1.0 AND Canvas == 1.0 AND CanvasFont != 1.0 AND WebGL != 1.0 AND WebRTC != 1.0 AND JSEnum == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'AudioContextAndCanvasFontAndWebGL' AS TrackerType,
        COUNT(CASE WHEN AudioContext == 1.0 AND Canvas != 1.0 AND CanvasFont == 1.0 AND WebGL == 1.0 AND WebRTC != 1.0 AND JSEnum != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'AudioContextAndCanvasFontAndWebRTC' AS TrackerType,
        COUNT(CASE WHEN AudioContext == 1.0 AND Canvas != 1.0 AND CanvasFont == 1.0 AND WebGL != 1.0 AND WebRTC == 1.0 AND JSEnum != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'AudioContextAndCanvasFontAndJSEnum' AS TrackerType,
        COUNT(CASE WHEN AudioContext == 1.0 AND Canvas != 1.0 AND CanvasFont == 1.0 AND WebGL != 1.0 AND WebRTC != 1.0 AND JSEnum == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'AudioContextAndWebGLAndWebRTC' AS TrackerType,
        COUNT(CASE WHEN AudioContext == 1.0 AND Canvas != 1.0 AND CanvasFont != 1.0 AND WebGL == 1.0 AND WebRTC == 1.0 AND JSEnum != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'AudioContextAndWebGLAndJSEnum' AS TrackerType,
        COUNT(CASE WHEN AudioContext == 1.0 AND Canvas != 1.0 AND CanvasFont != 1.0 AND WebGL == 1.0 AND WebRTC != 1.0 AND JSEnum == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'AudioContextAndWebRTCAndJSEnum' AS TrackerType,
        COUNT(CASE WHEN AudioContext == 1.0 AND Canvas != 1.0 AND CanvasFont != 1.0 AND WebGL != 1.0 AND WebRTC == 1.0 AND JSEnum == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'CanvasAndCanvasFontAndWebGL' AS TrackerType,
        COUNT(CASE WHEN AudioContext != 1.0 AND Canvas == 1.0 AND CanvasFont == 1.0 AND WebGL == 1.0 AND WebRTC != 1.0 AND JSEnum != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'CanvasAndCanvasFontAndWebRTC' AS TrackerType,
        COUNT(CASE WHEN AudioContext != 1.0 AND Canvas == 1.0 AND CanvasFont == 1.0 AND WebGL != 1.0 AND WebRTC == 1.0 AND JSEnum != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'CanvasAndCanvasFontAndJSEnum' AS TrackerType,
        COUNT(CASE WHEN AudioContext != 1.0 AND Canvas == 1.0 AND CanvasFont == 1.0 AND WebGL != 1.0 AND WebRTC != 1.0 AND JSEnum == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'CanvasAndWebGLAndWebRTC' AS TrackerType,
        COUNT(CASE WHEN AudioContext != 1.0 AND Canvas == 1.0 AND CanvasFont != 1.0 AND WebGL == 1.0 AND WebRTC == 1.0 AND JSEnum != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'CanvasAndWebGLAndJSEnum' AS TrackerType,
        COUNT(CASE WHEN AudioContext != 1.0 AND Canvas == 1.0 AND CanvasFont != 1.0 AND WebGL == 1.0 AND WebRTC != 1.0 AND JSEnum == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'CanvasAndWebRTCAndJSEnum' AS TrackerType,
        COUNT(CASE WHEN AudioContext != 1.0 AND Canvas == 1.0 AND CanvasFont != 1.0 AND WebGL != 1.0 AND WebRTC == 1.0 AND JSEnum == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'CanvasFontAndWebGLAndWebRTC' AS TrackerType,
        COUNT(CASE WHEN AudioContext != 1.0 AND Canvas != 1.0 AND CanvasFont == 1.0 AND WebGL == 1.0 AND WebRTC == 1.0 AND JSEnum != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'CanvasFontAndWebGLAndJSEnum' AS TrackerType,
        COUNT(CASE WHEN AudioContext != 1.0 AND Canvas != 1.0 AND CanvasFont == 1.0 AND WebGL == 1.0 AND WebRTC != 1.0 AND JSEnum == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'CanvasFontAndWebRTCAndJSEnum' AS TrackerType,
        COUNT(CASE WHEN AudioContext != 1.0 AND Canvas != 1.0 AND CanvasFont == 1.0 AND WebGL != 1.0 AND WebRTC == 1.0 AND JSEnum == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
    UNION ALL
    SELECT 
        'WebGLAndWebRTCAndJSEnum' AS TrackerType,
        COUNT(CASE WHEN AudioContext != 1.0 AND Canvas != 1.0 AND CanvasFont != 1.0 AND WebGL == 1.0 AND WebRTC == 1.0 AND JSEnum == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
    FROM temp_table
	UNION ALL
	SELECT 
		'AudioContextAndCanvasAndCanvasFontAndWebGL' AS TrackerType,
		COUNT(CASE WHEN AudioContext == 1.0 AND Canvas == 1.0 AND CanvasFont == 1.0 AND WebGL == 1.0 AND WebRTC != 1.0 AND JSEnum != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
	FROM temp_table
	UNION ALL
	SELECT 
		'AudioContextAndCanvasAndCanvasFontAndWebRTC' AS TrackerType,
		COUNT(CASE WHEN AudioContext == 1.0 AND Canvas == 1.0 AND CanvasFont == 1.0 AND WebGL != 1.0 AND WebRTC == 1.0 AND JSEnum != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
	FROM temp_table
	UNION ALL
	SELECT 
		'AudioContextAndCanvasAndCanvasFontAndJSEnum' AS TrackerType,
		COUNT(CASE WHEN AudioContext == 1.0 AND Canvas == 1.0 AND CanvasFont == 1.0 AND WebGL != 1.0 AND WebRTC != 1.0 AND JSEnum == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
	FROM temp_table
	UNION ALL
	SELECT 
		'AudioContextAndCanvasAndWebGLAndWebRTC' AS TrackerType,
		COUNT(CASE WHEN AudioContext == 1.0 AND Canvas == 1.0 AND CanvasFont != 1.0 AND WebGL == 1.0 AND WebRTC == 1.0 AND JSEnum != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
	FROM temp_table
	UNION ALL
	SELECT 
		'AudioContextAndCanvasAndWebGLAndJSEnum' AS TrackerType,
		COUNT(CASE WHEN AudioContext == 1.0 AND Canvas == 1.0 AND CanvasFont != 1.0 AND WebGL == 1.0 AND WebRTC != 1.0 AND JSEnum == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
	FROM temp_table
	UNION ALL
	SELECT 
		'AudioContextAndCanvasAndWebRTCAndJSEnum' AS TrackerType,
		COUNT(CASE WHEN AudioContext == 1.0 AND Canvas == 1.0 AND CanvasFont != 1.0 AND WebGL != 1.0 AND WebRTC == 1.0 AND JSEnum == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
	FROM temp_table
	UNION ALL
	SELECT 
		'AudioContextAndCanvasFontAndWebGLAndWebRTC' AS TrackerType,
		COUNT(CASE WHEN AudioContext == 1.0 AND Canvas != 1.0 AND CanvasFont == 1.0 AND WebGL == 1.0 AND WebRTC == 1.0 AND JSEnum != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
	FROM temp_table
	UNION ALL
	SELECT 
		'AudioContextAndCanvasFontAndWebGLAndJSEnum' AS TrackerType,
		COUNT(CASE WHEN AudioContext == 1.0 AND Canvas != 1.0 AND CanvasFont == 1.0 AND WebGL == 1.0 AND WebRTC != 1.0 AND JSEnum == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
	FROM temp_table
	UNION ALL
	SELECT 
		'AudioContextAndCanvasFontAndWebRTCAndJSEnum' AS TrackerType,
		COUNT(CASE WHEN AudioContext == 1.0 AND Canvas != 1.0 AND CanvasFont == 1.0 AND WebGL != 1.0 AND WebRTC == 1.0 AND JSEnum == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
	FROM temp_table
	UNION ALL
	SELECT 
		'AudioContextAndWebGLAndWebRTCAndJSEnum' AS TrackerType,
		COUNT(CASE WHEN AudioContext == 1.0 AND Canvas != 1.0 AND CanvasFont != 1.0 AND WebGL == 1.0 AND WebRTC == 1.0 AND JSEnum == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
	FROM temp_table
	UNION ALL
	SELECT 
		'CanvasAndCanvasFontAndWebGLAndWebRTC' AS TrackerType,
		COUNT(CASE WHEN AudioContext != 1.0 AND Canvas == 1.0 AND CanvasFont == 1.0 AND WebGL == 1.0 AND WebRTC == 1.0 AND JSEnum != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
	FROM temp_table
	UNION ALL
	SELECT 
		'CanvasAndCanvasFontAndWebGLAndJSEnum' AS TrackerType,
		COUNT(CASE WHEN AudioContext != 1.0 AND Canvas == 1.0 AND CanvasFont == 1.0 AND WebGL == 1.0 AND WebRTC != 1.0 AND JSEnum == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
	FROM temp_table
	UNION ALL
	SELECT 
		'CanvasAndCanvasFontAndWebRTCAndJSEnum' AS TrackerType,
		COUNT(CASE WHEN AudioContext != 1.0 AND Canvas == 1.0 AND CanvasFont == 1.0 AND WebGL != 1.0 AND WebRTC == 1.0 AND JSEnum == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
	FROM temp_table
	UNION ALL
	SELECT 
		'CanvasAndWebGLAndWebRTCAndJSEnum' AS TrackerType,
		COUNT(CASE WHEN AudioContext != 1.0 AND Canvas == 1.0 AND CanvasFont != 1.0 AND WebGL == 1.0 AND WebRTC == 1.0 AND JSEnum == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
	FROM temp_table
	UNION ALL
	SELECT 
		'CanvasFontAndWebGLAndWebRTCAndJSEnum' AS TrackerType,
		COUNT(CASE WHEN AudioContext != 1.0 AND Canvas != 1.0 AND CanvasFont == 1.0 AND WebGL == 1.0 AND WebRTC == 1.0 AND JSEnum == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
	FROM temp_table
	UNION ALL
	SELECT 
		'AudioContextAndCanvasAndCanvasFontAndWebGLAndWebRTC' AS TrackerType,
		COUNT(CASE WHEN AudioContext == 1.0 AND Canvas == 1.0 AND CanvasFont == 1.0 AND WebGL == 1.0 AND WebRTC == 1.0 AND JSEnum != 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
	FROM temp_table
	UNION ALL
	SELECT 
		'AudioContextAndCanvasAndCanvasFontAndWebGLAndJSEnum' AS TrackerType,
		COUNT(CASE WHEN AudioContext == 1.0 AND Canvas == 1.0 AND CanvasFont == 1.0 AND WebGL == 1.0 AND WebRTC != 1.0 AND JSEnum == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
	FROM temp_table
	UNION ALL
	SELECT 
		'AudioContextAndCanvasAndCanvasFontAndWebRTCAndJSEnum' AS TrackerType,
		COUNT(CASE WHEN AudioContext == 1.0 AND Canvas == 1.0 AND CanvasFont == 1.0 AND WebGL != 1.0 AND WebRTC == 1.0 AND JSEnum == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
	FROM temp_table
	UNION ALL
	SELECT 
		'AudioContextAndCanvasAndWebGLAndWebRTCAndJSEnum' AS TrackerType,
		COUNT(CASE WHEN AudioContext == 1.0 AND Canvas == 1.0 AND CanvasFont != 1.0 AND WebGL == 1.0 AND WebRTC == 1.0 AND JSEnum == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
	FROM temp_table
	UNION ALL
	SELECT 
		'AudioContextAndCanvasFontAndWebGLAndWebRTCAndJSEnum' AS TrackerType,
		COUNT(CASE WHEN AudioContext == 1.0 AND Canvas != 1.0 AND CanvasFont == 1.0 AND WebGL == 1.0 AND WebRTC == 1.0 AND JSEnum == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
	FROM temp_table
	UNION ALL
	SELECT 
		'CanvasAndCanvasFontAndWebGLAndWebRTCAndJSEnum' AS TrackerType,
		COUNT(CASE WHEN AudioContext != 1.0 AND Canvas == 1.0 AND CanvasFont == 1.0 AND WebGL == 1.0 AND WebRTC == 1.0 AND JSEnum == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
	FROM temp_table
	UNION ALL
	SELECT 
		'AllTrackers' AS TrackerType,
		COUNT(CASE WHEN AudioContext == 1.0 AND Canvas == 1.0 AND CanvasFont == 1.0 AND WebGL == 1.0 AND WebRTC == 1.0 AND JSEnum == 1.0 THEN 1 END) / 732.0 * 100.0 AS Percentage
	FROM temp_table
)
SELECT 
    TrackerType, 
    FORMAT('%3.2f%%', Percentage) AS Percentage
FROM RawPercentages
ORDER BY CAST(Percentage AS REAL) DESC
