SELECT DISTINCT analysis_results.top_level_url, site_visits.site_rank, SUM(analysis_results.CookieFirstPartySession) AS CookieFirstPartySession,
		SUM(analysis_results.CookieThirdPartySession) AS CookieThirdPartySession
FROM analysis_results
JOIN site_visits ON site_visits.visit_id = analysis_results.visit_id
WHERE analysis_results.CookieFirstPartySession > 0.0 OR analysis_results.CookieThirdPartySession > 0.0
GROUP BY analysis_results.top_level_url, site_visits.site_rank
ORDER BY site_visits.site_rank ASC