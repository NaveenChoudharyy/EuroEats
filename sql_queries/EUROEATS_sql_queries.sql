
-- Using [EuroEatsDB] database
use [EuroEatsDB];

/* ============================================================================

   EUROEATS — BUSINESS SQL ANALYSIS

   ----------------------------------------------------------------------------
   Database: EuroEats Relational Database — 9 Tables • 14,967 Rows

   Tables: customers, restaurants, menu_items, drivers, orders,
           order_items, deliveries, payments, reviews
   ----------------------------------------------------------------------------

   The following SQL analysis contains a set of
   business-driven analytical requirements provided by EuroEats
   Operations, Product, Marketing, and Leadership teams.

   The queries are designed to answer practical business questions around
   customer behavior and loyalty, restaurant and menu performance, revenue
   and promotions, payment performance, delivery operations, driver efficiency,
   customer satisfaction, and cross-functional business performance.

   These requirements simulate a real-world analytics workflow where
   business stakeholders define analytical questions and the Data Analytics
   team uses SQL to extract, analyze, and interpret insights from the
   EuroEats relational database.

   The analysis covers:

   • Customer Insights & Loyalty
   • Restaurant & Menu Performance
   • Revenue, Orders & Promotions
   • Delivery & Driver Operations
   • Strategic & Cross-Functional Analysis

   The SQL solutions make use of practical analytical techniques including
   joins, aggregations, subqueries, CTEs, window functions, ranking,
   conditional logic, date-based analysis, and comparative analysis.

   Objective:
   Transform business requirements into meaningful SQL-based insights
   that can support operational decision-making, customer retention,
   restaurant partnerships, revenue optimization, delivery performance,
   driver management, and overall business improvement.

   ----------------------------------------------------------------------------
   Business Context:

   EuroEats is a food-delivery marketplace operating across 15 European
   countries. Leadership wants to understand what drives delivery times,
   where operational performance is weakest, how customers and restaurants
   are performing, and how the business can improve the reliability of
   delivery estimates.

   The analysis also supports the broader business objective of understanding
   customer satisfaction, revenue performance, promotions, driver operations,
   and restaurant health.

   ----------------------------------------------------------------------------
   Primary Analytical Focus:

   1. Customer & Loyalty Analysis
   2. Restaurant & Menu Analysis
   3. Revenue & Promotion Analysis
   4. Delivery & Driver Analysis
   5. Customer Satisfaction Analysis
   6. Cross-Functional Business Analysis

   ----------------------------------------------------------------------------


    ** Queries
    ------------

----Customer Insights & Loyalty

1.  Which customer segments (Budget, Regular, Premium) place the most orders, and how does that mix differ
by country?

2.  Who are EuroEats's 10 highest lifetime-spend customers?

3.  Which customers have had orders delivered but have never left a review?

4.  Rank all customers by total spend and group them into spending tiers, so Marketing can target the top tier
with a loyalty offer.

5.  Which customers haven't placed an order in the 90 days before the most recent order on the platform —
good candidates for a win-back campaign?

6.  For each customer, show how their total spend has built up over time, so the loyalty team can see who is
close to the next reward tier.


----Restaurant & Menu Performance
7.  Which restaurants bring in the most revenue, and does the answer change by country?

8.  What are the 10 most frequently ordered menu items on the platform?


9.  Which restaurants have the strongest customer ratings, and how many reviews is that rating actually based
on?

10.  For each restaurant, what are its three best-selling menu items? Restaurant partners keep asking us this.

11.  Which cuisine types offer the highest share of vegetarian dishes, and do those cuisines also see higher
order volume?


12.  Which restaurants take noticeably longer to prepare food than the platform average, ranked within their
own country, so our partnerships team knows who to talk to first?
Revenue, Orders & Promotions

13.  What does total revenue look like by country and by month, and is it trending up or down?

14.  What is the month-over-month revenue growth rate for the platform?

15.  What share of orders use a discount, and does typical discount size differ by country?

16.  Which payment methods fail most often, and is it worth flagging any of them to the payments team?

17.  How much order value has EuroEats lost to cancellations and refunds, broken down by country?

18.  For every country, which single restaurant generates the most revenue — we want a shortlist for a 'featured
partner' promotion.


----Delivery & Driver Operations

19.  How does average delivery time change across different traffic and weather conditions?

20.  What share of deliveries come in late, and does that cluster around particular traffic conditions?

21.  Which drivers combine a strong rating with high delivery volume — our candidates for a 'driver of the
month' recognition program?

22.  Does delivery performance differ meaningfully by vehicle type, and should that change how we recruit
drivers in any particular city?

23.  What is the typical (not just average) delivery time under each traffic condition? We want a realistic number
for the checkout ETA, not one skewed by outliers.

24.  Are there cases of different customers, in the same city, ordering from the same restaurant on the same
day? Ops wants to know if batching these deliveries is worth exploring.


----Strategic & Cross-Functional Questions

25.  Which countries have the fastest and the slowest average delivery times, and what in the data might
explain that gap?

26.  Do bigger orders tend to carry bigger discounts, and could that be quietly eating into our margin?

27.  Which restaurant-and-city combinations produce delayed deliveries most often, and should be first in line
for an operational review?

28.  Is there any real relationship between a restaurant's rating and how much business it does, or are they
unrelated?

29.  Do full-time, part-time, and freelance drivers actually perform differently, or is that a myth?

30.  Build one view that connects an order through to its delivery and its review, so Leadership can see
operational performance and customer satisfaction side by side in a single quarterly report.

============================================================================ */


--------------------------------------------------------------------------------------------------------
------------------------------------------------Solution------------------------------------------------
--------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------
-- 1. Which customer segments (Budget, Regular, Premium) place the most orders,
--    and how does that mix differ by country?
--------------------------------------------------------------------------------------------------------
WITH SegmentOrders AS
(
    SELECT
        c.country,
        c.customer_segment,
        COUNT(o.order_id) AS total_orders
    FROM dbo.customers AS c
    INNER JOIN dbo.orders AS o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.country,
        c.customer_segment
)
SELECT
    country,
    customer_segment,
    total_orders,
    SUM(total_orders) OVER (PARTITION BY country) AS country_total_orders,
    ROUND(
        100.0 * total_orders
        / SUM(total_orders) OVER (PARTITION BY country),
        2
    ) AS order_mix_pct,
    RANK() OVER
    (
        PARTITION BY country
        ORDER BY total_orders DESC
    ) AS segment_rank
FROM SegmentOrders
ORDER BY
    country,
    segment_rank;


--------------------------------------------------------------------------------------------------------
-- 2. Who are EuroEats's 10 highest lifetime-spend customers?
--------------------------------------------------------------------------------------------------------
SELECT TOP 10
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.country,
    c.customer_segment,
    COUNT(o.order_id) AS total_orders,
    SUM(TRY_CAST(o.total_amount_eur AS DECIMAL(10,2))) AS lifetime_spend_eur
FROM dbo.customers AS c
INNER JOIN dbo.orders AS o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.country,
    c.customer_segment
ORDER BY
    lifetime_spend_eur DESC;


--------------------------------------------------------------------------------------------------------
-- 3. Which customers have had orders delivered but have never left a review?
--------------------------------------------------------------------------------------------------------
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.country,
    c.customer_segment,
    COUNT(DISTINCT o.order_id) AS delivered_orders
FROM dbo.customers AS c
INNER JOIN dbo.orders AS o
    ON c.customer_id = o.customer_id
LEFT JOIN dbo.reviews AS r
    ON o.order_id = r.order_id
WHERE o.order_status = 'Delivered'
  AND r.review_id IS NULL
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.country,
    c.customer_segment
ORDER BY
    delivered_orders DESC;


--------------------------------------------------------------------------------------------------------
-- 4. Rank all customers by total spend and group them into spending tiers.
--------------------------------------------------------------------------------------------------------
WITH CustomerSpend AS
(
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        c.country,
        c.customer_segment,
        COALESCE(
            SUM(
                CASE
                    WHEN o.order_status = 'Delivered'
                    THEN TRY_CAST(o.total_amount_eur AS DECIMAL(10,2))
                    ELSE 0
                END
            ),
            0
        ) AS total_spend_eur
    FROM dbo.customers AS c
    LEFT JOIN dbo.orders AS o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name,
        c.country,
        c.customer_segment
),

RankedCustomers AS
(
    SELECT
        *,
        RANK() OVER (
            ORDER BY total_spend_eur DESC
        ) AS spend_rank,

        NTILE(4) OVER (
            ORDER BY total_spend_eur DESC
        ) AS spend_quartile

    FROM CustomerSpend
)

SELECT
    customer_id,
    customer_name,
    country,
    customer_segment,
    total_spend_eur,
    spend_rank,

    CASE
        WHEN spend_quartile = 1 THEN 'Top Tier'
        WHEN spend_quartile = 2 THEN 'High Tier'
        WHEN spend_quartile = 3 THEN 'Medium Tier'
        WHEN spend_quartile = 4 THEN 'Low Tier'
    END AS spending_tier

FROM RankedCustomers
ORDER BY spend_rank;


--------------------------------------------------------------------------------------------------------
-- 5. Which customers haven't placed an order in the 90 days
--    before the most recent order on the platform?
--------------------------------------------------------------------------------------------------------
WITH LatestOrder AS
(
    SELECT
        MAX(TRY_CAST(order_datetime AS DATETIME)) AS latest_order_date
    FROM dbo.orders
),

CustomerLastOrder AS
(
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        c.country,
        c.customer_segment,
        MAX(TRY_CAST(o.order_datetime AS DATETIME)) AS last_order_date
    FROM dbo.customers AS c
    LEFT JOIN dbo.orders AS o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name,
        c.country,
        c.customer_segment
)

SELECT
    clo.customer_id,
    clo.customer_name,
    clo.country,
    clo.customer_segment,
    clo.last_order_date,
    lo.latest_order_date,
    DATEDIFF(
        DAY,
        clo.last_order_date,
        lo.latest_order_date
    ) AS days_since_last_order

FROM CustomerLastOrder AS clo
CROSS JOIN LatestOrder AS lo

WHERE clo.last_order_date IS NULL
   OR clo.last_order_date < DATEADD(
        DAY,
        -90,
        lo.latest_order_date
   )

ORDER BY
    clo.last_order_date;


--------------------------------------------------------------------------------------------------------
-- 6. For each customer, show how their total spend has built up over time.
--------------------------------------------------------------------------------------------------------
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    o.order_id,
    TRY_CAST(o.order_datetime AS DATETIME) AS order_datetime,
    TRY_CAST(o.total_amount_eur AS DECIMAL(10,2)) AS order_amount_eur,

    SUM(
        TRY_CAST(o.total_amount_eur AS DECIMAL(10,2))
    ) OVER (
        PARTITION BY o.customer_id
        ORDER BY TRY_CAST(o.order_datetime AS DATETIME),
                 o.order_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_spend_eur

FROM dbo.orders AS o
INNER JOIN dbo.customers AS c
    ON o.customer_id = c.customer_id

WHERE o.order_status = 'Delivered'

ORDER BY
    c.customer_id,
    order_datetime,
    o.order_id;
    
    
--------------------------------------------------------------------------------------------------------
-- 7. Which restaurants bring in the most revenue,
--    and does the answer change by country?
--------------------------------------------------------------------------------------------------------
SELECT
    r.country,
    r.restaurant_id,
    r.restaurant_name,

    COUNT(o.order_id) AS delivered_orders,

    SUM(
        TRY_CAST(o.total_amount_eur AS DECIMAL(10,2))
    ) AS total_revenue_eur,

    RANK() OVER (
        PARTITION BY r.country
        ORDER BY
            SUM(
                TRY_CAST(o.total_amount_eur AS DECIMAL(10,2))
            ) DESC
    ) AS country_revenue_rank

FROM dbo.restaurants AS r
INNER JOIN dbo.orders AS o
    ON r.restaurant_id = o.restaurant_id

WHERE o.order_status = 'Delivered'

GROUP BY
    r.country,
    r.restaurant_id,
    r.restaurant_name

ORDER BY
    r.country,
    country_revenue_rank;
    
    
--------------------------------------------------------------------------------------------------------
-- 8. What are the 10 most frequently ordered menu items?
--------------------------------------------------------------------------------------------------------
SELECT TOP 10
    mi.item_id,
    mi.item_name,
    mi.category,
    r.restaurant_name,

    SUM(
        TRY_CAST(oi.quantity AS INT)
    ) AS total_quantity_ordered,

    COUNT(DISTINCT oi.order_id) AS number_of_orders

FROM dbo.order_items AS oi

INNER JOIN dbo.menu_items AS mi
    ON oi.item_id = mi.item_id

INNER JOIN dbo.restaurants AS r
    ON mi.restaurant_id = r.restaurant_id

INNER JOIN dbo.orders AS o
    ON oi.order_id = o.order_id

WHERE o.order_status = 'Delivered'

GROUP BY
    mi.item_id,
    mi.item_name,
    mi.category,
    r.restaurant_name

ORDER BY
    total_quantity_ordered DESC;


--------------------------------------------------------------------------------------------------------
-- 9. Which restaurants have the strongest customer ratings,
--    and how many reviews is that rating actually based on?
--------------------------------------------------------------------------------------------------------
SELECT
    r.restaurant_id,
    r.restaurant_name,
    r.country,
    r.city,

    COUNT(rv.review_id) AS review_count,

    ROUND(
        AVG(
            TRY_CAST(rv.rating AS DECIMAL(3,2))
        ),
        2
    ) AS average_customer_rating

FROM dbo.restaurants AS r

INNER JOIN dbo.orders AS o
    ON r.restaurant_id = o.restaurant_id

INNER JOIN dbo.reviews AS rv
    ON o.order_id = rv.order_id

GROUP BY
    r.restaurant_id,
    r.restaurant_name,
    r.country,
    r.city

ORDER BY
    average_customer_rating DESC,
    review_count DESC;
    
    
--------------------------------------------------------------------------------------------------------
-- 10. For each restaurant, what are its three best-selling menu items?
--------------------------------------------------------------------------------------------------------
WITH ItemSales AS
(
    SELECT
        r.restaurant_id,
        r.restaurant_name,
        mi.item_id,
        mi.item_name,
        mi.category,

        SUM(
            TRY_CAST(oi.quantity AS INT)
        ) AS total_quantity_sold

    FROM dbo.restaurants AS r

    INNER JOIN dbo.menu_items AS mi
        ON r.restaurant_id = mi.restaurant_id

    INNER JOIN dbo.order_items AS oi
        ON mi.item_id = oi.item_id

    INNER JOIN dbo.orders AS o
        ON oi.order_id = o.order_id

    WHERE o.order_status = 'Delivered'

    GROUP BY
        r.restaurant_id,
        r.restaurant_name,
        mi.item_id,
        mi.item_name,
        mi.category
),

RankedItems AS
(
    SELECT
        *,
        ROW_NUMBER() OVER
        (
            PARTITION BY restaurant_id
            ORDER BY total_quantity_sold DESC
        ) AS item_rank

    FROM ItemSales
)

SELECT
    restaurant_id,
    restaurant_name,
    item_id,
    item_name,
    category,
    total_quantity_sold,
    item_rank

FROM RankedItems

WHERE item_rank <= 3

ORDER BY
    restaurant_name,
    item_rank;
    
    
--------------------------------------------------------------------------------------------------------
-- 11. Which cuisine types offer the highest share of vegetarian dishes,
-- and do those cuisines also see higher order volume?
--------------------------------------------------------------------------------------------------------

WITH CuisineMenu AS
(
    SELECT
        r.cuisine_type,

        COUNT(mi.item_id) AS total_menu_items,

        SUM(
            CASE
                WHEN LOWER(mi.vegetarian) IN ('true', 'yes', '1')
                THEN 1
                ELSE 0
            END
        ) AS vegetarian_items

    FROM dbo.restaurants r
    INNER JOIN dbo.menu_items mi
        ON r.restaurant_id = mi.restaurant_id

    GROUP BY r.cuisine_type
),

CuisineOrders AS
(
    SELECT
        r.cuisine_type,
        COUNT(DISTINCT o.order_id) AS total_orders

    FROM dbo.restaurants r
    INNER JOIN dbo.orders o
        ON r.restaurant_id = o.restaurant_id

    WHERE o.order_status = 'Delivered'

    GROUP BY r.cuisine_type
)

SELECT
    cm.cuisine_type,
    cm.total_menu_items,
    cm.vegetarian_items,

    ROUND(
        100.0 * cm.vegetarian_items
        / NULLIF(cm.total_menu_items, 0),
        2
    ) AS vegetarian_share_pct,

    COALESCE(co.total_orders, 0) AS total_orders

FROM CuisineMenu cm

LEFT JOIN CuisineOrders co
    ON cm.cuisine_type = co.cuisine_type

ORDER BY vegetarian_share_pct DESC, total_orders DESC;


--------------------------------------------------------------------------------------------------------
-- 11. Which cuisine types offer the highest share of vegetarian dishes,
-- and do those cuisines also see higher order volume?
--------------------------------------------------------------------------------------------------------

WITH CuisineMenu AS
(
    SELECT
        r.cuisine_type,

        COUNT(mi.item_id) AS total_menu_items,

        SUM(
            CASE
                WHEN LOWER(mi.vegetarian) IN ('true', 'yes', '1')
                THEN 1
                ELSE 0
            END
        ) AS vegetarian_items

    FROM dbo.restaurants r
    INNER JOIN dbo.menu_items mi
        ON r.restaurant_id = mi.restaurant_id

    GROUP BY r.cuisine_type
),

CuisineOrders AS
(
    SELECT
        r.cuisine_type,
        COUNT(DISTINCT o.order_id) AS total_orders

    FROM dbo.restaurants r
    INNER JOIN dbo.orders o
        ON r.restaurant_id = o.restaurant_id

    WHERE o.order_status = 'Delivered'

    GROUP BY r.cuisine_type
)

SELECT
    cm.cuisine_type,
    cm.total_menu_items,
    cm.vegetarian_items,

    ROUND(
        100.0 * cm.vegetarian_items
        / NULLIF(cm.total_menu_items, 0),
        2
    ) AS vegetarian_share_pct,

    COALESCE(co.total_orders, 0) AS total_orders

FROM CuisineMenu cm

LEFT JOIN CuisineOrders co
    ON cm.cuisine_type = co.cuisine_type

ORDER BY vegetarian_share_pct DESC, total_orders DESC;


--------------------------------------------------------------------------------------------------------
-- 13. What does total revenue look like by country and by month,
-- and is it trending up or down?
--------------------------------------------------------------------------------------------------------

WITH MonthlyRevenue AS
(
    SELECT
        r.country,

        DATEFROMPARTS(
            YEAR(TRY_CAST(o.order_datetime AS DATETIME)),
            MONTH(TRY_CAST(o.order_datetime AS DATETIME)),
            1
        ) AS revenue_month,

        SUM(
            TRY_CAST(o.total_amount_eur AS DECIMAL(12,2))
        ) AS total_revenue_eur

    FROM dbo.orders o
    INNER JOIN dbo.restaurants r
        ON o.restaurant_id = r.restaurant_id

    WHERE o.order_status = 'Delivered'

    GROUP BY
        r.country,
        DATEFROMPARTS(
            YEAR(TRY_CAST(o.order_datetime AS DATETIME)),
            MONTH(TRY_CAST(o.order_datetime AS DATETIME)),
            1
        )
)

SELECT
    country,
    revenue_month,
    ROUND(total_revenue_eur, 2) AS total_revenue_eur,

    LAG(total_revenue_eur) OVER
    (
        PARTITION BY country
        ORDER BY revenue_month
    ) AS previous_month_revenue,

    ROUND(
        total_revenue_eur
        - LAG(total_revenue_eur) OVER
        (
            PARTITION BY country
            ORDER BY revenue_month
        ),
        2
    ) AS revenue_change_eur,

    CASE
        WHEN total_revenue_eur >
             LAG(total_revenue_eur) OVER
             (
                 PARTITION BY country
                 ORDER BY revenue_month
             )
            THEN 'Up'

        WHEN total_revenue_eur <
             LAG(total_revenue_eur) OVER
             (
                 PARTITION BY country
                 ORDER BY revenue_month
             )
            THEN 'Down'

        ELSE 'No Change'
    END AS revenue_trend

FROM MonthlyRevenue

ORDER BY country, revenue_month;


--------------------------------------------------------------------------------------------------------
-- 14. What is the month-over-month revenue growth rate for the platform?
--------------------------------------------------------------------------------------------------------

WITH MonthlyRevenue AS
(
    SELECT
        DATEFROMPARTS(
            YEAR(TRY_CAST(order_datetime AS DATETIME)),
            MONTH(TRY_CAST(order_datetime AS DATETIME)),
            1
        ) AS revenue_month,

        SUM(
            TRY_CAST(total_amount_eur AS DECIMAL(12,2))
        ) AS total_revenue_eur

    FROM dbo.orders

    WHERE order_status = 'Delivered'

    GROUP BY
        DATEFROMPARTS(
            YEAR(TRY_CAST(order_datetime AS DATETIME)),
            MONTH(TRY_CAST(order_datetime AS DATETIME)),
            1
        )
),

RevenueWithPreviousMonth AS
(
    SELECT
        revenue_month,
        total_revenue_eur,

        LAG(total_revenue_eur) OVER
        (
            ORDER BY revenue_month
        ) AS previous_month_revenue

    FROM MonthlyRevenue
)

SELECT
    revenue_month,
    ROUND(total_revenue_eur, 2) AS total_revenue_eur,
    ROUND(previous_month_revenue, 2) AS previous_month_revenue,

    ROUND(
        100.0 *
        (total_revenue_eur - previous_month_revenue)
        / NULLIF(previous_month_revenue, 0),
        2
    ) AS mom_revenue_growth_pct

FROM RevenueWithPreviousMonth

ORDER BY revenue_month;


--------------------------------------------------------------------------------------------------------
-- 15. What share of orders use a discount,
-- and does typical discount size differ by country?
--------------------------------------------------------------------------------------------------------

SELECT
    r.country,

    COUNT(o.order_id) AS total_orders,

    SUM(
        CASE
            WHEN TRY_CAST(o.discount_eur AS DECIMAL(10,2)) > 0
            THEN 1
            ELSE 0
        END
    ) AS discounted_orders,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN TRY_CAST(o.discount_eur AS DECIMAL(10,2)) > 0
                THEN 1
                ELSE 0
            END
        )
        / NULLIF(COUNT(o.order_id), 0),
        2
    ) AS discounted_order_share_pct,

    ROUND(
        AVG(
            CASE
                WHEN TRY_CAST(o.discount_eur AS DECIMAL(10,2)) > 0
                THEN TRY_CAST(o.discount_eur AS DECIMAL(10,2))
            END
        ),
        2
    ) AS avg_discount_eur

FROM dbo.orders o

INNER JOIN dbo.restaurants r
    ON o.restaurant_id = r.restaurant_id

GROUP BY r.country

ORDER BY discounted_order_share_pct DESC;


--------------------------------------------------------------------------------------------------------
-- 16. Which payment methods fail most often,
-- and is it worth flagging any of them to the payments team?
--------------------------------------------------------------------------------------------------------

SELECT
    payment_method,

    COUNT(payment_id) AS total_payment_attempts,

    SUM(
        CASE
            WHEN LOWER(payment_status) IN
                 ('failed', 'failure', 'declined')
            THEN 1
            ELSE 0
        END
    ) AS failed_payments,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN LOWER(payment_status) IN
                     ('failed', 'failure', 'declined')
                THEN 1
                ELSE 0
            END
        )
        / NULLIF(COUNT(payment_id), 0),
        2
    ) AS failure_rate_pct

FROM dbo.payments

GROUP BY payment_method

ORDER BY failure_rate_pct DESC;


--------------------------------------------------------------------------------------------------------
-- 17. How much order value has EuroEats lost to cancellations and refunds,
-- broken down by country?
--------------------------------------------------------------------------------------------------------

SELECT
    r.country,

    SUM(
        CASE
            WHEN LOWER(o.order_status) IN
                 ('cancelled', 'canceled', 'refunded')
            THEN TRY_CAST(o.total_amount_eur AS DECIMAL(12,2))
            ELSE 0
        END
    ) AS lost_order_value_eur,

    COUNT(
        CASE
            WHEN LOWER(o.order_status) IN
                 ('cancelled', 'canceled', 'refunded')
            THEN o.order_id
        END
    ) AS cancelled_or_refunded_orders

FROM dbo.orders o

INNER JOIN dbo.restaurants r
    ON o.restaurant_id = r.restaurant_id

GROUP BY r.country

ORDER BY lost_order_value_eur DESC;


--------------------------------------------------------------------------------------------------------
-- 18. For every country, which single restaurant generates the most revenue?
--------------------------------------------------------------------------------------------------------

WITH RestaurantRevenue AS
(
    SELECT
        r.country,
        r.restaurant_id,
        r.restaurant_name,

        SUM(
            TRY_CAST(o.total_amount_eur AS DECIMAL(12,2))
        ) AS total_revenue_eur

    FROM dbo.restaurants r

    INNER JOIN dbo.orders o
        ON r.restaurant_id = o.restaurant_id

    WHERE o.order_status = 'Delivered'

    GROUP BY
        r.country,
        r.restaurant_id,
        r.restaurant_name
),

RankedRestaurants AS
(
    SELECT
        *,
        ROW_NUMBER() OVER
        (
            PARTITION BY country
            ORDER BY total_revenue_eur DESC
        ) AS revenue_rank

    FROM RestaurantRevenue
)

SELECT
    country,
    restaurant_id,
    restaurant_name,
    ROUND(total_revenue_eur, 2) AS total_revenue_eur

FROM RankedRestaurants

WHERE revenue_rank = 1

ORDER BY country;


--------------------------------------------------------------------------------------------------------
-- 19. How does average delivery time change across different
-- traffic and weather conditions?
--------------------------------------------------------------------------------------------------------

SELECT
    d.traffic_level,
    d.weather_condition,

    COUNT(d.delivery_id) AS total_deliveries,

    ROUND(
        AVG(
            TRY_CAST(d.actual_delivery_minutes AS DECIMAL(10,2))
        ),
        2
    ) AS avg_actual_delivery_minutes

FROM dbo.deliveries d

GROUP BY
    d.traffic_level,
    d.weather_condition

ORDER BY
    avg_actual_delivery_minutes DESC;
    
    
--------------------------------------------------------------------------------------------------------
-- 20. What share of deliveries come in late,
-- and does that cluster around particular traffic conditions?
--------------------------------------------------------------------------------------------------------

SELECT
    traffic_level,

    COUNT(delivery_id) AS total_deliveries,

    SUM(
        CASE
            WHEN TRY_CAST(actual_delivery_minutes AS DECIMAL(10,2))
               > TRY_CAST(estimated_delivery_minutes AS DECIMAL(10,2))
            THEN 1
            ELSE 0
        END
    ) AS late_deliveries,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN TRY_CAST(actual_delivery_minutes AS DECIMAL(10,2))
                   > TRY_CAST(estimated_delivery_minutes AS DECIMAL(10,2))
                THEN 1
                ELSE 0
            END
        )
        / NULLIF(COUNT(delivery_id), 0),
        2
    ) AS late_delivery_share_pct

FROM dbo.deliveries

GROUP BY traffic_level

ORDER BY late_delivery_share_pct DESC;


--------------------------------------------------------------------------------------------------------
-- 21. Which drivers combine a strong rating with high delivery volume?
--------------------------------------------------------------------------------------------------------

WITH DriverPerformance AS
(
    SELECT
        dr.driver_id,
        CONCAT(dr.first_name, ' ', dr.last_name) AS driver_name,
        dr.country,
        dr.city,
        dr.vehicle_type,

        TRY_CAST(dr.driver_rating AS DECIMAL(10,2)) AS driver_rating,

        COUNT(d.delivery_id) AS delivery_volume

    FROM dbo.drivers dr

    INNER JOIN dbo.deliveries d
        ON dr.driver_id = d.driver_id

    GROUP BY
        dr.driver_id,
        dr.first_name,
        dr.last_name,
        dr.country,
        dr.city,
        dr.vehicle_type,
        dr.driver_rating
)

SELECT
    driver_id,
    driver_name,
    country,
    city,
    vehicle_type,
    driver_rating,
    delivery_volume,

    RANK() OVER
    (
        ORDER BY driver_rating DESC, delivery_volume DESC
    ) AS driver_rank

FROM DriverPerformance

ORDER BY driver_rank;


--------------------------------------------------------------------------------------------------------
-- 22. Does delivery performance differ meaningfully by vehicle type,
-- and should that change how we recruit drivers in any particular city?
--------------------------------------------------------------------------------------------------------

SELECT
    dr.city,
    dr.vehicle_type,

    COUNT(d.delivery_id) AS total_deliveries,

    ROUND(
        AVG(
            TRY_CAST(d.actual_delivery_minutes AS DECIMAL(10,2))
        ),
        2
    ) AS avg_delivery_time_minutes,

    ROUND(
        AVG(
            TRY_CAST(d.estimated_delivery_minutes AS DECIMAL(10,2))
        ),
        2
    ) AS avg_estimated_delivery_minutes,

    ROUND(
        AVG(
            TRY_CAST(d.actual_delivery_minutes AS DECIMAL(10,2))
            -
            TRY_CAST(d.estimated_delivery_minutes AS DECIMAL(10,2))
        ),
        2
    ) AS avg_delay_vs_estimate_minutes

FROM dbo.drivers dr

INNER JOIN dbo.deliveries d
    ON dr.driver_id = d.driver_id

GROUP BY
    dr.city,
    dr.vehicle_type

ORDER BY
    dr.city,
    avg_delivery_time_minutes;
    
    
--------------------------------------------------------------------------------------------------------
-- 23. What is the typical (not just average) delivery time under each traffic condition?
--------------------------------------------------------------------------------------------------------

WITH DeliveryStats AS
(
    SELECT
        traffic_level,
        TRY_CAST(actual_delivery_minutes AS DECIMAL(10,2))
            AS actual_delivery_minutes
    FROM dbo.deliveries
    WHERE actual_delivery_minutes IS NOT NULL
),

TrafficStats AS
(
    SELECT DISTINCT
        traffic_level,

        AVG(actual_delivery_minutes) OVER
        (
            PARTITION BY traffic_level
        ) AS average_delivery_minutes,

        PERCENTILE_CONT(0.50)
        WITHIN GROUP
        (
            ORDER BY actual_delivery_minutes
        )
        OVER
        (
            PARTITION BY traffic_level
        ) AS median_delivery_minutes,

        COUNT(*) OVER
        (
            PARTITION BY traffic_level
        ) AS total_deliveries

    FROM DeliveryStats
)

SELECT
    traffic_level,
    total_deliveries,

    ROUND(average_delivery_minutes, 2)
        AS average_delivery_minutes,

    ROUND(median_delivery_minutes, 2)
        AS median_delivery_minutes

FROM TrafficStats

ORDER BY median_delivery_minutes;


--------------------------------------------------------------------------------------------------------
-- 24. Are there cases of different customers, in the same city,
-- ordering from the same restaurant on the same day?
--------------------------------------------------------------------------------------------------------

WITH DailyRestaurantOrders AS
(
    SELECT
        r.city,
        r.restaurant_id,
        r.restaurant_name,

        CAST(
            TRY_CAST(o.order_datetime AS DATETIME)
            AS DATE
        ) AS order_date,

        COUNT(DISTINCT o.customer_id) AS unique_customers,
        COUNT(DISTINCT o.order_id) AS total_orders

    FROM dbo.orders o

    INNER JOIN dbo.restaurants r
        ON o.restaurant_id = r.restaurant_id

    GROUP BY
        r.city,
        r.restaurant_id,
        r.restaurant_name,
        CAST(
            TRY_CAST(o.order_datetime AS DATETIME)
            AS DATE
        )
)

SELECT
    city,
    restaurant_id,
    restaurant_name,
    order_date,
    unique_customers,
    total_orders

FROM DailyRestaurantOrders

WHERE unique_customers > 1

ORDER BY
    city,
    restaurant_name,
    order_date;
    
    
--------------------------------------------------------------------------------------------------------
-- 25. Which countries have the fastest and slowest average delivery times?
--------------------------------------------------------------------------------------------------------

WITH CountryDeliveryPerformance AS
(
    SELECT
        r.country,

        COUNT(d.delivery_id) AS total_deliveries,

        ROUND(
            AVG(
                TRY_CAST(d.actual_delivery_minutes AS DECIMAL(10,2))
            ),
            2
        ) AS avg_delivery_time_minutes,

        ROUND(
            AVG(
                TRY_CAST(d.distance_km AS DECIMAL(10,2))
            ),
            2
        ) AS avg_distance_km,

        ROUND(
            AVG(
                TRY_CAST(d.restaurant_wait_minutes AS DECIMAL(10,2))
            ),
            2
        ) AS avg_restaurant_wait_minutes,

        ROUND(
            AVG(
                TRY_CAST(d.pickup_delay_minutes AS DECIMAL(10,2))
            ),
            2
        ) AS avg_pickup_delay_minutes

    FROM dbo.deliveries d

    INNER JOIN dbo.orders o
        ON d.order_id = o.order_id

    INNER JOIN dbo.restaurants r
        ON o.restaurant_id = r.restaurant_id

    GROUP BY r.country
)

SELECT
    country,
    total_deliveries,
    avg_delivery_time_minutes,
    avg_distance_km,
    avg_restaurant_wait_minutes,
    avg_pickup_delay_minutes,

    RANK() OVER
    (
        ORDER BY avg_delivery_time_minutes
    ) AS delivery_speed_rank

FROM CountryDeliveryPerformance

ORDER BY delivery_speed_rank;


--------------------------------------------------------------------------------------------------------
-- 26. Do bigger orders tend to carry bigger discounts?
--------------------------------------------------------------------------------------------------------

WITH OrderSizeData AS
(
    SELECT
        order_id,

        TRY_CAST(number_of_items AS INT)
            AS number_of_items,

        TRY_CAST(total_amount_eur AS DECIMAL(12,2))
            AS total_amount_eur,

        TRY_CAST(discount_eur AS DECIMAL(12,2))
            AS discount_eur,

        CASE
            WHEN TRY_CAST(number_of_items AS INT) <= 2
                THEN '1-2 Items'

            WHEN TRY_CAST(number_of_items AS INT) <= 4
                THEN '3-4 Items'

            WHEN TRY_CAST(number_of_items AS INT) <= 6
                THEN '5-6 Items'

            ELSE '7+ Items'
        END AS order_size,

        CASE
            WHEN TRY_CAST(number_of_items AS INT) <= 2 THEN 1
            WHEN TRY_CAST(number_of_items AS INT) <= 4 THEN 2
            WHEN TRY_CAST(number_of_items AS INT) <= 6 THEN 3
            ELSE 4
        END AS order_size_rank

    FROM dbo.orders
)

SELECT
    order_size,

    COUNT(order_id) AS total_orders,

    ROUND(
        AVG(total_amount_eur),
        2
    ) AS avg_order_value_eur,

    ROUND(
        AVG(discount_eur),
        2
    ) AS avg_discount_eur,

    ROUND(
        SUM(discount_eur),
        2
    ) AS total_discount_eur

FROM OrderSizeData

GROUP BY
    order_size,
    order_size_rank

ORDER BY
    order_size_rank;
    
    
--------------------------------------------------------------------------------------------------------
-- 27. Which restaurant-and-city combinations produce delayed deliveries most often?
--------------------------------------------------------------------------------------------------------

WITH RestaurantDeliveryPerformance AS
(
    SELECT
        r.restaurant_id,
        r.restaurant_name,
        r.city,
        r.country,

        COUNT(d.delivery_id) AS total_deliveries,

        SUM(
            CASE
                WHEN TRY_CAST(d.actual_delivery_minutes AS DECIMAL(10,2))
                   > TRY_CAST(d.estimated_delivery_minutes AS DECIMAL(10,2))
                THEN 1
                ELSE 0
            END
        ) AS delayed_deliveries

    FROM dbo.restaurants r

    INNER JOIN dbo.orders o
        ON r.restaurant_id = o.restaurant_id

    INNER JOIN dbo.deliveries d
        ON o.order_id = d.order_id

    GROUP BY
        r.restaurant_id,
        r.restaurant_name,
        r.city,
        r.country
)

SELECT
    restaurant_id,
    restaurant_name,
    city,
    country,
    total_deliveries,
    delayed_deliveries,

    ROUND(
        100.0 * delayed_deliveries
        / NULLIF(total_deliveries, 0),
        2
    ) AS delayed_delivery_rate_pct

FROM RestaurantDeliveryPerformance

WHERE total_deliveries >= 5

ORDER BY delayed_delivery_rate_pct DESC;


--------------------------------------------------------------------------------------------------------
-- 28. Is there any real relationship between a restaurant's rating
-- and how much business it does?
--------------------------------------------------------------------------------------------------------

WITH RestaurantBusiness AS
(
    SELECT
        r.restaurant_id,
        r.restaurant_name,
        r.country,
        r.restaurant_rating,

        COUNT(o.order_id) AS total_orders,

        SUM(
            TRY_CAST(o.total_amount_eur AS DECIMAL(12,2))
        ) AS total_revenue_eur

    FROM dbo.restaurants r

    LEFT JOIN dbo.orders o
        ON r.restaurant_id = o.restaurant_id
        AND o.order_status = 'Delivered'

    GROUP BY
        r.restaurant_id,
        r.restaurant_name,
        r.country,
        r.restaurant_rating
)

SELECT
    restaurant_id,
    restaurant_name,
    country,

    TRY_CAST(
        restaurant_rating AS DECIMAL(10,2)
    ) AS restaurant_rating,

    total_orders,

    ROUND(
        COALESCE(total_revenue_eur, 0),
        2
    ) AS total_revenue_eur

FROM RestaurantBusiness

ORDER BY
    restaurant_rating DESC,
    total_revenue_eur DESC;
    
    
--------------------------------------------------------------------------------------------------------
WITH RestaurantBusiness AS
(
    SELECT
        r.restaurant_id,

        TRY_CAST(r.restaurant_rating AS FLOAT)
            AS restaurant_rating,

        COUNT(o.order_id) AS total_orders

    FROM dbo.restaurants r

    LEFT JOIN dbo.orders o
        ON r.restaurant_id = o.restaurant_id
        AND o.order_status = 'Delivered'

    GROUP BY
        r.restaurant_id,
        r.restaurant_rating
)

SELECT
    CORR = 
    (
        COUNT(*) * SUM(restaurant_rating * total_orders)
        - SUM(restaurant_rating) * SUM(total_orders)
    )
    /
    NULLIF(
        SQRT(
            (
                COUNT(*) * SUM(restaurant_rating * restaurant_rating)
                - POWER(SUM(restaurant_rating), 2)
            )
            *
            (
                COUNT(*) * SUM(total_orders * total_orders)
                - POWER(SUM(total_orders), 2)
            )
        ),
        0
    )

FROM RestaurantBusiness

WHERE restaurant_rating IS NOT NULL;


--------------------------------------------------------------------------------------------------------
-- 29. Do full-time, part-time, and freelance drivers actually perform differently?
--------------------------------------------------------------------------------------------------------

SELECT
    dr.employment_type,

    COUNT(DISTINCT dr.driver_id) AS total_drivers,

    COUNT(d.delivery_id) AS total_deliveries,

    ROUND(
        AVG(
            TRY_CAST(dr.driver_rating AS DECIMAL(10,2))
        ),
        2
    ) AS avg_driver_rating,

    ROUND(
        AVG(
            TRY_CAST(d.actual_delivery_minutes AS DECIMAL(10,2))
        ),
        2
    ) AS avg_delivery_time_minutes,

    ROUND(
        AVG(
            TRY_CAST(d.actual_delivery_minutes AS DECIMAL(10,2))
            -
            TRY_CAST(d.estimated_delivery_minutes AS DECIMAL(10,2))
        ),
        2
    ) AS avg_delay_vs_estimate_minutes,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN TRY_CAST(d.actual_delivery_minutes AS DECIMAL(10,2))
                   > TRY_CAST(d.estimated_delivery_minutes AS DECIMAL(10,2))
                THEN 1
                ELSE 0
            END
        )
        / NULLIF(COUNT(d.delivery_id), 0),
        2
    ) AS late_delivery_rate_pct

FROM dbo.drivers dr

INNER JOIN dbo.deliveries d
    ON dr.driver_id = d.driver_id

GROUP BY
    dr.employment_type

ORDER BY
    avg_delivery_time_minutes;

---------------------------------------------------- THE END ----------------------------------------------------