SELECT DISTINCT analysis_results.top_level_url, site_visits.site_rank, SUM(analysis_results.CookieFirstPartySecure) AS CookieFirstPartySecure,
		SUM(analysis_results.CookieThirdPartySecure) AS CookieThirdPartySecure
FROM analysis_results
JOIN site_visits ON site_visits.visit_id = analysis_results.visit_id
WHERE analysis_results.CookieFirstPartySecure > 0.0 OR analysis_results.CookieThirdPartySecure > 0.0
GROUP BY analysis_results.top_level_url, site_visits.site_rank
ORDER BY site_visits.site_rank ASC