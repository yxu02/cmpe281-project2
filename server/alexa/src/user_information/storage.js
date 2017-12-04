/**
 * @Author: Yu Xu <yu.xu@sjsu.edu>
 * 
 * This file contains Db storage and management logic for all indents.
 */

'use strict';
var mysql = require('mysql');
const uuidv1 = require('uuid/v1');

var connection = mysql.createConnection({
  host: 'xxxxxxxxxxxxxx',
  user: 'xxxxxxxxxxx',
  password: 'xxxxxxxxxxxx',
  database: 'xxxxxxxxxx',
  debug: true
});

module.exports.saveUser = (data) => {
    var that = this;

    var query = "SELECT user_id FROM users281 WHERE amazon_userId = ?";

    connection.query(query, [data.amazonID], (err, rows) => {
      if (err) {
        console.log('first error!');
      }

      if (rows[0] === undefined) {
        var query = 'REPLACE INTO users281 (amazon_userId, user_id, name, age, gender, address, created_at)' +
          'VALUES (' + connection.escape(data.amazonID) + ', ' + connection.escape(uuidv1()) + ', ' +
          connection.escape(data.name) + ', ' + connection.escape(data.age) + ', ' +
          connection.escape(data.gender) + ', ' + connection.escape(data.address) + ', NOW())';

        connection.query(query, (err, result) => {
          if (!err) {
            console.log('sssssssssss');
            that.emit(":tell", "success!");
            connection.end();
          } else {
            console.log('second error!');
          }
        });
      } else {
        console.log(JSON.stringify(rows[0]));
      }
//      callback(null, 'success!');
    });
};