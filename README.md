# miniapp-core-sdk

## Table of Contents

1. [Introduction](#introduction)
2. [Installation](#installation)
3. [Description](#description)
4. [Usage](#usage)
5. [Support](#support)
6. [Roadmap](#roadmap)

&nbsp;

## Introduction

A library with `miniapp_core` framework that provides a set of functions to initialize and manage various aspects of application's core functionality. It's also designed to handle navigation, API calls, event emissions, state management, and more.

&nbsp;

## Installation

### Swift Package Manager

To integrate `miniapp_core` SDK into your Xcode project using Swift Package Manager, add it to the dependencies value of your Package.swift:

```swift
dependencies: [
    .package(url: "https://github.com/stanydsouza/miniapp-core-sdk.git", .upToNextMajor(from: "0.0.1"))
]
```

### Requirements

Swift Version: 5.10

| Platform | Min. Version |
| -------- | ------------ |
| macOS    |    11.0      |
| iOS      |    14.0      |
| tvOS     |    14.0      |
| watchOS  |    7.0       |

&nbsp;

## Description

### MiniAppCore

It's a namespace which provide access to different feature modules of the SDK.

```swift
public enum MiniAppCore {
    
    public static let Auth: AuthenticationProtocol 
    
    public static let API: APIProtocol
    
    public static let Navigation: NavigationProtocol
    
    public static let EventBus: EventsProtocol
    
    public static let Logger: LoggerProtocol
    
    public static let Store: StoreProtocol
}
```

Below are the feature modules of MiniAppCore:

- [Auth](#auth)
- [Navigation](#navigation)
- [API](#api)
- [Store](#store)
- [EventBus](#eventbus)

&nbsp;

### Auth

Auth module provides the authentication feature. It's an instance of `AuthenticationProtocol`

```swift
public protocol AuthenticationProtocol: AnyObject {
    func config(authService: AuthenticationServiceProtocol)
    func login(id: String, password: String) async throws
    func logout() async throws
}
```

&nbsp;

- `func config(authService: AuthenticationServiceProtocol)`

 This method is used to config authentication module. It accepts `AuthenticationServiceProtocol` object as param.

 ```swift
 public protocol AuthenticationServiceProtocol {
    func authenticate(id: String, password: String) async throws -> AuthToken
    func deauthenticate(authToken: AuthToken) async throws
    func refreshToken(authToken: AuthToken) async throws -> AuthToken
}
 ```

Any authentication service can be used in Auth module by implementing `AuthenticationServiceProtocol` to generate `AuthToken` object & also invalidate `AuthToken` object

```swift
public struct AuthToken : Codable {

    public let accessToken: String 
    public let refreshToken: String

    public init(accessToken: String, refreshToken: String)
}
```

&nbsp;

- `func login(id: String, password: String) async throws`

This method authenticate the `id` & `password`

&nbsp;

- `func logout() async throws`

This method invalidate the `AuthToken` object

&nbsp;

### Navigation

Navigation module deals with the event based navigation logic. It's an instance of `NavigationProtocol`

```swift
public protocol NavigationProtocol {
    func config(navigate: @escaping (_ miniApp: String) -> Void)
    func configRouters(routers: [[String:Any]], currentMiniApp: String)
}
```

&nbsp;

- `func config(navigate: @escaping (_ miniApp: String) -> Void)`

This method configure the navigation closure which captures the MiniApp name which need to be navigate to.

&nbsp;

- `func configRouters(routers: [[String:Any]], currentMiniApp: String)`

This method configure the navigation routing data based on the events & also sets the current MiniApp

&nbsp;

### API

API module provides functionality of calling HTTP request. It's an instance of `NavigationProtocol`

```swift
public protocol APIProtocol: AnyObject {
    func config(apiConfig: APIConfig, authToken: AuthToken?)
    var logsEnabled: Bool { get set }
}
```

&nbsp;

- `func config(apiConfig: APIConfig, authToken: AuthToken?)`

This method configure the API module using `APIConfig` object & `AuthToken` object

```swift
public struct APIConfig {
    
    public init(
        baseURL: String, // base url of the api request
        timeout: TimeInterval, // In seconds
        headers: [String : String]?, // custom http headers
        cancelApiWhenRouterChange: Bool, // to cancel api call when screen changes
        retryApiEnabled: Bool, // to retry api once again when it http error occurs
        customErrorHandlers: [Int: (_ error: Error) -> Void]? // to perform custom action based on particular http error code
    ) 
}
```

&nbsp;

### Store

This module deals with management of data using Store concept. It's an instance of `StoreProtocol`

```swift
public protocol StoreProtocol {
    func getNavigationParams() -> Any?
    func createGlobalStore<T: StoreStateType>(storeName: String, isPersistent: Bool, initialState: T)
    func getGlobalData<T: StoreStateType>(storeName: String) -> T?
    func createMiniAppStore<T: StoreStateType>(isPersistent: Bool, initialState: T)
    func getMiniAppData<T: StoreStateType>() -> T?
}
```

&nbsp;

- `func getNavigationParams() -> Any?`

This method returns the navigation data for the current miniapp

&nbsp;

- `func createGlobalStore<T: StoreStateType>(storeName: String, isPersistent: Bool, initialState: T)`

This method creates a global store for specified name & accepts initial data of specified Type. Data can also be stored in UserDefaults

&nbsp;

- `func getGlobalData<T: StoreStateType>(storeName: String) -> T?`

This method returns the data of specified Type form the global store of the specified name.

&nbsp;

- `func createMiniAppStore<T: StoreStateType>(isPersistent: Bool, initialState: T)`

This method creates a miniapp store for current miniapp & accepts initial data of specified Type. Data can also be stored in UserDefaults. If store already exists for miniapp it doesn't create the store again.

&nbsp;

- `func getMiniAppData<T: StoreStateType>() -> T?`

This method returns the data of specified Type from the current miniapp store.

**_NOTE:_**  Here miniApp can also be refered to as screen

&nbsp;

### EventBus

This module provide us to call diffrent events. It's an instance of `EventsProtocol`

```swift
public protocol EventsProtocol: AnyObject {
    func navigate(event: String, params: Any?)
    func apiCall<Params: Encodable, Response: Decodable>(endpoint: String, method: APIMethod, params: Params?) async throws -> Response
    func apiCall<Params: Encodable>(endpoint: String, method: APIMethod, parameters: Params?) async throws -> Data
    func setGlobalData<T: StoreStateType>(storeName: String, mutate: StateChange<T>) throws
    func setMiniAppData<T: StoreStateType>(mutate: StateChange<T>) throws
}
```

&nbsp;

- `func navigate(event: String, params: Any?)`

This method navigate to screen based on the event called by the current screen.

&nbsp;

- `func apiCall<Params: Encodable, Response: Decodable>(endpoint: String, method: APIMethod, params: Params?) async throws -> Response`

This method performs HTTP request call & returns a Decodable response of specified Type

&nbsp;

- `func apiCall<Params: Encodable>(endpoint: String, method: APIMethod, parameters: Params?) async throws -> Data`

This method performs HTTP request call & returns a Data response

&nbsp;

- `func setGlobalData<T: StoreStateType>(storeName: String, mutate: StateChange<T>) throws`

This method set/change data of specified Type of global store

&nbsp;

- `func setMiniAppData<T: StoreStateType>(mutate: StateChange<T>) throws`

This method set/change data of specified Type of current miniApp store

&nbsp;

### Logger

The Logger module provides functionality to log events & errors. Available loggers are `Sentry`, `FirebaseAnalytics` & `OSLog`

```swift
public protocol LoggerProtocol {
    func config(loggers: Set<LoggerType>?, sentryConfig: SentryConfig?)
    func logEvent(eventName: String, eventData: Any, enabledLoggers: Set<LoggerType>?)
    func logError(error: Error, enabledLoggers: Set<LoggerType>?)
}
```

&nbsp;

- `func config(loggers: Set<LoggerType>?, sentryConfig: SentryConfig?)`

This method configure the selected loggers.

&nbsp;

- `func logEvent(eventName: String, eventData: Any, enabledLoggers: Set<LoggerType>?)`

This method logs event with data.

&nbsp;

- `func logError(error: Error, enabledLoggers: Set<LoggerType>?)`

This method logs error.

&nbsp;

## Usage

### Auth

To configure Auth in the SDK using custom authentication we need to use `AuthenticationServiceProtocol`. Below is a code snippet:

```swift
struct CustomAuthenticationService: AuthenticationServiceProtocol {
    
    func authenticate(id: String, password: String) async throws -> AuthToken {
        // Implement custom authentication logic & return the AuthToken opbject
    }
    
    func deauthenticate(authToken: AuthToken) async throws {
        // Implement custom deauthenticate logic
    }
    
    func refreshToken(authToken: AuthToken) async throws -> AuthToken {
        // Implement custom refresh logic & return the AuthToken opbject
    }
}
```

```swift
import miniapp_core

MiniAppCore.Auth.config(authService: CustomAuthenticationService())
```

&nbsp;

### Navigation

Naviagtion modules required to configure routing data & naviagtion logic 

```swift
import miniapp_core

MiniAppCore.Navigation.config(navigate: { miniApp in
    // Implement the navigation logic here using the miniApp variable
})
```

**_NOTE:_**  Here miniApp variable can also be refered as screen name

```swift

let routes = """
[
    {
        "key": "First",
        "events": {
            "next" : "Second"
        }
    },
    {
        "key": "Second",
        "events": {
            "back": "First",
        }
    }
]
"""

let json = try JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves) as? [[String: Any]] ?? [:]
// Here we configure routing data
MiniAppCore.Navigation.configRouters(routers: json, currentMiniApp: "First")
```

&nbsp;

### API

To configure API module, APIConfig object is required

```swift
import miniapp_core

MiniAppCore.API.config(
    apiConfig: APIConfig(
        baseURL: "<- base_url ->",
        timeout: 60, // seconds
        headers: nil,
        cancelApiWhenRouterChange: true,
        retryApiEnabled: true, 
        customErrorHandlers: [
            401: // custom logic to handle 401 error globally,
            404: // custom logic to handle 404 error globally,
            ....
        ]
    ),
    authToken: nil // authToken is optional
)
```

&nbsp;

### Store

```swift
struct AppGlobalData: Codable, Equatable {
    var name: String = "data"
}

struct MiniAppData: Codable, Equatable {
    var name: String = "data"
}
```

```swift
import minipp_core

// Creating global store named "app_data" with data of Type AppGlobalData
MiniAppCore.Store.createGlobalStore(storeName: "app_data", isPersistent: true, initialState: AppGlobalData())

// Getting data form global store
let data: AppGlobalData? = MiniAppCore.Store.getGlobalData(storeName: "app_data")

// Creating miniapp store with data of Type MiniAppData for current miniApp
MiniAppCore.Store.createMiniAppStore(isPersistent: true, initialState: MiniAppData())

// Getting data form miniapp store
let data: MockData? = MiniAppCore.Store.getMiniAppData()
```

&nbsp;

### Logger

```swift
import minipp_core

// Configure the Logger Module
MiniAppCore.Logger.config(
    loggers: [.Sentry, .OS, .GA],
    sentryConfig: SentryConfig(     // sentryConfig is optional if not using Sentry logger 
        isDebug: true,
        sentryDSN: "<sentry dsn>"
    )
)

// To log event
MiniAppCore.Logger.logEvent(eventName: "Test", eventData: "Data", enabledLoggers: nil)

// To log error
MiniAppCore.Logger.logError(error: CustomError.invalidData, enabledLoggers: nil)
```

&nbsp;

### EventBus

```swift
import miniapp_core

// Navigate Event
MiniAppCore.EventBus.navigate(event: "next", params: nil)

// Set Global Data
try MiniAppCore.EventBus.setGlobalData(storeName: "app_data") { (ref: inout AppGlobalData) in
    ref.name = "New Name"
}

try MiniAppCore.EventBus.setGlobalData(storeName: "app_data") { (ref: inout AppGlobalData) in
    ref = AppGlobalData(name: "Test Name") // This will assign new object
}

// Set MiniApp Data
try MiniAppCore.EventBus.setMiniAppData { (ref: inout MiniAppData) in
    ref.name = "New name"
}

// Dummy Models
struct User: Decodable {
    let name: String
}

struct DummyEncodable: Encodable {}

// API Call Event
let user: User = try await MiniAppCore.EventBus.apiCall(endpoint: "user", method: .get, params: nil as DummyEncodable?)
```

&nbsp;

## Support

Email: <stanydsouza93@gmail.com>

&nbsp;

## Roadmap

- Swift 6 support

&nbsp;

## License

MIT License
