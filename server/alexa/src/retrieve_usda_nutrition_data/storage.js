/**
 * @Author: Yu Xu <yu.xu@sjsu.edu>
 * 
 * This file contains Db storage and management.
 */

var mysql = require('mysql');

module.exports = {

  /**
   * function to save data to database
   */
  save: function (ori_data, dest_data) {

    var connection = mysql.createConnection({
      host: 'xxxxxxxxxxxxxxxx',
      user: 'xxxxxxxxxxxxxx',
      password: 'xxxxxxxxxxxxx',
      database: 'xxxxxxxxxxxxx',
      debug: true
    });

    var query = 'REPLACE INTO nutrition(usda_food_id, food_name, energy, carb, protein, fat, water, sugar, fiber, created_at)' + 'VALUES (' + connection.escape(ori_data.usda_food_id) + ', ' + connection.escape(ori_data.food_name) + ', ' + connection.escape(dest_data.nutrients[5].gm) + ', ' + connection.escape(dest_data.nutrients[4].value) + ', ' + connection.escape(dest_data.nutrients[1].value) + ', ' + connection.escape(dest_data.nutrients[3].value) + ', ' + connection.escape(dest_data.nutrients[0].value) + ', ' + connection.escape(dest_data.nutrients[2].value) + ', ' + connection.escape(dest_data.nutrients[6].value) + ', NOW())';
    
    connection.query(query, function (err, rows) {
        if (err) {
          console.log(err);
          return;
        } else {
          console.log('success!');
          return;
        }
      }
    );
    connection.end();
  }
};