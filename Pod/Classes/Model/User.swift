//
//  User.swift
//  Pods
//
//  Created by Jan Bartel on 12.03.16.
//
//

import Foundation

public enum UserStatus : String{
    case Online  = "online"
    case Away    = "away"
    case Busy    = "busy"
    case Offline = "offline"
}

public protocol UserProtocol{
    var userId   : String {get}
    var username : String {get}
}

public struct User : UserProtocol{
    public let userId   : String
    public let username : String
}

