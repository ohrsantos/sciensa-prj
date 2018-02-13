function ProverbiosDAO(connection) {
    this._connection = connection;
}

ProverbiosDAO.prototype.lista = function(callback) {
    this._connection.query('SELECT * FROM messages',callback);
}

ProverbiosDAO.prototype.insert = function(proverbios, callback){
    this._connection.query('INSERT INTO messages SET ?', proverbios, callback);
}

module.exports = function(){
    return ProverbiosDAO;
};

