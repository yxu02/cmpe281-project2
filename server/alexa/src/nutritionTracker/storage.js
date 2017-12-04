/**
 * @Author: Yu Xu <yu.xu@sjsu.edu>
 * 
 * This file contains Db storage and management logic for all indents.
 */

'use strict';
var mysql = require('mysql'),
  textHelper = require('textHelper');

var connection = mysql.createConnection({
  host: 'xxxxxxxxxxxxxxxxxx',
  user: 'xxxxxxxxxxxx',
  password: 'xxxxxxxxxxxxx',
  database: 'xxxxxxxxxxxxx',
  debug: true
});

var storage = (function () {

  function Nutrition(session, data) {
    if (data) {
      this.data = data;
    } else {
      this.data = {
        food: null,
        count: null,
        unit: null,
        food_id: null
      };
    }
    this._session = session;
  }

  Nutrition.prototype = {
    /**
     * Store a food into Db
     */
    save: function (response) {
      var date = new Date();
      var utcDate = new Date(date.toUTCString());
      utcDate.setHours(utcDate.getHours()-8);
      var usDate = new Date(utcDate);
      
      var meal_id =0, hr=usDate.getHours();
      if (hr>=6 && hr <=9) meal_id=1;
      else if(hr>=11 && hr <= 14) meal_id=2;
      else if(hr>=17 && hr <= 20) meal_id=4;
      else meal_id = 0;
      
      
      var query = 'REPLACE INTO user_foods(id, food_id, food_name, count, unit, meal_id, created_at)' +
        'VALUES (' + connection.escape(this._session.user.userId) + ', ' + connection.escape(this.data.food_id) + ', ' +
        connection.escape(this.data.food) + ', ' + connection.escape(this.data.count) + ', ' +
      connection.escape(this.data.unit) + ', ' + meal_id + ', NOW())';

      connection.query(query, (function (data) {
        return function (err, rows) {
          if (err) {
            console.log(err);
            return;
          }

          var speechOutput = '';
          if (data.count != 0) {
            speechOutput = data.count + ' ' + data.unit + ' ' + data.food;
          } else {
            speechOutput = 'nothing';
          }
          speechOutput += ' added to your nutrition.';
          response.tell(speechOutput);
        };
      })(this.data));
    }
  };

  return {
    /**
     * Validates input for save food action and calls Save method on success
     */
    saveFood: function (session, data, response) {
      
      var temp = '%' + data.food + '%';
      var query = "SELECT usda_food_id FROM nutrition WHERE food_name LIKE ?";

      connection.query(query, [temp], function (err, rows) {
        if (err) {
          console.log(err);
          return;
        }

        if (rows[0] !== undefined) {
          data.food_id = rows[0].usda_food_id;
          var currentFood = new Nutrition(session, data);
          currentFood.save(response);
        } else {
          var speechOutput = textHelper.invalidText;
          var reprompt = "Please say your command."
          response.ask(speechOutput, reprompt);
        }
      });
    },
  };

})();
module.exports = storage;