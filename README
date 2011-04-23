#The Echo Nest Cocoa Framework#

This is a wrapper framework written in Objective-C that eases connection to The Echo Nest API for music analysis. 

![Mac Example](http://melka.one.free.fr/echonestcocoa/EchoNestFramework.png)
![iPhone Example](http://melka.one.free.fr/echonestcocoa/FrameworkiPhone.jpg)

##Introduction##

The Echo Nest is an API that allows analysis of music files based on the "Musical Brain"

Details from The Echo Nest website :
_The Echo Nest's APIs are based on the "Musical Brain," a one-of-a-kind machine learning platform that actually listens to music and reads about music from every corner of the web. We're using the Musical Brain to power enhanced music search, recommendation and interactivity for online music services._

More infos : [The Echo Nest](http://the.echonest.com)

###Prerequisite###

To be able to use this Framework, you need to get an Echo Nest API Key. You can get one by registering with The Echo Nest on [the following page.](http://developer.echonest.com/account/register/)

Once you have a valid API Key, you'll be able to init an EchoNest object by using the method

	EchoNest* nest = [[EchoNest alloc] initWithAPIKey:@"yourApiKey"];

The API Key you entered will be tested on the server. If valid, you can go on with the other methods, if not, you can enter a new one by using

	[nest setApiKey:@"newApiKey"];
	[nest validateApiKey];

###Stuff Done with it###

[iPhone Music Visualiser](http://musichackday.org/hacks.php?page=iPhone+Music+Visualiser)  
![iPhone Music Visualiser](http://melka.one.free.fr/echonestcocoa/mhd-imv.png)  
_Matt Biddulph & George J Cook_

##TODO##
###Documentation###

For the time being, we use a good old commenting that is difficult to track. We need to improve commenting and documentation (i.e : doxygen) 

###Missing methods###

All the Artist methods.
Charts methods.
Identifier methods. 

###Improvements###

* Better error handling (almost inexistent now).
* Another notification mode. We are using NSNotification. Maybe we need to implement a delegate protocol.
* Find a way to update upload status (percentage) for the MP3 uploading method.
* URL "upload" for tracks
* ????
* profit


