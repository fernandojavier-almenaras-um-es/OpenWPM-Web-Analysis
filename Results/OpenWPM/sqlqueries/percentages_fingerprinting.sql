SELECT FORMAT('%3.2f%%', COUNT(DISTINCT CASE WHEN AudioContext == 1.0 THEN visit_id END) / 732.0 * 100.0, 2) AS AudioContext,
		FORMAT('%3.2f%%', COUNT(DISTINCT CASE WHEN Canvas == 1.0 THEN visit_id END) / 732.0 * 100.0, 2) AS Canvas,
		FORMAT('%3.2f%%', COUNT(DISTINCT CASE WHEN CanvasFont == 1.0 THEN visit_id END) / 732.0 * 100.0, 2) AS CanvasFont,
		FORMAT('%3.2f%%', COUNT(DISTINCT CASE WHEN WebGL == 1.0 THEN visit_id END) / 732.0 * 100.0, 2) AS WebGL,
		FORMAT('%3.2f%%', COUNT(DISTINCT CASE WHEN WebRTC == 1.0 THEN visit_id END) / 732.0 * 100.0, 2) AS WebRTC,
		FORMAT('%3.2f%%', COUNT(DISTINCT CASE WHEN JSEnum == 1.0 THEN visit_id END) / 732.0 * 100.0, 2) AS JSEnum
FROM analysis_results
WHERE visit_id NOT IN (SELECT visit_id FROM crawl_history WHERE command == "GetCommand" AND command_status != "ok")