module.exports = function(app) {
    var APP_VERSION = '0.02.007a';
    app.get('/dev', function(req, res) {
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
