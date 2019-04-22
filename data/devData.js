const { Pool, Client } = require('pg');
var fs = require("fs");
var war = fs.readFileSync("./data/_war_peace.txt").toString('utf-8');
var format = require('pg-format');

let name;
let email;


let start = async function(){
    // Get the count of existing users
    var query = {
        name: 'user-get-count',
        text: "SELECT count(*) cnt from pupmoney.users"
    };
    const countRes = await shards[0].query(query);
    let cnt = countRes.rows[0].cnt;
    console.log('USERS count:', countRes.rows[0].cnt, cnt); 


    // Add warren and betsy
    if(cnt == 0 ){
        name = 'Warren Anderson';
        email = 'warren@wyoming.cc';
        const data = await addUser();

        name = 'Betsy Anderson';
        email = 'betsy@wyoming.cc';
        const data2 = await addUser();

        // Update Betsy Wallet Shares
        var queryBetsyUpdate = {
            name: 'betsy-wallet-shares',
            text: "UPDATE pupmoney.wallets SET name = 'Betsy Wallet', shares = ARRAY[1] WHERE user_id = 2"
        };
        const betsySharesRes = await shards[0].query(queryBetsyUpdate); // shard 0 here

        // Warren as sys_admin
        var queryWarrenUpdateAdmin = {
            name: 'users-patch-warren-2',
            text: "UPDATE pupmoney.users SET sys_admin = 1 WHERE email = 'warren@wyoming.cc'"
        };
        const sysAdminsRes = await shards[0].query(queryWarrenUpdateAdmin);

        cnt = 2;
    }

    // Add more users
    for(var i=0; i<30000; i++){
        cnt++;
        name = 'TestUser_'+cnt;
        email = 'test_user_'+cnt+'@noaddresshere.com';
        const data = await addUser();
    }
    console.log('++++++++++ DONE ++++++++++++++')

}



/**
 * Only use shard 0 for USERS
 */
let addUser = async function(){
        // GET THE NEXT WALLET SHARD
        const shard = await getShard();


        var query = {
            name: 'users-post-with-default-wallet',
            text: "SELECT * from pupmoney.add_user($1, $2, $3)",
            values: [name, email, shard]
        };
        const userRes = await shards[0].query(query); // shard 0 here
        console.log('\n==> USER created <==\n', userRes.rows[0].add_user);


        // ==========================================
        // GET THE DEFAULT WALLET, should only be one
        var query = {
            name: 'wallets-get-default',
            text: "SELECT * from pupmoney.wallets where default_wallet = 1 AND user_id = $1",
            values: [userRes.rows[0].add_user.id]
        };
        const data = await shards[0].query(query); // shard 0 here
        let wallet_id = data.rows[0].id;
        let wallet_shard = data.rows[0].shard;
        console.log('WALLET_ID/USER_ID/SHARD', wallet_id, userRes.rows[0].add_user.id, wallet_shard)
        

        // ==========================================
        // CALL finalize_wallet()
        var query = {
            name: 'users-post-with-finalize-wallet',
            text: "SELECT * from pupmoney.finalize_wallet($1)",
            values: [wallet_id]
        };
        const walletRes = await shards[wallet_shard].query(query);
        console.log('FINALIZE WALLET:', walletRes.rows[0]);

        const two = await startExpItems(data.rows[0].id, shard);
        
};



// ***** GET SHARD ***** //
let getShard = async function(){
    let sizes = [];
    for (let z=0; z<shards.length;z++){
        // Get the db name from the connect string of the url array
        let dbName = urls[z].split('/')[3];
        try{
            var query = { name: "select-shard", text: "select pg_database_size('"+dbName+"')" };
            const res = await shards[z].query(query);
            let size = parseInt(res.rows[0].pg_database_size);
            //if(z===0) size = (size*2.5);
            sizes.push(size);
        }
        catch(err){
            console.log('++++++++++++++ GET SHARD ERROR ++++++++++++++');
            console.log(err);
        }
    }
    // https://www.google.com/search?q=js+string+to+number&rlz=1C5CHFA_enUS824US824&oq=js+string+to+number&aqs=chrome..69i57.3255j0j4&sourceid=chrome&ie=UTF-8
    let shard = sizes.indexOf(Math.min.apply(null,sizes))
    console.log(sizes, shard)
    return shard;
}




////////// CAT ///////////////////
let startExpItems = async function(wallet_id, shard){
    var query = {
        name: 'exp-get',
        text: "SELECT * from pupmoney.categories where wallet_id = $1 order by name",
        values: [wallet_id]
    };
    const res = await shards[shard].query(query);
    console.log('  CATEGORIES FOUND', res.rowCount);

    let arr = [];
    for(var i=0; i<res.rows.length; i++){
        //console.log("      CAT_ID", res.rows[i].id, "NAME", res.rows[i].name);
        
        process.stdout.write('.');
        for(var z=0; z<2000; z++){
            //await addExpenses(res.rows[i].id, shard);
            arr.push(addExpenses(res.rows[i].id, shard));
        }

        

    }

    // Bulk insert for each category
        console.log('ARRAY LOADED')
        try{
            let query = format('INSERT INTO expenses (category_id, amt, dttm, note, vendor, document) VALUES %L', arr);
            
            const res = await shards[shard].query(query);
            console.log('ARRAY INSERTED')
        }
        catch(err){
            // May fail due to duplicate date, just let it go
            console.log("ERROR inserting expense:", err.toString());
        }

    
}


let addExpenses = function(cat_id, shard){
    var precision = 100; // 2 decimals
    var randomnum = Math.floor(Math.random() * (10 * precision - 1 * precision) + 1 * precision) / (1*precision);
    let randumDate = getRandomDate(new Date(2009, 0, 1), new Date());
    let vendor = randomVendor();
    let note = getNoteTextDoc();
    //console.log('cat_id, shard', cat_id, shard);

    // Credit
    var items = Array(0,0,0,0,0,1,0,1,0,0,1,0,0,0);
    var credit = items[Math.floor(Math.random()*items.length)];
    if(credit == 1) randomnum = randomnum * -1;
    
    return [cat_id, randomnum, randumDate, note, vendor, "Placeholder for trigger"];

    /*try{
        var query = {
            name: 'expenses-item-post',
            text: `insert into expenses (category_id, amt, dttm, note, vendor, document) 
            values ($1, $2, $3, $4, $5, $6) returning id`,
            values: [cat_id, randomnum, randumDate, note, vendor, "Placeholder for trigger"]
        };
        const res = await shards[shard].query(query);
    }
    catch(err){
        // May fail due to duplicate date, just let it go
        console.log("ERROR inserting expense:", err.toString());
    }*/
    
}



// ***** GET NOTE TEXT ***** //
function getNoteTextDoc(){
    let randomWar = Math.floor((Math.random() * 3273635) + 100000);
    var note = war.substr(randomWar, 70);
    note = note.trim();
    note = note.replace(/\r/g, " ");
    note = note.replace(/\n/g, " ");
    note = note.replace(/:/g, " ");
    return note;
}


function getRandomDate(start, end) {
    return new Date(start.getTime() + Math.random() * (end.getTime() - start.getTime()));
}


// ***** GET RANDOM VENDOR ***** //
var textArray = ['Amazon','Walmart','Home Depot', 'Office Depot', 'Taco Bell','Target','REI','Best Buy',
'HP', 'Dell', 'Apple', 'AOC','Verizon','Misc Depatment Stores','Alberstons','Misc Grocery Stores'];
var randomNumber = Math.floor(Math.random()*textArray.length);
function randomVendor(){
    return textArray[Math.floor(Math.random()*textArray.length)];
}


//************** DB CONNECT *************/

let shards = [];
const urls =  process.env.DB_URLS.split(' ');
for (var i=0; i<urls.length;i++){
    console.log(urls[i])
}

for (var i=0; i<urls.length;i++){
    shards.push( new Pool({connectionString: urls[i]}) )
}




// TICKLE THE SHARDS
let tickleShard = async function(shardNumb){
    try{
        var query = { name: 'select-now',text: 'SELECT NOW()' };
        const res = await shards[shardNumb].query(query);
        console.log('Connected to:', shards[shardNumb].options.connectionString);

    }
    catch(err){
        console.log('++++++++++++++ Connect ERROR ++++++++++++++');
        console.log(err);
    }

};
let initShards = async function(){
    for (let z=0; z<shards.length;z++){
        const res = await tickleShard(z);
    }
    console.log('++++++++++ ADD USERS NOW ++++++++++++')
    start();
}
initShards();



// Keeps Node alive
process.stdin.resume();



