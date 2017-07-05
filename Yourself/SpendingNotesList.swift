import UIKit

class SpedingNotesList: BaseViewController, UITabBarControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    // MARK: *** Local variables
    @IBOutlet weak var emptyLabel: UILabel!
    private var selectedCellIndexPath: IndexPath?
    private let selectedCellHeight: CGFloat = 276
    private let unselectedCellHeight: CGFloat = 41.0
    private var isFirstTime = true
    private var intents: [DTOIntent]!
    
    // MARK: *** Data model
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var expenseNotesList: UITableView!
    
    
    // MARK: *** Fuction
    
    func showActivityIndicatory(uiView: UIView) {
        let container: UIView = UIView()
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColor.white
        container.alpha = 0.3
        
        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor(colorLiteralRed: 68, green: 68, blue: 68, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        
        
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        actInd.startAnimating()
    }
    
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
        self.emptyLabel.isHidden = intents.count > 0
        self.expenseNotesList.isHidden = intents.count == 0
        return intents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ExpenseNoteCell",
            for: indexPath) as! ExpenseNoteCell
        
        cell.selectionStyle = .none
        let borderColor = UIColor(colorLiteralRed: 224/255, green: 224/255, blue: 224/255, alpha: 1).cgColor
        cell.bodyView.layer.borderWidth = 1
        cell.bodyView.layer.borderColor = borderColor
        
        if intents.count > 0 {
            let intent = intents[indexPath.row]
            cell.dateLabel.text = Date.convertTimestampToDateString(timeStamp: intent.timestamp / 10)
            cell.ownedJarLabel.text = intent.type.rawValue
            if intent.content.isEmpty {
                cell.noteTextView.text = Language.BUILDER.get(group: Group.MESSAGE, view: Message.NO_NOTE)
                cell.noteTextView.textColor = UIColor.lightGray
            } else {
                cell.noteTextView.text = intent.content
            }
            cell.moneyLabel.text = ExchangeRate.BUILDER.transfer(price: intent.money).clean + " " + ExchangeRate.BUILDER.RateType.rawValue
            
            let alts = DAOAlternatives.BUILDER.GetAlternative(with: intent.timestamp, ownerType: intent.type)
            if alts.count > 0 {
                var str = "[" + alts[0].alts.rawValue + ": " + ExchangeRate.BUILDER.transfer(price: alts[0].money).clean
                for iAlt in 1..<alts.count {
                    str += ", " + alts[iAlt].alts.rawValue + ": " + ExchangeRate.BUILDER.transfer(price: alts[iAlt].money).clean
                }
                str += "]"
                cell.altJarLabel.text = str
            } else {
                cell.altJarLabel.text = ""
            }
            // Set delete button for the cell
            cell.deleteButton.tag = indexPath.row
            cell.deleteButton.addTarget(self, action: #selector(deleteCellButtonTapped(sender:)), for: .touchUpInside)
            // Set done button for the cell
            cell.confirmButton.tag = indexPath.row
            cell.confirmButton.addTarget(self, action: #selector(doneCellButtonTapped(sender:)), for: .touchUpInside)
        }
        
        return cell
    }
    
    @objc private func doneCellButtonTapped(sender: UIButton) {
        if intents.count > 0 {
            intents[sender.tag].state = .DONE
            _ = DAOIntent.BUILDER.Update(intent: intents[sender.tag])
            self.intents.remove(at: sender.tag)
            self.expenseNotesList.reloadData()
        }
    }
    
    @objc private func deleteCellButtonTapped(sender: UIButton) {
        if intents.count > 0 {
            _ = DAOIntent.BUILDER.Delete(timestamp: intents[sender.tag].timestamp)
            _ = DAOAlternatives.BUILDER.Delete(timestamp: intents[sender.tag].timestamp)
            let curMoney = DAOJars.BUILDER.GetJARS(with: intents[sender.tag].type).money
            _ = DAOJars.BUILDER.UpdateMoney(type: intents[sender.tag].type, money: curMoney + intents[sender.tag].money)
            self.intents.remove(at: sender.tag)
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
            self.showActivityIndicatory(uiView: self.view)
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
        intents = DAOIntent.BUILDER.GetAll(hasState: .NOT_YET)
        self.expenseNotesList.reloadData()
    }
   
}
