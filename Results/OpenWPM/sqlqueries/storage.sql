SELECT DISTINCT analysis_results.top_level_url, site_visits.site_rank, SUM(analysis_results.LocalStorage) AS LocalStorage,
		SUM(analysis_results.SessionStorage) AS SessionStorage, SUM(analysis_results.IndexedDB) AS IndexedDB
FROM analysis_results
JOIN site_visits ON site_visits.visit_id = analysis_results.visit_id
WHERE analysis_results.LocalStorage > 0.0 OR analysis_results.SessionStorage > 0.0 OR analysis_results.IndexedDB > 0.0
GROUP BY analysis_results.top_level_url, site_visits.site_rank
ORDER BY site_visits.site_rank ASC