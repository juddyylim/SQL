USE sakila;

-- 1a. Display the first and last names of all actors from the table 'actor'
SELECT first_name, last_name 
FROM actor;
-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column 'Actor Name'
SELECT CONCAT(first_name, ' ', last_name) AS 'Actor Name' 
FROM actor;
-- 2a. You need to find the ID number, first name and last name of an actor, of whom you now only the first name, "Joe". What is one query you would use to obtain this information?
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'Joe';
-- 2b. Find all actors whose last name contain the letters 'GEN':
SELECT first_name, last_name
FROM actor
WHERE last_name LIKE '%GEN';
-- 2c. Find all actors whose last names contain the letters 'LI'. This time, order the rows by last name and first name, in that order:
SELECT first_name, last_name
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name DESC;
-- 2d. Using 'IN', display the 'country_id' and 'country' columns of the following countries: Afghanistan, Bangladesh and China: 
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');
-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table 'actor' named 'description' and use the data type 'BLOB' (Make sure to research the type 'BLOB', as the difference between it and 'VARCHAR' are significant).
ALTER TABLE actor
ADD COLUMN description BLOB;
-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the 'description' column.
ALTER TABLE actor
DROP description;
-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(*)
FROM actor
GROUP BY last_name;
-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(*)
FROM actor
GROUP BY last_name
HAVING COUNT(*) >=2;
-- 4c. The actor 'HARPO WILLIAMS' was accidentally entered in the 'actor' table as 'GROUCHO WILLIAMS'. Write a query to fix the record.
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO';
-- 4d. Perhaps we were too hasty in changing 'GROUCHO' to 'HARPO'. It turns out that 'GROUCHO' was the correct name after all! In a single query, if the first name of the actor is currently 'HARPO', change it to 'GROUCHO'.
UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO';
-- 5a. You cannot locate the schema of the 'address' table. Which query would you use to re-create it?
SHOW CREATE TABLE address;
-- 6a. Use 'JOIN' to display the first and last names, as well as the address, of each staff member. Use the tables 'staff' and 'address': 
SELECT s.first_name, s.last_name, a.address
FROM staff s LEFT JOIN address a ON s.address_id = a.address_id;
-- 6b. Use 'JOIN' to display the total amount rung up by each staff member in August of 2005. Use tables 'staff' and 'payment'.
SELECT s.first_name, s.last_name, SUM(p.amount) AS total_rung
FROM staff s LEFT JOIN payment p ON s.staff_id = p.staff_id
WHERE p.payment_date LIKE '%2005-08-%'
GROUP BY s.staff_id;
-- 6c. List each film and the number of actors who are listed for that film. Use tables 'film_actor' and 'film'. Use inner join. 
SELECT f.title, COUNT(fa.actor_id) AS actor_number
FROM film f INNER JOIN film_actor fa on f.film_id = fa.film_id
GROUP BY f.title;
-- 6d. How many copies of the film 'Hunchback Impossible' exist in the inventory system?
SELECT f.title, COUNT(f.title) AS film_count
FROM film f INNER JOIN inventory i ON f.film_id = i.film_id
WHERE f.title = 'Hunchback Impossible'
GROUP BY f.title;
-- 6e. Using the tables 'payment' and 'customer' and the 'JOIN' command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT c.first_na, c.last_name, SUM(p.amount) AS total_paid
FROM customer c INNER JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY last_name;
-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an uninteded consequence, films starting with the letters 'K' and 'Q' have also soared in popularity. Use subqueries to display the titles of movies starting with the letters 'K' and 'Q' whose languasge is English.
SELECT f.title
FROM film f
WHERE f.title LIKE 'K%'OR f.title LIKE 'Q%'
AND language_id IN (
SELECT language_id
FROM language
WHERE name = 'English'
);
-- 7b. Use subqueries to display all actors who appear in the film 'Alone Trip'.
SELECT first_name, last_name 
FROM actor
WHERE actor_id IN (
	SELECT actor_id
FROM film_actor
WHERE film_id IN (
	SELECT film_id
FROM film
WHERE title = 'Alone Trip')
);
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT first_name, last_name, email country 
FROM customer c
INNER JOIN address a ON a.address_id = c.address_id
INNER JOIN city ci ON a.city_id = ci.city_id
INNER JOIN country co ON ci.country_id = co.country_id
WHERE country = 'CANADA';
-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films. 
SELECT title
FROM film f
INNER JOIN film_category fc ON f.film_id = fc.film_id
INNER JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Family';
-- 7e. Display the most frequently rented movies in descending order. 
SELECT title, COUNT(title) AS rented
FROM film f
INNER JOIN inventory i ON f.film_id = i.film_id
INNER JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY title
ORDER by rented DESC;
-- 7f. Write a query to display how much business, in dollars, each store brought in. 
SELECT st.store_id, SUM(amount) AS total
FROM payment p
INNER JOIN staff s ON p.staff_id = s.staff_id
INNER JOIN store st ON s.store_id = st.store_id
GROUP BY st.store_id;
-- 7g. Write a query to display for each store its store ID, city and country. 
SELECT s.store_id, c.city, co.country
FROM store s
INNER JOIN address a ON s.address_id = a.address_id
INNER JOIN city c ON a.city_id = c.city_id
INNER JOIN country co ON c.country_id = co.country_id;
-- 7h. List the top five genres in gross revenue in descending order. 
SELECT c.name FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN inventory i ON fc.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY SUM(amount) DESC LIMIT 5;
