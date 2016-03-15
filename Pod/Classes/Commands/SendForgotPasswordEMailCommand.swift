//
//  SendForgotPasswordEMailCommand.swift
//  Pods
//
//  Created by Jan Bartel on 15.03.16.
//
//

import Foundation

public protocol SendForgotPasswordEMailCommandProtocol{
    var userNameOrMail : String {get}
}

public struct SendForgotPasswordEMailCommand : SendForgotPasswordEMailCommandProtocol{
    public let userNameOrMail : String
}