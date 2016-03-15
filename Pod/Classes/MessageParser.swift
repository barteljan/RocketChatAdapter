//
//  MessageParser.swift
//  Pods
//
//  Created by Jan Bartel on 15.03.16.
//
//

import Foundation

public struct MessageParser : MessageParserProtocol{

    public func parseMessages(messages: [[String : AnyObject]]) -> (messages:[Message]?,errors:[Message: ErrorType]?){
        
        var errorMap = [Message : ErrorType]()
        
        let myMessages = messages.map { (messageDict:[String : AnyObject]) -> Message in
            let messageResult =  self.parseMessage(messageDict)
            if(messageResult.error != nil){
                errorMap[messageResult.message] = messageResult.error!
            }
            return messageResult.message
        }
        
        
        if(errorMap.count > 0){
            return (messages: myMessages, errors : errorMap)
        }
    
        return (messages: myMessages, errors : nil)
    }
    
    public func parseMessage(messageDict:[String : AnyObject]) -> (message:Message!,error:ErrorType?){
        
        print(messageDict)
        
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
        
        //check edited state
        let editedAtTime = messageDict["editedAt"]?["$date"] as? Double?
        var editedAt : Double?
        
        if(editedAtTime != nil){
            editedAt = editedAtTime!!/1000.0
        }
        
        var editedBy : UserProtocol?
        let editedByDict = messageDict["editedBy?"] as? [String:AnyObject]
        if(editedByDict != nil){
            editedBy = self.parseUser(editedByDict!)
        }
        
        //check mentioned users
        let mentionedUsersArray = messageDict["mentions"] as? [[String:AnyObject]]
        var mentionedUsers : [UserProtocol]?
        if(mentionedUsersArray != nil){
            mentionedUsers = [UserProtocol]()
            for userDict in mentionedUsersArray!{
                mentionedUsers?.append(self.parseUser(userDict))
            }
        }
        
        let attachments = messageDict["attachments"]
        let message = Message(messageId: messageId,
            message: msg,
            channelId: channelId,
            time: time,
            user: user,
            type: type,
            groupable: groupable,
            urls: urls,
            parsedUrls:parsedUrls,
            editedAt: editedAt,
            editedBy: editedBy,
            mentionedUsers: mentionedUsers,
            attachments: attachments as! [[String:AnyObject]]?)
        
        return (message: message, error: nil)
    }
    
    
    public func parseUser(userDict: [String : AnyObject]) -> UserProtocol{
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