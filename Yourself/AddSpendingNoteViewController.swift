import UIKit
import SCLAlertView
import BEMCheckBox

class AddSpendingNoteViewController: UIViewController, UITextFieldDelegate, BEMCheckBoxDelegate {
    
    // MARK: *** Local variables
    var keyboard: Keyboard?
    
    var moneyOfBoxIsChoosed: Double = 0
    var moneyOfBoxReplace: Double = 0
    var maxMoney: Double = 0
    
    var type: JARS_TYPE? = nil
    var typeReplace: JARS_TYPE? = nil
    
    private var preCheckBox: BEMCheckBox?
    
    
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
    
    
    @IBOutlet weak var typeMoney: UILabel!
    @IBOutlet weak var reaplaceMoney: UILabel!
    
    
    // MARK: *** UI events
    
    @IBAction func doneButton_Tapped(_ sender: AnyObject) {
        if (self.textField_GivingMoney.text?.characters.count)! > 0 {
           
            // cap nhat tien
            
            let timestamp = Date().ticks
            let moneyGiving = Double(self.textField_GivingMoney.text!)!
            let getMoneyIfHaving = moneyOfBoxIsChoosed - moneyGiving
           
            _ = DAOIntent.BUILDER.Add(DTOIntent(timestamp: timestamp, type: type!, content: self.textField_Notes.text!, money: moneyGiving))
            
            if typeReplace != nil {
                moneyOfBoxReplace = moneyOfBoxReplace - (-getMoneyIfHaving)
                _ = DAOJars.BUILDER.UpdateMoney(type: typeReplace!, money: moneyOfBoxReplace)
                moneyOfBoxIsChoosed = 0
            }
            else {
                typeReplace = type
                moneyOfBoxReplace = 0
            }
            
            _ = DAOJars.BUILDER.UpdateMoney(type: type!, money: moneyOfBoxReplace)
            
            _ = DAOAlternatives.BUILDER.Add(DTOAlternatives(timestamp: timestamp, owner: type!, alts: typeReplace!, money: moneyOfBoxReplace))
        }
    }
    
    
    @IBAction func backButton_Tapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if maxMoney == 0 {
            Alert.show(type: ALERT_TYPE.ERROR, title: Language.BUILDER.get(group: Group.MESSAGE_TITLE, view: MessageTitle.WARNING_MONEY), msg: Language.BUILDER.get(group: Group.MESSAGE, view: Message.ALLBOX_NOMONEY))
            textField.resignFirstResponder()
            return false
        }
        
        if (textField.text?.characters.count)! > 0 {
            if Double((textField.text! + string))! > maxMoney {
                textField.text = maxMoney.clean
            }
        }
        
        return true
    }
   
    
    func didTap(_ checkBox: BEMCheckBox) {
        if self.textField_GivingMoney.text! == "" {
            Alert.show(type: ALERT_TYPE.ERROR,
                       title: Language.BUILDER.get(group: Group.MESSAGE_TITLE, view: MessageTitle.WARNING_MONEY),
                       msg: Language.BUILDER.get(group: Group.MESSAGE, view: Message.GIVINGMONEY_EMPTY))
            checkBox.on = false
            return
        }
        
        if (checkBox.on) {
            
            setUnCheckForAllBox(checkBox: checkBox)
            
            if maxMoney != 0 {
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
                
                if isGettingMoneyOfBoxIsChoosed(type: type!) {
                    if Double(self.textField_GivingMoney.text!)! > maxMoney {
                        
                    }
                    else {
                        if Double(self.textField_GivingMoney.text!)! > moneyOfBoxIsChoosed {
                            show_SwapMoneyBox_ChoosingView(type: type!)
                        }
                    }
                }
            }
            else {
                Alert.show(type: ALERT_TYPE.ERROR,
                           title: Language.BUILDER.get(group: Group.MESSAGE_TITLE, view: MessageTitle.WARNING_MONEY), msg: Language.BUILDER.get(group: Group.MESSAGE, view: Message.ALLBOX_NOMONEY))
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
    
    //----------- No money massage box
    
    func non_Acction() {
       
    }
    
    
    
    //----------- Choose box to replace message box
    
    func necessities_Acction() {
        typeReplace = .NEC
        show_LabelNotification(labelMoneyOfGettingBox: self.necMoney, nameBox: Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.NEC))
    }
    
    func financialFreedomAccount_Acction() {
        typeReplace = .FFA
        show_LabelNotification(labelMoneyOfGettingBox: self.ffaMoney, nameBox: Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.FRA))
    }
    
    func longTermSavings_Acction() {
        typeReplace = .LTSS
        show_LabelNotification(labelMoneyOfGettingBox: self.ltssMoney, nameBox: Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.LTS))
    }
    
    func education_Acction() {
        typeReplace = .EDU
        show_LabelNotification(labelMoneyOfGettingBox: self.eduMoney, nameBox: Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.EDU))
    }
    
    func play_Acction() {
        typeReplace = .PLAY
        show_LabelNotification(labelMoneyOfGettingBox: self.playMoney, nameBox: Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.PLAY))
    }
    
    func give_Acction() {
        typeReplace = .GIVE
        show_LabelNotification(labelMoneyOfGettingBox: self.giveMoney, nameBox: Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.GIVE))
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
        self.textField_GivingMoney.delegate = self
        
        
        configBarBox()
        configViewBox()
        configBorderBox()
        configCheckBoxes()
        configLanguge()
        configLabelMoney()
        configLabelNotification()
        
        maxMoney = getMaxMoney()
        
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
        self.textField_GivingMoney.placeholder = Language.BUILDER.get(group: Group.PLACEHOLDER, view: PlaceholderViews.TYPE_MONEY)
        self.textField_Notes.placeholder = Language.BUILDER.get(group: Group.PLACEHOLDER, view: PlaceholderViews.TYPE_NOTE)
        
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
    
    private func configLabelMoney() {
        self.necMoney.text = String(Int(ExchangeRate.BUILDER.transfer(price: DAOJars.BUILDER.GetJARS(with: .NEC).money)))
        self.ffaMoney.text = String(Int(ExchangeRate.BUILDER.transfer(price: DAOJars.BUILDER.GetJARS(with: .FFA).money)))
        self.ltssMoney.text = String(Int(ExchangeRate.BUILDER.transfer(price: DAOJars.BUILDER.GetJARS(with: .LTSS).money)))
        self.eduMoney.text = String(Int(ExchangeRate.BUILDER.transfer(price: DAOJars.BUILDER.GetJARS(with: .EDU).money)))
        self.playMoney.text = String(Int(ExchangeRate.BUILDER.transfer(price: DAOJars.BUILDER.GetJARS(with: .PLAY).money)))
        self.giveMoney.text = String(Int(ExchangeRate.BUILDER.transfer(price: DAOJars.BUILDER.GetJARS(with: .GIVE).money)))
    }
    
    private func configLabelNotification() {
        if ExchangeRate.BUILDER.RateType == .VND {
            self.typeMoney.text = "VND"
        }
        else if ExchangeRate.BUILDER.RateType == .EURO {
            self.typeMoney.text = "EURO"
        }
        else {
            self.typeMoney.text = "DOLLAR"
        }
        
        self.reaplaceMoney.isHidden = true
        self.reaplaceMoney.text = Language.BUILDER.get(group: Group.TITLE, view: TitleViews.REPLACE)
    }
    
    private func setUnCheckForAllBox(checkBox: BEMCheckBox) {
        
        if preCheckBox != nil {
            preCheckBox?.on = false
            
            switch (preCheckBox!) {
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
        
        preCheckBox = checkBox
    }
  
    private func show_LabelNotification(labelMoneyOfGettingBox: UILabel, nameBox: String) {
        moneyOfBoxReplace = Double(labelMoneyOfGettingBox.text!)! - Double(self.textField_GivingMoney.text!)!
        labelMoneyOfGettingBox.text = moneyOfBoxReplace.clean
        self.reaplaceMoney.isHidden = false
        self.reaplaceMoney.text = self.reaplaceMoney.text! + " " + nameBox + " " + moneyOfBoxReplace.clean
    }
    
    private func show_SwapMoneyBox_ChoosingView(type: JARS_TYPE) {
        let appearance = configAppearanceAlertView()
        let alertView = SCLAlertView(appearance: appearance)
        
        var currentUnit = "VND"
        if ExchangeRate.BUILDER.RateType == .DOLLAR {
            currentUnit = "$"
        } else if ExchangeRate.BUILDER.RateType == .EURO {
            currentUnit = "EURO"
        }
        
        if type != .NEC {
            alertView.addButton(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.NEC) + " (" + self.necMoney.text! + " " + currentUnit + ")", target:self, selector:#selector(AddSpendingNoteViewController.necessities_Acction))
        }
        if type != .FFA {
            alertView.addButton(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.FRA) + " (" + self.ffaMoney.text! + " " + currentUnit + ")", target:self,selector:#selector(AddSpendingNoteViewController.financialFreedomAccount_Acction))
        }
        if type != .LTSS {
            alertView.addButton(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.LTS) + " (" + self.ltssMoney.text! + " " + currentUnit + ")", target:self, selector:#selector(AddSpendingNoteViewController.longTermSavings_Acction))
        }
        if type != .EDU {
            alertView.addButton(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.EDU) + " (" + self.eduMoney.text! + " " + currentUnit + ")", target:self, selector:#selector(AddSpendingNoteViewController.education_Acction))
        }
        if type != .PLAY {
            alertView.addButton(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.PLAY) + " (" + self.playMoney.text! + " " + currentUnit + ")", target:self, selector:#selector(AddSpendingNoteViewController.play_Acction))
        }
        if type != .GIVE {
            alertView.addButton(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.GIVE) + " (" + self.giveMoney.text! + " " + currentUnit + ")", target:self, selector:#selector(AddSpendingNoteViewController.give_Acction))
        }
        
        alertView.addButton(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.CANCEL), target:self, selector:#selector(AddSpendingNoteViewController.non_Acction))
        
        alertView.showInfo(Language.BUILDER.get(group: Group.MESSAGE_TITLE, view: MessageTitle.SWAP_MONEY), subTitle: Language.BUILDER.get(group: Group.MESSAGE, view: Message.CHOOSEBOX_SWAPMONEY))
    }
    
    private func getMaxMoney()->Double {
        
        var typeJAR = [JARS_TYPE.EDU, JARS_TYPE.FFA, JARS_TYPE.GIVE,
                       JARS_TYPE.LTSS, JARS_TYPE.NEC, JARS_TYPE.PLAY]
        var max_Money:Double = 0
    
        for i in 0..<typeJAR.count {
            let tmp = ExchangeRate.BUILDER.transfer(price: DAOJars.BUILDER.GetJARS(with: typeJAR[i]).money)
            if max_Money < tmp {
                max_Money = tmp
            }
        }
        
        return max_Money
    }
    
    private func isGettingMoneyOfBoxIsChoosed(type: JARS_TYPE)->Bool {
        moneyOfBoxIsChoosed = ExchangeRate.BUILDER.transfer(price: DAOJars.BUILDER.GetJARS(with: type).money)
        if (moneyOfBoxIsChoosed != 0) {
            return true
        }
        
        Alert.show(type: ALERT_TYPE.ERROR, title: Language.BUILDER.get(group: Group.MESSAGE_TITLE, view: MessageTitle.WARNING_MONEY), msg: Language.BUILDER.get(group: Group.MESSAGE, view: Message.BOXCHOOED_NOMONEY))
        
        return false
    }
}
