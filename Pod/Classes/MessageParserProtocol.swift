//
//  MessageParserProtocol.swift
//  Pods
//
//  Created by Jan Bartel on 15.03.16.
//
//

import Foundation

public protocol MessageParserProtocol{
        func parseMessages(messages: [[String : AnyObject]]) -> (messages:[Message]?,errors:[Message: ErrorType]?)
        func parseMessage(messageDict:[String : AnyObject]) -> (message:Message!,error:ErrorType?)
}