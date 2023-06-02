use  PROJECT_4;
--                              QUESTION SET 1 

--TASK 1 :WHO IS THE SENIOR MOST EMPLOYEE BASED ON JOB TITILE?

select * from  employee;

select first_name,last_name , title from employee
where reports_to is null;

--TASK 2 : WHICH COUNTRIES HAVE THE MOST INVOICES ?

SELECT * FROM invoice;

SELECT TOP 1 BILLING_COUNTRY , COUNT(invoice_id) AS NUMBER_OF_INVOICES FROM invoice
GROUP BY billing_country
ORDER BY  COUNT(invoice_id) DESC;

--TASK 3 : WHAT ARE THE TOP 3 VALUES OF THE INVOICES ?

SELECT * FROM invoice;
SELECT TOP 3 total FROM invoice
ORDER BY TOTAL DESC;


--TASK 4 : WHICH CITY HAS THE BEST CUSTOMERS ? WE WOULD LIKE TO THROW A PROMOTIONAL MUSIC FESTIVSL IN THE CITY WE THE MADE THE MOST MONEY .
--         WRITE A QUERY THAT RETURNS THE ONE CITY THAT HAS THW HIGHEST SUM OF INVOICES TOTALS . RETURN BOTH THE CITY NAMES AND SUM OF ALL 
--		   THE INVOICES TOTALS ?

SELECT * FROM invoice
SELECT TOP 3 billing_city , SUM(TOTAL) AS TOTAL_AMOUNT FROM INVOICE
GROUP BY billing_city
ORDER BY SUM(TOTAL) DESC;


--TASK 5 : WHO IS THE BEST CUSTOMERS ? THE CUSTOMERS WHO HAS SPENT THE MOST MONEY WILL BE DECLARD THE BEST CUSTOMERS .WRITE A QUERY THAT RETURNS
--         THE PERSON WHO HAS SPENT THE MOST MONEY ?

SELECT * FROM CUSTOMER;
SELECT * FROM invoice;
SELECT TOP 1   C.customer_id ,first_name,last_name,SUM(TOTAL) AS MONEY_SPENT  FROM customer C JOIN invoice I 
ON C.customer_id = I.customer_id
GROUP BY C.customer_id,first_name,last_name
ORDER BY SUM(TOTAL) DESC;



--                                         QUESTION SET 2 

-- TASK 1 : WRITE A QUERY TO RETUEN THE EMAIL,FIRSTNAME,LASTNAME AND GENRE OF ALL THE ROCK MUSIC LISTENERS . RETURN YOUR LIST ORDERED APLHABETICALLY
--          BY EMAIL STARTING WITH A?


select distinct c.email , c.first_name,c.last_name    from customer c join invoice i
on c.customer_id = i.customer_id
join invoice_line il on  il.invoice_id =  i.invoice_id 
join track t on il.track_id = t.track_id
join genre g on t.genre_id = g.genre_id
where g.name = 'Rock ' and c.email like '%a%'
order by email ;


-- TASK 2 : WRITE A QUERY THAT RETURNS THE ARTIST NAME AND TOTAL TRACK COUNT OF THR TOP 10 ROCK BRANDS? 

SELECT  artist.artist_id, artist.name,COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id,artist.name
ORDER BY number_of_songs DESC
;


-- TASK 3 : RETURN ALL THE TRACKS THAT HAVE A SONG LENGTH LONGER THAN THE AVERAGE SONG LENGTH . RETURN THE
--			NAME AND MILLISECONDS FOR THE EACH TRACK . ORDER BY THE SONGS WITH THE LONGEST SONGS LISTED FIRST ?

SELECT * FROM track;

SELECT  TOP 10 NAME , MILLISECONDS FROM track
WHERE milliseconds > (SELECT AVG(MILLISECONDS) AS AVG_TRACK FROM track)
ORDER BY milliseconds DESC;



--                                    QUESTION SET 3


-- Q1: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
--with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
--the maximum number of purchases is shared return all Genres. */


-- Method : Using CTE 

WITH popular_genre AS 
(
    SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id
    FROM invoice_line 
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY  customer.country, genre.name, genre.genre_id 
)
SELECT * FROM popular_genre
order by purchases 
;


--Q2: Write a query that determines the customer that has spent the most on music for each country. 
--Write a query that returns the country along with the top customer and how much they spent. 
--For countries where the top amount spent is shared, provide all customers who spent this amount.



-- Method : using CTE 

WITH Customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY customer.customer_id,first_name,last_name,billing_country
		)
SELECT * FROM Customter_with_country WHERE RowNo <= 1






