//
//  IVISPERCommandHandler.swift
//  Pods
//
//  Created by Jan Bartel on 26.02.16.
//
//

import Foundation

@objc public protocol IVISPERCommandHandler  {
    

    func isResponsibleForCommand(command: NSObject) -> Bool
    
    func identifier() -> String
    
    func processCommand(command: NSObject, completion: ((String?, NSObject?, NSErrorPointer) -> Bool)?)
    
    
    optional func isResponsibleForCommand(command: NSObject,error:NSErrorPointer) -> Bool

}
