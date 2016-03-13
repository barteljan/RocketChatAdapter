//
//  LogonCommandHandler.swift
//  Pods
//
//  Created by Jan Bartel on 12.03.16.
//
//

import Foundation



public class LogonCommandHandler: AbstractCommandHandler {

    
    public override func isResponsible(command: Any!) -> Bool {
        return command is LogonCommandProtocol
    }
    
    public override func process<T>(command: Any!, completion: ((result: T?, error: ErrorType?) -> Void)?)  throws{
        
        let myCommand = command as! LogonCommandProtocol
        
        self.meteorClient.logonWithUsernameOrEmail(myCommand.userNameOrEmail, password: myCommand.password) { (result: [NSObject:AnyObject]?, error: NSError?) -> Void in
            
            if(error != nil){
                completion?(result: nil,error: error!)
                return
            }
            
            if(result != nil){
                let res    = result!["result"] as? NSDictionary
                
                if(res == nil){
                    completion?(result:nil,error: RocketChatAdapterError.RequiredResponseFieldWasEmpty(field: "result",fileName: __FILE__,function: __FUNCTION__,line: __LINE__,column: __COLUMN__))
                    return
                }
                
                let userId = res?["id"] as! String?
                
                if(userId == nil){
                    completion?(result:nil,error: RocketChatAdapterError.RequiredResponseFieldWasEmpty(field: "id",fileName: __FILE__,function: __FUNCTION__,line: __LINE__,column: __COLUMN__))
                    return
                }
                
                let token  = res?["token"] as! String?
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
