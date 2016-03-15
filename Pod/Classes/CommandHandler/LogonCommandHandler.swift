//
//  LogonCommandHandler.swift
//  Pods
//
//  Created by Jan Bartel on 12.03.16.
//
//

import Foundation
import SwiftDDP
import VISPER_CommandBus


public class LogonCommandHandler: CommandHandlerProtocol {

    
    public func isResponsible(command: Any!) -> Bool {
        return command is LogonCommandProtocol
    }
    
    public func process<T>(command: Any!, completion: ((result: T?, error: ErrorType?) -> Void)?)  throws{
        
        let myCommand = command as! LogonCommandProtocol
        
        Meteor.loginWithPassword(myCommand.userNameOrEmail, password: myCommand.password) { (result, error) -> () in
            if(error != nil){
                completion?(result: nil,error: error!)
                return
            }
            
            if(result != nil){
                print(result)
                if(result == nil){
                    completion?(result:nil,error: RocketChatAdapterError.RequiredResponseFieldWasEmpty(field: "result",fileName: __FILE__,function: __FUNCTION__,line: __LINE__,column: __COLUMN__))
                    return
                }
                
                let userId = result?["id"] as! String?
                
                if(userId == nil){
                    completion?(result:nil,error: RocketChatAdapterError.RequiredResponseFieldWasEmpty(field: "id",fileName: __FILE__,function: __FUNCTION__,line: __LINE__,column: __COLUMN__))
                    return
                }
                
                let token  = result?["token"] as! String?
                if(token == nil){
                    completion?(result:nil,error: RocketChatAdapterError.RequiredResponseFieldWasEmpty(field: "token",fileName: __FILE__,function: __FUNCTION__,line: __LINE__,column: __COLUMN__))
                    return
                }
                
                let authorizationResult = AuthorizationResult(sessionToken: token!, userId: userId!)
                
                completion?(result: (authorizationResult as! T),error: nil)
                return
            }
            
            completion?(result: nil,error: RocketChatAdapterError.ServerDidResponseWithEmptyResult(fileName: __FILE__, function: __FUNCTION__, line: __LINE__, column: __COLUMN__))
        }
        
    }
}
