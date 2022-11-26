import Foundation
import Combine

// Class to store all dependency of the app (that shared using all places in the app)
class AppDependency {
    var token: String    // To store token
    
    init() {
        self.token = ""
    }
}
