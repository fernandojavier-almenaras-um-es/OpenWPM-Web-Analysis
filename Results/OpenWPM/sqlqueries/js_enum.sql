SELECT DISTINCT analysis_results.top_level_url, site_visits.site_rank
FROM analysis_results
JOIN site_visits ON site_visits.visit_id = analysis_results.visit_id
WHERE analysis_results.JSEnum == 1.0
ORDER BY site_visits.site_rank ASC