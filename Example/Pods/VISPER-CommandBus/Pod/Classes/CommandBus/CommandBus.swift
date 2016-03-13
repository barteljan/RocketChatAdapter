//
//  CommandBus.swift
//  Pods
//
//  Created by Jan Bartel on 23.02.16.
//
//

import Foundation

public struct CommandHandlerNotFoundError: ErrorType{
    public let command : Any!
    
}

public class CommandBus: NSObject,CommandBusProtocol {
    

    internal var handlers = [CommandHandlerProtocol]()
    
    public func isResponsible(command: Any!) -> Bool{
       for commandHandler in self.handlers{
            if(commandHandler.isResponsible(command)){
                return true
            }
        }
        return false
    }
    
    
    public func process<ResultType>(command: Any!, completion: ((result: ResultType?, error: ErrorType?) -> Void)?) throws {

        var handlerFound = false;
        
        for commandHandler in self.handlers{
            if(commandHandler.isResponsible(command)){
                try commandHandler.process(command, completion: completion)
                handlerFound = true
            }
        }
        
        if(!handlerFound){
            throw CommandHandlerNotFoundError(command: command)
        }
        
    }
    
    public func addHandler(handler:CommandHandlerProtocol){
        
        let contained = self.handlers.contains { (aHandler:CommandHandlerProtocol) -> Bool in
            if(handler===aHandler){
                return true
            }
            return false
        }

        if(!contained){
            self.handlers.append(handler)
        }
    }
    
   
    
    public func removeHandler(handler:CommandHandlerProtocol){
    
        let index = self.handlers.indexOf { (aHandler:CommandHandlerProtocol) -> Bool in
            if(aHandler === handler){
                return true
            }
            return false
        }
        
        if let anIndex = index{
            self.handlers.removeAtIndex(anIndex)
        }

    }
     
    
     
    
      
}
