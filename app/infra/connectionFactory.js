var mysql  = require('mysql');

var db_host="sciensa-db-instance.cbfgofnkvvl3.us-east-1.rds.amazonaws.com";

if (process.env.APP_ENV == "DEV") 
   var database="sciensa_dev";

if (process.env.APP_ENV == "PROD") 
   var database="sciensa_prod";

function createDBConnection() {
    return mysql.createConnection({
        host: db_host,
        user: 'root',
        password: '01234567',
        database: database
    });
}

module.exports = function() {
    return createDBConnection;
}
