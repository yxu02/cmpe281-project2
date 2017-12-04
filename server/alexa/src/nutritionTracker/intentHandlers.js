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
        count = intent.slots.Count.value;

      var unit = calculateUnit(intent);
      var data = {
        food: food,
        count: count,
        unit: unit,
        food_id: ''
      };

      storage.saveFood(session, data, response);

    } else {
      var speechOutput = "You have to specify quantity, unit and food name. " +
        "For example, you can say, three ounces bananas. Please try again.";
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

var calculateUnit = function (intent) {

  var count = intent.slots.Count.value;
  if (count === 0) {
    return null;
  }

  var unit;
  if (intent.slots.CountUnit.value !== undefined) {
    switch (intent.slots.CountUnit.value) {
      case 'ounce':
      case 'ounces':
      case 'Oz':
      case 'oz':
        unit = 'oz';
        break;
      case 'g':
      case 'gs':
      case 'gram':
      case 'grams':
        unit = 'gm';
        break;
      case 'ml':
      case 'milliliter':
      case 'milliliters':
        unit = 'ml';
        break;
      default:
        unit = 'gm';
        break;
    }
  } else {
    unit = 'gm';
  }

  return unit;
}

exports.register = registerIntentHandlers;