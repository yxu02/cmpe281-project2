/**
 * @Author: Yu Xu <yu.xu@sjsu.edu>
 * 
 * This file contains logics to retrieve data from USDA ndb-api.
 */
var request = require('request');
var storage = require('storage');

var key = 'xxxxxxxxxxxxxxx';

exports.handler = function (event, context, callback) {
  
  var food = {usda_food_id: event.key1,
  food_name: event.key2
};
  /*request({

    url: 'http://api.nal.usda.gov/ndb/search/?format=json&max=1&ds=Standard%20Reference&api_key=' + key + '&q=' + food.foodname,
    method: 'GET',
    headers: {
      accept: 'application/json',
      'content-type': 'application/json'
    },
    json: true

  }, function (error, response, body) {

    if (error || response.statusCode !== 200) {
      console.log('error: ' + response.statusCode);

    } else {
      var temp = body.list.item[0];
      console.log('First request: ', temp);*/
      request({
        url: 'http://api.nal.usda.gov/ndb/nutrients/?format=json' + '&nutrients=203&nutrients=204&nutrients=205&nutrients=208&nutrients=255&nutrients=269&nutrients=291' + '&api_key=' + key + '&ndbno=' + food.usda_food_id,
        method: 'GET',
        headers: {
          accept: 'application/json',
          'content-type': 'application/json'
        },
        json: true

      }, function (error, response, body) {

        if (error || response.statusCode !== 200) {
          console.log('error: ' + response.statusCode);

        } else {
          var temp = body.report.foods[0];
          food.food_name = temp.name.split(',')[0];
//          console.log('Second request: ', temp);
//          console.log('food name: ', food.food_name);

          storage.save(food, temp);

          callback(null, function (body) {
            console.log('OnSuccess: ', body);
          });
        }
      });
};