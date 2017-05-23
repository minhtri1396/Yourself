import UIKit

class AppManager {
    
    static func IsSigned() -> Bool {
        if let isSigned = UserDefaults.standard.value(forKey: "IsSigned") {
            return isSigned as! Bool
        }
        
        return false
    }
    
    static func SetSignedState(state: Bool) {
        UserDefaults.standard.set(state, forKey: "IsSigned")
    }
    
    static func SetUsingEmail(email: String) {
        UserDefaults.standard.set(email, forKey: "UsingEmail")
    }
    
    static func GetUsingEmail() -> String? {
        return (UserDefaults.standard.value(forKey: "UsingEmail") as? String)
    }
    
}
