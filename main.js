var apn = require('apn');
var url = require('url');
var http = require('http');
var util = require('util');
var querystring = require('querystring');

var nextID = 1;
var users = {};
var pushkeys = {};

var questions = {};

var options = {
  "production": false
};

var askForm = "<!DOCTYPE html><html><head><title>Ask Form</title></head><body><form method='POST'><label>User 1:</label><input type='text' name='interrogator'/><br><label>User 2:</label><input type='text' name='respondent'/><br><label>Question:</label><input type='text' name='interrogative'/><br><input type='submit' value='Inquire'/></form></body></html>";
var answerForm = "<!DOCTYPE html><html><head><title>Answer Form</title></head><body><form method='POST'><label>User 1:</label><input type='text' name='respondent'/><br><label>Answer:</label><select name='rejoinder'><option>Yes</option><option>No</option></select><br><input type='submit' value='Retort'/></form></body></html>";
var lookupForm = "<!DOCTYPE html><html><head><title>Lookup Form</title></head><body><form method='GET'><label>Email:</label><input type='text' name='respondent'/><br><input type='submit' value='Lookup'/></form></body></html>";
var registerForm = "<!DOCTYPE html><html><head><title>Register Form</title></head><body><form method='POST'><label>Email:</label><input type='text' name='email'/><br><label>APN ID:</label><input type='text' name='apnID'/><br><input type='submit' value='Register'/></form></body></html>";

function writeJSON(response, obj) {
  response.writeHead(200, {'Content Type': 'application/json'});
  response.write(JSON.stringify(obj, null, 2));
  response.end();
}

function writeHTML(response, html) {
  response.writeHead(200, {'Content Type': 'text/html'});
  response.write(html);
  response.end();
}

var conn = new apn.Connection(options);
function sendAPN(recipient, interrogator, index, question) {
  var token, device, notification;

  token = pushkeys[recipient];
  device = new apn.Device(token);
  notification = new apn.Notification();

  note.alert = question.interrogative;
  note.badge = index;
  note.payload = {'interrogator': interrogator};

  conn.pushNotification(notification, device);
}


var ask = function(request, response) {
  if(request.url === '/ask' && request.method === 'GET') {
    return writeHTML(response, askForm);
  }

  console.log('Ask a question');
  var interrogator, respondent, interrogative;

  var data = '';
  request.on('data', function(chunk) {
    data += chunk;
  });

  request.on('end', function() {
    var respondent, interrogator, interrogative, question, questionAPN, questionIndex, userQuestions;
    data = querystring.parse(data);

    respondent = data.respondent;
    interrogator = data.interrogator;
    interrogative = data.interrogative;

    userQuestions = questions[interrogator];
    if(userQuestions === undefined) {
      userQuestions = {};
      questions[interrogator] = userQuestions;
    }
    if(userQuestions[respondent] === undefined) {
      userQuestions[respondent] = [];
    }

    questionIndex = userQuestions[respondent].length;
    question = {'interrogative': interrogative, 'time': (new Date())};
    userQuestions[respondent].push(question);
    // sendAPN(recipient, interrogator, questionIndex, question);

    console.log(JSON.stringify(questions));
    writeJSON(response, {'success': true});
  });
}

var answer = function(request, response) {
  if(request.url === '/answer' && request.method === 'GET') {
    return writeHTML(response, answerForm);
  }

  console.log('Answer a question');
  var respondent, rejoinder;
  var data = '';
  request.on('data', function(chunk) {
    data += chunk;
  });

  request.on('end', function() {
    data = querystring.parse(data);

    rejoinder = data.rejoinder;
    recipient = data.respondent;

    console.log('User ' + recipient + ' says ' + rejoinder);
    writeJSON(response, {'success': true});
  });
}

var register = function(request, response) {
  if(request.url === '/register' && request.method === 'GET') {
    return writeHTML(response, registerForm);
  }

  console.log('Register a token');
  var email, apnID;
  var data = '';
  request.on('data', function(chunk) {
    data += chunk;
  });

  request.on('end', function() {
    var userID;
    data = querystring.parse(data);

    if(users[data.email]) {
      userID = users[data.email];
    } else {
      userID = nextID++;
      users[data.email] = userID;
    }

    if(pushkeys[userID] !== undefined) {
      pushkeys[userID] += pushkeys[userID] + ',' + data.apnID;
    } else {
      pushkeys[userID] = data.apnID;
    }

    console.log('Registered ' + data.email + ' as ' + userID);
    console.log(util.inspect(users));
    console.log(util.inspect(pushkeys));
    
    writeJSON(response, {'success': true, 'userID': userID});
  });
}

var lookup = function(request, response) { 
  if(request.url === '/lookup' && request.method === 'GET') {
    return writeHTML(response, lookupForm);
  }

  console.log('Lookup a user');
  var query = url.parse(request.url, true).query;
  var userID = users[query.respondent];
  
  writeJSON(response, {'success': userID ? true : false, 'respondent': userID} );
}

var router = function(request, response) {
  if(request.url.match('^/ask')) {
    ask(request, response);
  } else if(request.url.match('^/answer')) {
    answer(request, response);
  } else if(request.url.match('^/register')) {
    register(request, response);
  } else if(request.url.match('^/lookup')) {
    lookup(request, response);
  }

  console.log("Request: " + request.url);
  console.log();

  response.writeHead(404);
  response.end();
}

http.createServer(router).listen(8888);
console.log('Server up...');
