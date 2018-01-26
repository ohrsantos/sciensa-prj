function ProverbiosDAO(connection) {
    this._connection = connection;
}

ProverbiosDAO.prototype.lista = function(callback) {
    this._connection.query('SELECT * FROM messages',callback);
}

module.exports = function(){
    return ProverbiosDAO;
};

