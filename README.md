# CoAPApp
A simple iPhone app that allows you to send CoAP messages 


If you ended up here it is very likely that you need to implement a Swift application that allows you to send CoAP message.

Please note that this project relies very heavily on this other repo: https://github.com/stuffrabbit/SwiftCoAP which provides a basic CoAP implementation.

The work that has been done here provides a user interface that allows you to send and recieve CoAP messages by calling functions from SwiftCoAP
So for further documentation regarding lower level logic, please don't hesitate to head over to their repo.
For similar reasons I also reccommend you get the library files directly from their repo, as possible updates of that library will unlikely be reflected here.

Once imported into your XCode, this app should enable you to send/recieve CoAP messages directly fom your iPhone, all without any further configuration.
You will be prompted with a screen allowing you to edit some of the "relevant" parameters of the outgoing message. 
These are, of course, 
  - the request string (including host name and uri path) 
  - payload (as a string)
  - toggle between POST and GET verbs
  
Most of the logic is included in the action of the "Send" button inside ContentView.swift
Another critical part of the code (that was implemented on top of SwiftCoAP) is the ClientDelegate.swift file, and more specifically the class it contains:
It carries out the actions to be performed on specific events such as the reception of a new message, handle errors in the sending of a message
and perform actions after a message has been successfully sent.

Please note that, when adding a string to the "uriPath" field of the outgoing message, the string NEEDS to be tokenized (splitting on "/"). And
one separate "addOption" action needs to be performed forEach token.
