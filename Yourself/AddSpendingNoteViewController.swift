import UIKit
import SCLAlertView
import BEMCheckBox

class AddSpendingNoteViewController: UIViewController, BEMCheckBoxDelegate {
    
    // MARK: *** Local variables
    var keyboard: Keyboard?
    var moneyOfBoxIsChoosed: Double?
    var maxMoney: Double?

    
    // MARK: *** Data model
    
    @IBOutlet weak var label_Title: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textField_GivingMoney: UITextField!
    @IBOutlet weak var textField_Notes: UITextField!
    
    
    @IBOutlet weak var button_Add: UIButton!
    @IBOutlet weak var button_Back: UIButton!
    
    
    @IBOutlet weak var necCheckBox: BEMCheckBox!
    @IBOutlet weak var ffaCheckBox: BEMCheckBox!
    @IBOutlet weak var ltssCheckBox: BEMCheckBox!
    @IBOutlet weak var eduCheckBox: BEMCheckBox!
    @IBOutlet weak var playCheckBox: BEMCheckBox!
    @IBOutlet weak var giveCheckBox: BEMCheckBox!
    
    @IBOutlet weak var necView: UIView!
    @IBOutlet weak var ffaView: UIView!
    @IBOutlet weak var ltssView: UIView!
    @IBOutlet weak var eduView: UIView!
    @IBOutlet weak var playView: UIView!
    @IBOutlet weak var giveView: UIView!
    
    @IBOutlet weak var necBar: UIView!
    @IBOutlet weak var ffaBar: UIView!
    @IBOutlet weak var ltssBar: UIView!
    @IBOutlet weak var eduBar: UIView!
    @IBOutlet weak var playBar: UIView!
    @IBOutlet weak var giveBar: UIView!
    
    @IBOutlet weak var necName: UILabel!
    @IBOutlet weak var ffaName: UILabel!
    @IBOutlet weak var ltssName: UILabel!
    @IBOutlet weak var eduName: UILabel!
    @IBOutlet weak var playName: UILabel!
    @IBOutlet weak var giveName: UILabel!
    
    @IBOutlet weak var necMoney: UILabel!
    @IBOutlet weak var ffaMoney: UILabel!
    @IBOutlet weak var ltssMoney: UILabel!
    @IBOutlet weak var eduMoney: UILabel!
    @IBOutlet weak var playMoney: UILabel!
    @IBOutlet weak var giveMoney: UILabel!
        
    // MARK: *** UI events
    
    
    @IBAction func backButton_Tapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
   
    
    func didTap(_ checkBox: BEMCheckBox) {
        if (checkBox.on) {
            var type = JARS_TYPE.EDU

            if isFindingMaxMoney() {
                switch (checkBox) {
                case self.necCheckBox:
                    self.necMoney.isHidden = true
                    type = JARS_TYPE.NEC
                    break;
                case self.ffaCheckBox:
                    self.ffaMoney.isHidden = true
                    type = JARS_TYPE.FFA
                    break;
                case self.ltssCheckBox:
                    self.ltssMoney.isHidden = true
                    type = JARS_TYPE.LTSS
                    break;
                case self.eduCheckBox:
                    self.eduMoney.isHidden = true
                    type = JARS_TYPE.EDU
                    break;
                case self.playCheckBox:
                    self.playMoney.isHidden = true
                    type = JARS_TYPE.PLAY
                    break;
                default:
                    self.giveMoney.isHidden = true
                    type = JARS_TYPE.GIVE
                    break;
                }
                
                if isGettingMoneyOfBoxIsChoosed(type: type) {
                    if Double(self.textField_GivingMoney.text!)! > moneyOfBoxIsChoosed! {
                        show_SwapMoneyBox_ChoosingView()
                    }
                }
            }
            else {
                checkBox.on = false
            }
        }
    }
    
    func animationDidStop(for checkBox: BEMCheckBox) {
        if (!checkBox.on) {
            switch (checkBox) {
            case self.necCheckBox:
                self.necMoney.isHidden = false
                break;
            case self.ffaCheckBox:
                self.ffaMoney.isHidden = false
                break;
            case self.ltssCheckBox:
                self.ltssMoney.isHidden = false
                break;
            case self.eduCheckBox:
                self.eduMoney.isHidden = false
                break;
            case self.playCheckBox:
                self.playMoney.isHidden = false
                break;
            default:
                self.giveMoney.isHidden = false
                break;
            }
        }
    }

    
    
    // MARK: *** Fuction
    
    /* Message box event */
    
    //----------- No meny massage box
    
    func noMoney_Acction() {
        
    }
    
    //----------- Choose box to replace message box
    
    func necessities_Acction() {
        
    }
    
    func financialFreedomAccount_Acction() {
        print("First button tapped")
    }
    
    func longTermSavings_Acction() {
        print("First button tapped")
    }
    
    func education_Acction() {
        print("First button tapped")
    }
    
    func play_Acction() {
        print("First button tapped")
    }
    
    func give_Acction() {
        print("First button tapped")
    }
    
    /* Key board event */
    
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
        
        
        configBarBox()
        configViewBox()
        configBorderBox()
        configCheckBoxes()
        configLanguge()
        
        keyboard = Keyboard(arrTextField: [self.textField_Notes, self.textField_GivingMoney])
        keyboard?.createDoneButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* CONFIG */
    
    private func configAppearanceAlertView()->SCLAlertView.SCLAppearance {
        return SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false,
            showCircularIcon: true
        )
    }
    
    private func configLanguge() {
        self.button_Back.setTitle(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.BACK_BUTTON), for: .normal)
        self.button_Add.setTitle(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.DONE), for: .normal)
        self.label_Title.text = Language.BUILDER.get(group: Group.TITLE, view: TitleViews.ADD_SPENDING_NOTE_TITLE)
        self.textField_GivingMoney.placeholder = Language.BUILDER.get(group: Group.PLACEHOLDER, view: PlaceholderViews.ADD_MONEY)
        self.textField_Notes.placeholder = Language.BUILDER.get(group: Group.PLACEHOLDER, view: PlaceholderViews.ADD_MONEY_NOTE)
        
    }
    
    private func configBorderBox() {
        let borderColor = UIColor(colorLiteralRed: 224/255, green: 224/255, blue: 224/255, alpha: 1).cgColor
        self.necView.layer.borderWidth = 1
        self.necView.layer.borderColor = borderColor
        
        self.ffaView.layer.borderWidth = 1
        self.ffaView.layer.borderColor = borderColor
        
        self.ltssView.layer.borderWidth = 1
        self.ltssView.layer.borderColor = borderColor
        
        self.eduView.layer.borderWidth = 1
        self.eduView.layer.borderColor = borderColor
        
        self.playView.layer.borderWidth = 1
        self.playView.layer.borderColor = borderColor
        
        self.giveView.layer.borderWidth = 1
        self.giveView.layer.borderColor = borderColor
    }
    
    private func configBarBox() {
        self.necBar.layer.cornerRadius = 5
        self.eduBar.layer.cornerRadius = 5
        self.ffaBar.layer.cornerRadius = 5
        self.ltssBar.layer.cornerRadius = 5
        self.playBar.layer.cornerRadius = 5
        self.giveBar.layer.cornerRadius = 5
    }
    
    private func configViewBox() {
        self.necView.layer.cornerRadius = 5
        self.ffaView.layer.cornerRadius = 5
        self.eduView.layer.cornerRadius = 5
        self.ltssView.layer.cornerRadius = 5
        self.playView.layer.cornerRadius = 5
        self.giveView.layer.cornerRadius = 5
    }

    
    private func configCheckBoxes() {
        self.necCheckBox.onAnimationType = BEMAnimationType.fill
        self.necCheckBox.offAnimationType = BEMAnimationType.fill
        necCheckBox.delegate = self
        
        self.ffaCheckBox.onAnimationType = BEMAnimationType.fill
        self.ffaCheckBox.offAnimationType = BEMAnimationType.fill
        self.ffaCheckBox.delegate = self
        
        self.ltssCheckBox.onAnimationType = BEMAnimationType.fill
        self.ltssCheckBox.offAnimationType = BEMAnimationType.fill
        self.ltssCheckBox.delegate = self
        
        self.eduCheckBox.onAnimationType = BEMAnimationType.fill
        self.eduCheckBox.offAnimationType = BEMAnimationType.fill
        self.eduCheckBox.delegate = self
        
        self.playCheckBox.onAnimationType = BEMAnimationType.fill
        self.playCheckBox.offAnimationType = BEMAnimationType.fill
        self.playCheckBox.delegate = self
        
        self.giveCheckBox.onAnimationType = BEMAnimationType.fill
        self.giveCheckBox.offAnimationType = BEMAnimationType.fill
        self.giveCheckBox.delegate = self
    }
    
    private func show_SwapMoneyBox_ChoosingView() {
        let appearance = configAppearanceAlertView()
        let alertView = SCLAlertView(appearance: appearance)
        
        alertView.addButton(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.NEC), target:self, selector:#selector(AddSpendingNoteViewController.necessities_Acction))
        alertView.addButton(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.FRA), target:self,selector:#selector(AddSpendingNoteViewController.financialFreedomAccount_Acction))
        alertView.addButton(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.LTS), target:self, selector:#selector(AddSpendingNoteViewController.longTermSavings_Acction))
        alertView.addButton(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.EDU), target:self, selector:#selector(AddSpendingNoteViewController.education_Acction))
        alertView.addButton(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.PLAY), target:self, selector:#selector(AddSpendingNoteViewController.play_Acction))
        alertView.addButton(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.GIVE), target:self, selector:#selector(AddSpendingNoteViewController.give_Acction))
        
        alertView.showSuccess(Language.BUILDER.get(group: Group.MESSAGE_TITLE, view: MessageTitle.SWAP_MONEY), subTitle: Language.BUILDER.get(group: Group.MESSAGE, view: Message.CHOOSEBOX_SWAPMONEY))
    }
    
    private func isFindingMaxMoney()->Bool {
        
        var typeJAR = [JARS_TYPE.EDU, JARS_TYPE.FFA, JARS_TYPE.GIVE,
                       JARS_TYPE.LTSS, JARS_TYPE.NEC, JARS_TYPE.PLAY]
    
        if maxMoney == nil {
            for i in 0..<typeJAR.count {
                if let tmpMoney = DAOJars.BUILDER.GetJARS(with: typeJAR[i])?.money {
                    if maxMoney == nil || maxMoney! < tmpMoney {
                        maxMoney = tmpMoney
                    }
                }
            }
        }
        
        if maxMoney == nil {
            let appearance = configAppearanceAlertView()
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("OK", target:self, selector:#selector(noMoney_Acction))
            alertView.showError(Language.BUILDER.get(group: Group.MESSAGE_TITLE, view: MessageTitle.WARNING_MONEY), subTitle: Language.BUILDER.get(group: Group.MESSAGE, view: Message.ALLBOX_NOMONEY))
            
            return false
        }
        return true
    }
    
    private func isGettingMoneyOfBoxIsChoosed(type: JARS_TYPE)->Bool {
        if let tmp = DAOJars.BUILDER.GetJARS(with: type)?.money {
            moneyOfBoxIsChoosed = tmp
            return true
        }
        
        let appearance = configAppearanceAlertView()
        let alertView = SCLAlertView(appearance: appearance)
        
        alertView.addButton("OK", target:self, selector:#selector(noMoney_Acction))
        alertView.showError(Language.BUILDER.get(group: Group.MESSAGE_TITLE, view: MessageTitle.WARNING_MONEY), subTitle: Language.BUILDER.get(group: Group.MESSAGE, view: Message.BOXCHOOED_NOMONEY))
        
        return false
    }
}
