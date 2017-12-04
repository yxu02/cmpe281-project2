/**
 * @Author: Yu Xu <yu.xu@sjsu.edu>
 * 
 * This file contains all text helpers.
 */

'use strict';
var textHelper = (function () {
  return {
    helpText: 'You can store your food,',
    examplesText: 'Here\'s some things you can say,' +
      ' Add 10 ounces rice,' +
      ' Store 20 grams sugar,' +
      ' help' +
      ' and exit. What would you like? ',
    invalidText: 'The input is invalid. Please try again. '
  };
})();
module.exports = textHelper;