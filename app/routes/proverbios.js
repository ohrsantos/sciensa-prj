module.exports = function(app) {
    var APP_VERSION = '0.02.003a';
    app.get('/', function(req, res) {
        //var connection = app.infra.connectionFactory();
        //var ProverbiosDAO = new app.infra.ProverbiosDAO(connection);

        //ProverbiosDAO.lista(function(err, results) {
            res.render('proverbios/index.ejs', {app_env: process.env.APP_ENV, app_version: APP_VERSION});
        //});

        //connection.end();
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
