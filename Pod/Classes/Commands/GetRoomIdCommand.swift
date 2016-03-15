//
//  GetRoomCommand.swift
//  Pods
//
//  Created by Jan Bartel on 12.03.16.
//
//

import Foundation

public protocol GetRoomIdCommandProtocol{
    var roomName : String {get}
}

public struct GetRoomIdCommand : GetRoomIdCommandProtocol{
    public var roomName : String
}