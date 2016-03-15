//
//  Message.swift
//  Pods
//
//  Created by Jan Bartel on 12.03.16.
//
//

import Foundation

public enum MessageType : String{
    case Default = "Default"
    case Deleted = "rm"
    case UserJoin = "uj"
    case UserLeave = "ul"
    case UserRemoved = "ru"
    case UserAdded = "au"
    case Command = "command"
    case UserMuted = "user-muted"
    case UserUnmuted = "user-unmuted"
    case NewModerator = "new-moderator"
    case ModeratorRemoved = "moderator-removed"
    case NewOwner = "new-owner"
    case OwnerRemoved = "owner-removed"
    case RoomRenamed = "r"
    case RoomChangedTopic = "room_changed_topic"
    case RoomChangedPrivacy = "room_changed_privacy"
    case MessagePinned = "message_pinned"
    static let allValues = [Default, Deleted, UserJoin,UserLeave,UserRemoved,UserAdded,Command,UserMuted,UserUnmuted,NewModerator,ModeratorRemoved,NewOwner,OwnerRemoved,RoomRenamed,RoomChangedTopic,RoomChangedPrivacy,MessagePinned]
}


public protocol MessageProtocol : Hashable{
    var messageId : String              {get}
    var message   : String              {get}
    var channelId : String              {get}
    var time      : Double              {get}
    var user      : UserProtocol        {get}
    var type      : MessageType         {get}
    var groupable : Bool                {get}
    var urls      : [String]?           {get}
    var parsedUrls: [[String:NSObject]]?{get}
    var editedAt  : Double?             {get}
    var editedBy  : UserProtocol?       {get}
    var attachments : [[String:AnyObject]]? {get}
    /*
    var expireAt  : Double?          {get}
    var mentionedUsers : [String]?   {get}
    var visitor   : VisitorProtocol? {get}
    var pinned    : Bool             {get}
    var pinnedAt  : Double?          {get}
    var pinnedBy  : UserProtocol?    {get}
    */
}


public struct Message: MessageProtocol{
    public let messageId : String
    public let message   : String
    public let channelId : String
    public let time      : Double
    public let user      : UserProtocol
    public let type      : MessageType  
    public let groupable : Bool
    public let urls      : [String]?
    public let parsedUrls: [[String:NSObject]]?
    public let editedAt  : Double?
    public let editedBy  : UserProtocol?  
    public let mentionedUsers : [UserProtocol]?
    public let attachments : [[String:AnyObject]]?
    
    public var hashValue : Int{
        get{
            return self.messageId.hashValue
        }
    }
  
    
    /*
    public let expireAt  : Double?

    public let visitor   : VisitorProtocol?
    public let pinned    : Bool
    public let pinnedAt  : Double?
    public let pinnedBy  : UserProtocol? 
    */
}

public func == (lhs: Message, rhs: Message) -> Bool {
    return lhs.messageId == rhs.messageId
}


