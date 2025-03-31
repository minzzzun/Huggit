import Foundation

struct GitHubConfig {
    static var client_id: String? {
        return Bundle.main.infoDictionary?["GitHubClientID"] as? String
    }
    
    static var client_secret: String? {
        return Bundle.main.infoDictionary?["GitHubClientSecret"] as? String
    }
}
