import UIKit

class SpedingNotesList: BaseViewController, UITabBarControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    // MARK: *** Local variables
    private var selectedCellIndexPath: IndexPath?
    private let selectedCellHeight: CGFloat = 276
    private let unselectedCellHeight: CGFloat = 41.0
    private var isFirstTime = true
    private var intents: [DTOIntent]?
    
    // MARK: *** Data model
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var expenseNotesList: UITableView!
    
    
    // MARK: *** Fuction
    
    // MARK: *** UI events
    
    @IBAction func addSpendingNote_Tapped(_ sender: AnyObject) {
        let addSpendingNoteView = self.storyboard?.instantiateViewController(withIdentifier: "AddSpendingNoteViewController" ) as! AddSpendingNoteViewController
        self.present(addSpendingNoteView, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCellIndexPath = indexPath
        
        isFirstTime = false
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        if selectedCellIndexPath != nil {
            // This ensures, that the cell is fully visible once expanded
            tableView.scrollToRow(at: indexPath, at: .none, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedCellIndexPath == indexPath {
            return selectedCellHeight
        } else if isFirstTime {
            if indexPath.row == 0 {
                return selectedCellHeight
            }
        }
        return unselectedCellHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let intents = intents {
            return intents.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ExpenseNoteCell",
            for: indexPath) as! ExpenseNoteCell
        
        cell.selectionStyle = .none
        let borderColor = UIColor(colorLiteralRed: 224/255, green: 224/255, blue: 224/255, alpha: 1).cgColor
        cell.bodyView.layer.borderWidth = 1
        cell.bodyView.layer.borderColor = borderColor
        
        if let intents = intents {
            let intent = intents[indexPath.row]
            cell.dateLabel.text = Date.convertTimestampToDateString(timeStamp: intent.timestamp)
            cell.ownedJarLabel.text = intent.type.rawValue
            cell.noteTextView.text = intent.content
            cell.moneyLabel.text = intent.money.round(numberOfDecimal: 2).clean
            
            cell.deleteButton.tag = indexPath.row
            cell.deleteButton.addTarget(self, action: #selector(deleteCellButtonTapped(sender:)), for: .touchUpInside)
        }
        
        return cell
    }
    
    @objc private func deleteCellButtonTapped(sender: UIButton) {
        if let intents = intents {
            _ = DAOIntent.BUILDER.Delete(timestamp: intents[sender.tag].timestamp)
            _ = DAOJars.BUILDER.UpdateMoney(type: intents[sender.tag].type, money: intents[sender.tag].money)
            self.intents?.remove(at: sender.tag)
            self.expenseNotesList.reloadData()
        }
        
    }
    
    
    // MARK: *** UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
        
        navBar.title = "EXPENSE LIST";
        expenseNotesList.delegate = self
        expenseNotesList.dataSource = self
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
        super.iconsForCells = ["AddMoney", "Statistics", "Synchronization", "Settings", "Logout"]
        super.indentifiers = ["MoneyAddingController", "SpendingStatistics", "Synchronization", "SettingsController", "GSignInController" ]
        super.notIndentifiers = ["Synchronization"]
        
        super.addCallback(forIdentifier: "GSignInController") {
            GAccount.Instance.SignOut()
        }
        
        super.addCallback(forIdentifier: "Synchronization") {
            DB.Sync() {
                (result) in
                if result {
                    Alert.show(type: ALERT_TYPE.SUCCEESS, title: Language.BUILDER.get(group: Group.MESSAGE_TITLE, view: MessageTitle.NOTICE), msg: Language.BUILDER.get(group: Group.MESSAGE, view: Message.SYNC_SUCCESS))
                } else {
                    Alert.show(type: ALERT_TYPE.ERROR, title: Language.BUILDER.get(group: Group.MESSAGE_TITLE, view: MessageTitle.NOTICE), msg: Language.BUILDER.get(group: Group.MESSAGE, view: Message.SYNC_FAIL))
                }
            }
        }
        
        
        super.addSlideMenuButton()
        intents = DAOIntent.BUILDER.GetAll() as? [DTOIntent]
        self.expenseNotesList.reloadData()
    }
   
}
