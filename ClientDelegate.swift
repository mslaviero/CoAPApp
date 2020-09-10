//
//  ClientDelegate.swift
//  CoAPApp
//
//  Created by Matteo on 12/08/2020.
//  Copyright © 2020 Matteo. All rights reserved.
//

import Foundation
import SwiftUI

class ClientDelegate : SCClientDelegate, ObservableObject {
    //This observable variable is used to publish new messages to the content view
    @Published var lines: [String]
    
    init() {
        lines = []
    }
    
    //Called from client object when a message is recieved
    func swiftCoapClient(_ client: SCClient, didReceiveMessage message: SCMessage) {
        let payloadstring = message.payloadRepresentationString()
        let firstPartString = "Message received from \(message.hostName ?? "") with type: \(message.type.shortString())\nwith code: \(message.code.toString()) \nwith id: \(message.messageId ?? 0)\nPayload: \(payloadstring)\n"
                var optString = "Options:\n"
                for (key, _) in message.options {
                    var optName = "Unknown"
                        
                    if let knownOpt = SCOption(rawValue: key) {
                        optName = knownOpt.toString()
                    }

                    optString += "\(optName) (\(key))\n"
                }
        
        lines.append(firstPartString + optString)
    }
    
    //Called from client object when a failure occours. Simply prints the error description to the console
    @objc func swiftCoapClient(_ client: SCClient, didFailWithError error: NSError){
        
        lines.append("Failed with Error \(error.localizedDescription)")
    }
    
    //Called from client object when a message is successfully sent
    @objc func swiftCoapClient(_ client: SCClient, didSendMessage message: SCMessage, number: Int){

        lines.append("Message sent (\(number)) with type: \(message.type.shortString()) with id: \(String(describing: message.messageId!)) with payload: \(message.payloadRepresentationString())\n")
        
    }
    
    //Simply empties the current history of saved messages
    func eraseConsole() {
        lines.removeAll()
    }
    
}
