/***
* Author: Yu Xu   yu.xu@sjsu.edu
* 
***/

let speechOutput;
let reprompt;
const welcomeOutput = "Welcome to use Nutrition Tracker! Let's register as a user first! What's your name? ";
const welcomeReprompt = "As a new user you need to register first. What's your name?";
const conversationIntro = [
   "Thanks for the information! Let me repeat.",
   "Nice to know you!",
   "We are friends now!"
 ];

'use strict';
const Alexa = require('alexa-sdk');
const APP_ID = 'xxxxxxxxxxxxxxxx';
var storage = require('storage');

const handlers = {
  'LaunchRequest': function () {
    this.response.speak(welcomeOutput).listen(welcomeReprompt);
    this.emit(':responseReady');
  },
  'NewUserIntent': function () {
    
    var filledSlots = delegateSlotCollection.call(this);
    var speechOutput = randomPhrase(conversationIntro);

    var username = this.event.request.intent.slots.username.value;
    var age = this.event.request.intent.slots.age.value;
    var gender = this.event.request.intent.slots.gender.value;
    var address = this.event.request.intent.slots.address.value;

    speechOutput += " Your name is " + username + ". You are " + age + " years old. You are a " + gender + ". Your home address is " + address;

    this.response.speak(speechOutput);
    this.emit(":responseReady");
  },
  'AMAZON.HelpIntent': function () {
    speechOutput = "";
    reprompt = "";
    this.response.speak(speechOutput).listen(reprompt);
    this.emit(':responseReady');
  },
  'AMAZON.CancelIntent': function () {
    speechOutput = "";
    this.response.speak(speechOutput);
    this.emit(':responseReady');
  },
  'AMAZON.StopIntent': function () {
    speechOutput = "";
    this.response.speak(speechOutput);
    this.emit(':responseReady');
  },
  'SessionEndedRequest': function () {
    var speechOutput = "";
    this.response.speak(speechOutput);
    this.emit(':responseReady');
  },
};

exports.handler = (event, context) => {
  var alexa = Alexa.handler(event, context);
  alexa.appId = APP_ID;

  alexa.registerHandlers(handlers);
  alexa.execute();
};

function delegateSlotCollection() {
  console.log("in delegateSlotCollection");
  console.log("current dialogState: " + this.event.request.dialogState);
  if (this.event.request.dialogState === "STARTED") {
    console.log("in Beginning");
    var updatedIntent = this.event.request.intent;

    this.emit(":delegate", updatedIntent);
  } else if (this.event.request.dialogState !== "COMPLETED") {
    console.log("in not completed");
    this.emit(":delegate");
  } else {
    console.log("in completed");
    console.log("returning: " + JSON.stringify(this.event.request.intent));

    return this.event.request.intent;
  }
}

function randomPhrase(array) {
  var i = 0;
  i = Math.floor(Math.random() * array.length);
  return (array[i]);
}

function isSlotValid(request, slotName) {
  var slot = request.intent.slots[slotName];
  var slotValue;

  if (slot && slot.value) {
    slotValue = slot.value.toLowerCase();
    return slotValue;
  } else {
    return false;
  }
}