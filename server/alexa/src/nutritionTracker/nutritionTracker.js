/**
 * @Author: Yu Xu <yu.xu@sjsu.edu>
 */

'use strict';
var AlexaSkill = require('AlexaSkill'),
    eventHandlers = require('eventHandlers'),
    intentHandlers = require('intentHandlers');

var APP_ID = 'xxxxxxxxxxxxxxxxx';
var skillContext = {};

/**
 * nutritionTracker is a child of AlexaSkill.
 */
var nutritionTracker = function () {
    AlexaSkill.call(this, APP_ID);
    skillContext.needMoreHelp = true;
};


// Extend AlexaSkill
nutritionTracker.prototype = Object.create(AlexaSkill.prototype);
nutritionTracker.prototype.constructor = nutritionTracker;

eventHandlers.register(nutritionTracker.prototype.eventHandlers, skillContext);
intentHandlers.register(nutritionTracker.prototype.intentHandlers, skillContext);

module.exports = nutritionTracker;

