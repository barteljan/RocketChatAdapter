//
//  RegisterCommand.swift
//  Pods
//
//  Created by Jan Bartel on 15.03.16.
//
//

import Foundation

public protocol RegisterCommandProtocol{

    var email    : String {get}
    var name     : String {get}
    var password : String {get}

}

public struct RegisterCommand : RegisterCommandProtocol{
    public let email    : String
    public let name     : String
    public let password : String
}