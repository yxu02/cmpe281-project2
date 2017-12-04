/**
 * @Author: Yu Xu <yu.xu@sjsu.edu>
 */
process.env['PATH'] = process.env['PATH'] + ':' + process.env['LAMBDA_TASK_ROOT'];

'use strict';
var NutritionTracker = require('nutritionTracker');

exports.handler = function (event, context) {
    console.log(NutritionTracker);
    var nutritionTracker = new NutritionTracker();
    nutritionTracker.execute(event, context);   
};
