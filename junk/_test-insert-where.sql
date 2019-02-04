

with max_stuff as (
  select id, max(dttm) as max_thing
  from test t2 where asset_id = 1
  group by id
) 
select t1.id, 
       t1.dttm,
       t1.amt
from test t1
  join max_stuff t2 
    on t1.id = t2.id 
   and t1.dttm = t2.max_thing;




-- Gets the max amt for the max dttm of the asset list items for a given asset
select row_to_json(t)
from (
    SELECT
    id asset_item_id, dttm, max(amt) amt
    FROM asset_items
    WHERE asset_id = 61000 AND dttm = (SELECT MAX (dttm) FROM asset_items WHERE asset_id = 61000)
    GROUP BY dttm, id
) t;






SELECT DISTINCT ON (1)
       id, amt, max(dttm)
FROM   test
where asset_id = 1
ORDER  BY 1, 2 DESC, 3;



select t1.id,
       t1.dttm,
       t1.amt
from test t1
where t1.asset_id = 1 and t1.dttm = (select max(t2.dttm) 
                  from test t2
                  where t2.id = t1.id and t1.asset_id = 1);



INSERT INTO expense_items (expense_id, vendor, note, amt, dttm)
SELECT 99, 'Walmart', 'Groceries', 9.98, '2018-12-13'                -- inserting single row
FROM   expenses
WHERE  id = 9 AND wallet_id = 1
HAVING count(*) = 1

RETURNING *;

