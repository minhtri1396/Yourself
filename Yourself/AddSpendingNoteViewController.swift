import UIKit
import SCLAlertView

class AddSpendingNoteViewController: UIViewController {
    
    // MARK: *** Local variables
    var keyboard: Keyboard?
    
    // MARK: *** Data model
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var navigationBar_TitleBar: UINavigationBar!
    @IBOutlet weak var barButton_Back: UIBarButtonItem!
    @IBOutlet weak var textField_AddMoney: UITextField!
    @IBOutlet weak var textField_Notes: UITextField!
    
    
    
    
    
    
    
    
    
    // MARK: *** UI events
    
    
    @IBAction func back_Tapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func showMessage_Tapped(_ sender: AnyObject) {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false,
            showCircularIcon: true
        )
        
        let alertView = SCLAlertView(appearance: appearance)
        
        alertView.addButton("Necessities", target:self, selector:#selector(AddSpendingNoteViewController.Necessities_Acction))
        alertView.addButton("Financial Freedom Account", target:self, selector:#selector(AddSpendingNoteViewController.FinancialFreedomAccount_Acction))
        alertView.addButton("Long Term Savings", target:self, selector:#selector(AddSpendingNoteViewController.LongTermSavings_Acction))
        alertView.addButton("Education", target:self, selector:#selector(AddSpendingNoteViewController.Education_Acction))
        alertView.addButton("Play", target:self, selector:#selector(AddSpendingNoteViewController.Play_Acction))
        alertView.addButton("Give", target:self, selector:#selector(AddSpendingNoteViewController.Give_Acction))
        
        alertView.showSuccess("Swap money", subTitle: "Choose box to send money")
    }
    
    
    // MARK: *** Fuction
    
    func Necessities_Acction() {
        
    }
    
    func FinancialFreedomAccount_Acction() {
        print("First button tapped")
    }
    
    func LongTermSavings_Acction() {
        print("First button tapped")
    }
    
    func Education_Acction() {
        print("First button tapped")
    }
    
    func Play_Acction() {
        print("First button tapped")
    }
    
    func Give_Acction() {
        print("First button tapped")
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
    
    // MARK: *** UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view_Top1.layer.cornerRadius = self.view_Top1.frame.size.width / 2.0
//        self.view_Body1.layer.cornerRadius = 10
//        self.view_Top2.layer.cornerRadius = self.view_Top2.frame.size.width / 2.0
//        self.view_Body2.layer.cornerRadius = 10
//        self.view_Top3.layer.cornerRadius = self.view_Top3.frame.size.width / 2.0
//        self.view_Body3.layer.cornerRadius = 10
//        self.view_Top4.layer.cornerRadius = self.view_Top4.frame.size.width / 2.0
//        self.view_Body4.layer.cornerRadius = 10
//        self.view_Top5.layer.cornerRadius = self.view_Top5.frame.size.width / 2.0
//        self.view_Body5.layer.cornerRadius = 10
//        self.view_Top6.layer.cornerRadius = self.view_Top6.frame.size.width / 2.0
//        self.view_Body6.layer.cornerRadius = 10
        
        self.navigationBar_TitleBar.topItem?.title = "Thêm note"
        
        keyboard = Keyboard(arrTextField: [self.textField_Notes, self.textField_AddMoney])
        keyboard?.createDoneButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
