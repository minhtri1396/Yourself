import UIKit
import BEMCheckBox

class SettingsController: UIViewController, BEMCheckBoxDelegate {
    // MARK: *** Local variables
    
    var necPercent: Double = 0
    var ffaPercent: Double = 0
    var ltssPercent: Double = 0
    var eduPercent: Double = 0
    var playPercent: Double = 0
    var givePercent: Double = 0
    
    
    // MARK: *** Data model
    
    @IBOutlet weak var defaultButton: UIButton!
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
    
    
    @IBOutlet weak var necLabel: UILabel!
    @IBOutlet weak var ffaLabel: UILabel!
    @IBOutlet weak var ltssLabel: UILabel!
    @IBOutlet weak var eduLabel: UILabel!
    @IBOutlet weak var playLabel: UILabel!
    @IBOutlet weak var giveLabel: UILabel!
    
    @IBOutlet weak var necSlider: UISlider!
    @IBOutlet weak var ffaSlider: UISlider!
    @IBOutlet weak var ltssSlider: UISlider!
    @IBOutlet weak var eduSlider: UISlider!
    @IBOutlet weak var playSlider: UISlider!
    @IBOutlet weak var giveSlider: UISlider!
    
    
    
    
    // MARK: *** UI events
    
    func _necComponentChangedValue(sender: UISlider!) {
        let newValue = ceil((sender.value + 2.5) / 5) * 5
        calculusJARSPercent(type: .NEC, deviantValue: newValue - Float(necPercent))
        setValueForNEC(newValue: Double(newValue))
        roundPercentJAR()
    }
    
    func _ffaComponentChangedValue(sender: UISlider!) {
        let newValue = Int((sender.value + 2.5) / 5) * 5
        calculusJARSPercent(type: .FFA, deviantValue: Float(newValue) - Float(ffaPercent))
        setValueForFFA(newValue: Double(newValue))
        roundPercentJAR()
    }
    
    
    func _ltssComponentChangedValue(sender: UISlider!) {
        let newValue = Int((sender.value + 2.5) / 5) * 5
        calculusJARSPercent(type: .LTSS, deviantValue: Float(newValue) - Float(ltssPercent))
        setValueForLTSS(newValue: Double(newValue))
        roundPercentJAR()
    }
    
    
    func _eduComponentChangedValue(sender: UISlider!) {
        let newValue = Int((sender.value + 2.5) / 5) * 5
        calculusJARSPercent(type: .EDU, deviantValue: Float(newValue) - Float(eduPercent))
        setValueForEDU(newValue: Double(newValue))
        roundPercentJAR()
    }
    
    
    func _playComponentChangedValue(sender: UISlider!) {
        let newValue = Int((sender.value + 2.5) / 5) * 5
        calculusJARSPercent(type: .PLAY, deviantValue: Float(newValue) - Float(playPercent))
        setValueForPLAY(newValue: Double(newValue))
        roundPercentJAR()
    }
    
    
    func _giveComponentChangedValue(sender: UISlider!) {
        let newValue = Int((sender.value + 2.5) / 5) * 5
        calculusJARSPercent(type: .GIVE, deviantValue: Float(newValue) - Float(givePercent))
        setValueForGIVE(newValue: Double(newValue))
        roundPercentJAR()
    }
    
    
    
    @IBAction func defaultButton_Tapped(_ sender: AnyObject) {
        Language.BUILDER.Lang = .VNI
        vietnameseCheckBox.on = true
        bristishCheckBox.on = false
        
        ExchangeRate.BUILDER.RateType = .DOLLAR
        vndCheckBox.on = false
        dollarCheckBox.on = true
        euroCheckBox.on = false
        
        setValueForNEC(newValue: 55.0)
        setValueForFFA(newValue: 10.0)
        setValueForLTSS(newValue: 10.0)
        setValueForEDU(newValue: 10.0)
        setValueForPLAY(newValue: 10.0)
        setValueForGIVE(newValue: 5.0)
        
        setLanguage()
    }
    
    
    @IBAction func backButton_Tapped(_ sender: AnyObject) {
        _ = DAOJars.BUILDER.UpdatePercent(type: .NEC, percent: necPercent / 100)
        _ = DAOJars.BUILDER.UpdatePercent(type: .FFA, percent: ffaPercent / 100)
        _ = DAOJars.BUILDER.UpdatePercent(type: .LTSS, percent: ltssPercent / 100)
        _ = DAOJars.BUILDER.UpdatePercent(type: .EDU, percent: eduPercent / 100)
        _ = DAOJars.BUILDER.UpdatePercent(type: .PLAY, percent: playPercent / 100)
        _ = DAOJars.BUILDER.UpdatePercent(type: .GIVE, percent: givePercent / 100)
        
        if ExchangeRate.BUILDER.RateType == .DOLLAR {
            ExchangeRate.BUILDER.Rate = 1
        } else if ExchangeRate.BUILDER.RateType == .EURO {
            ExchangeRate.BUILDER.Rate = 0.89
        } else {
            ExchangeRate.BUILDER.Rate = 22722.50
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: *** UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Get JARS percent */
        
        necPercent = DAOJars.BUILDER.GetJARS(with: .NEC).percent.round(numberOfDecimal: 2) * 100
        ffaPercent = DAOJars.BUILDER.GetJARS(with: .FFA).percent.round(numberOfDecimal: 2) * 100
        ltssPercent = DAOJars.BUILDER.GetJARS(with: .LTSS).percent.round(numberOfDecimal: 2) * 100
        eduPercent = DAOJars.BUILDER.GetJARS(with: .EDU).percent.round(numberOfDecimal: 2) * 100
        playPercent = DAOJars.BUILDER.GetJARS(with: .PLAY).percent.round(numberOfDecimal: 2) * 100
        givePercent = DAOJars.BUILDER.GetJARS(with: .GIVE).percent.round(numberOfDecimal: 2) * 100
        
        
        configCheckbox()
        configTextField()
        configSlider()
        
        setLanguage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: *** Function
    
    func didTap(_ checkBox: BEMCheckBox) {
        if !checkBox.on {
            checkBox.on = true
        }
        switch (checkBox) {
        case self.bristishCheckBox:
            Language.BUILDER.Lang = .ENG
            setLanguage()
            vietnameseCheckBox.on = false
            break;
        case self.vietnameseCheckBox:
            Language.BUILDER.Lang = .VNI
            setLanguage()
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

    
    private func calculusJARSPercent(type: JARS_TYPE, deviantValue: Float) {
        let delta = -(deviantValue / 5)
        
        setValueForNEC(newValue: necPercent + Double(delta))
        setValueForFFA(newValue: ffaPercent + Double(delta))
        setValueForLTSS(newValue: ltssPercent + Double(delta))
        setValueForEDU(newValue: eduPercent + Double(delta))
        setValueForPLAY(newValue: playPercent + Double(delta))
        setValueForGIVE(newValue: givePercent + Double(delta))
    }
    
    private func setValueForNEC(newValue: Double) {
        var value = newValue
        
        if value < 0 {
            value = 0
            solveNegativePercentJAR(JAR_TYPEMAX: findJARPercentMax(JAR_TYPE_NOW: .NEC)!, value: value)
        }
        
        necPercent = value
        
        self.necSlider.value = Float(value)
        self.necTextField.text = String(Int(value))
    }
    
    private func setValueForFFA(newValue: Double) {
        var value = newValue
        
        if value < 0 {
            solveNegativePercentJAR(JAR_TYPEMAX: findJARPercentMax(JAR_TYPE_NOW: .FFA)!, value: value)
            value = 0
        }
        
        ffaPercent = value
        
        self.ffaSlider.value = Float(value)
        self.ffaTextField.text = String(Int(value))
    }
    
    private func setValueForLTSS(newValue: Double) {
        var value = newValue
        
        if value < 0 {
            solveNegativePercentJAR(JAR_TYPEMAX: findJARPercentMax(JAR_TYPE_NOW: .LTSS)!, value: value)
            value = 0
        }
        
        ltssPercent = value
        
        self.ltssSlider.value = Float(value)
        self.ltssTextField.text = String(Int(value))
    }
    
    private func setValueForEDU(newValue: Double) {
        var value = newValue

        if value < 0 {
            solveNegativePercentJAR(JAR_TYPEMAX: findJARPercentMax(JAR_TYPE_NOW: .EDU)!, value: value)
            value = 0
        }
        
        eduPercent = value
        
        self.eduSlider.value = Float(value)
        self.eduTextField.text = String(Int(value))
    }
    
    private func setValueForPLAY(newValue: Double) {
        var value = newValue
        
        if value < 0 {
            solveNegativePercentJAR(JAR_TYPEMAX: findJARPercentMax(JAR_TYPE_NOW: .PLAY)!, value: value)
            value = 0
        }
        
        playPercent = value
        
        self.playSlider.value = Float(value)
        self.playTextField.text = String(Int(value))
    }
    
    private func setValueForGIVE(newValue: Double) {
        var value = newValue
        
        if value < 0 {
            solveNegativePercentJAR(JAR_TYPEMAX: findJARPercentMax(JAR_TYPE_NOW: .GIVE)!, value: value)
            value = 0
        }
        
        givePercent = value
        
        self.giveSlider.value = Float(value)
        self.giveTextField.text = String(Int(value))
    }
   
    
    private func setLanguage() {
        self.backButton.setTitle(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.BACK_BUTTON), for: .normal)
        self.defaultButton.setTitle(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.DEFAULT), for: .normal)
        self.settingsTitle.text = Language.BUILDER.get(group: Group.TITLE, view: TitleViews.SETTINGS_TITLE)
        self.bristishLabel.text = Language.BUILDER.get(group: Group.LANGUAGE, view: LangTitles.ENG)
        self.vietnameseLabel.text = Language.BUILDER.get(group: Group.LANGUAGE, view: LangTitles.VNI)
        
        self.necLabel.text = Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.NEC)
        self.ffaLabel.text = Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.FRA)
        self.ltssLabel.text = Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.LTS)
        self.eduLabel.text = Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.EDU)
        self.playLabel.text = Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.PLAY)
        self.giveLabel.text = Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.GIVE)
    }
    
    private func findJARPercentMax(JAR_TYPE_NOW: JARS_TYPE)->JARS_TYPE? {
        var max:Double = -1
        var typeMax:JARS_TYPE?
        
        if max < necPercent && JAR_TYPE_NOW != .NEC {
            max = necPercent
            typeMax = .NEC
        }
        
        if max < ffaPercent && JAR_TYPE_NOW != .FFA {
            max = ffaPercent
            typeMax = .FFA
        }
        
        if max < ltssPercent && JAR_TYPE_NOW != .LTSS {
            max = ltssPercent
            typeMax = .LTSS
        }
        
        if max < eduPercent && JAR_TYPE_NOW != .EDU{
            max = eduPercent
            typeMax = .EDU
        }
        
        if max < playPercent && JAR_TYPE_NOW != .PLAY {
            max = playPercent
            typeMax = .PLAY
        }
        
        if max < givePercent && JAR_TYPE_NOW != .GIVE{
            max = givePercent
            typeMax = .GIVE
        }
        
        return typeMax
    }
    
    private func solveNegativePercentJAR(JAR_TYPEMAX: JARS_TYPE, value: Double) {
        if JAR_TYPEMAX == .NEC {
            setValueForNEC(newValue: necPercent + value)
        }
        else if JAR_TYPEMAX == .FFA {
            setValueForFFA(newValue: ffaPercent + value)
        }
        else if JAR_TYPEMAX == .LTSS {
            setValueForLTSS(newValue: ltssPercent + value)
        }
        else if JAR_TYPEMAX == .EDU {
            setValueForEDU(newValue: eduPercent + value)
        }
        else if JAR_TYPEMAX == .PLAY {
            setValueForPLAY(newValue: playPercent + value)
        }
        else if JAR_TYPEMAX == .GIVE {
            setValueForGIVE(newValue: givePercent + value)
        }
    }
    
    private func roundPercentJAR() {
        let check = 100 - Int(necPercent) - Int(ffaPercent) - Int(ltssPercent) - Int(eduPercent) - Int(playPercent) - Int(givePercent)
        
        if check != 0 {
            setValueForGIVE(newValue: givePercent + Double(check))
        }
    }
    
    private func configSlider() {
        self.necSlider.value = Float(necPercent)
        self.ffaSlider.value = Float(ffaPercent)
        self.ltssSlider.value = Float(ltssPercent)
        self.eduSlider.value = Float(eduPercent)
        self.playSlider.value = Float(playPercent)
        self.giveSlider.value = Float(givePercent)
        
        self.necSlider.isContinuous = false
        self.ffaSlider.isContinuous = false
        self.ltssSlider.isContinuous = false
        self.eduSlider.isContinuous = false
        self.playSlider.isContinuous = false
        self.giveSlider.isContinuous = false
        
        
        self.necSlider.addTarget(self, action:  #selector(_necComponentChangedValue),for: .valueChanged)
        self.ffaSlider.addTarget(self, action:  #selector(_ffaComponentChangedValue),for: .valueChanged)
        self.ltssSlider.addTarget(self, action:  #selector(_ltssComponentChangedValue),for: .valueChanged)
        self.eduSlider.addTarget(self, action:  #selector(_eduComponentChangedValue),for: .valueChanged)
        self.playSlider.addTarget(self, action:  #selector(_playComponentChangedValue),for: .valueChanged)
        self.giveSlider.addTarget(self, action:  #selector(_giveComponentChangedValue),for: .valueChanged)
    }
    
    private func configCheckbox() {
        self.bristishCheckBox.delegate = self
        self.vietnameseCheckBox.delegate = self
        self.dollarCheckBox.delegate = self
        self.euroCheckBox.delegate = self
        self.vndCheckBox.delegate = self
        
        
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
    }
    
    private func configTextField() {
        self.necTextField.isEnabled = false
        self.ffaTextField.isEnabled = false
        self.ltssTextField.isEnabled = false
        self.eduTextField.isEnabled = false
        self.playTextField.isEnabled = false
        self.giveTextField.isEnabled = false
        
        self.necTextField.keyboardType = .decimalPad
        self.ffaTextField.keyboardType = .decimalPad
        self.ltssTextField.keyboardType = .decimalPad
        self.eduTextField.keyboardType = .decimalPad
        self.playTextField.keyboardType = .decimalPad
        self.giveTextField.keyboardType = .decimalPad
        
        self.necTextField.text = String(necPercent)
        self.ffaTextField.text = String(ffaPercent)
        self.ltssTextField.text = String(ltssPercent)
        self.eduTextField.text = String(eduPercent)
        self.playTextField.text = String(playPercent)
        self.giveTextField.text = String(givePercent)
    }
}
