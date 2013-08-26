---
layout: post
title: "Web Worker Patterns"
date: 2013-08-26 14:03
comments: true
categories: ["Web Workers", "JavaScript"]
author: "Jesse Cravens (@jdcravens)"
---

JavaScript is executed in a single thread. If you're not familiar with threads, what this means is that JavaScript can only execute one block of code at a time. If code is already executing, any interaction by the user will instantiate an asynchronous event that is queued up for later execution. Other events like those from XMLHttpRequests and timers, are also added to the queue.

So, as you might expect, a single-threaded architecture can be problematic to the user experience if a particular script takes a long time to complete.

Read more at: [http://tech.pro/tutorial/1487/web-worker-patterns](http://tech.pro/tutorial/1487/web-worker-patterns)