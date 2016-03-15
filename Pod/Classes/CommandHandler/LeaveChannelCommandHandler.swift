//
//  LeaveChannelCommandHandler.swift
//  Pods
//
//  Created by Jan Bartel on 12.03.16.
//
//

import Foundation
import SwiftDDP
import VISPER_CommandBus

public class LeaveChannelCommandHandler: CommandHandlerProtocol {
    public func isResponsible(command: Any!) -> Bool {
        return command is LeaveChannelCommandProtocol
    }
    
    public func process<T>(command: Any!, completion: ((result: T?, error: ErrorType?) -> Void)?)  throws{
        
        let myCommand = command as! LeaveChannelCommandProtocol
        
        Meteor.call("leaveRoom", params: [myCommand.channelId]) { (result, error) -> () in
            
            if error != nil {
                completion?(result: nil,error: error)
                return
            }
            
            completion?(result: (result as! T?), error: nil)
        }
        
    }
    
}
