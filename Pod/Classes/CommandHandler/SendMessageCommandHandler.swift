//
//  SendMessageCommandHandler.swift
//  Pods
//
//  Created by Jan Bartel on 13.03.16.
//
//

import Foundation

public class SendMessageCommandHandler: AbstractCommandHandler {
    public override func isResponsible(command: Any!) -> Bool {
        return command is SendMessageCommandProtocol
    }
    
    public override func process<T>(command: Any!, completion: ((result: T?, error: ErrorType?) -> Void)?)  throws{
        
        let myCommand = command as! SendMessageCommandProtocol
        
        var messageObject : [String : NSObject]
        messageObject = [
            "rid":myCommand.channelId,
            "msg":myCommand.message
        ]
        
        meteorClient.callMethodName("sendMessage", parameters: [messageObject]) { (response, error) -> Void in
            
            print(response)
            
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
