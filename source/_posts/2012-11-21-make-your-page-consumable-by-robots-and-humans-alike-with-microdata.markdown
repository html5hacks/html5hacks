---
layout: post
title: "Make Your Page Consumable by Robots and Humans Alike with Microdata"
date: 2012-11-21 22:34
comments: true
categories: ["Markup","Microdata","JSON"]
author: Jeffrey Burtoft
---
HTML5 microdata provides the mechanism for easily allowing machines to consume the data on your pages, while not affecting the experience for the user.

If you’re like me, you believe that in the future, machines will rule over us humans with an iron fist (provided, of course, that the Zombie Apocalypse doesn’t get us first). While there isn’t anything we can do to help the zombie masses understand the Internet, HTML5 does offer a feature that prepares us for that machine dictatorship. It’s called microdata, and it’s supposed to be for machines only—no humans allowed.  

You can tell by now that HTML5 adds a lot of depth to your data, but up to this point the focus has been on your users. Microdata takes you down a slightly different path when you think about consumers who aren’t your users. Microdata is additional context you add to your markup to make it more consumable. When you build your page, you can add these additional attributes to give further context to your markup.

Microdata can be added to any page element to identify that element as an “item” or a high-level chunk of data. The content nested inside that item can then be labeled as properties. These properties essentially become name–value pairs when the itemprop becomes the value name and the human-readable content becomes the value. The relevant code would look something like this:

{% codeblock scope.html %}
<div itemscope>
    <span itemprop="name">Fred</span>
</div>
Sometimes item property data isn’t in the format that a “machine” would like, and additional attributes need to be added to clarify what the human-readable data is saying. In that scenario your data would look like this:
<div itemscope>
    Hello, my name is <span itemprop="name">Fred</span>.
    I was born on 
   <time itemprop="birthday" datetime="1975-09-29">Sept. 29, 1975</time>.
</div>
{% endcodeblock %}
Now imagine how consumable the Web would be for those machines of the future once microdata is utilized on every page!

In this hack we’ll use microdata to make sure our contact list is machine-readable. Each contact entry will be identified as an item, and its contents will be labeled as a property. Our first contact will look like this:

{% codeblock scopeitem.html %}
<li itemscope>
    <ul>
        <li>Name: <span itemprop="name">Fred</span></li>
        <li>Phone: <span itemprop="telephone">210-555-5555</span></li>
        <li>Email: <span itemprop="email">thebuffalo@rockandstone.com</span></li>
    </ul>
</li>
{% endcodeblock %}

As you can see, we have constructed one data item on our page, and when the markup is machine-read it will see the item as something like this:
{% codeblock json.js %}
    Item: {    name: 'Fred',
        telephone: '210-555-5555',
        email: 'thebuffalo@rockandstone.com'
        }
{% endcodeblock %}

Now let’s build ourselves a whole list:
{% codeblock wholelist.html %}
<ul>
<li itemscope>
    <ul>
        <li>Name: <span itemprop="name">Fred</span></li>
        <li>Phone: <span itemprop="telephone">210-555-5555</span></li>
        <li>Email: <span itemprop="email">thebuffalo@rockandstone.com</span></li>
    </ul>
</li>
<li itemscope>
    <ul>
        <li>Name: <span itemprop="name">Wilma</span></li>
        <li>Phone: <span itemprop="telephone">210-555-7777</span></li>
        <li>Email: <span itemprop="email">thewife@rockandstone.com</span></li>
    </ul>
</li>
<li itemscope>
    <ul>
        <li>Name: <span itemprop="name">Betty</span></li>
        <li>Phone: <span itemprop="telephone">210-555-8888</span></li>
        <li>Email: <span itemprop="email">theneighbour@rockandstone.com</span></li>
    </ul>
</li>
<li itemscope>
    <ul>
        <li>Name: <span itemprop="name">Barny</span></li>
        <li>Phone: <span itemprop="telephone">210-555-0000</span></li>
        <li>Email: <span itemprop="email">thebestfriend@rockandstone.com</span></li>
    </ul>
</li>
</ul>
{% endcodeblock %}

To our human friends the page looks something like Figure 1-14.

<img class="figure" alt="Figure 1-14" src="/images/chapter1-images/microdata1.jpg">

Figure 1-14. Adding microdata to the page, which does not change the view for users

To our machine friends, the code looks something like this:

{% codeblock itemjson.js %}
    Item: {    name: 'Fred',
        telephone: '210-555-5555',
        email: 'thebuffalo@rockandstone.com'
        },
    Item: {    name: 'Wilma',
        telephone: '210-555-7777',
        email: 'thewife@rockandstone.com'
        },
    Item: {    name: 'Betty',
        telephone: '210-555-8888',
        email: 'theneighbor@rockandstone.com'
        },
    Item: {    name: 'Barny,
        telephone: '210-555-0000',
        email: 'thebestfriend@rockandstone.com'
        }
{% endcodeblock %}

It’s that easy to add microdata to your page without sacrificing the interface for your human friends.

##Details, Details!

Microdata is pretty darn easy to implement, and the W3C spec thinks it should be just as easy to read, which is why the W3C added a JavaScript API to be able to access the data. Remember each of your identified elements was marked with an attribute called itemscope, which means the API considers them items. To get all these items, you simply call the following:

{% codeblock getitem.js %}
document.getItems();
{% endcodeblock %}

Now your items can also be segmented by type, so you can identify some of your items as people, and others as cats. Microdata allows you to define your items by adding the itemtype attribute, which will point to a URL, or have an inline definition. In this case, if we defined our cat type by referring to the URL http://example.com/feline, our cat markup would look something like this:

{% codeblock More lastscope.html %}
<li itemscope itemtype="http://example.com/feline">
    <ul>
        <li>Name: <span itemprop="name">Dino</span></li>
        <li>Phone: <span itemprop="telephone">210-555-4444</span></li>
        <li>Email: <span itemprop="email">thecat@rockandstone.com</span></li>
    </ul>
</li>
{% endcodeblock %}

And if we wanted to get items with only a specific type of cat, we would call:

{% codeblock getsample.js %}
document.getItems("http://example.com/feline")
{% endcodeblock %}

Thanks to this simple API, your microdata-enriched markup is both easy to produce and easy to consume.

