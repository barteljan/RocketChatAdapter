//
//  GetChannelHistoryCommandHandler.swift
//  Pods
//
//  Created by Jan Bartel on 12.03.16.
//
//

import Foundation
import SwiftDDP
import VISPER_CommandBus

public class GetChannelHistoryCommandHandler: CommandHandlerProtocol {
    
    let parser : MessageParserProtocol
    
    public init(parser : MessageParserProtocol){
        self.parser = parser
    }
    
    
    public func isResponsible(command: Any!) -> Bool {
        return command is GetChannelHistoryCommandProtocol
    }
    
    public func process<T>(command: Any!, completion: ((result: T?, error: ErrorType?) -> Void)?)  throws{
        
        let myCommand = command as! GetChannelHistoryCommandProtocol
        
        var startTimestamp : Int
        var endTimestamp   : Int
        
        if(myCommand.start != nil){
            startTimestamp = Int(myCommand.start!.timeIntervalSince1970 * 1000)
        }else {
            startTimestamp = 0
        }
        
        if(myCommand.end != nil){
            endTimestamp = Int(myCommand.end!.timeIntervalSince1970 * 1000)
        }else{
            endTimestamp = Int(NSDate().timeIntervalSince1970 * 1000)
        }
    
        
        let endFormData = NSDictionary(dictionary: [
            "$date": endTimestamp
        ])
        
        let startFormData = NSDictionary(dictionary: [
            "$date": startTimestamp
            ])
        
        Meteor.call("loadHistory", params: [myCommand.channelId,endFormData,myCommand.numberOfMessages,startFormData]) { (result, error) -> () in
            
            if error != nil {
                completion?(result: nil,error: error)
                return
            }
            
            if let myResult = result{
                
                let respMessages : [[String : AnyObject]] = myResult["messages"] as! [[String : AnyObject]]
                
                let unreadNotLoaded = myResult["unreadNotLoaded"] as! Int
                
                var firstUnread : Int?
                firstUnread = myResult["firstUnread"] as! Int?
                
                if(firstUnread == nil){
                    firstUnread = 0
                }
                
                let parsedMessages = self.parser.parseMessages(respMessages)
                
                let messageResult = MessageHistoryResult(unreadNotLoaded:unreadNotLoaded,firstUnread:firstUnread!,messages: parsedMessages.messages!)
                
                completion?(result: (messageResult as! T), error: nil)
                return
                
            }else{
                completion?(result: nil,error: RocketChatAdapterError.ServerDidResponseWithEmptyResult(fileName: __FILE__, function: __FUNCTION__, line: __LINE__, column: __COLUMN__))
                return
            }
        }
        
    }
    
   
}
