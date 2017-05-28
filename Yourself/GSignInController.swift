import Foundation
import Firebase
import GoogleSignIn

import UIKit

class GSignInController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    // MARK: *** local variables
    
    // MARK: *** Data model
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var offSignInLabel: UILabel!
    @IBOutlet weak var offSignInButton: UIView!
    @IBOutlet weak var gglSignInLabel: UILabel!
    @IBOutlet weak var gglSignInButton: UIView!
    @IBOutlet weak var offSignInWaitingView: UIView!
    @IBOutlet weak var gglSignInWaitingView: UIView!
    
    // MARK: *** UI events
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        progressView.setProgress(1, animated: true)
        
        GAccount.Instance.Sign(signIn, didSignInFor: user, withError: error)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
    }
    
    func OfflineSignInButton_Tapped(sender: UITapGestureRecognizer) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let offlineSignInController = storyBoard.instantiateViewController(withIdentifier: "OfflineSignInController") as! OfflineSignInController
        self.present(offlineSignInController, animated: true, completion: nil)
    }
    
    func GGLSignInButton_Tapped(sender: UITapGestureRecognizer) {
        progressView.setProgress(0.7, animated: true)
        self.offSignInWaitingView.isHidden = false
        self.gglSignInWaitingView.isHidden = false
        self.progressView.isHidden = false
        GAccount.Instance.SignIn() {
            [unowned self] (email, result) in
            if result {
                self.displayMainScreen(email: email)
            } else {
                self.offSignInWaitingView.isHidden = true
                self.gglSignInWaitingView.isHidden = true
                self.progressView.isHidden = true
            }
        }
    }
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if user signed in before
        if let user = GAccount.Instance.SignInUsingAccount() {
            displayMainScreen(email: user.email)
        }
        
        // Initialize google sign-in
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        // Initialize offline sign in button tapping
        let offSignInTap = UITapGestureRecognizer(target: self, action: #selector(OfflineSignInButton_Tapped(sender:)))
        offSignInTap.numberOfTapsRequired = 1
        offSignInButton.addGestureRecognizer(offSignInTap)
        // Initialize google sign in button tapping
        let gglSignInTap = UITapGestureRecognizer(target: self, action: #selector(GGLSignInButton_Tapped(sender:)))
        gglSignInTap.numberOfTapsRequired = 1
        gglSignInButton.addGestureRecognizer(gglSignInTap)
    }
    
    private func displayMainScreen(email: String) {
        DispatchQueue.main.async {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let notesList = storyBoard.instantiateViewController(withIdentifier: "NotesList")
            self.present(notesList, animated: true, completion: nil)
            self.offSignInWaitingView.isHidden = true
            self.gglSignInWaitingView.isHidden = true
            self.progressView.isHidden = true
        }
    }
    
}
