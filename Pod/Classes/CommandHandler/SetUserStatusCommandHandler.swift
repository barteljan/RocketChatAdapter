//
//  SetUserStatusCommandHandler.swift
//  Pods
//
//  Created by Jan Bartel on 15.03.16.
//
//

import Foundation
import VISPER_CommandBus
import SwiftDDP

public class UserStatusCommandHandler : CommandHandlerProtocol{
    
    public func isResponsible(command: Any!) -> Bool {
        return command is SetUserStatusCommandProtocol
    }
    
    public func process<T>(command: Any!, completion: ((result: T?, error: ErrorType?) -> Void)?)  throws{
        
        let myCommand = command as! SetUserStatusCommandProtocol
        
        Meteor.call("UserPresence:setDefaultStatus", params: [myCommand.userStatus.rawValue]) { (result, error) -> () in
            
            if error != nil {
                completion?(result: nil,error: error)
                return
            }
            
            
            completion?(result: (result as! T?), error: nil)
        }
        
    }

    
    
}