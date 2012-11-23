---
layout: post
title: "Configure Amazon S3 for Cross Origin Resourse Sharing to Host a Web Font"
date: 2012-11-18 19:42
comments: true
categories: ["Web Fonts","HTML5 Connectivity","CORS"]
author: Jesse Cravens
---

Cross-Origin Resource Sharing (CORS) is a specification that allows applications to
make requests to other domains from within the browser. With CORS you have a secure
and easy-to-implement approach for circumventing the browser’s same origin
policy.

In this hack we will explore hosting a web font on a cloud drive. In order to do so, we
will learn how to configure an Amazon S3 bucket to accept requests from other domains.

If you are not already familiar with web fonts and @font-face, refer to Hack #12.

In the next section I provide a bit more background on Amazon S3 and the same origin
policy, before we get into the details of CORS.

###What Is an Amazon S3 Bucket?

Amazon S3 (Simple Storage Service) is simply a cloud drive. Files of all kinds can be
stored using this service, but web application developers often use it to store static
assets such as images, JavaScript files, and stylesheets.

For performance improvements, web developers like to employ Content Delivery Networks
(CDNs) to serve their static files. While Amazon S3 is not a CDN in and of itself,
it’s easy to activate it as one by using CloudFront.

A bucket refers to the directory name that you choose to store your static files.
To get started let’s set up an account at Amazon and navigate to the Amazon Management
Console; see Figure 9-21.

Figure 9-21. S3 Management Console

<img class="figure" alt="Figure 9-21" src="/images/chapter9-images/9-21.png">

If we click on Create a Bucket we should see the prompt shown in Figure 9-22.

Figure 9-22. Creating an S3 bucket in the S3 Management Console

<img class="figure" alt="Figure 9-22" src="/images/chapter9-images/9-22.png">

Let’s name the bucket and choose a region (see Figure 9-23). As I stated earlier, you
can choose a region to optimize for latency, minimize costs, or address regulatory
requirements.

Figure 9-23. Naming an S3 bucket in the S3 Management Console

<img class="figure" alt="Figure 9-23" src="/images/chapter9-images/9-23.png">

We will go ahead and name our bucket none other than “html5hacks.” You should now
see an admin screen that shows an empty filesystem (see Figure 9-24).


Figure 9-24. The html5hacks S3 bucket

<img class="figure" alt="Figure 9-24" src="/images/chapter9-images/9-24.png">

Well, that was simple. So why are we doing this? Let’s start with some simple browser
security—something called the same origin policy.

###Same Origin Policy

As the browser becomes more and more of an application platform, application developers
have compelling reasons to write code that makes requests to other domains
in order to interact directly with the content. Wikipedia defines same origin policy as
follows:

In computing, the same origin policy is an important security concept for a
number of browser-side programming languages, such as JavaScript. The
policy permits scripts running on pages originating from the same site to
access each other’s methods and properties with no specific restrictions,
but prevents access to most methods and properties across pages on different
sites.1

1 http://en.wikipedia.org/wiki/Same_origin_policy

As stated in Wikipedia’s definition, the same origin policy is a good thing; it protects
the end user from security attacks. But it does cause some challenges for web developers.

This is where CORS comes into the picture. CORS allows developers of remote data
and content to designate which domains (through a whitelist) can interact with their
content.

###Using Web Fonts in Your Application

There are a number of ways to use a web font within your web pages, such as calling
the @font-face service, bundling the font within your application, hosting the web font
in your own Amazon S3 bucket (more on this later), or converting the file to Base64
and embedding the data inline in a data-uri. By the way, the last technique is similar
to the one outlined in Hack #13.

Each of these techniques has limitations.

* When calling the @font-face service you are limited to the fonts within the particular
service’s database.
* Bundling the font within your application does not make use of HTTP caching, so
your application will continue to download the font file on every page request.
Furthermore, you cannot reuse the font within other applications.
* Hosting the font in an Amazon S3 bucket works great, except with Firefox, which
enforces the same origin policy on all resources. So the response from the remote
server will be denied.
* Converting the font to Base64 adds additional weight to the stylesheet, and does
not take advantage of caching.

An exploration into the different types of web fonts is beyond the scope of this hack,
so I will assume that you have already selected the web font BebasNeue.otf.
You can download free and open fonts from sites such as http://www.dafont.com.

###Uploading Your Font to Your Amazon S3 Bucket

Now, all we have to do is to upload the font onto our filesystem in the cloud (see
Figure 9-25).

Figure 9-25. An uploaded BebasNeue font

<img class="figure" alt="Figure 9-25" src="/images/chapter9-images/9-25.png">

###Adding the Web Font to Your Web Page

In order to add a web font to our page, we need to add a single stylesheet to an HTML
page.

Here is our page. Let’s call it index.html, and add a <link> tag pointing to our base
stylesheet, styles.css.

{% codeblock geo.html %}

<html>
  <head>
    <title>S3 - font</title>
    <meta charset="utf-8" />
    <link rel="stylesheet" type="text/css" href="styles.css">
  </head>
  <body>
    <h1 class="test">HTML5 Hacks</>
  </body>
</html>

{% endcodeblock %}

In our styles.css let’s add the following and point to our uploaded file. Also, let’s assign
the font to our H1 header via the test class name.

{% codeblock style.css %}

@font-face { 
  font-family: BebasNeue;
  src: url('https://s3.amazonaws.com/html5hacks/BebasNeue.otf');
}

.test {
  font-family: 'BebasNeue';
}

{% endcodeblock %}

Now we’ll open a browser and point to our newly created HTML page. In Opera (see
Figure 9-26), Safari, and Chrome our header tag is being styled correctly.

Figure 9-26. Opera browser showing the BebasNeue font

<img class="figure" alt="Figure 9-26" src="/images/chapter9-images/9-26.png">

But if we view it in Firefox, we are having issues (see Figure 9-27).

Figure 9-27. Firefox browser failing to show the BebasNeue font

<img class="figure" alt="Figure 9-27" src="/images/chapter9-images/9-27.png">

If we examine the request for our font in the Chrome Dev Tools Network tab, we will
see that the response from the server is empty (see Figure 9-28).

Figure 9-28. Firefox browser showing an empty response

<img class="figure" alt="Figure 9-28" src="/images/chapter9-images/9-28.png">

What gives? Well, by default, Firefox will only accept links from the same domain as
the host page. If we want to include fonts from different domains, we need to add an
Access-Control-Allow-Origin header to the font.

So, if you try to serve fonts from any CDN, Firefox will not load them.

###What Is CORS?

The CORS specification uses the XMLHttpRequest object to send and receive headers
from the originating web page to a server that is properly configured in order to
enable cross-site requests.

The server accepting the request must respond with the
Access-Control-Allow-Origin header with either a wildcard (*) or the correct
origin domain sent by the originating web page as the value. If the value is not included,
the request will fail.

Furthermore, for HTTP methods other than GET or POST, such as PUT, a preflight request
is necessary, in which the browser sends an HTTP OPTIONS request to establish
a handshake with the server before accepting the PUT request.

Fortunately, after enough backlash from the development community, Amazon made
CORS configuration available on Amazon S3 via a very simple XML configuration.

Let’s get started.

###Configuring CORS at Amazon S3

You should already be at your Amazon Management Console at http://
console.aws.amazon.com. Click on Properties→Permissions→Edit CORS configuration,
and you should receive a modal prompt.

The configuration can accept up to 100 rule definitions, but for our web font we will
only need a few. For this example we will use the wildcard, but if you are doing this in
production, you should whitelist the domains to prevent others from serving your font
from your S3 account on their own web pages. It wouldn’t be the end of the world, but
it might get costly.

The first rule allows cross-origin GET requests from any origin. The rule also allows all
headers in a preflight OPTIONS request through the
Access-Control-Request-Headers header. In response to any preflight OPTIONS
request, Amazon S3 will return any requested headers.

The second rule allows cross-origin GET requests from all origins. The * wildcard
character refers to all origins.

{% codeblock config.xml %}

<CORSConfiguration>
<CORSRule>
<AllowedOrigin>*/AllowedOrigin>
<AllowedMethod>GET</AllowedMethod>
</CORSRule>
</CORSConfiguration>

{% endcodeblock %}

So, let’s add our new configuration to our Editor and save (see Figure 9-29).

Figure 9-29. Configuring CORS in the S3 Management Console

<img class="figure" alt="Figure 9-29" src="/images/chapter9-images/9-29.png">

Now, let’s return to Firefox and reload the page. We should now see the header font
styled with our BebasNeue web font, as shown in Figure 9-30.

Figure 9-30. Firefox browser successfully showing the BebasNeue font

<img class="figure" alt="Figure 9-30" src="/images/chapter9-images/9-30.png">

There is much more to learn about CORS, most notably, HTTP POST usage with certain
MIME types, and sending cookies and HTTP authentication data with requests if so
requested by the CORS-enabled server. So get out there and starting creating your
own CORS hacks.