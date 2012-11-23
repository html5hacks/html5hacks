---
layout: post
title: "Overview of the GeoLocation Chapter in O'Reilly HTML5 Hacks"
date: 2012-10-15 23:19
comments: true
categories: ["Geo Location", "Mobile"]
author: Jesse Cravens
---

An exploration of the future of web technologies and browser capabilities would not be complete without covering the tools and techniques available to enable location awareness.

Location-aware web applications provide content, functionality, and services based on the cooperative detection of the user’s physical location. These applications can then provide the user with real-time filtering of online information relevant to his current location, such as place markers indicating the user’s location within a map, local consumer reviews, local coupons and offers, and even relevant traffic and public transportation notices.

These applications also enable users to provide their location to friends in a social network and vice versa, creating possibilities for meetups and blended online and physical interaction.

As you might imagine, the opportunities are not just limited to enhancing the life of the consumer. Given real-time location data of potential consumers and their friends, retailers can also create highly targeted, location-specific marketing campaigns for both digital and physical products.

##How Does It Work?

The web browser employs various technologies to pass parameters via a background HTTP request to a Location Information Server that returns a data set that includes an estimated longitude and latitude.

The technologies used to gather location data depend on the device and on the operating system running on the device. The most common sources are:

- Public IP address
- WiFi access points
- Bluetooth MAC IDs
- GPS
- GSM/CDMA cell tower IDs

Geolocation libraries for the Web are not new. In fact, today’s W3C Geolocation specification is largely reflective of the original Google Gears API introduced by Google in 2008. The API has been standardized and is one of the most widely adopted of the HTML5 specifications covered in this book (O'Reilly HTML5 Hacks). 

Fortunately, the API is also easy to use—a benefit we will explore in “Use the Geolocation APIs to Display Longitude and Latitude in a Mobile Web Application” and “Update a User’s Current Location in a Google Map”. 

In addition, a number of third-party services are available for creating really interesting hacks, and they explore concepts such as reverse geocoding and geofencing. In “Use Google’s Geocoding API to Reverse-Geocode a User’s Location” and “Use the Geoloqi Service to Build a Geofence” we will pass our location data to a service that will provide an enhanced API for working with location data. 
In “Use the Geoloqi Real-Time Streaming Service to Broadcast a Remote User’s Movement” we will blend the power of the WebSocket API with location awareness to make our application update in real time.

For browsers that don’t provide this functionality natively, Google’s IP geocoding service can serve as a polyfill, as we will explore in “Polyfill Geolocation APIs with Webshims”.

The main drawback to this functionality is related to privacy and security, and for good reason. After all, as responsible application developers we should be doing what we can to protect the sensitive data of our users. In “Use the Geolocation APIs to Display Longitude and Latitude in a Mobile Web Application” we will take an in-depth look at how the browser employs cooperative detection, allowing the user to opt-in to only sharing location data with trusted web applications. 

Want to read more detail? ... [buy the book](http://shop.oreilly.com/product/0636920026273.do?sortby=bestSellers).