import UIKit

class TimeNotesList: BaseViewController {
    // MARK: *** Local variables
    
    // MARK: *** Data model
    
    // MARK: *** UI events
    @IBAction func StatsButton_Tapped(_ sender: AnyObject) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let timeStatistics = storyBoard.instantiateViewController(withIdentifier: "TimeStatistics")
        self.present(timeStatistics, animated: true, completion: nil)
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
