//
//  ViewController.swift
//  PropertyWrapper_Youtube
//
//  Created by Ahmed Fathy on 15/02/2023.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    @UpperCase var name: String
    @LowerCase var lowerName: String
    @UserDefaultsWropper<String>(key: .userName) var userName
    @UserDefaultsWropper<String>(key: .password) var password
    
    @RegexWropper(regex: "a") var passwordRegex
    
    
    private var anCancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        name = "ahmed" // Set
//        print("UperName name: \(name)")
//        lowerName = "AHMED" // Set
//        print("Lower name: \(lowerName)")
//
//        print("User Default is \(userName)")
//        userName = "ahmed fathy"
//        print("User Default is \(userName)")
//        userName = "Mohamed"
//        print("User Default is \(userName)")
//
//
        passwordRegex = "@"
        print("Password Regex wrapped Value \(passwordRegex)")
        print("Password Regex projected Value \($passwordRegex)")
        $passwordRegex.sink { value in
            print(value)
        }.store(in: &anCancellable)
        
        
        passwordRegex = "abdo"
        passwordRegex = "mohmed"
        passwordRegex = "ahemd"
    }
}

@propertyWrapper
struct UpperCase {
    var upperContainer: String = ""
    var wrappedValue: String {
        get { upperContainer.uppercased()}
        set { upperContainer = newValue }
    }

}

@propertyWrapper
struct LowerCase {
    var lowerContainer: String = ""
    var wrappedValue: String {
        get { lowerContainer.lowercased()}
        set { lowerContainer = newValue }
    }
}

@propertyWrapper
struct UserDefaultsWropper<Value> {
    private let standardDefault = UserDefaults.standard
    let key: String
    var wrappedValue: Value? {
        get { standardDefault.value(forKey: key) as? Value}
        set {standardDefault.set(newValue, forKey: key)}
    }
    
    init(key: UserDefaults.Keys) {
        self.key = key.rawValue
    }
}

extension UserDefaults {
    public enum Keys: String {
        case userName = "username"
        case password
    }
}

@propertyWrapper
struct RegexWropper {
    let regex: String
    // Container
    var value: String
    
    private let publisher = PassthroughSubject<Bool, Never>()
    
    var wrappedValue: String {
        get { value }
        set { value = newValue ; publisher.send(isValid) }
    }
    
    var isValid: Bool {
        return value.contains(regex)
    }
    var projectedValue: AnyPublisher<Bool, Never> {
        get { publisher.eraseToAnyPublisher() }
    }
    
    init(regex: String, value: String = "") {
        self.regex = regex
        self.value = value
    }
}
