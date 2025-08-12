
-- 1) Forum post in April 2048 that mentions EmptyStack AND dad
SELECT p.*
FROM forum_posts p
WHERE p.date >= DATE '2048-04-01'
  AND p.date <  DATE '2048-05-01'
  AND (p.title || ' ' || p.content) ILIKE '%emptystack%'
  AND (p.title || ' ' || p.content) ILIKE '%dad%';


-- 2) First + last name of that post’s author

SELECT a.first_name, a.last_name
FROM forum_posts    p
JOIN forum_accounts a
  ON a.username = p.author
WHERE p.date >= DATE '2048-04-01'
  AND p.date <  DATE '2048-05-01'
  AND (p.title || ' ' || p.content) ILIKE '%emptystack%'
  AND (p.title || ' ' || p.content) ILIKE '%dad%';


-- 3) All accounts with the same last name (forum + emptystack)

WITH all_accts AS (
  SELECT username, last_name FROM forum_accounts
  UNION ALL
  SELECT username, last_name FROM emptystack_accounts
)
SELECT last_name, array_agg(username ORDER BY username) AS usernames
FROM all_accts
GROUP BY last_name
HAVING COUNT(*) > 1;


-- 4) All employees with the same last name

SELECT last_name, array_agg(username ORDER BY username) AS usernames
FROM emptystack_accounts
GROUP BY last_name
HAVING COUNT(*) > 1;


-- 5) Employee message concerning the TAXI project
SELECT m.*
FROM emptystack_messages m
JOIN emptystack_projects p
  ON (m.subject ILIKE '%' || p.code || '%'
   OR  m.body    ILIKE '%' || p.code || '%')
WHERE p.code ILIKE '%taxi%';

-- 6) Credentials of the admin account
-- Pull creds for whoever sent a TAXI-related message.

SELECT e.username, e.password
FROM emptystack_accounts e
WHERE e.username IN (
  SELECT DISTINCT m."from"
  FROM emptystack_messages m
  JOIN emptystack_projects p
    ON (m.subject ILIKE '%' || p.code || '%'
     OR  m.body    ILIKE '%' || p.code || '%')
  WHERE p.code ILIKE '%taxi%'
);

-- 7) ID of the TAXI project
SELECT id
FROM emptystack_projects
WHERE code ILIKE '%taxi%';