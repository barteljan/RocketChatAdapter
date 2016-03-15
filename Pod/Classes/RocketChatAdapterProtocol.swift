//
//  RocketChatAdapterProtocol.swift
//  Pods
//
//  Created by Jan Bartel on 12.03.16.
//
//

import Foundation

public protocol RocketChatAdapterProtocol{
    
    /**
     * Logon
     **/
    func logon(userNameOrEmail: String, password: String, completion:((result: AuthorizationResultProtocol?,error:ErrorType?)->Void)?)
    
    /**
     * Get all public channels
     **/
    func channelList(completion:((result: [ChannelProtocol]?,error: ErrorType?)->Void)?)
    
    /**
     * Get a channels id by its name
     */
    func getChannelId(name:String, completion:((roomId:String?, error: ErrorType?)->Void)?)
    
    /**
     * Join a channel
     **/
    func joinChannel(channelId: String,completion:((error:ErrorType?)->Void)?)
    
    /**
     * Leave a channel
     **/
    func leaveChannel(channelId: String,completion:((error:ErrorType?)->Void)?)
    
    /**
     * Get messages from channel
     **/
    func channelMessages(channelId : String, numberOfMessages:Int, start: NSDate?, end: NSDate?, completion: ((result: MessageHistoryResultProtocol?, error: ErrorType?)->Void)?)
    
    /**
     * Send a message
     **/
    func sendMessage(channelId : String,message: String, completion: ((result: Message?, error: ErrorType?) -> Void)?)
}