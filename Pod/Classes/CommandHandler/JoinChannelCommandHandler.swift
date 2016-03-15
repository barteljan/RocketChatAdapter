//
//  JoinChannelCommandHandler.swift
//  Pods
//
//  Created by Jan Bartel on 12.03.16.
//
//

import Foundation
import SwiftDDP
import VISPER_CommandBus

public class JoinChannelCommandHandler: CommandHandlerProtocol {
    public func isResponsible(command: Any!) -> Bool {
        return command is JoinChannelCommandProtocol
    }
    
    public func process<T>(command: Any!, completion: ((result: T?, error: ErrorType?) -> Void)?)  throws{
        
        let myCommand = command as! JoinChannelCommandProtocol
        
        Meteor.call("joinRoom", params: [myCommand.channelId]) { (result, error) -> () in
        
            if error != nil {
                completion?(result: nil,error: error)
                return
            }
            

            completion?(result: (result as! T?), error: nil)
        }
        
    }

}
