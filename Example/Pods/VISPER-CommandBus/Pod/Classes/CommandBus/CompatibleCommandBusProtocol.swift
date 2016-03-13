//
//  CompatibleCommandBusProtocol.swift
//  Pods
//
//  Created by Jan Bartel on 25.02.16.
//
//

import Foundation

public protocol CompatibleCommandBusProtocol{

    // added for objective c compatibility
    func addHandler(handler:AnyObject)
    func removeHandler(handler:AnyObject)
    func process(command: AnyObject!, completion: ((result: AnyObject?, error: AnyObject?) -> Void)?)
    
   
    
}