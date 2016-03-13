//
//  TestViewController.swift
//  RocketChatAdapter
//
//  Created by Jan Bartel on 12.03.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import RocketChatAdapter

enum FieldKeys : String{
    case Server   = "Server"
    case Username = "Username"
    case Password = "Password"
    case LoginToken = "LoginToken"
    case UserId = "UserId"
    case Channel = "Channel"

}


class TestViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var serverField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var channelField: UITextField!
    
    @IBOutlet weak var tokenLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    
    
    
    
    var loginToken : String?{
        get{
            let token : String? = NSUserDefaults.standardUserDefaults().objectForKey(FieldKeys.LoginToken.rawValue) as! String?
            self.updateTokenText(token)
            return token
        }
        set{
            let token = newValue
            self.updateTokenText(token)
            NSUserDefaults.standardUserDefaults().setObject(token, forKey: FieldKeys.LoginToken.rawValue)
        }
    }
    
    var userId : String?{
        get{
            let userId : String? = NSUserDefaults.standardUserDefaults().objectForKey(FieldKeys.UserId.rawValue) as! String?
            self.updateUserIdText(userId)
            return userId
        }
        set{
            let userId = newValue
            self.updateUserIdText(userId)
            NSUserDefaults.standardUserDefaults().setObject(userId, forKey: FieldKeys.UserId.rawValue)
        }
    }
    
    
    var adapter : RocketChatAdapter?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.serverField.delegate   = self
        self.usernameField.delegate = self
        self.passwordField.delegate = self
        self.channelField.delegate  = self
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if(defaults.objectForKey(FieldKeys.Server.rawValue) != nil){
            self.serverField.text = defaults.objectForKey(FieldKeys.Server.rawValue) as! String?
        }
        
        if(defaults.objectForKey(FieldKeys.Username.rawValue) != nil){
            self.usernameField.text = defaults.objectForKey(FieldKeys.Username.rawValue) as! String?
        }
        
        if(defaults.objectForKey(FieldKeys.Password.rawValue) != nil){
            self.passwordField.text = defaults.objectForKey(FieldKeys.Password.rawValue) as! String?
        }
        
        if(defaults.objectForKey(FieldKeys.Channel.rawValue) != nil){
            self.channelField.text = defaults.objectForKey(FieldKeys.Channel.rawValue) as! String?
        }
        
        print("Token:\(self.loginToken)")
        print("ClientId:\(self.userId)")
        
        
    }

    @IBAction func connectAction(sender: AnyObject) {
        if(self.serverField.text?.characters.count > 0){
            self.adapter = RocketChatAdapter(ddpVersion: "pre2", endPoint: self.serverField.text!)
        }else{
            let alert = UIAlertView(title: "Error", message: "Please enter a valid server", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK")
            alert.show()
        }
    }
    
    func checkConnection()->Bool{
        if(self.adapter == nil){
            let alert = UIAlertView(title: "Error", message: "Please connect first!", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK")
            alert.show()
            return false
        }else{
            return true
        }
    }

    
    @IBAction func loginAction(sender: AnyObject) {
        
        if(checkConnection()){
            
            if(self.usernameField.text == nil){
                let alert = UIAlertView(title: "Error", message: "Please enter username!", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK")
                alert.show()
                return
            }
            
            if(self.passwordField.text == nil){
                let alert = UIAlertView(title: "Error", message: "Please enter password!", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK")
                alert.show()
                return
            }
            
            self.adapter?.logon(self.usernameField.text!,
                password: self.passwordField.text!, completion: { (result, error) -> Void in
                    if(error == nil && result != nil){
                        self.loginToken = result!.sessionToken
                        self.userId = result!.userId
                        print("sessionToken: \(result!.sessionToken) userId:\(result!.userId)")
                    }else{
                        print("error:\(String(error))")
                    }
            })
        
        }
        
    }
   

    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        self.saveValues(textField)
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        self.saveValues(textField)
        return true
    }
    
    func saveValues(textField: UITextField){
    
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let value = (textField.text != nil) ? textField.text : ""
        
        switch(textField){
        case self.serverField:
            defaults.setObject(value, forKey: FieldKeys.Server.rawValue)
            break
        case self.usernameField:
            defaults.setObject(value, forKey: FieldKeys.Username.rawValue)
            break
        case self.passwordField:
            defaults.setObject(value, forKey: FieldKeys.Password.rawValue)
            break
        case self.channelField:
            defaults.setObject(value, forKey: FieldKeys.Channel.rawValue)
            break
        default:
            break
        }
        
        defaults.synchronize()
        

    }
    
    func updateTokenText(text: String?){
        
        var labelText = "Token: "
        
        if(text != nil){
            labelText += text!
        }
        
        self.tokenLabel.text = labelText
    }
    
    func updateUserIdText(text: String?){
        
        var labelText = "UserId: "
        
        if(text != nil){
            labelText += text!
        }
        
        self.userIdLabel.text = labelText
    }

    
    @IBAction func channelListAction(sender: AnyObject) {
        if(checkConnection()){
            self.adapter?.channelList({ (result, error) -> Void in
                if error != nil {
                    print(String(error))
                    return
                }
                
                if(result != nil){
                    for channel in result!{
                        print("Channel: \(channel.name) id:\(channel.channelId)")
                    }
                }
            })
        }
    }
    
    @IBAction func joinChannel(sender: AnyObject) {
        if(checkConnection()){
            
            let channel = self.channelField.text
            
            if channel == nil{
                let alert = UIAlertView(title: "Error", message: "Please enter a channel name!", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK")
                alert.show()
                return
            }
            
            self.adapter?.getChannelId(channel!, completion: { (roomId, error) -> Void in
                print("Die Channel-Id ist:\(roomId)")
                
                if(roomId == nil){
                    print("Der Channel \(channel) existiert nicht")
                    return
                }
                
                self.adapter?.joinChannel(roomId!, completion: { (error) -> Void in
                    
                    if(error == nil){
                        print("\(channel) erfolgreich abonniert")
                    }else{
                        print("\(channel) konnte nicht abonniert werden. \(String(error))")
                    }
                })
                
            })
        
        }
    }

    @IBAction func leaveChannel(sender: AnyObject) {
        
        if(checkConnection()){
            
            let channel = self.channelField.text
            
            if channel == nil{
                let alert = UIAlertView(title: "Error", message: "Please enter a channel name!", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK")
                alert.show()
                return
            }
            
            self.adapter?.getChannelId(channel!, completion: { (roomId, error) -> Void in
                print("Die Channel-Id ist:\(roomId)")
                
                if(roomId == nil){
                    print("Der Channel \(channel) existiert nicht")
                    return
                }
                
                self.adapter?.leaveChannel(roomId!, completion: { (error) -> Void in
                    if(error == nil){
                        print("\(channel) erfolgreich deabonniert")
                    }else{
                        print("\(channel) konnte nicht abonniert werden. \(String(error))")
                    }
                })
                
            })
            
        }

    }
    
    @IBAction func loadMessagesAction(sender: AnyObject) {
        
        if(checkConnection()){
        
            let channel = self.channelField.text
            
            if channel == nil{
                let alert = UIAlertView(title: "Error", message: "Please enter a channel name!", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK")
                alert.show()
                return
            }
            
            self.adapter?.getChannelId(channel!, completion: { (roomId, error) -> Void in
                print("Die Channel-Id ist:\(roomId)")
                
                if(roomId == nil){
                    print("Der Channel \(channel) existiert nicht")
                    return
                }
                
                self.adapter?.channelMessages(roomId!, numberOfMessages: 10, start: nil, end: nil, completion: { (result, error) -> Void in
                    
                    if(error != nil){
                        print("Error: \(String(error!))")
                    }
                    
                    if let myResult : MessageHistoryResultProtocol? = result{
                        let messages = myResult!.messages
                        
                        for message in messages{
                            
                            let date = NSDate(timeIntervalSince1970: message.time)
                            
                            let dateFormatter = NSDateFormatter()
                            dateFormatter.dateFormat = "dd.MM.YYYY HH:MM"
                            let dateString = dateFormatter.stringFromDate(date)
                            
                            print("\(dateString) \(message.user.username): \(message.message)")
                        }
                        
                    }
                    
                })
                
            })
        }
    }
}
