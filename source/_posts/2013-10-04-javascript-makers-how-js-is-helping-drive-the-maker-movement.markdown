---
layout: post
title: "JavaScript Makers: How JS is Helping Drive the Maker Movement"
date: 2013-10-04 19:02
categories: ["Node.js", "Makers", "JavaScript"]
author: "Jesse Cravens (@jdcravens)"
---

This post is mirrored from: [jessecravens.com](http://jessecravens.com/blog/2013/10/04/javascript-makers-how-js-is-helping-drive-the-maker-movement/)

<img class="imgR300" alt="ok200 Conference" src="/images/200ok/200ok1.jpg">

I spend my days writing a lot of JavaScript, and helping companies deliver ambitious UX focused applications to the web. I [author books](http://shop.oreilly.com/product/0636920026273.do?cmp=af-code-book-product_cj_9781449334994_7080585) on the subject, blog, and [speak at conferences](http://lanyrd.com/profile/jdcravens/) as often as I can. 

I work for [frog](http://frogdesign.com), a product design firm, that for the last forty years has been helping increase the profiles of brands like Sony and Apple through iconic design.

I work within a culture that has deep roots into [the Maker Movement](http://en.wikipedia.org/wiki/Maker_culture); A culture that was making before the Maker Movement was cool, the "original makers" if you will. Written upon our walls and slide decks is the tag, ['Love What You Make'](https://vimeo.com/24940735), and as you might expect many of the frogs that sit around me are craftsfolk, DIYourselfers, and tinkerers. It is not uncommon to see a flying quadcopter, a mesh sensor network of Arduinos, 3D printed prototypes, explorations in next generation gesture with the Leap Motion and Kinect, video production, motion studies, 3D modeling, along with the standard artistic mood boards and web and native mobile application wireframes. Let's just say there is no shortage of creativity across every medium imaginable. 

## Sharing My Craft with my Children

<img class="imgL300" alt="ok200 Conference - setting up" src="/images/200ok/200ok2.jpg">

All of that being said, I'm a parent of two young children. My little ones constantly challenge me to find ways to share quality time with them. The parents reading this know the juggling act. 

What I try to do is architect bridges between my children's curiosity and the passions of others that have explored their crafts in a deep way. Myself, and my wife, being the most important of those craftsfolk. 

If I'm doing it right, when I spend time with my children, they should share in my excitement and passion. If I'm doing it wrong, I'm overwhelmed and exhausted from work. In my vision, my children should be witnessing a model of how to wake up everyday with the goal of embracing opportunity to create a combination of function and beauty within the world around them. 

<img class="imgR200" alt="Maker Faire" src="/images/200ok/Maker_Faire.gif">

So it is in this context, that I met up with Mozilla's Luke Crouch, and [Tulsa Mini Maker Faire](http://makerfairetulsa.com/)'s Scott Phillips to put together [the closing keynote at the 200ok conference](http://200ok.us/schedule/javascript-makers/) . 

## JavaScript Makers: How JS is Helping Drive the Maker Movement

The [200ok conference](http://200ok.us/schedule/javascript-makers/) is on track to become Oklaoma's premier web conference attracting a sold out crowd of web professionals from all over Oklahoma and the neighboring states. Going in, I felt as though I knew my audience well. In other words, if I spoke to them about languages they would understand, JavaScript and HTML5, my message would easily resonate. I also knew that given their location, Tulsa, OK, a presentation that touched upon work life balance and family values would immediate strike a chord as well.

So in the spirit of authenticity, I pretended as if getting prepared for a closing keynote dependent on hacked together hardware and software demos wasn't challenging enough; I made the decision to include my 6 year old son, Carter with a flying drone and a custom configured Minecraft server accessible over conference wifi. I knew this would ensure that the presentation dangled on the brink of disaster, mirroring the chaotic reality of both open hacking and parenting.

My thinking was that a presentation on this topic should be authentic, and reflect the reality of my proposition, not be an ivory tower, academic/authoritative talk about how to share your craft with your children. I also made sure to not prep Carter. With a loose structure in place, we took the stage and worked our way through a story that consisted of 12 open software and hardware demos that showcased JavaScript as a primary scripting language, and a table full of hardware that ranged from a drone, a dissected wifli helicopter and erector set, a leap motion, and numerous prototyping boards. 

<script async class="speakerdeck-embed" data-slide="10" data-id="78b4c9300a8801313e8202078d31cabc" data-ratio="1.2994923857868" src="//speakerdeck.com/assets/embed.js"></script>

Here are some of the highlights: 

## JavaScript and Prototyping Boards

Earlier this year I did a presentation at HTML5.tx that focused on building an [Internet of Things with JavaScript](http://www.youtube.com/watch?v=H00_BGRkBRM) and various open hardware prototyping boards such as Arduino, BeagleBone, and the Raspberry Pi. It was in that talk that I made a connection that eventually led to an introduction to Luke. So, given that the HTML5.tx content was of interest I started the presentation with a demo of the Arduino, [Johnny Five](https://github.com/rwaldron/johnny-five), the original Beaglebone and [BoneScript](https://github.com/jadonk/bonescript). 
 
## Nodecopter and the Leap Motion

One crowd favorite was mapping the gestures from the [Leap Motion](https://www.leapmotion.com/) to the [Parrot AR drone](http://ardrone2.parrot.com/), so that a one finger clockwise gesture triggered a nodecopter takeoff. A counter clockwise gesture then landed it. I was able to put this together using the leapJS and node-ardrone node modules, based on some initial hacking by [Markus Kobler](https://twitter.com/markuskobler), where he pulled this off at a [Nodecopter London event](https://github.com/markuskobler/nodecopter-london). 

<iframe src="//player.vimeo.com/video/75616363" width="500" height="281" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe> <p><a href="http://vimeo.com/75616363">Jesse Cravens blowing minds with a JS-driven copter.</a> from <a href="http://vimeo.com/user21333523">Michael Gorsuch</a> on <a href="https://vimeo.com">Vimeo</a>.</p>

## ScriptCraft: Running JavaScript from within Minecraft

<img class="imgL300" alt="ok200 Conference" src="/images/200ok/200ok3.jpg">

Later, I showed how to script inside of the Minecraft virtual world, using [Walter Higgins'](https://twitter.com/walter) great [ScriptCraft library](https://github.com/walterhiggins/ScriptCraft). I wasn't expecting the conference wifi, and single access point, to suffice in allowing Carter and I to interact within virtual world. I was also concerned about the dynamic IP, and having to change it on the fly, start/restart the server, etc. So I made the decision 10 minutes before to not have Carter log in, and I would just speak to the possibility instead. In true 6 year old fashion, he rebelled and logged onto my server, popping up in front of me wearing a Creeper mask, as I was mid stream explaining how to script wooden signs with his 1st grade sight words as a homework exercise. Needless to say, his innapropriate behavior was a crowd favorite. I have to admit, it was mine as well. 

<img class="imgR300" alt="ok200 Conference" src="/images/200ok/200ok4.png">

Going into the talk, I knew I'd either be trying this again in the future or abandoning it as 'one of those ideas' that sounded good in theory, but was just not going to work. Where did I land? Well, let's just say that Carter and I are looking for our next opportunity to share our experiences with other parents/web professionals.

