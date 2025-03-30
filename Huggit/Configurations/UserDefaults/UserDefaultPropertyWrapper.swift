//
//  UserDefaultPropertyWrapper.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/30/25.
//

import Foundation

// MARK: - UserDefault 프로퍼티 래퍼
@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
