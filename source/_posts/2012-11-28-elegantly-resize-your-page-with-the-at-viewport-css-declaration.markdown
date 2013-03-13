---
layout: post
title: "Elegantly Resize Your Page with the @-viewport CSS Declaration"
date: 2012-11-28 18:37
comments: true
categories: ["CSS","Mobile","W3C"]
---
####Gone are the days of viewport meta tags that with implementations different across browsers.  The new @-viewport is easy to use and puts the control in the right place.


There is a minsconception that the meta “viewport” tag is a standard.  We have seen it implemeted in quite a few browsers, mostly mobile, and looks something like this:

{% codeblock meta.html %}
<meta name="viewport" content="width=320" />
{% endcodeblock %}


Developers use this meta tag to control the zoom factor of the browser when loading the page.  If the above example, the page will assume that the viewport is 320px, no matter how many pixels are really available for rendering.  Usually, it was used to squeeze a 900-1200px screen, into a 320px screen.

The meta tag worked okay but it has limitations, and since it’s non-standard, it’s been implemented different ways across browsers.

##CSS Pixels
To follow what's happening to your page with the viewport values, it’s important to understand the basic concept of viewport zooming.  I don’t think the explanation can be done any better than it was by PPK in [this post about viewports](http://www.quirksmode.org/mobile/viewports2.html).  Here’s the summary:

> Both viewports are measured in CSS pixels, obviously. But while the visual viewport dimensions change with zooming (if you zoom in, less CSS pixels fit on the screen), the layout viewport dimensions remain the same. (If they didn’t your page would constantly reflow as percentual widths are recalculated.)

Let’s look at an example:

<img class="figure" alt="Figure 7-1" src="/images/news-images/viewport.png">

Two screenshots, the left used rendered in ie10 on windows phone 8 with no view port setting.  The screenshot on the right has a viewport declaration set to  set the viewport width to 320px

In the above figure, we see a smiley face on a page.   Both pages have a smiley face that has a width set to 300 pixels.  The difference is in css pixels.  Mobile browsers zoom out to see more content on a page by default.  In this case the page on the left is zoomed out so that the whole page can be seen.  This makes our smiley face much smaller that it actually is.  Although it may only take up 70 pixels of actual screen pixels, it’s  css pixel width will always be 300. 

The figure on the right also is 300 css pixels, but since the viewport is set to 320px, the device pixels of the smiley face is actually 450 or so pixels.

##@-viewport CSS
Sound difficult?  It’s going to get a lot simpler with a new specification.  The W3C has a specification to address the non-standard viewport meta tag and more, and the control has now rightfully been moved to CSS.

The specification can be found here:
  [http://dev.w3.org/csswg/css-device-adapt/](http://dev.w3.org/csswg/css-device-adapt/)

Although still in draft form, the specification has been implemented in Internet Explorer 10, and has developers quite excited about it.  Lets look at an example.  To set the screen to a CSS pixel width of 640 pixels, we would use the following css:

{% codeblock viewport.css %}
@-viewport {
width: 640px;
} 
{% endcodeblock %}

Doesn’t that make sense?  The great thing is that this property works both ways (scaling up and down).  If you screen width is smaller than 640px, your screen will be zoomed out to fix the entire 640px viewport on the screen.  If you screen is larger than 640px, you screen will be zoomed in to only show 640px viewport.  In either case the css width of the screen is 640px.

Inside the viewport tag, you can set any value that is related to the viewport, specifically that means width, height, max-width, max-height, min-width, and min-height.  Widths and heights can be set to any of the these values:

- auto:  let the user agent determine the best
- device width/height: scales to the actual width or height of the device.
- percent/pixel value: specific settings to assume as the screen width or height.

To maximize responsive design, you can use this @-viewport tag along with media queries, and may appear as something like the following:

{% codeblock viewport.css %}
@media (max-width: 699px) and (min-width: 520px) {
  @-viewport {
    width: 640px;
  }
}
{% endcodeblock %}


The above css will normalize any screen smaller than 699px and larger than 520px to be rendered at a viewport of 640px.  This will save a boatload of other css properties to do this same feature.  

In addition to the existing values, we have a few new values added as well, specifically the zoom value. Zoom allows us to set an initial zoom factor for the window or viewing area.  Zoom, along with min-zoom and max-zoom, can be set using any of the following values:

- auto: let the user agent determine the zoom factor
- numeric: a positive integer that is used to determine the zoom value  A value of 1.0 has no zoom.
- percentage: a positive percentage.  In the case of 100% there is no zoom.

Zoom can be used by itself or in conjunction with a width or height value:

{% codeblock viewport.css %}
@-viewport {
    width: device-width;
    zoom: .5;
  }
{% endcodeblock %}

The second new descriptor is that of “orientation”.  Any keen developer can tell that this is used to request that your device lock in a specific orientation.  Any of the following keywords can be used:

- auto: let the user agent determin 
- landscape: lock the device in landscape orientation
- portrait: lock the device in portrait mode

The implementation can be used along with width and zoom as in the following example:

{% codeblock viewport.css %}
@viewport {
    width: 980px;
    min-zoom: 0.25;
    max-zoom: 5;
    orientation: landscape;
}
{% endcodeblock %}


##Internet Explorer Implementation

The implementation in Internet Explorer 10 is practically identical to the W3C standard (great job IE team), with the addition of a prefix to signify that it’s an experimental implementation (as all prefixed implementations are).  The ie viewport value appears as follows:

{% codeblock viewport.css %}
@-ms-viewport {
  width: device-width
}
{% endcodeblock %}

IEs implementation currently only supports the width and height properties. Min and max height/width are not implemented and neither are zoom or orientation.  As with all early implementation of standards, if the specification changes, I have no doubt that the internet explorer team with update the implementation to match the standard.


##Legacy Implementations
When most developers think about viewport, this is what they think of:

{% codeblock  meta.html %}
<meta name="viewport" content="width=320" />
{% endcodeblock %}

This tag zooms in the page to a viewport of 320 pixels.  Although originally introduced by apple most mobile browsers went on to support this tag in one form or another.  The tag was often supported differently from browser to browser, and the syntax was never really clear in its documentation.  hence, the need for a standard.

Different browses implemented the meta tag differently when using the meta tag to determine the width of the page (specifically by setting width to device-width)  Let’s look at the Windows Phone 7 Internet Explorer and iOS safari implementations.

###Internet explorer
If you set the width in the meta tag to a specific size in internet explorer for windows phone 7, you get exactly what you ask for.  A meta tag like this:

{% codeblock meta.html %}
<meta name="viewport" content="width=480" />
{% endcodeblock %}

The above code will get you exactly what you ask for, which is a viewport zoomed to 480 pixels.  Now, when you set the width to be “device-width” such as the following:

{% codeblock meta.html %}
<meta name="viewport" content="width=device-width" />
{% endcodeblock %}

In this case, you get a page with a width of 320px in portrait mode, and 480px in landscape.  This is independent of how many pixels are actually available on the screen.


###Safari
Safari on iOS works just like ie does for specific pixel settings, but differs when you set width to “device width”.  Let’s again look at our meta tag:

{% codeblock meta.html %}
<meta name="viewport" content="width=device-width" />
{% endcodeblock %}

In the case of iOS, the width of the screen will be set to the actual width of the screen.  If the screen has 640 pixels, than the viewport will be resized to 640 pixels.

One of the worst parts about this meta tag is it really only helps on smaller screen, where content needs to scale down in size.  it’s outdated and was due to be replace with something better.  

The viewport standard is supported in ie10 on windows phone 8, but has legacy support for this meta tag as well.  Implementation of this meta tag in ie10 will give you the normalized values for page width (320px) when asking for screen size.



