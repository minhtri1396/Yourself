import UIKit

class TimeNotesList: BaseViewController, UITabBarControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    // MARK: *** Local variables
    @IBOutlet weak var emptyLabel: UILabel!
    private var selectedCellIndexPath: IndexPath?
    private let selectedCellHeight: CGFloat = 276
    private let unselectedCellHeight: CGFloat = 41.0
    private var isFirstTime = true
    private var timeNotes: [DTOTime]!
    
    // MARK: *** Data model
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var timeNotesList: UITableView!
    
    // MARK: *** Function
    
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
    
    @IBAction func AddNoteTime_Tapped(_ sender: AnyObject) {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let addNoteView = mainStoryboard.instantiateViewController(withIdentifier: "TimeNoteAddingController") as! TimeNoteAddingController
        self.present(addNoteView, animated: true, completion: nil)
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
        self.emptyLabel.isHidden = timeNotes.count > 0
        self.timeNotesList.isHidden = timeNotes.count == 0
        return timeNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "TimeNoteCell",
            for: indexPath) as! TimeNoteCell
        
        cell.selectionStyle = .none
        let borderColor = UIColor(colorLiteralRed: 224/255, green: 224/255, blue: 224/255, alpha: 1).cgColor
        cell.bodyView.layer.borderWidth = 1
        cell.bodyView.layer.borderColor = borderColor
        
        if timeNotes.count > 0 {
            let timeNote = timeNotes[indexPath.row]
            cell.startDateLabel.text = Date.convertTimestampToDateString(timeStamp: timeNote.startTime / 10, withFormat: "(HH:mm) dd-MM-yyyy")
            cell.appointmentDateLabel.text = Date.convertTimestampToDateString(timeStamp: timeNote.appointment / 10, withFormat: "dd-MM-yyyy (HH:mm)")
            
            if timeNote.content.isEmpty {
                cell.contentTextView.text = Language.BUILDER.get(group: Group.MESSAGE, view: Message.NO_NOTE)
                cell.contentTextView.textColor = UIColor.lightGray
            } else {
                cell.contentTextView.text = timeNote.content
            }
            let tags = timeNote.getAllTags()
            var tagsAsStr = "Tag: " + getTagName(tag: tags[0])
            
            for iTag in 1..<tags.count {
                tagsAsStr += ", \(getTagName(tag: tags[iTag]))"
            }
            cell.tagsLabel.text = tagsAsStr
            
            // Set delete button for the cell
            cell.cancelButton.tag = indexPath.row
            cell.cancelButton.addTarget(self, action: #selector(cancelCellButtonTapped(sender:)), for: .touchUpInside)
            // Set done button for the cell
            cell.doneButton.tag = indexPath.row
            cell.doneButton.addTarget(self, action: #selector(doneCellButtonTapped(sender:)), for: .touchUpInside)
        }

        
        return cell
    }
    
    private func getTagName(tag: TAG) -> String {
        var tagView: TimeTags
        switch tag {
        case .FAMILY:
            tagView = TimeTags.FAMILY
            break;
        case .PERSONAL:
            tagView = TimeTags.PERSONAL
            break;
        case .FRIEND:
            tagView = TimeTags.FRIEND
            break;
        case .STUDY:
            tagView = TimeTags.STUDY
            break;
        case .WORK:
            tagView = TimeTags.WORK
            break;
        case .LOVE:
            tagView = TimeTags.LOVE
            break;
        default:
            tagView = TimeTags.RELAX
        }
        
        return Language.BUILDER.get(group: .TIME_TAG, view: tagView)
    }
    
    @objc private func doneCellButtonTapped(sender: UIButton) {
        if timeNotes.count > 0 {
            let id = self.timeNotes[sender.tag].id
            setTimeNotes()
            
            if id == self.timeNotes[sender.tag].id {
                updateCheerUp(timeNote: self.timeNotes[sender.tag])
                updateTimeStats(for: self.timeNotes[sender.tag])
                _ = DAOTime.BUILDER.Delete(id: id)
                self.timeNotes.remove(at: sender.tag)
            } else {
                Alert.show(type: .INFO, title: Language.BUILDER.get(group: Group.MESSAGE_TITLE, view: MessageTitle.SO_SAD), msg: Language.BUILDER.get(group: Group.MESSAGE, view: Message.OVERTIME_NOTE))
            }
            
            self.timeNotesList.reloadData()
        }
    }
    
    private func updateCheerUp(timeNote: DTOTime) {
        let curTime = Date().ticks
        if let cheerUps = DAOCheerUp.BUILDER.GetAll() as? [DTOCheerUp] {
            if cheerUps.count < 3 {
                _ = DAOCheerUp.BUILDER.Add(DTOCheerUp(timestamp: curTime, content: "\(Date.convertTimestampToDateString(timeStamp: curTime/10))***\(timeNote.content)***\(curTime - timeNote.startTime)"))
            } else {
                var maxFinishTime = Int64.min
                var finishTime: Int64
                var timestamp = cheerUps[0].timestamp
                var content: [String]
                for cheerUp in cheerUps {
                    content = cheerUp.content.components(separatedBy: "***")
                    finishTime = Int64(content[content.count - 1])!
                    if finishTime > maxFinishTime {
                        maxFinishTime = finishTime
                        timestamp = cheerUp.timestamp
                    }
                }
                
                if maxFinishTime > (curTime - timeNote.startTime) {
                    _ = DAOCheerUp.BUILDER.Delete(timestamp: timestamp)
                    _ = DAOCheerUp.BUILDER.Add(DTOCheerUp(timestamp: curTime, content: "\(Date.convertTimestampToDateString(timeStamp: curTime/10))***\(timeNote.content)***\(curTime - timeNote.startTime)"))
                }
            }
        } else {
            _ = DAOCheerUp.BUILDER.Add(DTOCheerUp(timestamp: curTime, content: "\(Date.convertTimestampToDateString(timeStamp: curTime/10))***\(timeNote.content)***\(curTime - timeNote.startTime)"))
        }
    }
    
    private func updateTimeStats(for timeNote: DTOTime) {
        let curDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let time = (dateFormatter.date(from: "01-\(Date.getMonth(date: curDate))-\(Date.getYear(date: curDate)) 00:00:00")?.ticks)!
        
        let totalTime = curDate.ticks - timeNote.startTime
        
        if let timeStats = DAOTimeStats.BUILDER.GetTimeStats(with: time) {
            timeStats.totalCompletionTime += totalTime
            timeStats.numberSuccessNotes += 1
            timeStats.totalNumberNotes += 1
            _ = DAOTimeStats.BUILDER.Update(timeStats: timeStats)
        } else {
            let timeStats = DTOTimeStats(timestamp: time, totalCompletionTime: totalTime, numberSuccessNotes: 1, numberFailNotes: 0, totalNumberNotes: 1)
            _ = DAOTimeStats.BUILDER.Add(timeStats: timeStats)
        }
    }
    
    @objc private func cancelCellButtonTapped(sender: UIButton) {
        if timeNotes.count > 0 {
            _ = DAOTime.BUILDER.Delete(id: self.timeNotes[sender.tag].id)
            self.timeNotes.remove(at: sender.tag)
            self.timeNotesList.reloadData()
        }
    }
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
        
        timeNotesList.delegate = self
        timeNotesList.dataSource = self
        
        navBar.title = Language.BUILDER.get(group: Group.TITLE, view: TitleViews.NOTES_LIST)
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
        super.indentifiers = ["TimeStatistics", "Synchronization", "SettingsController", "GSignInController" ]
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
        self.setTimeNotes()
        self.timeNotesList.reloadData()
    }
    
    func setTimeNotes() {
        let curTime = Date().ticks
        if let timeNotes = DAOTime.BUILDER.GetAll() as? [DTOTime] {
            for timeNote in timeNotes {
                if curTime > timeNote.appointment {
                    let timeAsString = Date.convertTimestampToDateString(timeStamp: timeNote.appointment/10, withFormat: "01-MM-yyyy 00:00:00")
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                    let time = (dateFormatter.date(from: timeAsString)?.ticks)!
                    _ = DAOTime.BUILDER.Delete(id: timeNote.id)
                    if let timeStats = DAOTimeStats.BUILDER.GetTimeStats(with: time) {
                        timeStats.numberFailNotes += 1
                        timeStats.totalNumberNotes += 1
                        _ = DAOTimeStats.BUILDER.Update(timeStats: timeStats)
                    } else {
                        let timeStats = DTOTimeStats(timestamp: time, totalCompletionTime: 0, numberSuccessNotes: 0, numberFailNotes: 1, totalNumberNotes: 1)
                        _ = DAOTimeStats.BUILDER.Add(timeStats: timeStats)
                    }
                }
            }
        }
        timeNotes = DAOTime.BUILDER.GetAll(hasStates: [.NOT_TIME, .DOING])
    }
    
}
