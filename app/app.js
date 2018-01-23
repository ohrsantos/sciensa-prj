var http = require('http');
var url = require('url');
var mysql = require('mysql');

var app_version='0.051a'

var db_host="sciensa-db-instance.cbfgofnkvvl3.us-east-1.rds.amazonaws.com";
var connected=false;

if (process.env.APP_ENV == "DEV") 
   var database="sciensa_dev";

if (process.env.APP_ENV == "PROD") 
   var database="sciensa_prod";

var con = mysql.createConnection({
  host: db_host,
  user: "root",
  password: "sciensa1",
  database: database
});

con.connect(function(err) {
  if (err) throw err;
  connected=true;
});

var public_dns=process.env.PUBLIC_DNS;

http.createServer(function (req, res) {
res.writeHead(200, {'Content-Type': 'text/html'});
    var q = url.parse(req.url, true).query;
    res.write('<html>');
    res.write('<head><title></title><meta charset="utf-8"></head>');
    res.write('<body style="color: rgb(15, 15, 15); background-color:rgb(250, 250, 250)">');
    res.write('<h1 style="font-family:Sans-serif;background-color:#C01080; color:white;">Sciensa - Projeto (' + process.env.APP_ENV + ') ver: ' + app_version + '</h1><br>');
    if (connected == true) {
       res.write("<h3> RDS: " + db_host + "/" + database + " ... conectado com sucesso! </h3>");
    }
    res.write("Horário UTC deste servidor: " + Date());
    res.write('<ul>');
    res.write('<li>pid: ' + process.pid + '</li>');
    res.write('<li>uptime: ' + process.uptime() + ' </li>');
    res.write('<li>Arquitetura: ' + process.arch + '</li>');
    res.write('<li>Plataforma: ' + process.platform + '</li>');
    res.write('</ul>');
    res.write('URL:' + req.url + '<br>');
    res.write('<br><button type="button" onclick="alert(\'Hello World!\')">Ol&aacute;!</button>');
    res.write('<br><button type="button" onclick="window.location.href=\'http://' + public_dns + ':3000/?action=select\'">Select</button>');
    switch(q.action) {
        case "insert":
            //con.query("INSERT INTO messages (lang, content, author) VALUES ?", [records], function (err, result, fields) {
                //if (err) throw err;
            //});
            res.write('<h4> Rescurso ainda nao implementado</h4>');
            res.end('</body></html>');
            break;
        case "select":
            //res.write('<h3>' + q.action + '</h3>');
            con.query("SELECT * FROM messages", function (err, result, fields) {
                if (err) throw err;
                res.write('<hr>');
                res.write('<ul>');
                Object.keys(result).forEach(function(key) {
                    var row = result[key];
                    res.write('<li> <p style="font-family: Verdana, Geneva, sans-serif"><q>' + row.content + '</q></p></li>');
                    console.log(row.content)
                  });
                res.write('</ul>');
                res.end('</body></html>');
            });
            break;
        case "drop":
            //res.write('<h3>' + q.action + '</h3>');
            res.write('<h4> Rescurso ainda nao implementado</h4>');
            res.end('</body></html>');
            break;
        default:
            res.end('</body></html>');
    }
}).listen(3000);
