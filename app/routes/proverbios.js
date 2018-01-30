module.exports = function(app) {
    console.log('module.exports = function(app)');

    var APP_VERSION = '0.02.025a';

function log_date_ip(req, path) {
        var ip;
        if (req.headers['x-forwarded-for']) {
            ip = req.headers['x-forwarded-for'].split(",")[0];
        } else if (req.connection && req.connection.remoteAddress) {
            ip = req.connection.remoteAddress;
        } else {
            ip = req.ip;
        }console.log(Date() + '| client IP: ' + ip + ' ' + path );
}
        //}console.log(Date() + '| client IP: ' + ip + ' app.get(\'/dev\', ...)');

/*
function getCallerIP(request) {
    var ip = request.headers['x-forwarded-for'] ||
        request.connection.remoteAddress ||
        request.socket.remoteAddress ||
        request.connection.socket.remoteAddress;
    ip = ip.split(',')[0];
    ip = ip.split(':').slice(-1); //in case the ip returned in a format: "::ffff:146.xxx.xxx.xxx"
    return ip;
}
*/
    app.get('/', function(req, res) {
        console.log(Date() + ' app.get(\'/\', ...)');
        res.render('proverbios/index.ejs', {app_env: process.env.APP_ENV,
                                            app_version: APP_VERSION,
                                            process_pid: process.pid,
                                            process_arch: process.arch,
                                            process_platform: process.platform
                                           }
        );
    });

    app.get('/dev', function(req, res) {
        res.render('proverbios/index.ejs', {app_env: process.env.APP_ENV,
                                            app_version: APP_VERSION,
                                            process_pid: process.pid,
                                            process_arch: process.arch,
                                            process_platform: process.platform
                                           }
        );
        log_date_ip(req, '/dev');
    });

    app.get('/prod', function(req, res) {
        console.log(Date() + ' app.get(\'/prod\', ...)');
        res.render('proverbios/index.ejs', {app_env: process.env.APP_ENV,
                                            app_version: APP_VERSION,
                                            process_pid: process.pid,
                                            process_arch: process.arch,
                                            process_platform: process.platform
                                           }
        );
    });

    app.get('/proverbios', function(req, res) {
        var connection = app.infra.connectionFactory();
        var ProverbiosDAO = new app.infra.ProverbiosDAO(connection);

        ProverbiosDAO.lista(function(err, results) {
            res.render('proverbios/lista', {lista: results});
        });

        connection.end();
    });

    app.get('/dev/proverbios', function(req, res) {
        var connection = app.infra.connectionFactory();
        var ProverbiosDAO = new app.infra.ProverbiosDAO(connection);

        ProverbiosDAO.lista(function(err, results) {
            res.render('proverbios/lista', {lista: results});
        });

        connection.end();
    });

    app.get('/prod/proverbios', function(req, res) {
        var connection = app.infra.connectionFactory();
        var ProverbiosDAO = new app.infra.ProverbiosDAO(connection);

        ProverbiosDAO.lista(function(err, results) {
            res.render('proverbios/lista', {lista: results});
        });

        connection.end();
    });
}
