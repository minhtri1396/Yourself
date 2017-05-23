import UIKit

class OfflineSignInController: UIViewController {
    // MARK: *** Local variables
    
    // MARK: *** Data model
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    
    // MARK: *** UI events
    @IBAction func BackButton_Tapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SignInButton_Tapped(_ sender: AnyObject) {
        let email = emailTextField.text
        if email == nil || email!.characters.count == 0 {
            // Alert information message: Empty email
        } else {
            if GAccount.Instance.SignInWithoutVerify(email: email!) {
                displayMainScreen(email: email!)
            } else {
                // Alert information message: Invalid email
            }
        }
    }
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.emailTextField.keyboardType = UIKeyboardType.emailAddress
    }
    
    private func displayMainScreen(email: String) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let notesList = storyBoard.instantiateViewController(withIdentifier: "NotesList")
        self.present(notesList, animated: true, completion: nil)
    }
    
}
