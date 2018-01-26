module.exports = function(app) {
    var app_version='0.02.002a';

    app.get('/', function(req, res) {
        //var connection = app.infra.connectionFactory();
        //var ProverbiosDAO = new app.infra.ProverbiosDAO(connection);

        //ProverbiosDAO.lista(function(err, results) {
            res.render('proverbios/index.ejs', {app_env: process.env.APP_ENV, app_ver: app_ver});
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
