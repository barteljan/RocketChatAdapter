//
//  CommandHandlerProtocol.swift
//  Pods
//
//  Created by Bartel on 20.02.16.
//
//

import Foundation

public protocol CommandHandlerProtocol : class{
    func isResponsible(command: Any!) -> Bool
    
    func process(command: Any!) throws
    func process(command: Any!, completion: ((result: Any?, error: ErrorType?) -> Void)?) throws
    func process<T>(command: Any!, completion: ((result: T?, error: ErrorType?) -> Void)?) throws
    
}

public extension CommandHandlerProtocol{
    
    public  func process(command: Any!) throws{
        try self.process(command) { (myResult : AnyObject?, myError: ErrorType?) -> Void in}
    }
    
    public func process<T>(command: Any!, completion: ((result: T?, error: ErrorType?) -> Void)?)  throws{
        
        let myCompletion = completion
        
        try self.process(command) { (result, error) -> Void in
            myCompletion?(result:(result as! T?),error: error)
        }
        
    }
}