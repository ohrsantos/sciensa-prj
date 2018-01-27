module.exports = function(app) {
    console.log('module.exports = function(app)');

    var APP_VERSION = '0.02.012a';
    app.get('/', function(req, res) {
    console.log(Date() + ' from: ' + request.connection.remoteAddress + ' app.get(\'/\', ...)');
            res.render('proverbios/index.ejs', {app_env: process.env.APP_ENV,
                                                app_version: APP_VERSION,
                                                process_pid: process.pid,
                                                process_arch: process.arch,
                                                process_platform: process.platform
                                               });
    });

    app.get('/dev', function(req, res) {
    console.log(Date() + ' from: ' + request.connection.remoteAddress + ' app.get(\'/dev\', ...)');
            res.render('proverbios/index.ejs', {app_env: process.env.APP_ENV,
                                                app_version: APP_VERSION,
                                                process_pid: process.pid,
                                                process_arch: process.arch,
                                                process_platform: process.platform
                                               });
    });

    app.get('/prod', function(req, res) {
    console.log(Date() + ' from: ' + request.connection.remoteAddress + ' app.get(\'/prod\', ...)');
            res.render('proverbios/index.ejs', {app_env: process.env.APP_ENV,
                                                app_version: APP_VERSION,
                                                process_pid: process.pid,
                                                process_arch: process.arch,
                                                process_platform: process.platform
                                               });
    });

    app.get('/proverbios', function(req, res) {
        var connection = app.infra.connectionFactory();
        var ProverbiosDAO = new app.infra.ProverbiosDAO(connection);

        ProverbiosDAO.lista(function(err, results) {
            res.render('proverbios/lista', {lista: results});
        });

        connection.end();
    });
}
