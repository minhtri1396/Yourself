import UIKit
import BEMCheckBox

class MoneyAddingController: UIViewController, BEMCheckBoxDelegate {
    // MARK: *** Local variables
    
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
    
    // MARK: *** UI events
    @IBAction func backButton_Tapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButton_Tapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
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
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        unitMoneyTitle.text = ExchangeRate.BUILDER.RateType.rawValue
        
        if ExchangeRate.BUILDER.RateType == .VND {
            moneyTextField.keyboardType = UIKeyboardType.numberPad
        } else {
            moneyTextField.keyboardType = UIKeyboardType.decimalPad
        }
            
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
        
        
        
        configCheckBoxes()

        self.necMoney.text = String(ExchangeRate.BUILDER.transfer(price: DAOJars.BUILDER.GetJARS(with: .NEC)!.money).clean)
        self.ffaMoney.text = String(ExchangeRate.BUILDER.transfer(price: DAOJars.BUILDER.GetJARS(with: .FFA)!.money).clean)
        self.ltssMoney.text = String(ExchangeRate.BUILDER.transfer(price: DAOJars.BUILDER.GetJARS(with: .LTSS)!.money).clean)
        self.eduMoney.text = String(ExchangeRate.BUILDER.transfer(price: DAOJars.BUILDER.GetJARS(with: .EDU)!.money).clean)
        self.playMoney.text = String(ExchangeRate.BUILDER.transfer(price: DAOJars.BUILDER.GetJARS(with: .PLAY)!.money).clean)
        self.giveMoney.text = String(ExchangeRate.BUILDER.transfer(price: DAOJars.BUILDER.GetJARS(with: .GIVE)!.money).clean)
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
}
