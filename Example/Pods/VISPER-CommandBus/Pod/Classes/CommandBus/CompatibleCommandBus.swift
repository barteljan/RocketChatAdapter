//
//  CompatibleCommandBus.swift
//  Pods
//
//  Created by Jan Bartel on 25.02.16.
//
//

import Foundation


public class CompatibleCommandBus: CommandBus,CompatibleCommandBusProtocol {
    
    let CommandNotFoundErrorDomain = "CommandNotFoundErrorDomain"
    
    //just for objective c compatability
    public func process(command: AnyObject!, completion: ((result: AnyObject?, error: AnyObject?) -> Void)?){
        do{
            try super.process(command) { (myResult : AnyObject?, myError: ErrorType?) -> Void in
                if(myError != nil){
                    completion?(result: myResult, error: (myError as! AnyObject))
                }else{
                    completion?(result: myResult, error: nil)
                }
            }
        }catch let error {
            if(error is CommandHandlerNotFoundError){
                let myError = error as! CommandHandlerNotFoundError
                let nsError = self.nsErrorFor(myError)
                completion?(result: nil, error: nsError)
            }else{
                completion?(result: nil, error: (error as! AnyObject))
            }
        }
    }
    
    func nsErrorFor(myError:CommandHandlerNotFoundError) -> NSError{
        let userInfo : [NSObject : AnyObject] = [NSLocalizedDescriptionKey : "CommandHandler for command:" + String(myError.command) + " not found!"]
        let nsError = NSError(domain: self.CommandNotFoundErrorDomain, code: 2, userInfo: userInfo)
        return nsError
    }
    
    public func addHandler(handler:AnyObject){
        super.addHandler(handler as! CommandHandlerProtocol)
    }
    
    public func removeHandler(handler:AnyObject){
        super.removeHandler(handler as! CommandHandlerProtocol)
    }


}
