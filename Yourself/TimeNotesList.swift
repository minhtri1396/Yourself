import UIKit

class TimeNotesList: BaseViewController, UITabBarControllerDelegate {
    // MARK: *** Local variables
    
    // MARK: *** Data model
    
    // MARK: *** Function
    
    // MARK: *** UI events
    
    @IBAction func AddNoteTime_Tapped(_ sender: AnyObject) {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let addNoteView = mainStoryboard.instantiateViewController(withIdentifier: "TimeNoteAddingController") as! TimeNoteAddingController
        self.present(addNoteView, animated: true, completion: nil)
    }
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.titlesForCells = [
            Language.BUILDER.get(group: Group.TABLE_MENU, view: TableMenuViews.STATISTIC),
            Language.BUILDER.get(group: Group.TABLE_MENU, view: TableMenuViews.SYNCHRONUS),
            Language.BUILDER.get(group: Group.TABLE_MENU, view: TableMenuViews.SETTINGS),
            Language.BUILDER.get(group: Group.TABLE_MENU, view: TableMenuViews.LOGOUT)
        ]
        super.iconsForCells = ["Statistics", "Synchronization", "Settings", "Logout"]
        super.indentifiers = ["SpendingStatistics", "Synchronization", "SettingsController", "GSignInController" ]
        super.notIndentifiers = ["Synchronization"]
        
        super.addCallback(forIdentifier: "GSignInController") {
            GAccount.Instance.SignOut()
        }
        
        super.addCallback(forIdentifier: "Synchronization") {
            DB.Sync() {
                (result) in
                if result {
                    Alert.show(title: "Success", msg: "Sync completed!", vc: self)
                } else {
                    Alert.show(title: "Failure", msg: "Sync failed!", vc: self)
                }
            }
        }
        
        
        super.addSlideMenuButton()
    }
    
}
