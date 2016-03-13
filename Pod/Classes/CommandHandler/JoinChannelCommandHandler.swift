//
//  JoinChannelCommandHandler.swift
//  Pods
//
//  Created by Jan Bartel on 12.03.16.
//
//

import Foundation

public class JoinChannelCommandHandler: AbstractCommandHandler {
    public override func isResponsible(command: Any!) -> Bool {
        return command is JoinChannelCommandProtocol
    }
    
    public override func process<T>(command: Any!, completion: ((result: T?, error: ErrorType?) -> Void)?)  throws{
        
        let myCommand = command as! JoinChannelCommandProtocol
        
        meteorClient.callMethodName("joinRoom", parameters: [myCommand.channelId]) { (response, error) -> Void in
            
            if error != nil {
                completion?(result: nil,error: error)
                return
            }
            
            let result = response!["result"] as? String
            
            completion?(result: (result as! T?), error: nil)
        }
        
    }

}
