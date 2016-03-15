//
//  SetUserNameCommand.swift
//  Pods
//
//  Created by Jan Bartel on 15.03.16.
//
//

import Foundation

public protocol SetUserNameCommandProtocol{
    var username : String {get}
}

public struct SetUserNameCommand : SetUserNameCommandProtocol{
    public let username : String
}