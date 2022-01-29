SELECT * 
 FROM subscriptions
 LIMIT 100;
 SELECT COUNT(DISTINCT segment)
 FROM subscriptions;
SELECT MIN(subscription_start), MAX(subscription_start)
FROM subscriptions;

WITH months AS 
  (SELECT
    '2017-01-01' AS first_day,
    '2017-01-31' AS last_day
  UNION
  SELECT
    '2017-02-01' AS first_day,
    '2017-02-28' AS last_day
  UNION
  SELECT
    '2017-03-01' AS first_day,
    '2017-03-31' AS last_day),
cross_join AS 
  (SELECT *
    FROM subscriptions
    CROSS JOIN months),
status AS 
  (SELECT id,
  first_day AS month,
  CASE
    WHEN (subscription_start < first_day)
      AND (subscription_end > first_day
        OR subscription_end IS NULL)
      AND (segment = 87)
    THEN 1
    ELSE 0
  END AS is_active_87,
  CASE
    WHEN (subscription_start < first_day)
      AND (subscription_end > first_day
        OR subscription_end IS NULL)
      AND (segment = 30)
    THEN 1
    ELSE 0
  END AS is_active_30,
  CASE
    WHEN (subscription_end
      BETWEEN first_day AND last_day)
      AND (segment = 87)
    THEN 1
    ELSE 0
  END AS is_canceled_87,
  CASE
    WHEN (subscription_end
      BETWEEN first_day AND last_day)
      AND (segment = 30)
    THEN 1
    ELSE 0
  END AS is_canceled_30
  FROM cross_join),
status_temporary AS 
  (SELECT month,
    SUM(is_active_87) AS sum_active_87,
    SUM(is_active_30) AS sum_active_30,
    SUM(is_canceled_87) AS sum_canceled_87,
    SUM(is_canceled_30) AS sum_canceled_30,
    (1.0 * SUM(is_canceled_87) / SUM(is_active_87)) AS churn_87,
    (1.0 * SUM(is_canceled_30) / SUM(is_active_30)) AS churn_30
  FROM status
  GROUP BY month)
SELECT *
FROM status_temporary;