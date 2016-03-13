//
//  GetRoomCommandHandler.swift
//  Pods
//
//  Created by Jan Bartel on 12.03.16.
//
//

import Foundation

public class GetRoomIdCommandHandler: AbstractCommandHandler {
    
    public override func isResponsible(command: Any!) -> Bool {
        return command is GetRoomIdCommandProtocol
    }
    
    public override func process<T>(command: Any!, completion: ((result: T?, error: ErrorType?) -> Void)?)  throws{
        
        let myCommand = command as! GetRoomIdCommandProtocol
        
        meteorClient.callMethodName("getRoomIdByNameOrId", parameters: [myCommand.roomName]) { (response, error) -> Void in
            
            if error != nil {
                completion?(result: nil,error: error)
                return
            }
            
            let result = response!["result"] as? String
            
            if(result == nil){
                completion?(result:nil,error: RocketChatAdapterError.RequiredResponseFieldWasEmpty(field: "result",fileName: __FILE__,function: __FUNCTION__,line: __LINE__,column: __COLUMN__))
                return
            }
            
            completion?(result: (result as! T?), error: nil)
        }
        
    }

}
