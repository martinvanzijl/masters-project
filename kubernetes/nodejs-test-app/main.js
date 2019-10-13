/** "Hello World" application in Node.js for Kubernetes testing. */

/* Import modules. */
var http = require('http');
var url = require('url');

/* Create lock. */
var locked = false;

/* Set counter. */
var counter = 1;

/* Request handler. */
var handleRequest = async function(request, response) {

  /* Get parameters. */
  var response_time = 1000;
  try {
	var query = url.parse(request.url,true).query;
	response_time = query.rt;
  }
  catch(error) {
	console.log("No rt parameter specified, using default value");
  }
  console.log("Response time = " + response_time);

  /* Wait while locked. */
  while(locked) {
    await sleep(response_time/10);
  }

  /* Turn on lock. */
  locked = true;

  /* Log message. */
  console.log('Received request for URL: ' + request.url);

  /* Wait (sleep) for a while. */
  await sleep(response_time);

  /* Get the current time, to avoid cached (304) responses. */
  var datetime = new Date();

  /* Send reply. */
  response.writeHead(200);
  response.end('Hello World!\nThe time is: ' + datetime + "\nYou are visitor number: " + counter + "\n");

  /* Increment counter, to avoid cached (304) responses. */
  counter += 1;

  /* Turn off lock. */
  locked = false;
};

/* Sleep for the given number of milliseconds.
   From: https://stackoverflow.com/questions/14249506/how-can-i-wait-in-node-js-javascript-l-need-to-pause-for-a-period-of-time
   */
function sleep(ms){
    return new Promise(resolve=>{
        setTimeout(resolve,ms)
    })
}

/* Make server. */
var www = http.createServer(handleRequest);

/* Listen for connections. */
www.listen(8080);
