//
//  User.swift
//  Pods
//
//  Created by Jan Bartel on 12.03.16.
//
//

import Foundation

public protocol UserProtocol{
    var userId   : String {get}
    var username : String {get}
}

public struct User : UserProtocol{
    public let userId   : String
    public let username : String
}

