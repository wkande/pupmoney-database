const { Pool, Client } = require('pg');
var fs = require("fs");
var war = fs.readFileSync("./data/_war_peace.txt").toString('utf-8');


let name;
let email;


let start = async function(){
    // Get the count of existing users
    var query = {
        name: 'user-get-count',
        text: "SELECT count(*) cnt from users"
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
            text: "UPDATE wallets SET name = 'Betsy Wallet', shares = ARRAY[1] WHERE user_id = 2"
        };
        const betsySharesRes = await shards[0].query(queryBetsyUpdate); // shard 0 here

        // Warren as sys_admin
        var queryWarrenUpdateAdmin = {
            name: 'users-patch-warren-2',
            text: "UPDATE users SET sys_admin = 1 WHERE email = 'warren@wyoming.cc'"
        };
        const sysAdminsRes = await shards[0].query(queryWarrenUpdateAdmin);

        cnt = 2;
    }

    // Add more users
    for(var i=0; i<2; i++){
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
            text: "SELECT * from add_user($1, $2, $3)",
            values: [name, email, shard]
        };
        const userRes = await shards[0].query(query); // shard 0 here
        console.log('\n==> USER created <==\n', userRes.rows[0].add_user);


        // ==========================================
        // GET THE DEFAULT WALLET, should only be one
        var query = {
            name: 'wallets-get-default',
            text: "SELECT * from wallets where default_wallet = 1 AND user_id = $1",
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
            text: "SELECT * from finalize_wallet($1)",
            values: [wallet_id]
        };
        const walletRes = await shards[wallet_shard].query(query);
        console.log('FINALIZE WALLET:', walletRes.rows[0]);

        const one = await startAssetItems(wallet_id, shard);
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



let startAssetItems = async function(wallet_id, shard){
    var query = {
        name: 'assets-get',
        text: "SELECT * from assets where wallet_id = $1 order by name",
        values: [wallet_id]
    };
    const res = await shards[shard].query(query);
    console.log('  ASSETS FOUND', res.rowCount);
    for(var i=0; i<res.rows.length; i++){
        for(var z=0; z<48; z++){
            try{
                await addAssetItems(res.rows[i].id, shard);
            }
            catch(err){
                // If there is a duplicate dattm let it go
            }
        }
    }
}
let addAssetItems = async function(asset_id, shard){
    var precision = 100; // 2 decimals
    var randomnum = Math.floor(Math.random() * (10 * precision - 1 * precision) + 1 * precision) / (1*precision);
    let randumDate = getRandomDate(new Date(2014, 0, 1), new Date());
    // console.log('randumDate', randumDate);
    //randumDate.setDate(01);
    try{
        var query = {
            name: 'asset-items-post',
            text: "insert into asset_items (asset_id, amt, dttm) values ($1, $2, $3)",
            values: [asset_id, randomnum, randumDate]
        };
        const res = await shards[shard].query(query);
        //process.stdout.write(".");
    }
    catch(err){
        // May fail due to duplicate date, just let it go
        //console.log(err.detail);
    }

}


////////// EXP ///////////////////
let startExpItems = async function(wallet_id, shard){
    var query = {
        name: 'exp-get',
        text: "SELECT * from expenses where wallet_id = $1 order by name",
        values: [wallet_id]
    };
    const res = await shards[shard].query(query);
    console.log('  EXPENSES FOUND', res.rowCount);
    for(var i=0; i<res.rows.length; i++){
        //console.log("      EXP_ID", res.rows[i].id, "NAME", res.rows[i].name);
        for(var z=0; z<300; z++){
            await addExpItems(res.rows[i].id, res.rows[i].name, shard);
        }
    }
}
let addExpItems = async function(exp_id, exp_name, shard){
    var precision = 100; // 2 decimals
    var randomnum = Math.floor(Math.random() * (10 * precision - 1 * precision) + 1 * precision) / (1*precision);
    let randumDate = getRandomDate(new Date(2014, 0, 1), new Date());
    let vendor = randomVendor();
    let note = getNoteTextDoc();
    //console.log(note);
    let document = getSearchTextDoc(exp_name, vendor, note);
    //console.log('===>'+document+'<===');
    
    
        var query = {
            name: 'exp-items-post',
            text: `insert into expense_items (expense_id, amt, dttm, document, note, vendor) 
            values ($1, $2, $3, to_tsvector($4), $5, $6) returning id`,
            values: [exp_id, randomnum, randumDate, document, note, vendor]
        };
        const res = await shards[shard].query(query);
    
}

// ***** BUILD TEXT DOCUMENT ***** //
// https://www.compose.com/articles/mastering-postgresql-tools-full-text-search-and-phrase-search/
function getSearchTextDoc(exp_name, vendor, note){
    if(!note) note = ' ';
    if(!vendor) vendor = '';
    return exp_name+' '+vendor+' '+note;
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



