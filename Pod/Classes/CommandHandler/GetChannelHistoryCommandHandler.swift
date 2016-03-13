//
//  GetChannelHistoryCommandHandler.swift
//  Pods
//
//  Created by Jan Bartel on 12.03.16.
//
//

import Foundation

public class GetChannelHistoryCommandHandler: AbstractCommandHandler {
    
    public override func isResponsible(command: Any!) -> Bool {
        return command is GetChannelHistoryCommandProtocol
    }
    
    public override func process<T>(command: Any!, completion: ((result: T?, error: ErrorType?) -> Void)?)  throws{
        
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
        
        meteorClient.callMethodName("loadHistory", parameters: [myCommand.channelId,endFormData,myCommand.numberOfMessages,startFormData]) { (response, error) -> Void in
            
            if error != nil {
                completion?(result: nil,error: error)
                return
            }
            
            let result = response!["result"] as? [String:NSObject]?
            
            if let myResult = result{
                
                let respMessages : [[String : AnyObject]] = myResult!["messages"] as! [[String : AnyObject]]
                
                let unreadNotLoaded = myResult!["unreadNotLoaded"] as! Int
                
                var firstUnread : Int?
                firstUnread = myResult?["firstUnread"] as! Int?
                
                if(firstUnread == nil){
                    firstUnread = 0
                }
                
                let parsedMessages = self.parseMessages(respMessages)
                
                let messageResult = MessageHistoryResult(unreadNotLoaded:unreadNotLoaded,firstUnread:firstUnread!,messages: parsedMessages.messages!)
                
                completion?(result: (messageResult as! T), error: nil)
                return
                
            }else{
                completion?(result: nil,error: RocketChatAdapterError.ServerDidResponseWithEmptyResult(fileName: __FILE__, function: __FUNCTION__, line: __LINE__, column: __COLUMN__))
                return
            }
        }
        
    }
    
    func parseMessages(messages: [[String : AnyObject]]) -> (messages:[MessageProtocol]?,error:ErrorType?){
        let myMessages = messages.map { (messageDict:[String : AnyObject]) -> MessageProtocol in
            
            //parse base fields
            let messageId = messageDict["_id"] as! String
            let msg       = messageDict["msg"] as! String
            let channelId = messageDict["rid"] as! String
            
            //parse timestamp
            let timestamp = messageDict["ts"]?["$date"] as! Int?
            
            var time : Double
            if(timestamp != nil && timestamp!>0){
                 time = Double(timestamp!) / 1000
            }else{
                time = 0
            }
            
            //parse user
            let user = self.parseUser(messageDict["u"] as! [String : AnyObject])
            
            //a message is groupable if nothing else is said
            var groupable : Bool
            if(messageDict["groupable"] != nil && (messageDict["groupable"] as! Int) == 0){
                groupable = false
            }else{
                groupable = true
            }
            
            //get the type of the message, if nothing is said type will be .Default
            let type = self.messageType(messageDict["t"] as! String?)
            
            //rawUrls contains the parsed data of all urls appended to this message
            let parsedUrls : [[String:NSObject]]? = messageDict["urls"] as! [[String:NSObject]]?

            //urls contains the appended urls of this message as string
            var urls : [String]?
            if(parsedUrls != nil){
                urls = [String]()
                for parsedUrl in parsedUrls! {
                    let url = parsedUrl["url"] as! String
                    urls!.append(url)
                }
            }
            
            
            let message = Message(messageId: messageId,
                                    message: msg,
                                  channelId: channelId,
                                       time: time,
                                       user: user,
                                       type: type,
                                  groupable: groupable,
                                       urls: urls,
                                 parsedUrls:parsedUrls)
            
            return message
            
            
        }
        
        
        return (messages: myMessages, error : nil)
    }
    
    func parseUser(userDict: [String : AnyObject]) -> UserProtocol{
        let userId   = userDict["_id"] as! String
        let username = userDict["username"] as! String
        let user     = User(userId: userId, username: username)
        
        return user
    }
    
    func messageType(typeString: String?)-> MessageType{
        
        if(typeString == nil){
            return MessageType.Default
        }
    
        var messageType : MessageType?
        
        for type in MessageType.allValues{
            if(type.rawValue == typeString){
                messageType = type
                break
            }
        }
        
        if(messageType != nil){
            return messageType!
        }else{
            return MessageType.Default
        }
        
    }
}
