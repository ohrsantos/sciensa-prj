module.exports = function(app) {

    app.get('/', function(req, res) {
        //var connection = app.infra.connectionFactory();
        //var ProverbiosDAO = new app.infra.ProverbiosDAO(connection);

        //ProverbiosDAO.lista(function(err, results) {
            res.render('proverbios/index.ejs', {app_env: process.env.APP_ENV, app_ver: '0.02.002a'});
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
