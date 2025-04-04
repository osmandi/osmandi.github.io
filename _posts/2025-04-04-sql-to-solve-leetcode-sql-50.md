---
layout: post
title: "El conocimiento de SQL para resolver LeetCode SQL 50"
---

Luego de haber resuelto el reto de [LeetCode SQL 50](https://leetcode.com/studyplan/top-sql-50/) escribo este pequeño blog para compartirte las funciones de SQL que he utilizado para resolverlo y que podrían serte de ayuda. Aprovecho para comentarte que he aplicado estas funciones muchas veces en proyectos de Data Engineer.

[LeetCode SQL 50](https://leetcode.com/studyplan/top-sql-50/) son un conjunto de 50 problemas para resolver con SQL que involucran los problemas más comunes planteados en entrevistas de código con pruebas de SQL, estando agrupados por tipo como Select, Joins, agregaciones, ordenamiento y agrupaciones.

Bueno y sin más presentación, empezamos.

## EXISTS

Sirve para filtrar por la existencia en una subquery con la diferencia de que es más óptimo que usar subqueries.

> La primera vez que vi la función `EXISTS` fue en una query de un compañero de trabajo, estaba bastante incrédulo en lo rápido que funcionaba esa query en comparación con usar `WHERE`.

{% highlight sql %}
SELECT id, name
FROM table1 AS t1
WHERE EXISTS (SELECT 1 FROM table2 AS t2 WHERE t1.id = t2.id)
{% endhighlight %}

## FILTER

Se aplica a las agrupaciones y sirve para aplicar un filtro a esa agrupación en particular.

{% highlight sql %}
SELECT create_date, count(1) , count(1) FILTER (WHERE id = 1)
FROM table1
{% endhighlight %}

## HAVING

Es un filtro que se puede aplicar luego de hacer un `GROUP BY`.

{% highlight sql %}
-- Filtrar por aquellos países con 2 o más registros
SELECT country, COUNT(1) AS total
FROM table1
GROUP BY country
HAVING COUNT(1) > 2
{% endhighlight %}

## REGEX_LIKE

Si encuentra el patrón de búsqueda en formato REGEX (expresiones regulares) retorna `TRUE`.

{% highlight sql %}
-- Filtrar solo los correos gmail
SELECT email
FROM table1
WHERE REGEX_LIKE(email, '.*@gmail\.com$')
{% endhighlight %}

## LIKE

Filtro más sencillo en comparación a expresiones regulares (REGEX).

{% highlight sql %}
-- Filtro de nombres que empiecen por a
SELECT name
FROM table1
WHERE LIKE name 'a%'
{% endhighlight %}

## STRING_AGG

Se utiliza para convertir columnas de texto a un agrupado separado por el símbolo que le indiques.

{% highlight sql %}
-- Agrupar los nombres ordenados alfabéticamente y separados por ','
---- Generará algo como: "nombre1,nombre2,nombre3"
SELECT STRING_AGG(name, ',' ORDER BY name ASC) name_array
FROM table1
{% endhighlight %}

## Windows functions

Las Windows Functions permiten hacer queries con un mayor nivel de dificultad pero muy útiles para situaciones puntuales (una vez las domines sabrás identificar esas situaciones). Las windows functions más comunes (y las que llegué a utilizar en el reto) son las siguientes:

- `ROW_NUMBER`: crea una enumeración de forma secuencial, en caso de haber dos filas que cumplan la misma condición continúa la secuencia numérica.
- `DENSE_RANK`: crea una numeración de forma secuencial, en caso de haber dos filas que cumplan la misma condición repetirá el mismo número para seguir con la secuencia numérica sin salto numérico.
- `RANK`: similar a la función `DENSE_RANK` con la diferencia de que genera un salto de valor numérico en caso de encontrarse con más de una fila que cumpla la misma condición.
- `LAG`: valor anterior de la columna especificada de la fila.
- `LEAD`: valor siguiente de la columna especificada de la fila.

Para dar un ejemplo de estas funciones vamos a crear una base de datos en SQLite. Empezamos creando una tabla e insertando registros aleatorios:

{% highlight sql %}
-- Tables creation
CREATE TABLE IF NOT EXISTS clients (
    id INTEGER PRIMARY KEY,
    name VARCHAR,
    age INTEGER
);

-- Insert data
INSERT INTO clients (name, age) VALUES
    ('Pepito', 20),
    ('Juanito', 20),
    ('Jose', 20),
    ('Maria', 19),
    ('Juanita', 30);
    ('Pepa', 31);
{% endhighlight %}

Con el siguiente código creamos una query con las windows functions comentadas anteriormente:

{% highlight sql %}
SELECT
    id,
    name AS name,
    age AS age, 
    ROW_NUMBER() OVER(ORDER BY age DESC) AS "ROW_NUMBER",
    RANK() OVER(ORDER BY age DESC) AS "RANK",
    DENSE_RANK() OVER(ORDER BY age DESC) AS "DENSE_RANK",
    LAG(name) OVER(ORDER BY id ASC) AS "LAG",
    LEAD(name) OVER(ORDER BY id ASC) AS "LEAD"
FROM clients
ORDER BY id ASC;
{% endhighlight %}

Dando como resultado la siguiente tabla:

| id  | name    | age | ROW_NUMBER | RANK | DENSE_RANK | LAG     | LEAD    |
| --- | ------- | --- | ---------- | ---- | ---------- | ------- | ------- |
| 1   | Pepito  | 20  | 3          | 3    | 3          |         | Juanito |
| 2   | Juanito | 20  | 4          | 3    | 3          | Pepito  | Jose    |
| 3   | Jose    | 20  | 5          | 3    | 3          | Juanito | Maria   |
| 4   | Maria   | 19  | 6          | 6    | 4          | Jose    | Juanita |
| 5   | Juanita | 30  | 2          | 2    | 2          | Maria   | Pepa    |
| 6   | Pepa    | 31  | 1          | 1    | 1          | Juanita |         |


## CTE (Common Table Expressions)

Son tablas que se crean en memoria, dependiendo del motor de bases de datos, algunas se crean en la memoria del disco. Útil como alternativa a las subqueries.

> Ten presente que si el tamaño de la query resultante dentro de una CTE es mayor a la memoria en disco de la base de datos podrías generar algunos problemas.

{% highlight sql %}
-- Crear una tabla con solamente la columna nombre
WITH name_table AS (
    SELECT name
    FROM table1
)
SELECT *
FROM name_table
{% endhighlight %}

## COALESCE

Se utiliza para manejar valores nulos, admite un conjunto de valores y retornará el primer valor no nulo.

{% highlight sql %}
-- Selecionar el nombre y si es nulo colocar 'No aplica'
SELECT COALESCE(name, 'No aplica') as name
FROM table1
{% endhighlight %}

## TO_CHAR

Utilizado para cambiar el formato de fecha.

{% highlight sql %}
-- Filtrar por el mes de enero de 2025
SELECT *
FROM table1
WHERE TO_CHAR(current_date, 'YYYY-mm' = '2025-01')
{% endhighlight %}

## UNION & UNION ALL

Se utilizan para unir resultados de queries como una misma tabla.

> Si lo combinas con las CTE (Common Table Expressions) te ayudará a tener un código ordenado y más sencillo de leer.

{% highlight sql %}
-- Unir los resultados eliminando filas con duplicados
SELECT 1 AS col1 UNION SELECT 1 AS col1

-- Unir los resultados sin eliminar filas duplicadas
SELECT 1 AS col1 UNION ALL SELECT 1 AS col1
{% endhighlight %}

## CASE

Usado para crear condiciones según el valor de la columna.

{% highlight sql %}
-- Colocar como TRUE si los correos terminan en gmail, en caso contrario FALSE
SELECT (
    CASE
    WHEN email LIKE '%@gmail.com' THEN TRUE
    ELSE FALSE
    END
) AS is_gmail
FROM table1
{% endhighlight %}

--- 

Si te ha sido útil o si tienes algún comentario que quieras compartirme de este artículo te invito a dejarlo en mi [LinkedIn](https://www.linkedin.com/in/osmandi/).

Créditos especiales para la publicación [When to choose rank() over dense_rank() or row_number()](https://stackoverflow.com/questions/64420584/when-to-choose-rank-over-dense-rank-or-row-number) en Stack Overflow que me ayudó a ver las diferencias de una forma clara entre cada una de las `Windows Functions`.
