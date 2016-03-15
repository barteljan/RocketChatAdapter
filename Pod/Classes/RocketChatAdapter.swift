//
//  RocketChatAdapter.swift
//  Pods
//
//  Created by Jan Bartel on 12.03.16.
//
//
import VISPER_CommandBus
import SwiftDDP
import XCGLogger

public enum RocketChatAdapterError : ErrorType {
    case ServerDidResponseWithEmptyResult(fileName:String,function: String,line: Int,column: Int)
    case RequiredResponseFieldWasEmpty(field:String,fileName:String,function: String,line: Int,column: Int)

}


public struct RocketChatAdapter : RocketChatAdapterProtocol{
    
    let commandBus : CommandBusProtocol
    let endPoint : String
    
    /**
    * initialiser
    **/
    public init(endPoint:String){
        self.init(endPoint:endPoint,commandBus: nil)
    }
    
    
    
    public init(endPoint:String,commandBus: CommandBusProtocol?){
        self.endPoint   = endPoint
        
        if(commandBus != nil){
            self.commandBus = commandBus!
        }else{
            self.commandBus = CommandBus()
        }
    }
    
    public func connect(endpoint:String,callback:(() -> ())?){
        Meteor.client.allowSelfSignedSSL = true   
        Meteor.client.logLevel = .Info
        Meteor.connect(endpoint,callback: callback)
    }
    
    
    /**
    * Logon
    **/
    public func logon(userNameOrEmail: String, password: String, completion:((result: AuthorizationResultProtocol?,error:ErrorType?)->Void)?){
        
        let command = LogonCommand(userNameOrEmail:userNameOrEmail,password: password)
        
        if(!self.commandBus.isResponsible(command)){
            self.commandBus.addHandler(LogonCommandHandler())
        }
        
        try! self.commandBus.process(command) { (result: AuthorizationResultProtocol?, error: ErrorType?) -> Void in
            completion?(result:result,error: error)
        }
        
    }
    
    /**
    * get all public channels
    **/
    public func channelList(completion:((result: [ChannelProtocol]?,error: ErrorType?)->Void)?){
        
        let command = GetChannelsCommand()
        
        if(!self.commandBus.isResponsible(command)){
            self.commandBus.addHandler(GetChannelsCommandHandler())
        }
        
        try! self.commandBus.process(command) { (result: [ChannelProtocol]?, error: ErrorType?) -> Void in
            completion?(result: result, error: error)
        }
    }
    
    /**
     * get a channels id by its name
     */
    public func getChannelId(name:String, completion:((roomId:String?, error: ErrorType?)->Void)?){
        
        let command = GetRoomIdCommand(roomName: name)
        
        if(!self.commandBus.isResponsible(command)){
            self.commandBus.addHandler(GetRoomIdCommandHandler())
        }
        
        try! self.commandBus.process(command) { (result: String?, error: ErrorType?) -> Void in
            completion?(roomId: result, error: error)
        }
    }
    
    /**
     * Join a channel
     **/
    public func joinChannel(channelId: String,completion:((error:ErrorType?)->Void)?){
        
        
        let command = JoinChannelCommand(channelId: channelId)
        
        if(!self.commandBus.isResponsible(command)){
            self.commandBus.addHandler(JoinChannelCommandHandler())
        }
        
        
        try! self.commandBus.process(command) { (result: Any?, error: ErrorType?) -> Void in
            completion?(error: error)
        }
    }
    
    
    /**
     * Leave a channel
     **/
    public func leaveChannel(channelId: String,completion:((error:ErrorType?)->Void)?){
        
        let command = LeaveChannelCommand(channelId: channelId)
        
        if(!self.commandBus.isResponsible(command)){
            self.commandBus.addHandler(LeaveChannelCommandHandler())
        }
        
        
        try! self.commandBus.process(command) { (result: Any?, error: ErrorType?) -> Void in
            completion?(error: error)
        }
    
    }
    
    
    public func channelMessages(channelId : String, numberOfMessages:Int, start: NSDate?, end: NSDate?, completion: ((result: MessageHistoryResultProtocol?, error: ErrorType?)->Void)?){
        
        
        let command = GetChannelHistoryCommand(channelId: channelId,numberOfMessages: numberOfMessages,start: start, end: end)
        
        if(!self.commandBus.isResponsible(command)){
            self.commandBus.addHandler(GetChannelHistoryCommandHandler(parser: MessageParser()))
        }
        
        
        try! self.commandBus.process(command) { (result: MessageHistoryResult?, error: ErrorType?) -> Void in
            completion?(result: result,error: error)
        }
    }
    
    
    public func sendMessage(channelId : String,message: String, completion: ((result: Message?, error: ErrorType?) -> Void)?){
        
        let command = SendMessageCommand(channelId: channelId, message: message)
        
        if(!self.commandBus.isResponsible(command)){
            self.commandBus.addHandler(SendMessageCommandHandler(parser:MessageParser()))
        }
        
        
        try! self.commandBus.process(command) { (result: Message?, error: ErrorType?) -> Void in
            completion?(result: result,error: error)
        }
    
    }


}
