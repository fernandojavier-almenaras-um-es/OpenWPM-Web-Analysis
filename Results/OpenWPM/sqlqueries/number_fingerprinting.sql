SELECT DISTINCT site_visits.site_url, site_visits.site_rank
FROM analysis_results
JOIN site_visits ON site_visits.visit_id = analysis_results.visit_id
WHERE analysis_results.AudioContext == 1.0 OR
	analysis_results.Canvas == 1.0 OR
	analysis_results.CanvasFont == 1.0 OR
	analysis_results.WebGL == 1.0 OR
	analysis_results.WebRTC == 1.0 OR
	analysis_results.JSEnum == 1.0
GROUP BY site_visits.site_rank
ORDER BY site_visits.site_rank ASC
