//
//  RocketChatAdapter.swift
//  Pods
//
//  Created by Jan Bartel on 12.03.16.
//
//
import SocketRocket
import M13OrderedDictionary
import ObjectiveDDP
import VISPER_CommandBus

public enum RocketChatAdapterError : ErrorType {
    case ServerDidResponseWithEmptyResult(fileName:String,function: String,line: Int,column: Int)
    case RequiredResponseFieldWasEmpty(field:String,fileName:String,function: String,line: Int,column: Int)

}


public struct RocketChatAdapter : RocketChatAdapterProtocol{
    
    let commandBus : CommandBusProtocol
    let meteorClient : MeteorClient
    let ddpVersion  : String
    let endPoint : String
    
    /**
    * initialiser
    **/
    public init(ddpVersion: String,endPoint:String){
        self.init(ddpVersion: ddpVersion,endPoint:endPoint,commandBus: nil)
    }
    
    public init(meteorClient : MeteorClient){
        self.init(meteorClient: meteorClient,commandBus: nil)
    }
    
    public init(meteorClient : MeteorClient,commandBus: CommandBusProtocol?){
        
        if(commandBus != nil){
            self.commandBus = commandBus!
        }else{
            self.commandBus = CommandBus()
        }
        
        self.ddpVersion   = meteorClient.ddpVersion
        self.endPoint     = meteorClient.ddp.urlString
        self.meteorClient = meteorClient
    }
    
    public init(ddpVersion: String,endPoint:String,commandBus: CommandBusProtocol?){
        self.ddpVersion = ddpVersion
        self.endPoint   = endPoint
        
        if(commandBus != nil){
            self.commandBus = commandBus!
        }else{
            self.commandBus = CommandBus()
        }
        
        let client = MeteorClient(DDPVersion: ddpVersion)
        let ddp    = ObjectiveDDP(URLString: endPoint, delegate: client)
        client.ddp = ddp
        client.ddp.connectWebSocket()
        self.meteorClient = client
    }
    
    
    /**
    * Logon
    **/
    public func logon(userNameOrEmail: String, password: String, completion:((result: AuthorizationResultProtocol?,error:ErrorType?)->Void)?){
        
        let command = LogonCommand(userNameOrEmail:userNameOrEmail,password: password)
        
        if(!self.commandBus.isResponsible(command)){
            self.commandBus.addHandler(LogonCommandHandler((meteorClient : self.meteorClient)))
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
            self.commandBus.addHandler(GetChannelsCommandHandler((meteorClient : self.meteorClient)))
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
            self.commandBus.addHandler(GetRoomIdCommandHandler((meteorClient : self.meteorClient)))
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
            self.commandBus.addHandler(JoinChannelCommandHandler((meteorClient : self.meteorClient)))
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
            self.commandBus.addHandler(LeaveChannelCommandHandler((meteorClient : self.meteorClient)))
        }
        
        
        try! self.commandBus.process(command) { (result: Any?, error: ErrorType?) -> Void in
            completion?(error: error)
        }
    
    }
    
    
    public func channelMessages(channelId : String, numberOfMessages:Int, start: NSDate?, end: NSDate?, completion: ((result: MessageHistoryResultProtocol?, error: ErrorType?)->Void)?){
        
        
        let command = GetChannelHistoryCommand(channelId: channelId,numberOfMessages: numberOfMessages,start: start, end: end)
        
        if(!self.commandBus.isResponsible(command)){
            self.commandBus.addHandler(GetChannelHistoryCommandHandler((meteorClient : self.meteorClient)))
        }
        
        
        try! self.commandBus.process(command) { (result: MessageHistoryResult?, error: ErrorType?) -> Void in
            completion?(result: result,error: error)
        }
    }
    
    
    public func sendMessage(channelId : String,message: String){
        
        let command = SendMessageCommand(channelId: channelId, message: message)
        
        if(!self.commandBus.isResponsible(command)){
            self.commandBus.addHandler(SendMessageCommandHandler((meteorClient : self.meteorClient)))
        }
        
        
        try! self.commandBus.process(command) { (result: MessageHistoryResult?, error: ErrorType?) -> Void in
            //completion?(result: result,error: error)
        }
    
    }


}
