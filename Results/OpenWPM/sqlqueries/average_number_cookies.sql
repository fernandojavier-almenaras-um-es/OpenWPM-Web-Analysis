SELECT FORMAT('%.2f', AVG(CookieFirstPartyTotal)) AS CookieFirstPartyTotal,
		FORMAT('%.2f', AVG(CookieThirdPartyTotal)) AS CookieThirdPartyTotal
FROM (
	SELECT FORMAT('%f', SUM(CookieFirstPartyTotal)) AS CookieFirstPartyTotal,
			FORMAT('%f', SUM(CookieThirdPartyTotal)) AS CookieThirdPartyTotal
	FROM analysis_results
	WHERE visit_id NOT IN (SELECT visit_id FROM crawl_history WHERE command == "GetCommand" AND command_status != "ok")
	GROUP BY visit_id
)