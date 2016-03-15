//
//  GetUserNameSuggestionCommandHandler.swift
//  Pods
//
//  Created by Jan Bartel on 15.03.16.
//
//

import Foundation
import VISPER_CommandBus
import SwiftDDP

public class GetUserNameSuggestionCommandHandler : CommandHandlerProtocol{
    
    public func isResponsible(command: Any!) -> Bool {
        return command is GetUserNameSuggestionCommandProtocol
    }
    
    public func process<T>(command: Any!, completion: ((result: T?, error: ErrorType?) -> Void)?)  throws{
        
        Meteor.call("getUsernameSuggestion", params: nil) { (result, error) -> () in
            
            if error != nil {
                completion?(result: nil,error: error)
                return
            }
            
            
            completion?(result: (result as! T?), error: nil)
        }
        
    }

    
}