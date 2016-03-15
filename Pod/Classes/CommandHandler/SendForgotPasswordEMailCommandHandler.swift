//
//  SendForgotPasswordEMailCommandHandler.swift
//  Pods
//
//  Created by Jan Bartel on 15.03.16.
//
//

import Foundation
import SwiftDDP
import VISPER_CommandBus

public class SendForgotPasswordEMailCommandHandler : CommandHandlerProtocol{

    public func isResponsible(command: Any!) -> Bool {
        return command is SendForgotPasswordEMailCommandProtocol
    }
    
    public func process<T>(command: Any!, completion: ((result: T?, error: ErrorType?) -> Void)?)  throws{
        
        let myCommand = command as! SendForgotPasswordEMailCommandProtocol
        
        Meteor.call("sendForgotPasswordEmail", params: [myCommand.userNameOrMail]) { (result, error) -> () in
            
            if error != nil {
                completion?(result: nil,error: error)
                return
            }
            
            completion?(result: (result as! T?), error: nil)
        }
        
    }
}