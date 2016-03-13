//
//  AuthorizationResult.swift
//  Pods
//
//  Created by Jan Bartel on 12.03.16.
//
//

import Foundation

public protocol AuthorizationResultProtocol{
    var sessionToken : String{get}
    var userId       : String{get}
}

public struct AuthorizationResult : AuthorizationResultProtocol{
    public let sessionToken : String
    public let userId       : String
}