//
//  VCommandBus.swift
//  Pods
//
//  Created by Jan Bartel on 25.02.16.
//
//

import Foundation

 @objc public class VISPERCommandBus: CompatibleCommandBus,IVISPERCommandBus {

    internal var _strictMode : Bool = false
    
    public func isInStrictMode() -> Bool{
        return self._strictMode
    }
    
    public func setStrictMode(isInStrictMode: Bool){
        self._strictMode = isInStrictMode
    }
    
    var _identifier = String(self)
    
    var commandHandlers = [IVISPERCommandHandler]()
    
    
    public func isResponsibleForCommand(command: NSObject) -> Bool{
        if(super.isResponsible(command)){
            return true
        }
        
        return false
    }
    
    public func identifier() -> String{
        return self._identifier
    }
    
    public func processCommand(command: NSObject, completion: ((String?, NSObject?, NSErrorPointer) -> Bool)?){
        
        var handlerFound = false
        
        for handler in self.commandHandlers{
            if(handler.isResponsibleForCommand(command)){
                handler.processCommand(command, completion:completion)
                handlerFound = true
            }
        }
        
        super.process(command) { (result: AnyObject?, error: AnyObject?) -> Void in
            if(self.isCommandNotFoundError(error) && self.isInStrictMode() && !handlerFound){
                fatalError(String(error!))
            }else if(self.isCommandNotFoundError(error) && !handlerFound){
                completion?(self.identifier(),(error as! NSObject?),nil)
            }else if(self.isCommandNotFoundError(error) && handlerFound){

            }else if(error != nil && !self.isCommandNotFoundError(error)){
                completion?(self.identifier(),(error as! NSObject?),nil)
            }else{
                completion?(self.identifier(),(result as! NSObject?),nil)
            }
        }
    }
    
    func isCommandNotFoundError(error: Any?) -> Bool{
        if(error != nil){
            if let nserror = error as? NSError {
                if(nserror.domain == self.CommandNotFoundErrorDomain && self.isInStrictMode()){
                    return true
                }
            }
        }
        return false
    }
    
    
    public override func process<ResultType>(command: Any!, completion: ((result: ResultType?, error: ErrorType?) -> Void)?) throws {
        
        let myCompletion = completion
        var handlerFound = false
        
        do{
            try super.process(command, completion: completion)
            handlerFound = true
        }catch let anError{
            if(!self.isCommandNotFoundError(anError)){
                completion?(result: nil,error: anError)
            }
        }
        
        
        if let myCommand = command as? NSObject{
            for handler in self.commandHandlers{
                if(handler.isResponsibleForCommand(myCommand)){
                    handler.processCommand(myCommand, completion: { (identifier: String?, myResult: NSObject?, myError: NSErrorPointer) -> Bool in
                        
                        if(myError != nil){
                            let realError : NSError = myError.memory!
                            myCompletion?(result: (myResult as! ResultType?),error: realError)
                        }else{
                            myCompletion?(result: (myResult as! ResultType?),error: nil)
                        }
                        
                        return true
                        
                    })
                    handlerFound = true
                }
            }
        }
        
        if(!handlerFound){
            let swiftError = CommandHandlerNotFoundError(command: command)
            let nsError = self.nsErrorFor(swiftError)
            if(self.isInStrictMode()){
                fatalError(String(nsError))
            }else{
                throw swiftError
            }
        }
    }
    
    public override func process(command: AnyObject!, completion: ((result: AnyObject?, error: AnyObject?) -> Void)?) {
        super.process(command) { (result, error) -> Void in
            if(self.isCommandNotFoundError(error) && self.isInStrictMode()){
                fatalError(String(error))
            }else{
                completion?(result: result,error: error)
            }
        }
    }

    
    public override func addHandler(handler: AnyObject) {
        if(handler is IVISPERCommandHandler){
            self.commandHandlers.append(handler as! IVISPERCommandHandler)
        }else if(handler is CommandHandlerProtocol){
            super.addHandler(handler)
        }else{
            fatalError("handler should conform to protocol IVISPERCommandHandler or CommandHandlerProtocol")
        }
        
    }
    
    public override func removeHandler(handler: AnyObject) {
        let index = self.commandHandlers.indexOf { (aHandler:IVISPERCommandHandler) -> Bool in
            if(aHandler === handler){
                return true
            }
            return false
        }
        
        if let anIndex = index{
            self.commandHandlers.removeAtIndex(anIndex)
        }
    }
    

}

