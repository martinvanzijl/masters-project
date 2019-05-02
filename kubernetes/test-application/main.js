/** "Hello World" application in Node.js for Kubernetes testing. */

/* Import modules. */
var http = require('http');

/* Request handler. */
var handleRequest = function(request, response) {

  /* TODO: Use semaphore. */
  
  /* Log message. */
  console.log('Received request for URL: ' + request.url);

  /* Send reply. */
  response.writeHead(200);
  response.end('Hello World!');

  /* TODO: Wait. */  
};

/* Make server. */
var www = http.createServer(handleRequest);

/* Listen for connections. */
www.listen(8080);


