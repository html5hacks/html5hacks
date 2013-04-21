---
layout: post
title: "Web Workers: Basics of the Web Browser's UI Thread"
date: 2012-09-22 23:44
categories: ["Web Workers"]
comments: true
external-url: http://jessecravens.com/12112011/hack-82-web-wokers-basics-web-browser039s-ui-thread
author: Jesse Cravens
---

##Single Threadin'

As we set out to build a highly responsive UI for our demo web application, we must fully understand how browsers manage processes. Perhaps the biggest challenge we will face has to do with browsers using a single thread for both JavaScript execution and user interface updates. While the browser's JavaScript interpreter is executing code, the UI is unable to respond to the user's input. If a script is taking a long time to complete, after a specified amount of time the browser will provide the user an option to terminate the script. To accommodate for the 'freeze' associated with scripts that exceed the browser execution time limit, web developers have traditionally created smaller units of work and used JavaScript timers to return execution to the next event in the queue. As you will see, web workers solve the locking of the UI thread by opening an additional thread, or even multiple threads, for execution of these long running, processor intensive tasks.

When designing your application, especially if you come from more of a 'server-side' or Java background, it is important to understand that non-blocking execution is not the same as concurrent threading. While not extremely complex, JavaScript's event driven style does take some getting used to for developers coming from other languages such as Java and C. Later, we will touch on a few examples where we pass a callback continuation function to take full advantage of JavaScript's non blocking design.

##Thread Safety

Mozilla, in particular, provides a Worker interface which web workers implement. While the Worker interface spawns OS-level threads, web workers use the postMessage mechanism to send messages (with serializable objects) between the two execution contexts. To ensure thread safety the worker is only given access to thread safe components to include the following:

- timers: setTimeout() and setInterval() methods
- XMLHttpRequest
- importScripts() method

The worker script can also make use of:

- navigator and location objects
- native JavaScript objects such as Object, String, Date

At the same time, the worker restricts access to DOM APIs, global variables, and the parent page. In Hack #84 Building the DOM with web workers and Handlebars.js, we will explore the restricted access to DOM APIs, and introduce JavaScript templating, importScripts, and the use of timers to poll for postMessage.

##HTML5 Web Workers
As mentioned earlier, the Web worker spec defines an API for executing scripts in the background by spawning an independent execution context.

It is important to note that web workers are costly, having an impact on startup and overall memory consumption. So, they are intended to be used lightly and in conjunction with the some of the asynchronous techniques mentioned earlier. A well built client-side application would typically make use of one or two cases where tasks are expensive. Here are a few common uses cases:

- Single Page Application bootstrapping large amounts of data during initial load
- Performing long running mathematical calculations in the browser
- Processing large JSON datasets
- Text formatting, spell checking, and syntax highlighting
- Processing multimedia data (Audio/Video)
- Long polling webservices
- Filtering images in canvas
- Calculating points for a 3D image
- Reading/Writing of local storage database


##Long Running Scripts

Our first web worker hack will be a long running script with heavy computation. It will execute 2 loops that output a two-dimensional array. First, we will use this computation to lock up the browser's UI thread, and later we will move the task to a worker.

{% codeblock init.js %}
	
	function init() {
		var r = 1000;
		var c = 1000;
		var a = new Array(r);

		for (var i = 0; i < r; i++) {
		    a[i] = new Array(c);

		    for (var j = 0; j < c; j++) {
		        a[i][j] = "[" + i + "," + j + "]";
		    }
		}
	}
	
	window.onload = init;

{% endcodeblock %}


##Spawning a Worker

Now let's move our heavy computational task to a dedicated web worker, so that the user doesn't have to wait for the script to complete execution in order to interact with user interface. First, lets spawn a new worker:

{% codeblock spawn.js %}
  
  var worker = new Worker('highComp.js');

  worker.postMessage(JSON.stringify(message));

  worker.addEventListener('message', function(event){}, false);

{% endcodeblock %}

Here, we define an external file that will contain the logic of our heavy computational task. The file, highComp.js will listen for a message that will receive the serialized JSON payload, and then we will set up an additional listener to receive a message back from highComp.js.

Now, we can move this cpu-intensive task to a separate file: highComp.js

{% codeblock highComp.js %}
var r = 1000;
var c = 1000;

var a = new Array(r);

for (var i = 0; i < r; i++) {
  a[i] = new Array(c);

    for (var j = 0; j < c; j++) {
     a[i][j] = "[" + i + "," + j + "]";
    }
};
postMessage(a);
{% endcodeblock %}

In highComp.js, our two dimensional array is built and set to variable a. It is then passed back to our main script via the postMessage call.

In the next hack, we will mix our use of timers with the power of a dedicated worker. As we send messages (passing serializable objects as a parameter to postMessage) back and forth to code running in the shared UI thread, our timer will periodically send and check for new messages and use their contents to modify the DOM.