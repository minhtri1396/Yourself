import Foundation
import Firebase
import GoogleSignIn

class GAccount {
    static let Instance = GAccount()
    
    var verifyResult: ((String, Bool) -> Void)? // email and isSuccess
    var signInResult: ((String, Bool) -> Void)? // email and isSuccess
    
    // We can use this method to verify google account
    func Verify(closure: @escaping (String, Bool) -> Void) {
        self.verifyResult = closure
        GIDSignIn.sharedInstance().signIn()
    }
    
    // We can use this method to sign in google account
    func SignIn(closure: @escaping (String, Bool) -> Void) {
        self.signInResult = closure
        GIDSignIn.sharedInstance().signIn()
    }
    
    // Use this method to try signing in account which user signed in before
    func SignInUsingAccount() -> DTOUser? {
        var user: DTOUser?
        
        if let email = AppManager.GetUsingEmail() {
            if email.characters.count > 0 {
                user = DAOUser.BUILDER.GetUser(by: email)
                // Check if the email is existed in DB (to be safe)
                if user != nil {
                    DAOSuper.userID = user!.uid
                    DAOSuper.userFID = user!.fid
                }
            }
        }
        
        return user
    }
    
    func SignOut() {
        GIDSignIn.sharedInstance().signOut()
        AppManager.SetSignedState(state: false)
        AppManager.SetUsingEmail(email: "")
    }
    
    // The class invoke SignIn method of this class shoule override:
    // func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) of GIDSignInDelegate
    // and invoke below Sign method in the sign method overrided.
    func Sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // Sign in Google account
        if let _ = error {
            print("1412573_1412591 -> GSignIn.sign error occurred: \(error)")
            self.ResponseResult(email: "", result: false)
        } else {
            let uid = user.userID! // For client-side use only!
            
            // Sign in Firebase
            guard let authentication = user.authentication else {
                self.ResponseResult(email: "", result: false)
                return
            }
            let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            FIRAuth.auth()?.signIn(with: credential) {
                [unowned self] (user, error) in
                if let _ = error {
                    print("1412573_1412591 -> GSignIn.sign error occurred: \(error)")
                    self.ResponseResult(email: "", result: false)
                } else {
                    // Inform user's information
                    GAccount.Instance.Signed(
                        uid: uid,
                        fid: FIRAuth.auth()!.currentUser!.uid,
                        email: user!.email!,
                        verified: true
                    )
                    self.ResponseResult(email: user!.email!, result: true)
                }
            }
        }
    }
    
    // Used for offline login
    func SignInWithoutVerify(email: String) -> Bool {
        if IsValidEmail(email: email) {
            let uid = GenerateOfflineUID()
            Signed(uid: uid, fid: uid, email: email, verified: false)
            return true
        }
        return false
    }
    
    private func IsValidEmail(email:String) -> Bool {
        // Check whether the email has format of a email address
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        var isValid = emailTest.evaluate(with: email)
        
        // Check whether the email has @gmail.com
        if isValid {
            let range: Range<String.Index> = email.range(of: "@")!
            let mx = email.substring(from: range.upperBound)
            isValid = (mx == "gmail.com")
        }
        
        return isValid
    }
    
    // We use this method to generate UID for user when he (she) used offline
    private func GenerateOfflineUID() -> String {
        var uid = Date().ticks
        
        while DAOUser.BUILDER.IsUIDExisted(uid: "\(uid)") {
            uid += 1
        }
        
        return "\(uid)"
    }
    
    // Save some information after user signed in
    private func Signed(uid: String, fid: String, email: String, verified: Bool) {
        AppManager.SetSignedState(state: true)
        AppManager.SetUsingEmail(email: email)
        DAOUser.BUILDER.CreateTable()
        
        // Check if the email is existed in DB
        if let user = DAOUser.BUILDER.GetUser(by: email) {
            DAOSuper.userID = user.uid // current uid
            DAOSuper.userFID = user.fid // current fid
            if verified && !user.verified {
                _ = DAOUser.BUILDER.UpdateFID(fid: fid)
                _ = DAOUser.BUILDER.UpdateVerified(verified: verified)
                
                // Move old table to new ones
                DAOUser.BUILDER.Move(to: uid)
                
                _ = DAOUser.BUILDER.UpdateUID(uid: uid)
                DAOSuper.userID = uid // new uid
                DAOSuper.userFID = fid // new fid
            }
        } else {
            _ = DAOUser.BUILDER.Insert(userTuple: DTOUser(
                    uid: uid,
                    fid: fid,
                    email: email,
                    verified: verified
                )
            )
            
            DAOSuper.userID = uid
            DAOSuper.userFID = fid
            DAOJars.BUILDER.CreateTable()
            DAOIntent.BUILDER.CreateTable()
            DAOAlternatives.BUILDER.CreateTable()
            DAOTime.BUILDER.CreateTable()
            DAOCheerUp.BUILDER.CreateTable()
            DAOTimeStats.BUILDER.CreateTable()
            DAOTimestamp.BUILDER.CreateTable()
        }
    }
    
    private func ResponseResult(email: String, result: Bool) {
        ResponseVerifyResult(email: email, result: result)
        ResponseSignResult(email: email, result: result)
    }
    
    private func ResponseVerifyResult(email: String, result: Bool) {
        if let verifyResult = self.verifyResult {
            verifyResult(email, result)
            self.verifyResult = nil
        }
    }
    
    private func ResponseSignResult(email: String, result: Bool) {
        if let signInResult = self.signInResult {
            signInResult(email, result)
            self.signInResult = nil
        }
    }
    
}
