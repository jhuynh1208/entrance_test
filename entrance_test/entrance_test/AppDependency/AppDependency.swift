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
            UserDefaults.standard.set(newValue.token, forKey: "token")
        }
    }
    
    
    init() {
        self.tokenable = Session(token: "")
    }
}

class Session: Tokenable {
    var token: String?
    
    init(token: String?) {
        self.token = token
    }
}
