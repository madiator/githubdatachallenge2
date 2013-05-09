SELECT day, repository_language, COUNT(day) AS count FROM
  (SELECT repository_language, UTC_USEC_TO_DAY(PARSE_UTC_USEC(created_at))/1000000/3600/24 AS day FROM githubarchive:github.timeline WHERE repository_language IS NOT NULL AND type='PushEvent')
GROUP BY day, repository_language
ORDER BY day