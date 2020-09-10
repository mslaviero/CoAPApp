//
//  ContentView.swift
//  CoAPApp
//
//  Created by Matteo on 31/07/2020.
//  Copyright © 2020 Matteo. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    //String describing the port of outgoing messages
    @State var portString = "5683"
    //Where the server is
    @State var hostName = "10.0.0.6"
    @State var payloadString = "payload"
    //Goes after the hostName in the final request string
    @State var uriPath = "info"
    //Switch variable (1=GET, 2=POST)
    @State var verb = 1
    @State var verbToggle = false
    
    //Delegate that handles client's action outcomes
    @ObservedObject var cDelegate = ClientDelegate.init()
    
    //Actual view
    var body: some View {
        NavigationView {
            VStack {
                //list makes content scrollable
                List {
                    //this VStack contains the console displaying incoming and outgoing messages updated by the delegate
                    VStack {
                        ForEach(cDelegate.lines.reversed(), id: \.self) { line in
                            Text(line)
                        }
                    }
                    .foregroundColor(Color.white)
                    .padding(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
                    .background(Color.init(red: 50/255, green: 50/255, blue: 50/255))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(radius: 8)
                }
                
                //simple button to clear the console
                Button(action: {
                    self.cDelegate.eraseConsole()
                }) {
                    Text("Erase console")
                        .foregroundColor(Color.white)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        .background(Color.init(red: 242/255, green: 163/255, blue: 64/255))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .shadow(radius: 8)
                }
                
                //VStack containing the form to edit variables and set the outgoing message. Texts describing the fields are self explainatory
                VStack {
                    HStack{
                        VStack {
                            Text("host:")
                                .foregroundColor(Color.white)
                            TextField("hostName", text: $hostName)
                                .padding(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
                                .foregroundColor(Color.black)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .shadow(radius: 8)
                        }
                        VStack {
                            Text("resource:")
                                .foregroundColor(Color.white)
                            TextField("uriPath", text: $uriPath)
                                .padding(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
                                .foregroundColor(Color.black)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .shadow(radius: 8)
                        }
                    }
                    HStack{
                        VStack {
                            Text("payload:")
                                .foregroundColor(Color.white)
                            TextField("payloadString", text: $payloadString)
                                .padding(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
                                .foregroundColor(Color.black)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .shadow(radius: 8)
                        }
                    }
                    
                    HStack {
                        //Toggles the verb variable between get and post
                        HStack{
                            Toggle(isOn: $verbToggle){}
                            if(self.verbToggle){
                                Text("GET")
                                    .foregroundColor(Color.white)
                                    .padding()
                            }else{
                                Text("POST")
                                    .foregroundColor(Color.white)
                                    .padding()
                            }
                        }
                        
                        //Most of the logic to build the message happens inside the action of this button
                        Button(action: {
                            if(verbToggle){
                                verb = 1
                            }else{
                                verb = 2
                            }
                            let client = SCClient(delegate: self.cDelegate)
                            
                            //initializes the new message to be sent
                            let m = SCMessage(code: SCCodeValue(classValue: 0, detailValue: UInt8(verb))!, type:.confirmable, payload: self.$payloadString.wrappedValue.data(using: String.Encoding.utf8))
                            
                            //tokenization of the uri string in order to append the uriPath options
                            let uriArray = uriPath.split(separator: "/")
                            for token in uriArray {
                                m.addOption(SCOption.uriPath.rawValue, data: token.data(using: String.Encoding.utf8)!)
                            }
                            
                            //tells the client object to send the message to the specified host on the specified port
                            client.sendCoAPMessage(m, hostName: self.$hostName.wrappedValue,  port: UInt16(self.$portString.wrappedValue)!)
                            
                        }) {
                            Text("Send")
                                .foregroundColor(Color.white)
                                .padding(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
                                .background(Color.init(red: 242/255, green: 163/255, blue: 64/255))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .shadow(radius: 8)
                        }
                    }
                }
                .padding()
                .background(Color.init(red: 50/255, green: 50/255, blue: 50/255))
                
            }
            .navigationBarTitle(Text("CoAP Messagess"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
