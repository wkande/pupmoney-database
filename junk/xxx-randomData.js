const { Pool, Client } = require('pg');





console.log('________ RANDOM DATA _________')


// DTTM
function randomDate(start, end) {
    return new Date(start.getTime() + Math.random() * (end.getTime() - start.getTime()));
}

// EXPENSE_ID: function always returns a random number between min (included) and max (excluded):
function getRndInteger(min, max) {
    return Math.floor(Math.random() * (max - min) ) + min;
}

// AMT 
function getRndAmount(lo, hi, prec) {
    prec= Math.floor(Math.random()*(prec+1));
    return Number((lo+ Math.random()*(hi-lo+1)).toFixed(prec));
}


// START
async function start(){
    for(var i=0; i< 1000; i++){
        let z = getRndInteger(1, 23);
        let amt = getRndAmount(1, 50, 2);
        let dat = randomDate(new Date(2018, 0, 1), new Date());
        if (z ===1 || z === 22)
            console.log(z, amt.toFixed(2), dat);
            try{
                var query = {
                    name: 'expense-item-post_random',
                    text: `INSERT INTO expense_items (expense_id, note, vendor, amt, dttm)
                        VALUES ($1, null, null, $2, $3)
                        RETURNING *;`,
                        values: [z, amt, dat]
                };
                const data = await pool.query(query);
                console.log(data.rows[0])
            }
            catch(err){
                console.log(err);
            }
    }
}



//************** DB CONNECT *************/
const pool = new Pool({
    connectionString: process.env.DB_URL
})
// The query will start the pool
pool.query('SELECT NOW()', (err, res) => {
    if(err){
        console.log('++++++++++++++ Connect ERROR ++++++++++++++');
        console.log(err, res);
    }
    else{
        console.log('Connected to:', pool.options.connectionString);
        start();
    }
})


// Keeps Node alive
process.stdin.resume();



