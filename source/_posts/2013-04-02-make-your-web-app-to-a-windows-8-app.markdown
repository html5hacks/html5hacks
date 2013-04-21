---
layout: post
title: "Turn Your Web App into a Windows 8 App"
date: 2013-04-02 01:17
comments: true
categories: ['  Windows 8', 'JavaScript', 'Games']
---
I talk a lot about just how similar the Windows 8 App environment is to developing for the Web.  Since windows 8 uses the same rendering engine as IE10, and the same JavaScript engine as IE10, building a Windows 8 App with JavaScript is in fact, building a web app.  We’ll talk about some of the keys to success but first, let’s take a step by step walk through converting one of my favorite web apps into a Windows 8 App.
First thing first, you need to make sure your using [Visual Studio 2012](http://www.microsoft.com/visualstudio/eng/products/visual-studio-express-products) (I’m using the Express version which is free).  Since Visual Studio 2012 has a requirement of Windows 8, you’ll need to be running Windows 8 as well.
We’re going to be taking the new fantastic game “YetiBowl” for our conversion.  You can play a web version of the game [here](http://touch.azurewebsites.net/yeti/game.html). 

<img class="figure" alt="Figure 7-1" src="/images/win8app/ieweb.png"> 

Once your done playing go to codeplex and download the project: 

[http://yetibowl.codeplex.com](http://yetibowl.codeplex.com)

If you open up the content in the directory marked “web”  you’ll see all the code for the YetiBowl game.  Now let’s go to Visual Studio and open up a new "Blank" JavaScript App:

<img class="figure" alt="Figure 7-1" src="/images/win8app/VS1.PNG"> 

Next, go back to your recently downloaded code, and copy all the content from the "web" folder

<img class="figure" alt="Figure 7-1" src="/images/win8app/VS2.png"> 

Now go back to your new Visual Studio project, and find the solutions explorer on the right side of the screen, past your code into your project:

<img class="figure" alt="Figure 7-1" src="/images/win8app/VS3.png"> 

Before our code is going to work, we need to open up our package.appxmanifest and make one small change.  Find the field for "start page" and change it to the name of your html file(game.html):

<img class="figure" alt="Figure 7-1" src="/images/win8app/VS4.PNG"> 

Now, hit F5 and see what happens!  That’s all it takes, our YetiBowl game is now a Windows 8 Store App, and a pretty fine one at that.  Our web app code just works in Windows 8.

<img class="figure" alt="Figure 7-1" src="/images/win8app/VS5.PNG"> 

##Add a Little Delight for your users

Now that you have your app up and running, let’s use one of the favorite Windows 8 API to add some additional features to our app.  With a few lines of code we’ll be able to add the ability to “share” with the Windows 8 Share Charm.
  To keep it easy, let’s go to the bottom of our game.html file and add a script tag.  We’ll then past a few lines of code into it:

{% codeblock win8.js %} 



        var dataTransferManager = Windows.ApplicationModel.DataTransfer.DataTransferManager.getForCurrentView();



        dataTransferManager.addEventListener("datarequested", function (e) {
            // Code to handle event goes here.


            var request = e.request;
            request.data.properties.title = "I'm Rocking out with the Yeti";
            request.data.properties.description = "HTML share from YetiBowl Game";
            var localImage = 'ms-appx:///media/logos/yeti_logo.png';
            var htmlExample = "<p>Here's to some fun with the Yeti. If your not playing YetiBowl, then your not really having fun!</p><div><img src=\"" + localImage + "\">.</div>";

            var htmlFormat = Windows.ApplicationModel.DataTransfer.HtmlFormatHelper.createHtmlFormat(htmlExample);
            request.data.setHtmlFormat(htmlFormat);
            var streamRef = Windows.Storage.Streams.RandomAccessStreamReference.createFromUri(new Windows.Foundation.Uri(localImage));
            request.data.resourceMap[localImage] = streamRef;

        });




{% endcodeblock %}

<img class="figure" alt="Figure 7-1" src="/images/win8app/VS6.PNG"> 

You can find out more about the [share charm here](http://msdn.microsoft.com/en-us/library/windows/apps/hh758314.aspx), but we are basically taking advantage of one of the [many Windows RT APIs](http://msdn.microsoft.com/en-us/library/windows/apps/br211377.aspx) that you have access to via JavaScript inside your Windows 8 App.  Once you’ve added this above code, you’ll now be able to share info from your Yeti Bowl Game to other apps you have installed.

<img class="figure" alt="Figure 7-1" src="/images/win8app/VS7.PNG"> 

<img class="figure" alt="Figure 7-1" src="/images/win8app/VS8.PNG"> 

##A Few Closing Notes
It is very easy to move your web apps to Windows 8 where you have access to a whole series of new APIs and functionality that isn’t safe to expose on the web.  That being the case, it’s important that you look into the [security model](http://msdn.microsoft.com/en-us/library/windows/apps/hh849625.aspx) that is implemented in Windows 8 Apps.  Using a JavaScript library?  Many libraries like [YUI](http://www.yuiblog.com/blog/2013/03/12/windows-8-loves-yui/) and [jQuery](http://blogs.msdn.com/b/interoperability/archive/2013/03/29/jquery-adds-support-for-windows-store-apps-creates-new-opportunities-for-javascript-open-source-developers.aspx) already work within the Windows 8 App environment. 
It’s that easy, reuse your code, and your skills to build Windows 8 Store Apps.

Author: Jeff Burtoft - [@boyofgreen](http://www.twitter.com/boyofgreen)
code sample: [http://touch.azurewebsites.net/yeti/game.html](http://touch.azurewebsites.net/yeti/game.html)
