import UIKit
import BEMCheckBox

class SettingsController: UIViewController, BEMCheckBoxDelegate {
    // MARK: *** Local variables
    
    // MARK: *** Data model
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var settingsTitle: UILabel!
    
    @IBOutlet weak var bristishLabel: UILabel!
    @IBOutlet weak var bristishCheckBox: BEMCheckBox!
    
    
    @IBOutlet weak var vietnameseLabel: UILabel!
    @IBOutlet weak var vietnameseCheckBox: BEMCheckBox!
    
    @IBOutlet weak var dollarCheckBox: BEMCheckBox!
    @IBOutlet weak var euroCheckBox: BEMCheckBox!
    @IBOutlet weak var vndCheckBox: BEMCheckBox!
    
    @IBOutlet weak var necTextField: UITextField!
    @IBOutlet weak var ffaTextField: UITextField!
    @IBOutlet weak var ltssTextField: UITextField!
    @IBOutlet weak var eduTextField: UITextField!
    @IBOutlet weak var playTextField: UITextField!
    @IBOutlet weak var giveTextField: UITextField!
    
    
    // MARK: *** UI events
    
    @IBAction func backButton_Tapped(_ sender: AnyObject) {
        _ = DAOJars.BUILDER.UpdatePercent(type: .NEC, percent: Double(necTextField.text!)!)
        _ = DAOJars.BUILDER.UpdatePercent(type: .FFA, percent: Double(ffaTextField.text!)!)
        _ = DAOJars.BUILDER.UpdatePercent(type: .LTSS, percent: Double(ltssTextField.text!)!)
        _ = DAOJars.BUILDER.UpdatePercent(type: .EDU, percent: Double(eduTextField.text!)!)
        _ = DAOJars.BUILDER.UpdatePercent(type: .PLAY, percent: Double(playTextField.text!)!)
        _ = DAOJars.BUILDER.UpdatePercent(type: .GIVE, percent: Double(giveTextField.text!)!)
        
        if ExchangeRate.BUILDER.RateType == .DOLLAR {
            ExchangeRate.BUILDER.Rate = 1
        } else if ExchangeRate.BUILDER.RateType == .EURO {
            ExchangeRate.BUILDER.Rate = 0.89
        } else {
            ExchangeRate.BUILDER.Rate = 22722.50
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func didTap(_ checkBox: BEMCheckBox) {
        if !checkBox.on {
            checkBox.on = true
        }
        switch (checkBox) {
        case self.bristishCheckBox:
            Language.BUILDER.Lang = .ENG
            setContent()
            vietnameseCheckBox.on = false
            break;
        case self.vietnameseCheckBox:
            Language.BUILDER.Lang = .VNI
            setContent()
            bristishCheckBox.on = false
            break
        case self.dollarCheckBox:
            ExchangeRate.BUILDER.RateType = .DOLLAR
            euroCheckBox.on = false
            vndCheckBox.on = false
            break
        case self.euroCheckBox:
            ExchangeRate.BUILDER.RateType = .EURO
            dollarCheckBox.on = false
            vndCheckBox.on = false
            break
        case self.vndCheckBox:
            ExchangeRate.BUILDER.RateType = .VND
            dollarCheckBox.on = false
            euroCheckBox.on = false
            break
        default:
            break
        }
    }
    
    // MARK: *** UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bristishCheckBox.delegate = self
        self.vietnameseCheckBox.delegate = self
        self.dollarCheckBox.delegate = self
        self.euroCheckBox.delegate = self
        self.vndCheckBox.delegate = self
        
        self.necTextField.keyboardType = .decimalPad
        self.ffaTextField.keyboardType = .decimalPad
        self.ltssTextField.keyboardType = .decimalPad
        self.eduTextField.keyboardType = .decimalPad
        self.playTextField.keyboardType = .decimalPad
        self.giveTextField.keyboardType = .decimalPad
        
        self.necTextField.text = String(DAOJars.BUILDER.GetJARS(with: .NEC).percent.round(numberOfDecimal: 2))
        self.ffaTextField.text = String(DAOJars.BUILDER.GetJARS(with: .FFA).percent.round(numberOfDecimal: 2))
        self.ltssTextField.text = String(DAOJars.BUILDER.GetJARS(with: .LTSS).percent.round(numberOfDecimal: 2))
        self.eduTextField.text = String(DAOJars.BUILDER.GetJARS(with: .EDU).percent.round(numberOfDecimal: 2))
        self.playTextField.text = String(DAOJars.BUILDER.GetJARS(with: .PLAY).percent.round(numberOfDecimal: 2))
        self.giveTextField.text = String(DAOJars.BUILDER.GetJARS(with: .GIVE).percent.round(numberOfDecimal: 2))

        if Language.BUILDER.Lang == LangType.ENG {
            self.bristishCheckBox.on = true
        } else {
            self.vietnameseCheckBox.on = true
        }
        
        if ExchangeRate.BUILDER.RateType == .DOLLAR {
            self.dollarCheckBox.on = true
        } else if ExchangeRate.BUILDER.RateType == .EURO {
            self.euroCheckBox.on = true
        } else {
            self.vndCheckBox.on = true
        }
        
        setContent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    private func setContent() {
        self.backButton.setTitle(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.BACK_BUTTON), for: .normal)
        self.settingsTitle.text = Language.BUILDER.get(group: Group.TITLE, view: TitleViews.SETTINGS_TITLE)
        
        self.bristishLabel.text = Language.BUILDER.get(group: Group.LANGUAGE, view: LangTitles.ENG)
        self.vietnameseLabel.text = Language.BUILDER.get(group: Group.LANGUAGE, view: LangTitles.VNI)
    }
}
