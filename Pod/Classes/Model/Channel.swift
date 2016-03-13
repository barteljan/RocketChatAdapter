//
//  Channel.swift
//  Pods
//
//  Created by Jan Bartel on 12.03.16.
//
//

import Foundation

public protocol ChannelProtocol{
    var channelId : String {get}
    var name : String {get}
}

public struct Channel : ChannelProtocol{
    public var channelId : String
    public var name : String
}

