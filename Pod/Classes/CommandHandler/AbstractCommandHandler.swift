//
//  BaseCommandHandler.swift
//  Pods
//
//  Created by Jan Bartel on 12.03.16.
//
//

import Foundation
import VISPER_CommandBus
import ObjectiveDDP

public class AbstractCommandHandler: CommandHandlerProtocol {

    let meteorClient : MeteorClient
    
    public init(meteorClient : MeteorClient){
        self.meteorClient = meteorClient
    }
    
    public func isResponsible(command: Any!) -> Bool {
        fatalError("please implement isResponsible in your subclass")
    }
    
    
    public func process<T>(command: Any!, completion: ((result: T?, error: ErrorType?) -> Void)?)  throws{
        fatalError("please implement process<T> in your subclass")
    }
    
}
