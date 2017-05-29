import UIKit

class SettingsController: UIViewController {
    // MARK: *** Local variables
    
    // MARK: *** Data model
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var settingsTitle: UILabel!
    @IBOutlet weak var languageTitle: UILabel!
    @IBOutlet weak var differenceSettingsTitle: UILabel!
    @IBOutlet weak var bristishFlag: UIView!
    @IBOutlet weak var vietnamFlag: UIView!
    
    
    // MARK: *** UI events
    
    private func setContent() {
        self.backButton.setTitle(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.BACK_BUTTON), for: .normal)
        self.settingsTitle.text = Language.BUILDER.get(group: Group.TITLE, view: TitleViews.SETTINGS_TITLE)
        self.languageTitle.text = Language.BUILDER.get(group: Group.TITLE, view: TitleViews.LANGUAGE_TITLE)
        self.differenceSettingsTitle.text = Language.BUILDER.get(group: Group.TITLE, view: TitleViews.DIFERENCE_SETTINGS_TITLE)
    }
    
    @IBAction func BristishTapGusture_Tapped(_ sender: AnyObject) {
        self.bristishFlag.isHidden = true
        self.vietnamFlag.isHidden = false
        Language.BUILDER.Lang = LangType.ENG
        setContent()
    }
    
    @IBAction func VietNamTapGusture_Tapped(_ sender: AnyObject) {
        self.bristishFlag.isHidden = false
        self.vietnamFlag.isHidden = true
        Language.BUILDER.Lang = LangType.VNI
        setContent()
    }
    
    @IBAction func BackButton_Tapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: *** UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        if Language.BUILDER.Lang == LangType.ENG {
            self.bristishFlag.isHidden = true
        } else {
            self.vietnamFlag.isHidden = true
        }
        setContent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
