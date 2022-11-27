import Foundation
import Combine

// Class to store all dependency of the app (that shared using all places in the app)
class AppDependency {
    var token: Tokenable    // To store token
    
    init() {
        self.token = Session(token: "")
    }
}

class Session: Tokenable {
    var token: String?
    
    init(token: String?) {
        self.token = token
    }
}
