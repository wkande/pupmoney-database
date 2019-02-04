const { Pool, Client } = require('pg');



console.log('_________________')


let pswd = '8cf90eba82926e8a0cf760846ef327052c5c2de1d18f05795ea7b24127adfae2';


// ADD ADDITIONAL USERS ///////////////////
let name = '';
let email = '';
let cnt = 0;


let addWallets = async function(){
    // Add asset and exp items for wallets 1 and 2

    // Asset IDs 1-6 belong to wallet_id #1
    for(var i=1; i<6; i++){
        for(var y=0; y<30; y++){
            await addAssetItems(i);
        }
    }

    // Exp IDs 1-22 belong to wallet_id #1
    for(var i=1; i<23; i++){
        for(var y=0; y<300; y++){
            const expItem = await addExpItems(i);
        }
    }

    
    // Get all users except first two
    var query = {
        name: 'users-get',
        text: "SELECT * from users",
        values: []
    };
    const data = await pool.query(query);
    for(let i=0; i<data.rows.length; i++){
        console.log('USER', data.rows[i].id, data.rows[i].email);

        // Add 2 wallets
        for(var z=0;z<2;z++){
            var queryWallet = {
                name: 'wallets-insert',
                text: "INSERT INTO wallets (user_id, name, shares) VALUES($1, $2, $3) RETURNING *",
                values: [data.rows[i].id, 'Wallet #'+z, '{'+(data.rows[i].id+2)+', '+(data.rows[i].id+1)+'}']
            };
            const wallet = await pool.query(queryWallet);
            console.log('      WALLET', wallet.rows[0].id);

            // Add assets
            const one = await addAssets(wallet.rows[0].id);
            const two = await addExpenses(wallet.rows[0].id);
        }
        
    }
    console.log('++++++++++ DONE ++++++++++++++')
};






let addAssets = async function(wallet_id){
    for(let z=0; z<5; z++){
        var query = {
            name: 'assets-insert',
            text: "INSERT INTO assets (wallet_id, name, dttm) VALUES($1, $2, current_date) RETURNING *",
            values: [wallet_id, 'Asset #'+z]
        };
        const res = await pool.query(query);
        for(var i=0; i<res.rows.length; i++){
            //console.log(i)
            for(var y=0; y<30; y++){
                await addAssetItems(res.rows[i].id);
            }
        }
    }
}
let addAssetItems = async function(asset_id){
    var precision = 100; // 2 decimals
    var randomnum = Math.floor(Math.random() * (10000 * precision - 1 * precision) + 1 * precision) / (1*precision);
    let randumDate = randomDate(new Date(2014, 0, 1), new Date());
    randumDate.setDate(01);
    //console.log(randumDate, randumDate.getDate());
    try{
        var query = {
            name: 'asset-items-post',
            text: "insert into asset_items (asset_id, amt, dttm) values ($1, $2, $3)",
            values: [asset_id, randomnum, randumDate]
        };
        const res = await pool.query(query);
    }
    catch(err){
        // May fail due to dupliocate date, just let it go
        //console.log(err.detail);
    }
}


////////// EXP ///////////////////
let addExpenses = async function(wallet_id){
    //console.log('adding to wallet_id', wallet_id)
    for(let z=0; z<20; z++){
        var query = {
            name: 'exp-insert',
            text: "INSERT INTO expenses (wallet_id, name, dttm) VALUES($1, $2, current_date) RETURNING *",
            values: [wallet_id, 'Expense #'+z]
        };
        const res = await pool.query(query);
        //console.log('->>Expense', res.rows[0].id);
        for(var i=0; i<res.rows.length; i++){
            for(var y=0; y<300; y++){
                await addExpItems(res.rows[i].id);
            }
        }
    }
}
let addExpItems = async function(exp_id){
    var precision = 100; // 2 decimals
    var randomnum = Math.floor(Math.random() * (10 * precision - 1 * precision) + 1 * precision) / (1*precision);
    let randumDate = randomDate(new Date(2014, 0, 1), new Date());
    var query = {
        name: 'exp-items-post',
        text: "insert into expense_items (expense_id, amt, dttm) values ($1, $2, $3)",
        values: [exp_id, randomnum, randumDate]
    };
    const res = await pool.query(query);
}


function randomDate(start, end) {
    return new Date(start.getTime() + Math.random() * (end.getTime() - start.getTime()));
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
        addWallets();
    }
})


// Keeps Node alive
process.stdin.resume();



