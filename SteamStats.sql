SELECT *
FROM dbo.games


/* Total Number of Games */

SELECT COUNT(Name) AS GameCount
FROM dbo.games

/* Total Number of DLCs */

SELECT SUM(DLC_count)
FROM dbo.games

/* Total Number of Achievements */

SELECT COUNT(Achievements) AS AchievementCount
FROM dbo.games

/* Total Number of Genres */
SELECT DISTINCT value AS Genre
INTO #TempGenres
FROM dbo.games
CROSS APPLY STRING_SPLIT(Genres, ',')

SELECT COUNT(*) AS TotalUniqueGenres
FROM #TempGenres


/* Total Number of Developers */

SELECT COUNT(DISTINCT Developers) AS DeveloperCount
FROM dbo.games

/* Genres by Total Games */

SELECT 
    value AS Genre,
    COUNT(*) AS TotalGames
FROM dbo.games
CROSS APPLY STRING_SPLIT(Genres, ',')
GROUP BY value
ORDER BY TotalGames DESC

/* Total Games by Year */

SELECT
	YEAR(Release_date) AS ReleaseYear,
	COUNT(*) AS TotalGames
FROM dbo.games
GROUP BY YEAR(Release_date)
ORDER BY ReleaseYear

/* Bethesda's yearly average price for games */

SELECT
	Year(Release_date) AS ReleaseYear,
	AVG(Price) AS AveragePrice
FROM dbo.games
WHERE
	Developers LIKE '%bethesda%' OR
	PUBLISHERS LIKE '%bethesda%'
GROUP BY YEAR(Release_date)

/* Bethesda's Games with Prices */

SELECT Name, Price
from dbo.games
WHERE
	Developers LIKE '%bethesda%' OR
	Publishers LIKE '%bethesda%'

/* Bethesda's Pricepoint For Games */

SELECT
	CASE
		WHEN Price BETWEEN 60 and 70 THEN '<$70'
		WHEN Price BETWEEN 50 and 60 THEN '<$60'
		WHEN Price BETWEEN 40 and 50 THEN '<$50'
		WHEN Price BETWEEN 30 and 40 THEN '<$40'
		WHEN Price BETWEEN 20 and 30 THEN '<$30'
		WHEN Price BETWEEN 10 and 20 THEN '<$20'
		WHEN Price BETWEEN 0 and 10 THEN '<$10'
		ELSE 'Free'
	END AS PriceCategory,
	COUNT(*) AS GameCount,
	CASE
		WHEN Price BETWEEN 60 and 70 THEN 1
		WHEN Price BETWEEN 50 and 60 THEN 2
		WHEN Price BETWEEN 40 and 50 THEN 3
		WHEN Price BETWEEN 30 and 40 THEN 4
		WHEN Price BETWEEN 20 and 30 THEN 5
		WHEN Price BETWEEN 10 and 20 THEN 6
		WHEN Price BETWEEN 0 and 10 THEN 7
		ELSE 8
	END AS CategoryOrder
FROM dbo.games
WHERE
	Developers LIKE '%bethesda%' OR
	PUBLISHERS LIKE '%bethesda%'
GROUP BY
	CASE
		WHEN Price BETWEEN 60 and 70 THEN '<$70'
		WHEN Price BETWEEN 50 and 60 THEN '<$60'
		WHEN Price BETWEEN 40 and 50 THEN '<$50'
		WHEN Price BETWEEN 30 and 40 THEN '<$40'
		WHEN Price BETWEEN 20 and 30 THEN '<$30'
		WHEN Price BETWEEN 10 and 20 THEN '<$20'
		WHEN Price BETWEEN 0 and 10 THEN '<$10'
		ELSE 'Free'
	END,
	CASE
		WHEN Price BETWEEN 60 and 70 THEN 1
		WHEN Price BETWEEN 50 and 60 THEN 2
		WHEN Price BETWEEN 40 and 50 THEN 3
		WHEN Price BETWEEN 30 and 40 THEN 4
		WHEN Price BETWEEN 20 and 30 THEN 5
		WHEN Price BETWEEN 10 and 20 THEN 6
		WHEN Price BETWEEN 0 and 10 THEN 7
		ELSE 8
	END;

/* TOP 10 Bethesda Games by Playtime */

SELECT TOP 10 
    Name, 
    Average_playtime_forever / 60 AS AvgPlaytimeHours
FROM dbo.games
WHERE
    (Developers LIKE '%bethesda%' OR
    Publishers LIKE '%bethesda%') AND
    Average_playtime_forever <> 0
ORDER BY Average_playtime_forever DESC