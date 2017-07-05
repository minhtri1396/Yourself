import UIKit
import BEMCheckBox
import SCLAlertView

class MoneyAddingController: UIViewController, BEMCheckBoxDelegate {
    // MARK: *** Local variables
    
    private var keyboard: Keyboard?
    
    // MARK: *** Data model
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var unitMoneyTitle: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var moneyTextField: UITextField!
    
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
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: *** UI events
    @IBAction func backButton_Tapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButton_Tapped(_ sender: AnyObject) {
        if let jarsTypes = isCompleted() {
            let moneys = calcMoneyForJars(jarsTypes: jarsTypes)
            
            var money: Double
            for i in 0..<jarsTypes.count {
                money = moneys[i] + DAOJars.BUILDER.GetJARS(with: jarsTypes[i]).money
                if (!DAOJars.BUILDER.Add(DTOJars(type: jarsTypes[i], money: money))) {
                    _ = DAOJars.BUILDER.UpdateMoney(type: jarsTypes[i], money: money)
                }
            }
            
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func didTap(_ checkBox: BEMCheckBox) {
        if (checkBox.on) {
            switch (checkBox) {
            case self.necCheckBox:
                self.necMoney.isHidden = true
                break;
            case self.ffaCheckBox:
                self.ffaMoney.isHidden = true
                break;
            case self.ltssCheckBox:
                self.ltssMoney.isHidden = true
                break;
            case self.eduCheckBox:
                self.eduMoney.isHidden = true
                break;
            case self.playCheckBox:
                self.playMoney.isHidden = true
                break;
            default:
                self.giveMoney.isHidden = true
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
            }
        }
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
        
        unitMoneyTitle.text = "(" + ExchangeRate.BUILDER.RateType.rawValue + ")"
        
        // Set keyboard type
        if ExchangeRate.BUILDER.RateType == .VND {
            moneyTextField.keyboardType = UIKeyboardType.numberPad
        } else {
            moneyTextField.keyboardType = UIKeyboardType.decimalPad
        }
        
        // Set border for jars
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
        
        self.moneyTextField.placeholder = Language.BUILDER.get(group: Group.PLACEHOLDER, view: PlaceholderViews.TYPE_MONEY)
        
        keyboard = Keyboard(arrTextField: [self.moneyTextField])
        keyboard?.createDoneButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
        configCheckBoxes()
        setContent()
    }
    
    private func configCheckBoxes() {
        self.necCheckBox.onAnimationType = BEMAnimationType.fill
        self.necCheckBox.offAnimationType = BEMAnimationType.fill
        self.necCheckBox.delegate = self
        
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
    
    private func setContent() {
        self.backButton.setTitle(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.BACK_BUTTON), for: .normal)
        self.doneButton.setTitle(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.DONE), for: .normal)
        self.titleLabel.text = Language.BUILDER.get(group: Group.TITLE, view: TitleViews.MONEY_ADDING_TITLE)
        self.moneyTextField.placeholder = Language.BUILDER.get(group: Group.PLACEHOLDER, view: PlaceholderViews.TYPE_MONEY_JARS)
        
        // Set money for jars
        self.necMoney.text = String(ExchangeRate.BUILDER.transfer(price: DAOJars.BUILDER.GetJARS(with: .NEC).money).clean)
        self.ffaMoney.text = String(ExchangeRate.BUILDER.transfer(price: DAOJars.BUILDER.GetJARS(with: .FFA).money).clean)
        self.ltssMoney.text = String(ExchangeRate.BUILDER.transfer(price: DAOJars.BUILDER.GetJARS(with: .LTSS).money).clean)
        self.eduMoney.text = String(ExchangeRate.BUILDER.transfer(price: DAOJars.BUILDER.GetJARS(with: .EDU).money).clean)
        self.playMoney.text = String(ExchangeRate.BUILDER.transfer(price: DAOJars.BUILDER.GetJARS(with: .PLAY).money).clean)
        self.giveMoney.text = String(ExchangeRate.BUILDER.transfer(price: DAOJars.BUILDER.GetJARS(with: .GIVE).money).clean)
    }
    
    private func isCompleted() -> [JARS_TYPE]? {
        if let _ = Double(moneyTextField.text!) {
            var jarsTypes = [JARS_TYPE]()
            if self.necCheckBox.on {
                jarsTypes.append(JARS_TYPE.NEC)
            }
            
            if self.ffaCheckBox.on {
                jarsTypes.append(JARS_TYPE.FFA)
            }
            
            if self.ltssCheckBox.on {
                jarsTypes.append(JARS_TYPE.LTSS)
            }
            
            if self.eduCheckBox.on {
                jarsTypes.append(JARS_TYPE.EDU)
            }
            
            if self.playCheckBox.on {
                jarsTypes.append(JARS_TYPE.PLAY)
            }
            
            if self.giveCheckBox.on {
                jarsTypes.append(JARS_TYPE.GIVE)
            }
            
            if jarsTypes.count > 0 {
                return jarsTypes
            }
            
            Alert.show(type: ALERT_TYPE.INFO, title: "", msg: Language.BUILDER.get(group: Group.MESSAGE, view: Message.CHOOSE_JAR))
        } else {
            Alert.show(type: ALERT_TYPE.INFO, title: "", msg: Language.BUILDER.get(group: Group.MESSAGE, view: Message.SET_MONEY))
        }
        
        return nil
    }
    
    private func calcMoneyForJars(jarsTypes: [JARS_TYPE]) -> [Double] {
        var percentSum: Double = 0
        for type in jarsTypes {
            percentSum.add(DAOJars.BUILDER.GetJARS(with: type).percent)
        }
        
        var moneys = [Double]()
        var moneySum: Double = 0
        
        let money =  ExchangeRate.BUILDER.calcMoneyForDB(money: Double(moneyTextField.text!)!)
        
        var jars: DTOJars
        for type in jarsTypes {
            jars = DAOJars.BUILDER.GetJARS(with: type)
            moneys.append((money * jars.percent) / percentSum)
            moneySum += moneys[moneys.count - 1]
        }
        
        if moneySum != money {
            moneys[moneys.count - 1] += money - moneySum
        }
        
        return moneys
    }
}
