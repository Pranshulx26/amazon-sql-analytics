/*
===============================================================================
Query Name  : Payment Success Rate by Status
===============================================================================
Objective:
- Calculate the distribution and percentage of payments by status
- Measure overall payment success rate

Business Definition:
- Each row in the payments table represents a payment attempt
- Payment Success Rate is calculated at the payment level
- Includes all payment statuses (e.g., Success, Failed, Pending)

Grain:
- One row per payment status

Metrics:
- Total payment count
- Percentage contribution of each payment status
===============================================================================
*/

WITH payment_counts AS (
    SELECT
        payment_status,
        COUNT(*) AS total_payments
    FROM payments
    GROUP BY payment_status
),

total_payments AS (
    SELECT
        SUM(total_payments) AS overall_payment_count
    FROM payment_counts
)

SELECT
    pc.payment_status,
    pc.total_payments,
    CAST(
        pc.total_payments * 100.0 / tp.overall_payment_count
        AS DECIMAL(5,2)
    ) AS payment_status_percentage
FROM payment_counts pc
CROSS JOIN total_payments tp
ORDER BY
    payment_status_percentage DESC;
