//
//  SetUserStatus.swift
//  Pods
//
//  Created by Jan Bartel on 15.03.16.
//
//

import Foundation

public protocol SetUserStatusCommandProtocol{
    var userStatus : UserStatus {get}
}

public struct SetUserStatusCommand : SetUserStatusCommandProtocol{
    public let userStatus : UserStatus
}