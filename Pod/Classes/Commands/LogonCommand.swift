//
//  LogonCommand.swift
//  Pods
//
//  Created by Jan Bartel on 12.03.16.
//
//

import Foundation

public protocol LogonCommandProtocol{
    var userNameOrEmail : String {get}
    var password        : String {get}
}

public struct LogonCommand: LogonCommandProtocol {
    
    public let userNameOrEmail : String
    public let password        : String
    
}
