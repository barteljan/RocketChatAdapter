//
//  GetChannelHistoryCommand.swift
//  Pods
//
//  Created by Jan Bartel on 12.03.16.
//
//

import Foundation

public protocol GetChannelHistoryCommandProtocol{
    var channelId : String {get}
    var numberOfMessages:Int {get}
    var start:NSDate? {get}
    var end:NSDate?{get}
}


public struct GetChannelHistoryCommand : GetChannelHistoryCommandProtocol{
    public let channelId : String
    public let numberOfMessages:Int
    public let start:NSDate?
    public let end:NSDate?
}