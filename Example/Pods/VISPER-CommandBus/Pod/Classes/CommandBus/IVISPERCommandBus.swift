//
//  IVISPERCommandBus.swift
//  Pods
//
//  Created by Jan Bartel on 26.02.16.
//
//

import Foundation

@objc public protocol IVISPERCommandBus : IVISPERCommandHandler {
    
    func addHandler(commandHandler: AnyObject!)
    func removeHandler(commandHandler: AnyObject!)
    
}
