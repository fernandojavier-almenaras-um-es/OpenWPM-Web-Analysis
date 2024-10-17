SELECT FORMAT('%.2f', AVG(CookieFirstPartySecure)) AS CookieFirstPartySecure,
		FORMAT('%.2f', AVG(CookieThirdPartySecure)) AS CookieThirdPartySecure
FROM (
	SELECT FORMAT('%f', SUM(CookieFirstPartySecure)) AS CookieFirstPartySecure,
			FORMAT('%f', SUM(CookieThirdPartySecure)) AS CookieThirdPartySecure
	FROM analysis_results
	WHERE visit_id NOT IN (SELECT visit_id FROM crawl_history WHERE command == "GetCommand" AND command_status != "ok")
	GROUP BY visit_id
)