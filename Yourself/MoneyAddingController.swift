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
        
    }
    
    @IBAction func addButton_Tapped(_ sender: AnyObject) {
        
    }
    
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let borderColor = UIColor(colorLiteralRed: 224/255, green: 224/255, blue: 224/255, alpha: 1).cgColor
        necView.layer.borderWidth = 1
        necView.layer.borderColor = borderColor
        
        ffaView.layer.borderWidth = 1
        ffaView.layer.borderColor = borderColor
        
        ltssView.layer.borderWidth = 1
        ltssView.layer.borderColor = borderColor
        
        eduView.layer.borderWidth = 1
        eduView.layer.borderColor = borderColor
        
        playView.layer.borderWidth = 1
        playView.layer.borderColor = borderColor
        
        giveView.layer.borderWidth = 1
        giveView.layer.borderColor = borderColor
    }
}
