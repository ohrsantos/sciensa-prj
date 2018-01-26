module.exports = function(app) {
    app.get('/proverbios', function(req, res) {
        var connection = app.infra.connectionFactory();
        var proverbiosDAO = new app.infra.ProverbiosDAO(connection);

        ProverbiosDAO.lista(function(err, results) {
            res.render('proverbios/lista', {lista: results});
        });

        connection.end();
    });
}
