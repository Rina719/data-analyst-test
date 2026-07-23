-- ===========================================================================
-- Блок 3. SQL
-- Диалект: PostgreSQL
-- ===========================================================================

-- Задание 1. Абитуриенты

SELECT
    id,
    scores,
    RANK() OVER (ORDER BY scores DESC) AS rating_position
FROM examination
ORDER BY rating_position, id;

-- ---------------------------------------------------------------------------
-- Задание 2. FULL JOIN

-- ОТВЕТ: минимально 30 и максимально 600 строк.
-- Минимум = 30. FULL JOIN гарантирует, что каждая строка обеих таблиц попадёт в результат хотя бы один раз, поэтому результат не может быть короче большей таблицы. Ровно 30 получается, 
-- когда все 20 ключей второй таблицы уникальны и каждый находит ровно одно совпадение в первой: 20 сматченных пар + 10 строк первой таблицы с NULL-ами = 30.
-- Максимум = 600. Максимум даёт не отсутствие совпадений (это дало бы 30 + 20 = 50), а наоборот — полное совпадение при дублирующихся ключах. Если во всех 30 строках первой таблицы ключ один и тот же, 
-- и во всех 20 строках второй он же, соединение вырождается в декартово произведение: 30 × 20 = 600.

-- ---------------------------------------------------------------------------
-- Задание 3. Покупки

SELECT
    a.client_id
FROM account a
LEFT JOIN transaction t ON t.account_id = a.id
      AND t.type = 'PUR'
      AND t.transaction_date >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1 month'
      AND t.transaction_date <  DATE_TRUNC('month', CURRENT_DATE)
GROUP BY a.client_id
HAVING COALESCE(SUM(t.amount), 0) < 5000;


-- Вариант, если по условию нужны только клиенты, у которых покупки были (то есть нулевые клиенты не считаются) — тогда достаточно INNER JOIN:

-- SELECT a.client_id
-- FROM account a
-- JOIN transaction t ON t.account_id = a.id
-- WHERE t.type = 'PUR'
	-- AND t.transaction_date >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1 month'
	-- AND t.transaction_date <  DATE_TRUNC('month', CURRENT_DATE)
-- GROUP BY a.client_id
-- HAVING SUM(t.amount) < 5000; 