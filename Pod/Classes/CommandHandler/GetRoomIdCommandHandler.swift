//
//  GetRoomCommandHandler.swift
//  Pods
//
//  Created by Jan Bartel on 12.03.16.
//
//

import Foundation
import SwiftDDP
import VISPER_CommandBus

public class GetRoomIdCommandHandler: CommandHandlerProtocol {
    
    public func isResponsible(command: Any!) -> Bool {
        return command is GetRoomIdCommandProtocol
    }
    
    public func process<T>(command: Any!, completion: ((result: T?, error: ErrorType?) -> Void)?)  throws{
        
        let myCommand = command as! GetRoomIdCommandProtocol
        
         Meteor.call("getRoomIdByNameOrId", params:  [myCommand.roomName]) { (result, error) -> () in
            
            if error != nil {
                completion?(result: nil,error: error)
                return
            }
            
            if(result == nil){
                completion?(result:nil,error: RocketChatAdapterError.RequiredResponseFieldWasEmpty(field: "result",fileName: __FILE__,function: __FUNCTION__,line: __LINE__,column: __COLUMN__))
                return
            }
            
            completion?(result: (result as! T?), error: nil)
        }
        
    }

}
