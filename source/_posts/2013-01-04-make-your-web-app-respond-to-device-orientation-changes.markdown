---
layout: post
title: "Make Your Web App Respond to Device Orientation Changes"
date: 2013-01-04 00:31
comments: true
categories: ["CSS","Mobile","Media Queries"]
---

####Your native apps are smart enough to know how you’re holding your device. Now your web apps can be, too. Use orientation-based media queries to make your site responsive. 

Mobile devices have brought a new paradigm to web development. Unlike desktops and laptops that have a fixed orientation (I rarely see people flip their PowerBook on its side), mobile devices can be viewed in either landscape or portrait mode. Most mobile phones and tablets have an accelerometer inside that recognizes the change in orientation and adjusts the screen accordingly. This allows you to view content on these devices in either aspect ratio. For example, the iPad has a screen aspect ratio of 3:4 where the device is taller than it is wide. When you turn it on its side, it has an aspect ratio of 4:3 (wider than it is tall). That’s an orientation change.

Using media queries, you can natively identify which orientation the device is being held in, and utilize different CSS for each orientation. Let’s go back to our example page and see what it would look like in landscape mode (see Figure 2-16) and portrait mode (see Figure 2-17).


<img class="figure" alt="Figure 2-16" src="/images/chapter2-images/2-15.png">

Figure 2-16:Our sample page in landscape mode on an iPad, with three columns of content

Here is the markup that makes each view work:

{% codeblock orientation.html %}
<div class="row">
  <div class="span4">...</div>
  <div class="span4">...</div>
  <div class="span4">...</div>
</div>
{% endcodeblock %}


Here is the CSS for the three-column view:

{% codeblock orientation.css %}
.row {
   width: 100%;
}
{% endcodeblock %}


<img class="figure" alt="Figure 2-17" src="/images/chapter2-images/2-15b.png">

Figure 2-17: Our sample page in portrait mode on an iPad, with one column of linear content:

{% codeblock orientation.css %}
.span4 {
   width: 300px;
   float: left;
   margin-left: 30px;
}
{% endcodeblock %}
and the CSS for the single-column view:
{% codeblock orientation.css %}
.row {
   width: 100%;
}
.span4 {
   width: auto;
   float: none;
   margin: 0;
}
{% endcodeblock %}


Now we’ll wrap each CSS option in media queries so that they only apply in their proper orientation. Remember, the media queries wrap the CSS in conditions that only apply the declarations when the media query resolves to true. Using inline media queries, our CSS will now look something like this:

{% codeblock orientation.css %}
@media screen and (orientation:landscape) {
.row {
   width: 100%;
}
.span4 {
   width: 300px;
   float: left;
   margin-left: 30px;
}
}
@media screen and (orientation:portrait) {
.row {
   width: 100%;
}
.span4 {
   width: auto;
   float: none;
   margin: 0;
}
}
{% endcodeblock %}


With the CSS and media queries in place, our page will have three columns of content in landscape mode, and only one in portrait mode.

##Why Not Width?

If you compare device orientation to max-width pixel media queries, you may realize you can accomplish this hack with max- and min-width queries, since the width will change when the device changes orientation. However, there are pros and cons to doing this.

Media queries based on orientation can often be simpler. You don’t need to know what screen size to expect for landscape versus portrait view. You simply rely on the orientation published by the device. You also gain consistency between devices in terms of how the pages appear in each orientation.

The argument against orientation media queries is pretty much the same. You really shouldn’t care if your orientation is portrait or landscape. If your screen width is 700px, it shouldn’t matter which way the device is being held: the layout should cater to a 700px screen. When you design for the available space the actual orientation becomes inconsequential.

Want to try it out?  View this code sample in our [GitHub Repo](https://github.com/html5hacks/chapter2).