//
//  LeaveChannelCommand.swift
//  Pods
//
//  Created by Jan Bartel on 12.03.16.
//
//

import Foundation

public protocol LeaveChannelCommandProtocol{
    var channelId : String {get}
}

public struct LeaveChannelCommand : LeaveChannelCommandProtocol{
    public let channelId : String
}