SELECT DISTINCT analysis_results.top_level_url, site_visits.site_rank, SUM(analysis_results.CookieFirstPartyHost) AS CookieFirstPartyHost,
		SUM(analysis_results.CookieThirdPartyHost) AS CookieThirdPartyHost
FROM analysis_results
JOIN site_visits ON site_visits.visit_id = analysis_results.visit_id
WHERE analysis_results.CookieFirstPartyHost > 0.0 OR analysis_results.CookieThirdPartyHost > 0.0
GROUP BY analysis_results.top_level_url, site_visits.site_rank
ORDER BY site_visits.site_rank ASC