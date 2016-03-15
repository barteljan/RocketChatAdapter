//
//  JoinChannelCommand.swift
//  Pods
//
//  Created by Jan Bartel on 12.03.16.
//
//

import Foundation

public protocol JoinChannelCommandProtocol{
    var channelId : String {get}
}

public struct JoinChannelCommand : JoinChannelCommandProtocol{
    public let channelId : String
}