---
layout: post
title: "Utilize Rich Input Data from W3C Pointer Events"
date: 2013-05-13 01:42
comments: true
categories: ["HTML5", "W3C Spec", "touch", "Pointer Events"]
author: "Jeff Burtoft (@boyofgreen)"
---

The W3C Pointer Events specification allows you to develop for a single event model that supports various input types.  Instead of writing code for multiple event types, or having to use feature detection on page load that forces one event model over the other, Pointers allows you to write one event model that works everywhere.  To make the transition easy, Pointer Events builds upon the Event Model of Mouse Events.  This means that code that’s written for mouse events is going to be very easy to upgrade to Pointers.

There’s a lot of great content out there on how to implement pointers.  Microsoft’s original post on pointer event implementation in IE10 and Windows 8 Apps is a great place to start learning about Pointers.  To see an example of how to convert a current mouse based app into a pointers based app, I suggest you check out my channel 9 video on pointers. In this post I want to focus on a different aspect of pointers.  Along with the multiple input support, and ease of implementation, Pointer Events also provide a wealth of new data values that can be quite useful in your applications.  This post will look in depth at that data.

The code samples will all use the W3C spec pointer names such as “pointermove” and “pointerup”, however in practice this spec is not finalized, so the working code samples will be using the prefixed version such as “MSPointerMove” and “MSPointerUp”.

##The Pointer Event Object

The Pointer Event object is modeled directly off the Mouse Event object, meaning all the values, and all the methods available in a mouse event model, will be present inside a Pointer Event Model.  Let’s look at an example you might implement for the Mouse Event Model:

{% codeblock More poiner.js %}
        var myY, myX;
        document.getElementById('myElement').addEventListener('mouseup', function(e){
        
            e.preventDefault();
            
            myY = e.offsetY;
            myX = e.offsetX;
        
        });
{% endcodeblock %}

This same code will also run with Pointer Events:

{% codeblock More poiner.js %}
        document.getElementById('myElement').addEventListener('pointerup', function(e){
        
            e.preventDefault();
            
            myY = e.offsetY;
            myX = e.offsetX;
        
        });
{% endcodeblock %}

Every value and method will run the same.  The main difference is that Pointers aren’t single threaded as Mouse Events are (you can only have one mouse pointer on the screen at a time).  So if you have two Pointers on the screen, say two fingers on your touch screen, or one finger and one mouse, this event will be fired twice.

The “upgrade” comes in all the additional data that is available when you use Pointer Events.

##The Event Type

Since a Pointer Event will be fired no matter what type of input you are using, it’s sometimes important to know what type of input is firing the Event. While accessing the event object, you can retrieve the pointer type like so:

{% codeblock More poiner.js %}
        document.getElementById('myElement').addEventListener('pointerup', function(e){
        
            var pointerType = e.pointerType;
        
        });
 {% endcodeblock %}
 
The type will return one of three value types:

-mouse: movement with a mouse
-pen: movement with a pressure sensitive pen (not a capacitive stylus)
-touch: any input from the touch screen

Note that the original spec, and what is implemented In IE10, provides number values that correspond with the input types.  The value will return either a 2(touch), 3(pen) or 4(mouse).

For implementing pointers today, I actually check for both the string value or the number to be sure I support both the current implementation and the final spec:

{% codeblock More poiner.js %}
        document.getElementById('myElement').addEventListener('pointerup', function(e){
        
            var pointerType = e.pointerType;

            if (pointerType == 'touch'||4) {
                //this is a touch type pointer
            }
        
        });
{% endcodeblock %}

##New Values for All Pointer Types

There is a range of new values packed into the Pointer Event Object that is common across all pointer types.  Each of these expose new values that provide valuable data for interaction development

*PointerID:* each pointer interaction is given a unique ID within your page and session.  This number will be consistent across events for each interaction.  For Example, a “pointerdown” event may be given a PointerID of 127, the subsequent “pointermove” and “pointerend” events will all have the same PointerID.  This could be helpful for tracking which finger is doing what when there are multiple touch screen pointers on the screen at once.  You can access the value as below:

{% codeblock More poiner.js %}
        document.getElementById('myElement').addEventListener('pointerdown', function(e){
        
            var pointerId = e.pointerId
            ;
        });
{% endcodeblock %}

*isPrimary:* When multiple Pointer Events are on the screen at once, one of them will be assigned as the primary pointer.  If one of them is of the Pointer type of mouse, it will be the primary, otherwise the first pointer to fire an event will be designated as the primary.  This could be helpful for a developer who is building an application that is intended for a single pointer input.  There is one catch, when you are using multiple pointer types on the screen at the same time, the first pointer of each type will be a primary pointer, and thus will allow you to have multiple primary pointers on the screen at the same time.  The value can be accessed as such:
        
{% codeblock More poiner.js %}
        document.getElementById('myElement').addEventListener('pointerup', function(e){

            var isPrimary = e.isPrimary; // will return true or false

        });
{% endcodeblock %}

*button/buttons:* This isn’t a new value for pointers, but in pointers you get new information.  With both a mouse and a pen, the user has buttons that can be pressed. Weather those buttons are being pressed, and which button is pressed can be determined in these two values.

<img class="figure" alt="Figure 12-1" src="/images/chapter-jeff/buttonChart.png">
 

The entire list of values can be found in the most recent version of the spec, and keep in mind, not all values are implemented in IE10 (or any other browser) at this point.

##Pen Specific Values

There are some values that are only applicable to the pointer type of Pen.  Keep in mind the pen type refers to a mechanical stylus that works with supported screen types.  Capacitive styus like the types used with iPads or Surface RT register as pointer types of touch, which will be discussed next.

The following values provide data in the Pointer Event Object for pens:

*tiltX/tiltY:* When you hold a pen there is generally an angle associated with it.  If you were to hold the pen by the end and lower it perfectly straight on the screen, the tilt would be 0, but if you were to hold it in writing position, it would have a tilt value like 90.  The tilt values are returned in degrees and be accessed as such:

{% codeblock More poiner.js %}
document.getElementById('myElement').addEventListener('pointerup', function(e){
        

            var tiltX = e.tiltX; 
            var tiltY = e. tiltY;

        });
{% endcodeblock %}

*Pressure:*  Much of the data provided from a pen type pointer event is actually data provided from the pen to the screen.  Another one of those is pressure.  This is a value that reports how hard a pen is being pressed against the screen.  The value is reported as a number between x and x.  The value is accessed as below:

{% codeblock More poiner.js %}
document.getElementById('myElement').addEventListener('pointerup', function(e){
        

            var pressure = e.pressure;

        });
 {% endcodeblock %}
 
##New Data for Touch

The Pointer Spec provides for detail touch data that just doesn’t exist in any other touch model on the web.  Most significantly the actual width and height of a the touch area.  Being so new, my testing showed that this value is often returned as 0 depending on the touch screen and driver installed on the device.  Accessing this data follows the same patteren as the other new data:

{% codeblock More poiner.js %}
document.getElementById('myElement').addEventListener('pointerup', function(e){
        

            var width = e.width;
            var height = e.height;

        });
{% endcodeblock %}

Keep in mind this is related to touch pointers only, so a mouse or pen will always return 0 for these values.

##Mobile Implementations

The only mobile browser that has implemented Pointers is IE10 for Windows Phone 8.  Since the phone OS doesn’t support a mouse or mechanical stylus, the only pointer type that returns is touch.  The user agent does accurately report the pointer type, but many of the other new pointer values (such as width and height) are currently reported as 0s.

##The Sample App

I’ve been working on a sample app that helps illustrate the rich data reported through pointers.  It’s a simple canvas resized to your page that shows a report from each touch point of the key data values, additionally, the new data is used to effect the drawing on the screen to make a more accurate drawing surface.  

Test the app here in IE 10 or any future browser that supports pointer events, or view this video of the app in action.

##Next Steps

The Pointer Event Specification is not yet finalized so changes could occur at any time (and it has changed since the version implemented in ie10). If you interested in the work that is going on around Pointers, join the working group mailing list, and encourage others in the browser maker community to implement the Pointer Even Specification in every browser.

