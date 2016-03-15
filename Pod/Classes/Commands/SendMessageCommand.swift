//
//  SendMessageCommand.swift
//  Pods
//
//  Created by Jan Bartel on 13.03.16.
//
//

import Foundation

public protocol SendMessageCommandProtocol{
    var channelId : String {get}
    var message   : String {get}
}

public struct SendMessageCommand : SendMessageCommandProtocol{
    public let channelId : String
    public let message   : String
}