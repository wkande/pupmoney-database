SELECT e.id, e.category_id, e.dttm
                FROM expenses e JOIN categories c
                ON e.category_id = c.id
                WHERE e.dttm between '2010-01-01' AND '2019-01-01' AND c.wallet_id = 1  
                ORDER BY e.dttm DESC, e.id DESC LIMIT 50 OFFSET 0;
