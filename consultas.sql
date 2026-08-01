----- W.Functions e CTEs -----

--Primeira e última compra por cliente--
WITH firstlast AS
(
    SELECT customer_id, order_date,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS first,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS last
    FROM raw_vendas
)

SELECT * 
FROM firstlast
WHERE first = 1 OR last = 1;



--Comparação de total faturado entre mês--
WITH totalrevenue_mes AS
(
    SELECT DATE_TRUNC('month', order_date) AS mes,
    sum(revenue) AS total_receita
    FROM raw_vendas
    GROUP BY mes
    ORDER BY mes
),

com_lag AS 
(
    SELECT *,
    LAG(total_receita) OVER (ORDER BY mes) AS receita_mes_anterior  
    FROM totalrevenue_mes
),
com_lag_diferenca AS 
(
    SELECT *, 
    total_receita - receita_mes_anterior AS diferenca
    FROM com_lag
)
SELECT *,
((total_receita - receita_mes_anterior) / receita_mes_anterior * 100) AS diferenca_percentual
FROM com_lag_diferenca;




