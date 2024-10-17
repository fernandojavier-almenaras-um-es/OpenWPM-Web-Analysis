SELECT FORMAT('%.2f', AVG(CookieFirstPartyHost)) AS CookieFirstPartyHost,
		FORMAT('%.2f', AVG(CookieThirdPartyHost)) AS CookieThirdPartyHost
FROM (
	SELECT FORMAT('%f', SUM(CookieFirstPartyHost)) AS CookieFirstPartyHost,
			FORMAT('%f', SUM(CookieThirdPartyHost)) AS CookieThirdPartyHost
	FROM analysis_results
	WHERE visit_id NOT IN (SELECT visit_id FROM crawl_history WHERE command == "GetCommand" AND command_status != "ok")
	GROUP BY visit_id
)