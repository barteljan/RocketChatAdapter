//
//  RegisterCommandHandler.swift
//  Pods
//
//  Created by Jan Bartel on 15.03.16.
//
//

import Foundation
import VISPER_CommandBus
import SwiftDDP

public class RegisterCommandHandler : CommandHandlerProtocol{
    public func isResponsible(command: Any!) -> Bool {
        return command is RegisterCommandProtocol
    }
    
    public func process<T>(command: Any!, completion: ((result: T?, error: ErrorType?) -> Void)?)  throws{
        
        let myCommand = command as! RegisterCommandProtocol
        
        let formData = NSDictionary(dictionary: [
            "email": myCommand.email,
            "pass": myCommand.password,
            "name": myCommand.name
            ])
        
        Meteor.call("registerUser", params: [formData]) { (result, error) -> () in
            
            if error != nil {
                completion?(result: nil,error: error)
                return
            }
            
            
            completion?(result: (result as! T?), error: nil)
        }
        
    }

}