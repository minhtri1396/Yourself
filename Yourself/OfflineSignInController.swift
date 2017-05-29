import UIKit

class OfflineSignInController: UIViewController {
    // MARK: *** Local variables
    
    var keyboard: Keyboard?
    
    // MARK: *** Data model
    
    @IBOutlet weak var scrollView: UIScrollView!
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
            Alert.show(title: Language.BUILDER.get(group: Group.MESSAGE_TITLE, view: MessageTitle.NOTICE), msg: Language.BUILDER.get(group: Group.MESSAGE, view: Message.EMPTY_EMAIL), vc: self)
        } else {
            if GAccount.Instance.SignInWithoutVerify(email: email!) {
                displayMainScreen(email: email!)
            } else {
                Alert.show(title: Language.BUILDER.get(group: Group.MESSAGE_TITLE, view: MessageTitle.NOTICE), msg: Language.BUILDER.get(group: Group.MESSAGE, view: Message.INVALID_EMAIL), vc: self)
            }
        }
    }
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.backButton.setTitle(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.BACK_BUTTON), for: .normal)
        self.signInButton.setTitle(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.LOGIN_BUTTON), for: .normal)
        self.emailTextField.placeholder = Language.BUILDER.get(group: Group.PLACEHOLDER, view: PlaceholderViews.GMAIL_LOGIN_OFFLINE)
        self.instructionLabel.text = Language.BUILDER.get(group: Group.REMINDING, view: RemindingViews.GMAIL_LOGIN_OFFLINE)
        self.titleLabel.text = Language.BUILDER.get(group: Group.TITLE, view: TitleViews.LOGIN_OFFLINE_TITLE)
        
        // Do any additional setup after loading the view, typically from a nib.
        self.emailTextField.keyboardType = UIKeyboardType.emailAddress
        
        // Set property for keyboard and create dont button for all keyboard in this viewcontroller
        keyboard = Keyboard(arrTextField: [self.emailTextField])
        keyboard?.createDoneButton()
        
        // Register 2 events: 1-Keyboard will show , 2-Keyboard will hide
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: Notification) {
        if let contentInset = keyboard?.catchEventOfKeyboard(isScroll: true, notification: notification) {
            self.scrollView.setContentOffset(contentInset, animated: true)
        }
    }
    
    func keyboardWillHide(notification: Notification) {
        if let contentInset = keyboard?.catchEventOfKeyboard(isScroll: false, notification: notification) {
            self.scrollView.setContentOffset(contentInset, animated: true)
        }
    }
    
    private func displayMainScreen(email: String) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let notesList = storyBoard.instantiateViewController(withIdentifier: "NotesList")
        self.present(notesList, animated: true, completion: nil)
    }
    
}
