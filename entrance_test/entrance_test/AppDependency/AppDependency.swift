import Foundation
import Combine

// Class to store all dependency of the app (that shared using all places in the app)
class AppDependency {
    var tokenable: Tokenable {
        get {
            let token = UserDefaults.standard.string(forKey: "token") ?? ""
            return Session(token: token)
        }
        set {
            set(newValue.token, forKey: "token")
        }
    }
    
    var profile: UserProfile? {
        get {
            return object(ofType: UserProfile.self, forKey: "user_profile")
        }
        set {
            set(newValue, forKey: "user_profile")
        }
    }
    
    
    init() {
        self.tokenable = Session(token: "")
    }
    
    func set<T: Codable>(_ object: T?, forKey key: String) {
        if let object = object {
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(object) {
                UserDefaults.standard.set(data, forKey: key)
            }
        } else {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }

    func object<T: Codable>(ofType type: T.Type, forKey key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return nil
        }
        let decoder = JSONDecoder()
        guard let object = try? decoder.decode(type.self, from: data) else {
            return nil
        }
        return object
    }
}

class Session: Tokenable {
    var token: String?
    
    init(token: String?) {
        self.token = token
    }
}
