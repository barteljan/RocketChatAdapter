//
//  GetChannelsCommandHandler.swift
//  Pods
//
//  Created by Jan Bartel on 12.03.16.
//
//

import Foundation
import SwiftDDP
import VISPER_CommandBus

public class GetChannelsCommandHandler: CommandHandlerProtocol {
    
    public func isResponsible(command: Any!) -> Bool {
        return command is GetChannelsCommandProtocol
    }
    
    public func process<T>(command: Any!, completion: ((result: T?, error: ErrorType?) -> Void)?)  throws{
        
        Meteor.call("channelsList", params: nil) { (result, error) -> () in
            
            if error != nil {
                completion?(result: nil,error: error)
                return
            }
            
            if result != nil {
                
                let channels : [[String : String]]? = result!["channels"] as! [[String : String]]?
                
                if channels != nil{
                    
                    let resultArray = channels!.map({ (channelDict : [String : String]) -> ChannelProtocol in
                        let channelId = channelDict["_id"]
                        let name = channelDict["name"]
                        let channel = Channel(channelId: channelId! ,name : name!)
                        return channel
                    })
                    
                     completion?(result:(resultArray as! T),error:nil)
                }else{
                
                }
            }else{
                completion?(result: nil,error: RocketChatAdapterError.ServerDidResponseWithEmptyResult(fileName: __FILE__, function: __FUNCTION__, line: __LINE__, column: __COLUMN__))
                return
            }
        }
        
    }
}
