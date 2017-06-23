import UIKit


class SpedingNotesList: BaseViewController {
    // MARK: *** Local variables
    
    // MARK: *** Data model
    
    // MARK: *** UI events
    
    @IBAction func addSpendingNote_Tapped(_ sender: AnyObject) {
        let addSpendingNoteView = self.storyboard?.instantiateViewController(withIdentifier: "AddSpendingNoteViewController" ) as! AddSpendingNoteViewController
        self.present(addSpendingNoteView, animated: true, completion: nil)
    }
    
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.titlesForCells = [Language.BUILDER.get(group: Group.TABLE_MENU, view: TableMenuViews.STATISTIC), Language.BUILDER.get(group: Group.TABLE_MENU, view: TableMenuViews.SYNCHRONUS), Language.BUILDER.get(group: Group.TABLE_MENU, view: TableMenuViews.SETTINGS), Language.BUILDER.get(group: Group.TABLE_MENU, view: TableMenuViews.LOGOUT)]
        self.iconsForCells = ["Statistics", "Synchronization", "Settings", "Logout"]
        self.indentifiers = ["SpendingStatistics", "Clound", "SettingsController", "GSignInController" ]
        self.addSlideMenuButton()
    }
    
}
