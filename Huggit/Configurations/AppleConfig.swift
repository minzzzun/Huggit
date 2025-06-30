//
//  AppleConfig.swift
//  Huggit
//
//  Created by 김민준 on 6/27/25.
//

import Foundation

struct AppleConfig {
    static var clientId: String? {
        return Bundle.main.infoDictionary?["AppleClientID"] as? String
    }
    
    static var clientSecret: String? {
        return Bundle.main.infoDictionary?["AppleClientSecret"] as? String
    }
    
    static var privateKey: String? {
        return Bundle.main.infoDictionary?["ApplePrivateKey"] as? String
    }
    
    static var teamId: String? {
        return Bundle.main.infoDictionary?["AppleTeamID"] as? String
    }
        
    static var keyId: String? {
        return Bundle.main.infoDictionary?["AppleKeyID"] as? String
    }
}
