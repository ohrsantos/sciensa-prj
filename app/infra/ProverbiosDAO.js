function ProverbiosDAO(connection) {
    this._connection = connection;
}

ProverbiosDAO.prototype.lista = function(callback) {
    this._connection.query('SELECT * FROM messages',callback);
}

ProverbiosDAO.prototype.insert = function(proverbios, callback){
    this._connection.query('INSERT INTO messages SET ?', proverbios, callback);
    //Essa seria a forma origina sem uma das ajudas do parser
    //this._connection.query('insert into produtos (titulo, preco, descricao) values (?, ?, ?)',  [produto.titulo, produto.preco, produto.descricao], callback);
}

module.exports = function(){
    return ProverbiosDAO;
};

