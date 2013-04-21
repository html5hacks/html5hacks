---
layout: post
title: "Build a Windows 8 App with YUI"
date: 2013-03-10 19:10
comments: true
categories: ["Windows 8", "YUI", "Native Development", "JavaScript"]
author: Jeff Burtoft
---


I’ve always been a big fan of YUI.  YUI has taught me how to write good, scalable code.  If I ever wanted to know the “right” way to do something, I looked back at how the YUI devs did it, and I would do it the same way.  In the last few years, with the release of YUI3, that standard is even higher.  The encapsulation practices and the decentralization of the code base has made it pleasure to develop, and a rock solid foundation for my applications.

You can imagine how excited I was to introduce this honored, experienced titan to the new kid on the block, WinJS.  For those of you who don’t know, WinJS is the library that runs exclusively inside of Windows 8 Apps written in JavaScript and HTML5.  For those of you who aren’t familiar with the concept, Microsoft has written this kick-ass ecosystem for Windows 8 in which we as developers can build Windows Store Apps with web technologies (js/css/html) just as we would with any managed code base like c++ or c#.  WinJS provides you with core functionality like templating, file system access, reusable UI components, and service calls via XHR.  Widows 8 Apps use the same rendering engine and the same JavaScript engine as IE10, and being a sandboxed app, you also have access to a whole slew of APIs from the WinRT service layer.  You can read all about how this works [directly from MSDN](http://msdn.microsoft.com/en-us/library/windows/apps/br211377.aspx).

Since your Windows 8 Apps are running IE10 components you can pull in your favorite JavaScript library to provide you with app functionality.  In my case, my favorite library has always been YUI, so my goal was to shoehorn YUI into the Windows 8 App.  Much to my surprise, I never once had to pull out the shoehorn, YUI not only worked well inside the app, but it also worked seamlessly with WinJS.  This is my story. A love story really, of how Windows 8 Loves YUI.

##What you need

If you’re a YUI developer, you probably know how this all works.  If you want to, and are able to, use the Yahoo CDN, then there is very little barrier to entry; in fact it’s incredibly simple.   You basically have two simple steps.

Step 1:  add the YUI seed to your page:

{% codeblock win8.js %} 

// Put the YUI seed file on your page.
<script src="http://yui.yahooapis.com/3.8.1/build/yui/yui-min.js"></script>
{% endcodeblock %}

Step 2: start a new instance:
    
{% codeblock win8.js %} 
<script>
// Create a YUI sandbox on your page.
YUI().use('node', 'event', function (Y) {
    // The Node and Event modules are loaded and ready to use.
    // Your code goes here!
});
</script>
{% endcodeblock %}

Pretty Simple.  Now for our example. We’ll be running code in the local context of our app, so for security reasons, we can’t load our JS libraries from a CDN- they have to be packaged with the app which we’ll discuss more in a bit.  So in our case, you’ll also need another tool provided by the YUI team, the [YUI configurator](http://yuilibrary.com/yui/configurator/).   The configurator will be used to determine what JS files we want to add to each of our pages.  Also, you’re going to need a local copy of the library as well, so download that [from github](https://github.com/yui).
To build our pages into a Windows 8 App, you’ll need a copy of visual Studio 2012. My suggestion is to go download yourself a copy of [Visual Studio Express for Windows 8](http://www.microsoft.com/visualstudio/eng/products/visual-studio-express-for-windows-8).  This version of VS is free, but it has everything you need to build a Windows 8 App.  It’s more than your average free editor as well.  It has incredible code completion and intelisence.  Visual Studio express 2012 has Windows 8 as a system requirement, so by default you need to be running on a Windows 8 machine (or VM) as well.  

##Let’s take it up a Notch

I want to hit home the idea that YUI just works inside of a Windows 8 App, so were’ going to take a few samples straight from the YUI library and build them into an app.  We’ll basically be creating a three page app consisting of a home page and two examples pages.  We’re going to Use WinJS for high level things like Navigation, App Status, and cool Windows 8 features, and use YUI for all the functionality of our App.
 Let’s kick it off by opening a brand new project in Visual Studio.  Let’s start by opening a new “navigation” app.
  
  <img class="figure" alt="Figure 7-1" src="/images/chapter-jeff/vs-menu.png"> 
  
You’ll find the navigation boiler plate app to be quite interesting.  Out of the box, WinJS turns this code into a single page application.  If you were to run this code, you would see a blank page that has the text on it “content goes here.” But if you look into your code a bit, you’ll see that this text doesn’t actually appear in our default.html page (this is our starting page).  Instead, it appears in the file called home.html (which is located in a \pages\home\home.html).  This is the magic that is the navigation app.  When we use WinJS for navigation, we don’t need to worry about state or page loads, it’s all taken care of for us.
  In this case, our default.html file contains our template target: 
      
{% codeblock win8.html %} 
<div id="contenthost" data-win-control="Application.PageControlNavigator" data-win-options="{home: '/pages/home/home.html'}"></div>
{% endcodeblock %}

In a WinJS Navigation App, each html file has an associated .js file and .css file.  If we open up default.js we see this code attached to our process all method in a “promise”:
{% codeblock win8.js %} 
WinJS.UI.processAll().then(function () {
                if (nav.location) {
                    nav.history.current.initialPlaceholder = true;
                    return nav.navigate(nav.location, nav.state);
                } else {
                    return nav.navigate(Application.navigator.home);
                }
            });
{% endcodeblock %}

The "process all" method parses the page and processes any page construction that is necessary before rendering the page.  Once that is complete the “.then()” promise fires off the navigation.  Without getting into too much detail, there is a library component added to this style of app called navigator.js, which adds this functionally for us. 
The file “home.html” will be our navigation point in this app, but we want to create some new pages to navigate to.  Let’s go ahead and add our first one.  To keep our code clean, the first thing I want to do is add a directory inside our “\pages\” directory called “duck”.  I’ll use this directory to keep my new page separate from my other pages.  Now let’s go into Visual Studio, and right click on that new folder.  In our contextual menu, we’ll have the option to add a “new item.”  

<img class="figure" alt="Figure 7-1" src="/images/chapter-jeff/vs-menu2.png"> 

Add a new “page control” which we will call duck.html.  Once we hit add, not only is an HTML file created, but an associated .js and .css file as well.

<img class="figure" alt="Figure 7-1" src="/images/chapter-jeff/vs-page.png"> 

This is the new page we are going to navigate to.  If you open up duck.js, you’ll see we have some content already created for us:

{% codeblock win8.js %} 

// For an introduction to the Page Control template, see the following documentation:
// http://go.microsoft.com/fwlink/?LinkId=232511
(function () {
    "use strict";

    WinJS.UI.Pages.define("/pages/duck/duck.html", {
        // This function is called whenever a user navigates to this page. It
        // populates the page elements with the app's data.
        ready: function (element, options) {
            // TODO: Initialize the page here.
        },

        unload: function () {
            // TODO: Respond to navigations away from this page.
        },

        updateLayout: function (element, viewState, lastViewState) {
            /// <param name="element" domElement="true" />

            // TODO: Respond to changes in viewState.
        }
    });
})();

{% endcodeblock %}

You’ll notice the first thing in our blind function is that we have our page “defined”.  This code will be called whenever a user navigates to this page, so in our case, we’ll want to use this method to wrap all of our JavaScript from our YUI examples.
Now it’s time to go get a few cool examples.  Let’s start with a little game that takes me back to my days of being raised by “carnies” (that’s carnival folk for all those who aren’t from Texas).  

  <img class="figure" alt="Figure 7-1" src="/images/chapter-jeff/library-page.png"> 

This [duck shooter game](http://yuilibrary.com/yui/docs/node/ducks.html) demonstrates the use of the Node list.  I basically want to pull this sample right off the library and dump into a Windows 8 App. On this page scroll down to the full code example.  Copy the CSS into the duck.css file, merge the HTML into your duck.html file (be sure not to delete the references to the already existing .js and .css files) and then take the YUI use() statement and copy it into the “ready” method inside of the duck.js file

{% codeblock win8.js %} 
        ready: function (element, options) {
            // Paste Your Code right here!
        },
{% endcodeblock %}

##A Match Made in Heaven

Next is the step where YUI and WinJS actually meet.  For me, this is like the “as you wish” moment from the Princess Bride where Princess Buttercup realized she truly loved Westley too.  It’s going to work so seamlessly.    At this point there is one BIG thing missing.  YUI.  We need to load YUI into our local context so we can reference it from our local pages.  First things first, you need to go to github and download a copy of the library.  Now in “file explorer window” select the “build” directory from the library, copy it and then head back to your solutions explorer and paste it into your app.  Okay, that wasn’t hard at all, but there is one more thing to plan for.  When you use the YUI CDN along with the loader, you get a magical file concoction that loads all the proper files for you based on your YUI requires statement.  Since we aren’t using the CDN, we don’t get that magic.  The good news is, YUI’s got an app for that.  It’s called the YUI configurator and it’s pretty snazzy too.  Let’s quickly review our use statement in our sample, and you will see that are using two library components:
{% codeblock win8.js %} 
YUI().use('transition', 'button', function (Y) {…
{% endcodeblock %}

So let’s go over to the configurator and select those two components from the list of required components.  There are a few other settings we can update to make our life easier.  First, make sure you have the box unchecked to load separate files, not combined files.  Next, you can update your root path; in this case we will update it to “/js/build” since that is where the files will be in our app.  Once you have these settings in place, you should have a nice list of files that we need to load into our DOM in order to have our demo function:

{% codeblock win8.html %} 
<script type="text/javascript" src="/js/build/yui-base/yui-base.js"></script>
<script type="text/javascript" src="/js/build/oop/oop.js"></script>
<script type="text/javascript" src="/js/build/attribute-core/attribute-core.js"></script>
<script type="text/javascript" src="/js/build/classnamemanager/classnamemanager.js"></script>
<script type="text/javascript" src="/js/build/event-custom-base/event-custom-base.js"></script>
<script type="text/javascript" src="/js/build/features/features.js"></script>
<script type="text/javascript" src="/js/build/dom-core/dom-core.js"></script>
<script type="text/javascript" src="/js/build/dom-base/dom-base.js"></script>
<script type="text/javascript" src="/js/build/selector-native/selector-native.js"></script>
<script type="text/javascript" src="/js/build/selector/selector.js"></script>
<script type="text/javascript" src="/js/build/node-core/node-core.js"></script>
<script type="text/javascript" src="/js/build/node-base/node-base.js"></script>
<script type="text/javascript" src="/js/build/event-base/event-base.js"></script>
<script type="text/javascript" src="/js/build/button-core/button-core.js"></script>
<script type="text/javascript" src="/js/build/event-custom-complex/event-custom-complex.js"></script>
<script type="text/javascript" src="/js/build/attribute-observable/attribute-observable.js"></script>
<script type="text/javascript" src="/js/build/attribute-extras/attribute-extras.js"></script>
<script type="text/javascript" src="/js/build/attribute-base/attribute-base.js"></script>
<script type="text/javascript" src="/js/build/attribute-complex/attribute-complex.js"></script>
<script type="text/javascript" src="/js/build/base-core/base-core.js"></script>
<script type="text/javascript" src="/js/build/base-observable/base-observable.js"></script>
<script type="text/javascript" src="/js/build/base-base/base-base.js"></script>
<script type="text/javascript" src="/js/build/pluginhost-base/pluginhost-base.js"></script>
<script type="text/javascript" src="/js/build/pluginhost-config/pluginhost-config.js"></script>
<script type="text/javascript" src="/js/build/base-pluginhost/base-pluginhost.js"></script>
<script type="text/javascript" src="/js/build/event-synthetic/event-synthetic.js"></script>
<script type="text/javascript" src="/js/build/event-focus/event-focus.js"></script>
<script type="text/javascript" src="/js/build/dom-style/dom-style.js"></script>
<script type="text/javascript" src="/js/build/node-style/node-style.js"></script>
<script type="text/javascript" src="/js/build/widget-base/widget-base.js"></script>
<script type="text/javascript" src="/js/build/widget-base-ie/widget-base-ie.js"></script>
<script type="text/javascript" src="/js/build/widget-htmlparser/widget-htmlparser.js"></script>
<script type="text/javascript" src="/js/build/widget-skin/widget-skin.js"></script>
<script type="text/javascript" src="/js/build/event-delegate/event-delegate.js"></script>
<script type="text/javascript" src="/js/build/node-event-delegate/node-event-delegate.js"></script>
<script type="text/javascript" src="/js/build/widget-uievents/widget-uievents.js"></script>
<script type="text/javascript" src="/js/build/button/button.js"></script>
<script type="text/javascript" src="/js/build/transition/transition.js"></script> 
{% endcodeblock %}

Paste that into the header, and we are ready to go.  What’s going to happen next is that when we navigate to duck.html, WinJS will fire the “ready” method and execute the YUI.use() statement from the demo page.  We still have one small problem- we don’t yet have any way to navigate to this code.  Never fear, we can fix that. To navigate to a page, you really just need to fire one method:

{% codeblock win8.js %} 

WinJS.Navigation.navigate("PathToFile");
{% endcodeblock %}

When this method is fired, your app will then navigate to the page referenced by the string passed into it.  Remember, our WinJS apps are all single page applications, so there is no page load- instead your new page content is loaded inside of your app container.  In this case, the container was defined inside the default.html file.  In addition to the HTML being injected into your DOM from your new page, it’s references are added to ( .js files or .css files).  It’s quite a smooth process.
To make the whole thing a bit easier on me, I’m going to crack open my home.js file, and have a bit of code loaded up that will make my navigation even more familiar.  Remember, when the “home.html” file is loaded, our “home.js” file is executed as well.  Inside the “ready” method of this file, we’re going to add a few lines of code so the file appears as below:

{% codeblock win8.js %} 

(function () {
    "use strict";

    WinJS.UI.Pages.define("/pages/home/home.html", {
        // This function is called whenever a user navigates to this page. It
        // populates the page elements with the app's data.
        ready: function (element, options) {


            WinJS.Utilities.query("a").listen("MSPointerDown", function (evt) {
                // dont load this link in the main window
                evt.preventDefault();

                // get target element
                var link = evt.target;

                //call navigate and pass the href of the link
                WinJS.Navigation.navigate(link.href);
            });

        }
    });
})();

{% endcodeblock %}

You’ll notice I added a listener to all of my anchor tags that prevents the default behavior and then takes the url from the href, and passes it into our navigation method.  With the addition of this code, I can now simply add anchor tags into my code as I would with the web, and the navigation module will take over and provide me with page construction and high level app navigation (state for back button).
Now I can go back to my “home.html” file and add a link in to my duck app:

{% codeblock win8.html %} 

  <p><a class="duck" href="/pages/duck/duck.html" >duck</a></p>      
{% endcodeblock %}

Our app now navigates from the start page to the duck sample, and back again.

<img class="figure" alt="Figure 7-1" src="/images/chapter-jeff/screen-1.png"> 

<img class="figure" alt="Figure 7-1" src="/images/chapter-jeff/screen-2.png"> 
  
##Growing the App

Let’s keep going with this navigation app and add a new page.  Go to your solution explorer, create a new directory inside the “pages” directory and call it "dial".  Inside of it, right click and add a new page control called “dial.html”.  Again, watch the magic happen as it generates your .html file, your .js file and your .css file.
Next, navigate to the super cool [YUI sample dial app](http://yuilibrary.com/yui/docs/dial/dial-interactive.html):

  <img class="figure" alt="Figure 7-1" src="/images/chapter-jeff/cap-3.png"> 
  
Here, we’re going to again copy out sample code directly from the web and move it into our app.   You have your three file types (.html, .js, .css), so use them.  Move your css from the sample style tag to your CSS file, move your HTML from the body of your sample into the body of your HTML file, and move the JS code from the sample page into the “ready” method of dial.js file. At this point, you’ll want to go back to your YUI configurator to determine what JS files you need to lean in the head of the page as well.  Your resulting HTML file should look like this:

{% codeblock win8.html %} 

<!DOCTYPE HTML>
<html>
        <!-- WinJS references -->
    <link href="//Microsoft.WinJS.1.0/css/ui-light.css" rel="stylesheet" />
    <script src="//Microsoft.WinJS.1.0/js/base.js"></script>
    <script src="//Microsoft.WinJS.1.0/js/ui.js"></script>
    <!-- CSS -->
    <link rel="stylesheet" type="text/css" href="/js/build/widget-base/assets/skins/sam/widget-base.css">
    <link rel="stylesheet" type="text/css" href="/js/build/dial/assets/skins/sam/dial.css">
    <link href="dial.css" rel="stylesheet" />

    <!-- JS -->
    <script type="text/javascript" src="/js/build/yui-base/yui-base-min.js"></script>
    <script type="text/javascript" src="/js/build/intl-base/intl-base-min.js"></script>
    <script type="text/javascript" src="/js/build/oop/oop-min.js"></script>
    <script type="text/javascript" src="/js/build/event-custom-base/event-custom-base-min.js"></script>
    <script type="text/javascript" src="/js/build/event-custom-complex/event-custom-complex-min.js"></script>
    <script type="text/javascript" src="/js/build/intl/intl-min.js"></script>
    <script type="text/javascript" src="/js/build/dial/lang/dial.js"></script>
    <script type="text/javascript" src="/js/build/attribute-core/attribute-core-min.js"></script>
    <script type="text/javascript" src="/js/build/attribute-observable/attribute-observable-min.js"></script>
    <script type="text/javascript" src="/js/build/attribute-extras/attribute-extras-min.js"></script>
    <script type="text/javascript" src="/js/build/attribute-base/attribute-base-min.js"></script>
    <script type="text/javascript" src="/js/build/attribute-complex/attribute-complex-min.js"></script>
    <script type="text/javascript" src="/js/build/base-core/base-core-min.js"></script>
    <script type="text/javascript" src="/js/build/base-observable/base-observable-min.js"></script>
    <script type="text/javascript" src="/js/build/base-base/base-base-min.js"></script>
    <script type="text/javascript" src="/js/build/pluginhost-base/pluginhost-base-min.js"></script>
    <script type="text/javascript" src="/js/build/pluginhost-config/pluginhost-config-min.js"></script>
    <script type="text/javascript" src="/js/build/base-pluginhost/base-pluginhost-min.js"></script>
    <script type="text/javascript" src="/js/build/classnamemanager/classnamemanager-min.js"></script>
    <script type="text/javascript" src="/js/build/features/features-min.js"></script>

    <script src="dial.js"></script>



<body class="yui3-skin-sam"> <!-- You need this skin class -->

       <div class="dial fragment">
        <header aria-label="Header content" role="banner">
            <button class="win-backbutton" aria-label="Back" disabled type="button"></button>
            <h1 class="titlearea win-type-ellipsis">
                <span class="pagetitle">Welcome to duck</span>
            </h1>
        </header>
        <section aria-label="Main content" role="main">
            <div class="content">
<div id="example_container">
    <div id="view_frame">
        <div id="scene">
            <div id="stars"></div>
            <img id="hubble" src="/images/hubble.png"/>
            <img id="earth" src="/images/mountain_earth.png"/>
            <div class="label hubble">hubble</div>
            <div class="label thermosphere">thermosphere</div>
            <div class="label mesosphere">mesosphere</div>
            <div class="label stratosphere">stratosphere</div>
            <div class="label troposphere">troposphere</div>
            <div class="label ozone">ozone</div>
            <div class="label crust">crust</div>
            <div class="label mantle">mantle</div>
        </div>
    </div>
    <div class="controls">
        <div class="intro-sentence">From Earth to <a id="a-hubble">Hubble</a></div>
        <div id="altitude_mark"></div>
        <div id="demo"></div>
    </div>
</div>
</div>
    </section>
    </div>
</body>

</html>

{% endcodeblock %}

If you were to run the app at this point, it would have a visually incomplete dial as illustrated:

   <img class="figure" alt="Figure 7-1" src="/images/chapter-jeff/screen-4.png"> 
   
But how can that be you ask?  Have I lead you astray and YUI doesn’t really work in a Windows 8 App?  Not at all.  Remember how I mentioned that WinJS is constructing the pages for you.  In the process, they take the HTML content out of one HTML file and inject it into our main file (default.html).  What they don’t inject is the body tag.  This YUI example, for skinning purposes, has a class on the body tag, so we need to manually move that class to the body tag of our default.html file so it looks like this:

{% codeblock win8.html %} 

<body class="yui3-skin-sam">
    <div id="contenthost" data-win-control="Application.PageControlNavigator" data-win-options="{home: '/pages/home/home.html'}"></div>

</body>

{% endcodeblock %}

When we reload our application with the new app, we have a skinned version of out dial: 
 
<img class="figure" alt="Figure 7-1" src="/images/chapter-jeff/screen-5.png"> 
 
Now we’re all set to go.  Let’s go back to home.html and add a link to our new page: 

{% codeblock win8.html %} 
<p><a href="/pages/dial/dial.html" >Dial</a></p> 
{% endcodeblock %}

At this point we’ll have a fully functional navigation app with two different YUI samples in the same Windows 8 App.

##Accessing Windows APIs with YUI
One of the great things about being inside of a Windows 8 Store App is the access to the WinRT APIs.  There are a lot of cool platform features you can include, one of which is the share contract.  The share contract allows you to share data between apps.  In our case, we want to define what data will be passed to other apps when the user engages the share charm (part of the Windows 8 charms bar):

<img class="figure" alt="Figure 7-1" src="/images/chapter-jeff/screen-6.png"> 
  
In this case, I’m going to go into my sample code of the dial example code and add a few lines of JavaScript in:

{% codeblock win8.js %} 

var dataTransferManager = Windows.ApplicationModel.DataTransfer.DataTransferManager.getForCurrentView();
dataTransferManager.addEventListener("datarequested", shareTextHandler);
 
function shareTextHandler(e) {
          var request = e.request;
          request.data.properties.title = "Share Dial Level";
          request.data.properties.description = "I'd like to share something with you";
 	   request.data.setText("Hello, my dial is set to " + dial.get('value') + " Kilometers in altitude");
                    
        }

                YUI.namespace("win8App");

                YUI.win8App.sharePointer = dataTransferManager;
                YUI.win8App.shareFunction = shareTextHandler;

{% endcodeblock %}

We set up a listener here for an event called “datarequested” in which we set properties of our data object.  At this point every app has declared (through the app manifest) what type of data can be shared to it.  In this method, we are simply declaring what type of data we are sharing.  In this case, we are setting text.  We also have a title and description that will be used by some apps.  Now, when we reload our app and navigate to our dial sample, we can select the “share charm” from our charm bar.  You’ll see a list of apps appear that are able to handle this type of shared content.  

<img class="figure" alt="Figure 7-1" src="/images/chapter-jeff/screen-7.png"> 

I’ll select the mail app and you can see how this data will be shared:
 
<img class="figure" alt="Figure 7-1" src="/images/chapter-jeff/screen-8.png"> 
   
We are sharing info about our dial settings, so it doesn’t make sense to share that same data when we are viewing another sample, so we want to add a few additional lines of JavaScript to remove this listener when we don’t need it.  If you noticed above we used the YUI namespace to expose a pointer to both the function we are calling when we share, and a pointer to the dataTransfermanager itself.  We’re going to move down in our JavaScript object a bit to the “unload” method.  This method is called every time you navigate away from this page, so it will be a perfect place to remove this listener:

{% codeblock win8.js %} 

unload: function () {
            // TODO: Respond to navigations away from this page.
            YUI.win8App.sharePointer.removeEventListener("datarequested", YUI.win8App.shareFunction);
        },
{% endcodeblock %}

More information about the share contract and other Windows APIs can be found here.

##Success!
Well, we’ve done it.  We’ve built a Windows 8 Store App using YUI, we’ve mixed YUI with WinJS and were ready to roll.  I’ll add just a bit of CSS to my starting page to give it a bit of a metro feel and we’re all done.


##Conclusion
To wrap up this whole experiment in a few works, it just works.  YUI works inside a Windows 8 Store App just as it would inside your browser.  The big difference is you now have access to all those Windows APIs that aren’t exposed to the web browser.  We’ve demonstrated how you can use YUI alongside of WinJS, but you don’t need to.  Your existing YUI app can be ported to Windows 8 Apps without needing WinJS.  It doesn’t stop at YUI, Windows 8 Apps are built on the engines that run IE10, so bring your favorite JavaScript library, your favorite YUI component or your favorite Web App and go “Native” with Windows 8.
The Key is to use the skills you already have, and the investments you’ve already made in your apps, and increase your reach in the Windows 8 Store.

###Posted by: [Jeff Burtoft](http://twitter.com/boyofgreen)