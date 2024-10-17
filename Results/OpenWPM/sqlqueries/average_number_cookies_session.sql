SELECT FORMAT('%.2f', AVG(CookieFirstPartySession)) AS CookieFirstPartySession,
		FORMAT('%.2f', AVG(CookieThirdPartySession)) AS CookieThirdPartySession
FROM (
	SELECT FORMAT('%f', SUM(CookieFirstPartySession)) AS CookieFirstPartySession,
			FORMAT('%f', SUM(CookieThirdPartySession)) AS CookieThirdPartySession
	FROM analysis_results
	WHERE visit_id NOT IN (SELECT visit_id FROM crawl_history WHERE command == "GetCommand" AND command_status != "ok")
	GROUP BY visit_id
)