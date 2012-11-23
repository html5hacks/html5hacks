---
layout: post
title: "Use the GeoLocation API to Display Long/Lat in a jQuery Mobile App"
date: 2012-10-15 23:15
comments: true
categories: ["Geo Location","jQuery Mobile","Mobile"]
author: Jesse Cravens
---

The Geolocation specification exposes an easy-to-use API. With only a couple of lines of code, you can obtain the user’s current position. What’s more, jQuery Mobile provides a simple framework for building a cross-browser mobile web application.

In this hack we will utilize the jQuery Mobile framework to provide a relatively simple means of authoring a cross-browser mobile application. Since this hack is focused on displaying our current longitude and latitude and exercising the API across the mobile Web, we will only need a simple UI.

###A Simple jQuery Mobile App

As always, we’ll start by building a basic page utilizing the HTML5 doctype and including our dependencies:

{% codeblock geo.html %}
<!DOCTYPE html> 
<html lang="en">
    <head> 
        <title>jQuery Mobile GeoLocation demo</title> 
        <meta name="viewport" content="width=device-width, initial-scale=1"> 

        <link rel="stylesheet" href="http://code.jquery.com/mobile/1.1.1/jquery.mobile-1.1.1.min.css" />

        <script src="http://code.jquery.com/jquery-1.7.1.min.js"></script>

        <script src="http://code.jquery.com/mobile/1.1.1/jquery.mobile-1.1.1.min.js"></script>

    </head> 
<body> 

    // jQuery mobile declarative markup here

</body>
</html>
{% endcodeblock %}

As you can see, we have declared a dependency on one stylesheet, and three JavaScripts. We will build the remainder of the application using declarative HTML markup and data- attributes that the jQuery Mobile framework will interpret.  
Within the <body> tag, we can now place the following: 

{% codeblock More geo.html %}
<div data-role="page" data-theme="a">

    <div data-role="header">
        <h1>Geo Location</h1>
    </div><!-- /header -->

    <div data-role="content">	
        <ul data-role="listview" data-inset="true">
            <li><a href="./longlat-embed.html" data-ajax="false">LongLat</a></li>
        </ul>
    </div><!-- /content -->

</div><!-- /page -->
{% endcodeblock %}

At this point you should see what’s shown in Figure 7-1, if you access this page from a smaller screen or shrink your desktop browser window to the size of a mobile browser.
 
Figure 7-1. jQuery Mobile simple button

<img class="figure" alt="Figure 7-1" src="/images/chapter7-images/7-1.png">

As you might expect, the UI wasn’t created through magic. jQuery Mobile uses JavaScript to consume the data- attributes present in your HTML markup to dynamically generate more HTML and CSS. The end result is what you see in your browser. 
Now we will create a separate page to link to. You many have noticed a link to longlat-embed.html within the main page. 


{% codeblock More geo.html %}
	<ul data-role="listview" data-inset="true">
		<li><a href="./longlat-embed.html" data-ajax="false">LongLat</a></li>
	</ul>
{% endcodeblock %}


This will take us to a page that will run our JavaScript that contains our geolocation code. Notice that we designated for this to not be a jQuery Mobile Ajax page. This ensures that upon the click of the link we navigate to the new page. It is important that the linked page is loaded so that its JavaScript will execute. 

This page is structured similarly to the other page, with the same dependencies. I intentionally kept the jQuery Mobile code as simple as possible. You can find more information on working with jQuery Mobile in the excellent set of [documentation](http://jquerymobile.com/demos/1.1.1/) .

{% codeblock More geo.html %}
<div data-role="page" data-theme="a">

    <div data-role="header">
        <h1>LongLat</h1>
    </div><!-- /header -->

        <div data-role="content">

        </div><!-- /content -->

</div><!-- /page -->
{% endcodeblock %}

In the content, we will create a div element that will contain our longitude and latitude data once it is returned from the remote service. We will also include a back capability to return to the previous page. 

{% codeblock More geo.html %}
    <div class="geo-coords">
        GeoLocation: <span id="Lat">lat: ...</span>°, 
               <span id="Long">long: ...</span>°
    </div>

    <a href="./jqueryMobile-embed.html" 
       data-role="button"
       data-inline="true">
        Back
    </a>
{% endcodeblock %}

Now we will address our geolocation JavaScript. If you are familiar with jQuery the initial $ variable will look familiar in the code that follows. If not, you can learn more about jQuery at http://docs.jquery.com/Main_Page.

Simply put, the jQuery function wrapper ensures that our page is ready before we execute the following script. Then we will set up a global namespace object that we will use to store our data. This type of organization will be important as our script gets more complex moving forward.

Next, we will check to make sure the current browser supports geolocation by checking the navigator object for the presence of the geolocation property. If it is available, we will call the getCurrentPosition method and pass a success and error object. 
Then we will construct both a success and error object. Within our success object we can accept a position as a parameter and query the object for its nested coords object which contains both latitude and longitude properties.

We will then call populateHeader(), which uses jQuery to append the returned values to the span tags that contain the IDs Lat and Long.

{% codeblock geo.js %}
    $(function() {

        var Geo={};

        if (navigator.geolocation) {
           navigator.geolocation.getCurrentPosition(success, error);
        }

        //Get the latitude and the longitude;
        function success(position) {
            Geo.lat = position.coords.latitude;
            Geo.lng = position.coords.longitude;
            populateHeader(Geo.lat, Geo.lng);
        }

        function error(){
            console.log("Geocoder failed");
        }

        function populateHeader(lat, lng){
            $('#Lat').html(lat);
            $('#Long').html(lng);
        }

    });
{% endcodeblock %}

Now let’s return to our browser and navigate to the new page. When a user accesses a web page that includes a call to navigator.geolocation.getCurrentPosition(), a security notification bar will be presented at the top of the page. Browsers that support the Geolocation API have their own security notification, which asks the user to allow or deny the browser access to the device’s current location (see Figure 7-2).
 
Figure 7-2. Google Chrome geolocation security notification

<img class="figure" alt="Figure 7-2" src="/images/chapter7-images/7-2.png">


If the user allows the web application to track her physical location, the script will continue to execute and make a request to the Location Information Server. The remote server returns a data set that includes longitude and latitude. Once we have the information and the success() callback has been called, we update the page (see Figure 7-3). 
 
Figure 7-3. Latitude and longitude 

<img class="figure" alt="Figure 7-3" src="/images/chapter7-images/7-3.png">


###Security and Privacy Concerns

The ability for web application developers to collect location data about end users raises quite a bit of concern in regard to security and privacy. The W3C specification clearly indicates that client applications should notify users and provide an interface to authorize the use of location data, allowing them to determine which web applications they trust:

User agents must not send location information to Web sites without the express permission of the user. User agents must acquire permission through a user interface, unless they have prearranged trust relationships with users, as described below. The user interface must include the host component of the document's URI [URI]. Those permissions that are acquired through the user interface and that are preserved beyond the current browsing session (i.e. beyond the time when the browsing context [BROWSINGCONTEXT] is navigated to another URL) must be revocable and user agents must respect revoked permissions. 
