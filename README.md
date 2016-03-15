# RocketChatAdapter

An adapter to connect your app to a Rocket-Chat server.

[![CI Status](http://img.shields.io/travis/Jan Bartel/RocketChatAdapter.svg?style=flat)](https://travis-ci.org/Jan Bartel/RocketChatAdapter)
[![Version](https://img.shields.io/cocoapods/v/RocketChatAdapter.svg?style=flat)](http://cocoapods.org/pods/RocketChatAdapter)
[![License](https://img.shields.io/cocoapods/l/RocketChatAdapter.svg?style=flat)](http://cocoapods.org/pods/RocketChatAdapter)
[![Platform](https://img.shields.io/cocoapods/p/RocketChatAdapter.svg?style=flat)](http://cocoapods.org/pods/RocketChatAdapter)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

To include it in your own project take a look at the AdapterProtocol

<pre>
public protocol RocketChatAdapterProtocol{

    /**
    * Connect to server
    **/
    func connect(endpoint:String,callback:(() -> ())?)

    /**
    * Register user
    **/
    func register(email: String,name: String,password: String,completion: ((userId: String?, error: ErrorType?) -> Void)?)

    /**
    * Get a suggestion for your username
    **/
    func usernameSuggestion(completion:((username: String?,error:ErrorType?)->Void)?)

    /**
    * Set username
    **/
    func setUsername(username:String,completion:((username: String?,error:ErrorType?)->Void)?)

    /**
    * Send forgot password email
    **/
    func sendForgotPasswordEmail(usernameOrMail: String, completion:((result: Int?,error: ErrorType?)->Void)?)

    /**
    * Logon
    **/
    func login(userNameOrEmail: String, password: String, completion:((result: AuthorizationResultProtocol?,error:ErrorType?)->Void)?)

    /**
    * Get all public channels
    **/
    func channelList(completion:((result: [ChannelProtocol]?,error: ErrorType?)->Void)?)

    /**
    * Get a channels id by its name
    */
    func getChannelId(name:String, completion:((roomId:String?, error: ErrorType?)->Void)?)

    /**
    * Join a channel
    **/
    func joinChannel(channelId: String,completion:((error:ErrorType?)->Void)?)

    /**
    * Leave a channel
    **/
    func leaveChannel(channelId: String,completion:((error:ErrorType?)->Void)?)

    /**
    * Get messages from channel
    **/
    func channelMessages(channelId : String, numberOfMessages:Int, start: NSDate?, end: NSDate?, completion: ((result: MessageHistoryResultProtocol?, error: ErrorType?)->Void)?)

    /**
    * Send a message
    **/
    func sendMessage(channelId : String,message: String, completion: ((result: Message?, error: ErrorType?) -> Void)?)

    /**
    * Set user status
    **/
    func setUserStatus(userStatus: UserStatus,completion: ((error:ErrorType?)->Void)?)

}
</pre>


## Requirements

## Installation

RocketChatAdapter is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "RocketChatAdapter"
```

## Author

Jan Bartel, barteljan@yahoo.de

## License

RocketChatAdapter is available under the MIT license. See the LICENSE file for more info.
