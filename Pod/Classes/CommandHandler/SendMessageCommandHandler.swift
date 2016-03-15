//
//  SendMessageCommandHandler.swift
//  Pods
//
//  Created by Jan Bartel on 13.03.16.
//
//

import Foundation
import SwiftDDP
import VISPER_CommandBus

public class SendMessageCommandHandler: CommandHandlerProtocol {
    
    let parser : MessageParserProtocol
    
    public init(parser : MessageParserProtocol){
        self.parser = parser
    }
    
    public func isResponsible(command: Any!) -> Bool {
        return command is SendMessageCommandProtocol
    }
    
    public func process<T>(command: Any!, completion: ((result: T?, error: ErrorType?) -> Void)?)  throws{
        
        let myCommand = command as! SendMessageCommandProtocol
        
        var messageObject : [String : NSObject]
        messageObject = [
            "rid":myCommand.channelId,
            "msg":myCommand.message
        ]
        
        Meteor.call("sendMessage", params: [messageObject]) { (result, error) -> () in
            
            
            if error != nil {
                completion?(result: nil,error: error)
                return
            }
            
            if(result == nil){
                completion?(result:nil,error: RocketChatAdapterError.RequiredResponseFieldWasEmpty(field: "result",fileName: __FILE__,function: __FUNCTION__,line: __LINE__,column: __COLUMN__))
                return
            }
            
            print(result)
            
            let messageResult = self.parser.parseMessage(result as! [String:AnyObject])
        
            //completion?(result: (result as! T?), error: nil)
            completion?(result:(messageResult.message as! T), error: messageResult.error)
        }
        
    }
}
