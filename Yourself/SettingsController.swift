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
    
    private func setContent() {
        self.backButton.setTitle(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.BACK_BUTTON), for: .normal)
        self.settingsTitle.text = Language.BUILDER.get(group: Group.TITLE, view: TitleViews.SETTINGS_TITLE)
    }
    
    @IBAction func backButton_Tapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didTap(_ checkBox: BEMCheckBox) {
        checkBox.on = true
        switch (checkBox) {
        case self.bristishCheckBox:
            vietnameseCheckBox.on = false
            break;
        case self.vietnameseCheckBox:
            bristishCheckBox.on = false
            break
        case self.dollarCheckBox:
            euroCheckBox.on = false
            vndCheckBox.on = false
            break
        case self.euroCheckBox:
            dollarCheckBox.on = false
            vndCheckBox.on = false
            break
        case self.vndCheckBox:
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
        
        bristishCheckBox.delegate = self
        vietnameseCheckBox.delegate = self
        dollarCheckBox.delegate = self
        euroCheckBox.delegate = self
        vndCheckBox.delegate = self

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
}
