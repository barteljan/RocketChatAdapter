//
//  Visitor.swift
//  Pods
//
//  Created by Jan Bartel on 12.03.16.
//
//

import Foundation

public protocol VisitorProtocol{
    var visitorId : String {get}
    var name      : String {get}
    var email     : String?{get}
    var phone     : String?{get}
    var token     : String?{get}
}