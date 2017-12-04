/**
 * @Author: Yu Xu <yu.xu@sjsu.edu>
 * 
 * This file contains handler logic for all indents.
 */

'use strict';
var textHelper = require('textHelper'),
  storage = require('storage');

var registerIntentHandlers = function (intentHandlers, skillContext) {

  /**
   * Creates new food input
   */
  intentHandlers.NewFoodIntent = function (intent, session, response) {
    if (intent.slots.Food.value !== undefined && !isNaN(intent.slots.Count.value) &&
      intent.slots.Count.value > 0 && intent.slots.CountUnit.value !== undefined) {

      var food = intent.slots.Food.value,
        count1 = calculateQuantity(intent);

      var data = {
        food: food,
        count: count1,
        food_id: '',
        user_id: ''
      };

      storage.saveFood(session, data, response);

    } else {
      var speechOutput = "You have to specify quantity, unit and food name. " +
        "For example, you can say, three ounces bananas. Please try again.";
      var reprompt = "Please say your input."
      response.ask(speechOutput, reprompt);
    }
  };

  intentHandlers.NewBodyIntent = function (intent, session, response) {
    if (!isNaN(intent.slots.weight.value) && !isNaN(intent.slots.fat.value) &&
      !isNaN(intent.slots.water.value)) {

      var weight = intent.slots.weight.value,
        fat = intent.slots.fat.value * 453.592,
        water = intent.slots.water.value * 453.592;

      var data = {
        weight: weight,
        fat: fat,
        water: water
      };

      storage.saveBody(session, data, response);

    } else {
      var speechOutput = "You have to specify weight, body fat, and body water. " +
        "For example, you can say, my weight is X pounds, my body fat is Y pounds, my body water is Z pounds.";
      var reprompt = "Please say your input."
      response.ask(speechOutput, reprompt);
    }
  };

  intentHandlers.MyHelpIntent = function (intent, session, response) {
    var speechOutput = textHelper.helpText + textHelper.examplesText;
    var reprompt = "What would you like?"
    response.ask(speechOutput, reprompt);
  };

  intentHandlers.MyCancelIntent = function (intent, session, response) {
    var speechOutput = "Goodbye. Thanks for using Nutrition Tracker.";
    response.tell(speechOutput);
  };

  intentHandlers['AMAZON.HelpIntent'] = function (intent, session, response) {
    var speechOutput = textHelper.helpText + textHelper.examplesText;
    var reprompt = "What would you like?"
    response.ask(speechOutput, reprompt);
  };

  intentHandlers['AMAZON.CancelIntent'] = function (intent, session, response) {
    var speechOutput = "Okay.";
    response.tell(speechOutput);
  };

  intentHandlers['AMAZON.StopIntent'] = function (intent, session, response) {
    var speechOutput = "Goodbye. Thanks for using Nutrition Tracker.";
    response.tell(speechOutput);
  };

};

var calculateQuantity = function (intent) {

  var count = intent.slots.Count.value, count_in_gram,
      unit = intent.slots.CountUnit.value;

    switch (unit) {
      case 'ounce':
      case 'ounces':
      case 'Oz':
      case 'oz':
        count_in_gram = 28.3495 * count;
        break;
      case 'lb':
      case 'lbs':
      case 'pound':
      case 'pounds':
        count_in_gram = 453.592 * count;
        break;
      case 'liter':
      case 'liters':
        count_in_gram = 1000.000 * count;
        break;
      default:
        count_in_gram = count;
        break;
    }

  return count_in_gram;
}

exports.register = registerIntentHandlers;