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
     * get all public channels
     **/
    func channelList(completion:((result: [ChannelProtocol]?,error: ErrorType?)->Void)?)
    
    /**
     * get a channels id by its name
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
    
    
}