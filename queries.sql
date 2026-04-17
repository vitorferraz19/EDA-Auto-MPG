-- 1 - Which car models are the most common per origin?

SELECT origin, car_name, MAX(freq) AS frequency
FROM (
		SELECT origin, car_name, count(*) AS freq
		FROM cleaned_data
GROUP BY origin, car_name
)
GROUP BY origin
ORDER BY origin DESC;

-- 2 - Which cars are the most fuel-efficient? In other words, which have the highest MPG?

SELECT car_name, mpg
FROM cleaned_data
GROUP BY car_name
ORDER BY CAST(mpg AS REAL) DESC   -- casting possible values to numbers, given that initial sorting was not displaying properly
LIMIT 10;

-- 3 - Do high-power cars have lower fuel efficiency (need to choose a hp threshold)?

SELECT 
    CASE 
        WHEN CAST(horsepower AS REAL) >= 100 THEN 'High HP'  -- choosing 100 hp as the threshold
        ELSE 'Low HP'
    END AS hp_category,
    round(AVG(CAST(mpg AS REAL)), 1) AS avg_mpg
FROM cleaned_data
GROUP BY hp_category;   -- output suggest that high hp cars are less fuel-efficient when compared to low horsepower cars, which are much more fuel efficient

-- 4 - What is the average MPG per model year? Are the cars becoming more efficient?

SELECT 
    "model year",
    round(AVG(CAST(mpg AS REAL)), 1) AS avg_mpg   -- casting to enforce numerical
FROM cleaned_data
GROUP BY model_year
ORDER BY model_year;

-- 5 - How do car and engine characteristics compare between high and low mpg cars?

SELECT 
    CASE 
        WHEN CAST(mpg AS REAL) >= 25 THEN 'High MPG'    -- assuming 25 mpg as the threshold
        ELSE 'Low MPG'
    END AS mpg_category,
    round(AVG(CAST(horsepower AS REAL)), 1) AS avg_hp,
    round(AVG(CAST(weight AS REAL)), 1) AS avg_weight,
    round(AVG(CAST(displacement AS REAL)), 1) AS avg_displacement
FROM cleaned_data
GROUP BY mpg_category;

-- 6.How does power-to-weight ratio varies according the origin?

SELECT origin AS "Origin", round((AVG(horsepower)/AVG(weight)), 3) AS "Power-to-weight ratio"
FROM cleaned_data
GROUP BY origin
ORDER BY "Power-to-weight ratio" DESC;

-- 7. How does power-to-weight ratio influence acceleration?

SELECT origin AS "Origin", round((AVG(horsepower)/AVG(weight)), 3) AS "Power-to-weight ratio", acceleration AS "Acceleration"
FROM cleaned_data
GROUP BY origin
ORDER BY "Power-to-weight ratio" DESC;

-- 8.The acceleration of american cars increases over time. Is this correlated with the variation of power-to-weight ratio?

SELECT model_year AS "Year", round((AVG(horsepower)/AVG(weight)), 3) AS "Power-to-Weight Ratio"
FROM cleaned_data
WHERE origin = "USA"           -- enforcing this particular country
GROUP BY origin, model_year
ORDER BY model_year ASC;

-- 9.How do mpg and horsepower compare among 4-cylinder cars from different origins?

SELECT origin AS "Origin", round(AVG(mpg), 1) AS "avg_mpg", round(AVG(horsepower), 1) AS "avg_hp"
FROM cleaned_data
WHERE cylinders = 4                             -- enforcing 4 cylinders
GROUP BY origin
ORDER BY "MPG" DESC;

-- 10.What is the average displacement value for each cylinder count?

SELECT cylinders AS "Engine Cylinders", round(AVG(displacement), 1) AS "avg_displacement"
FROM cleaned_data
GROUP BY cylinders
ORDER BY cylinders ASC;

-- 11.What is the average horsepower per cylinder count?

SELECT cylinders AS "Engine Cylinders", round(AVG(horsepower), 1) AS "avg_hp"
FROM cleaned_data
GROUP BY cylinders
ORDER BY cylinders ASC;