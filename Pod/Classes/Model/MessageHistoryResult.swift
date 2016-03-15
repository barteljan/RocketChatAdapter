//
//  MessageHistoryResult.swift
//  Pods
//
//  Created by Jan Bartel on 12.03.16.
//
//

import Foundation

public protocol MessageHistoryResultProtocol{
    var unreadNotLoaded : Int {get}
    var messages : [Message] {get}
}

public struct MessageHistoryResult : MessageHistoryResultProtocol{
    public let unreadNotLoaded : Int
    public let firstUnread : Int
    public let messages : [Message]
}