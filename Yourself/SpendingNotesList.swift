import UIKit


class SpedingNotesList: BaseViewController, UITabBarControllerDelegate {
    // MARK: *** Local variables
    
    // MARK: *** Data model
    
    
    // MARK: *** Fuction
    
    
    // MARK: *** UI events
    
    @IBAction func addSpendingNote_Tapped(_ sender: AnyObject) {
        let addSpendingNoteView = self.storyboard?.instantiateViewController(withIdentifier: "AddSpendingNoteViewController" ) as! AddSpendingNoteViewController
        self.present(addSpendingNoteView, animated: true, completion: nil)
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
            Language.BUILDER.get(group: Group.TABLE_MENU, view: TableMenuViews.MONEY_ADDING),
            Language.BUILDER.get(group: Group.TABLE_MENU, view: TableMenuViews.STATISTIC),
            Language.BUILDER.get(group: Group.TABLE_MENU, view: TableMenuViews.SYNCHRONUS),
            Language.BUILDER.get(group: Group.TABLE_MENU, view: TableMenuViews.SETTINGS),
            Language.BUILDER.get(group: Group.TABLE_MENU, view: TableMenuViews.LOGOUT)
        ]
        super.iconsForCells = ["Statistics", "Statistics", "Synchronization", "Settings", "Logout"]
        super.indentifiers = ["MoneyAddingController", "SpendingStatistics", "Synchronization", "SettingsController", "GSignInController" ]
        super.notIndentifiers = ["Synchronization"]
        
        super.addCallback(forIdentifier: "GSignInController") {
            GAccount.Instance.SignOut()
        }
        
        super.addCallback(forIdentifier: "Synchronization") {
            DB.Sync() {
                (result) in
                if result {
                    Alert.show(type: 1, title: Language.BUILDER.get(group: Group.MESSAGE_TITLE, view: MessageTitle.NOTICE), msg: Language.BUILDER.get(group: Group.MESSAGE, view: Message.SYNC_SUCCESS), selector:#selector(SpedingNotesList.dont_use), vc: self)
                } else {
                    Alert.show(type: 0, title: Language.BUILDER.get(group: Group.MESSAGE_TITLE, view: MessageTitle.NOTICE), msg: Language.BUILDER.get(group: Group.MESSAGE, view: Message.SYNC_FAIL), selector:#selector(SpedingNotesList.dont_use), vc: self)
                }
            }
        }
        
        
        super.addSlideMenuButton()
    }
    
    @objc private func dont_use() {
        
    }
}
