import UIKit
import Charts

class IntentStats {
    var date: [String]
    var money: [Double]
    
    init(date: [String], money: [Double]) {
        self.date = date
        self.money = money
    }
    
    convenience init() {
        self.init(date: [], money: [])
    }
}

class SpendingDayStats: UIViewController {
    // MARK: *** Local variables
    
    var intentOnDay = [DTOIntent]()
    var keyboard: Keyboard?
    var isShow = 0
    
    // MARK: *** Data model
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dateText: UITextField!
    
    @IBOutlet weak var givingDetailLabel: UILabel!
    @IBOutlet weak var notificationLabel: UILabel!
    
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var moneyUnitLabel: UILabel!
    @IBOutlet weak var dayStats: BarChartView!

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: *** UI events
    
    
    @IBAction func doneButton_Tapped(_ sender: AnyObject) {
        if self.dateText.text! != "" {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            
            let fullDay = self.dateText.text! + "-" + String(Date.getMonth(date: Date())) + "-" + String(Date.getYear(date: Date()))
            
            if dateFormatter.date(from: fullDay) != nil {
                loadGivingDataOnDay(date: fullDay)
                self.tableView.reloadData()
            }
            else {
                
                Alert.show(type: ALERT_TYPE.ERROR, title: Language.BUILDER.get(group: Group.MESSAGE_TITLE, view: MessageTitle.NOTICE), msg: Language.BUILDER.get(group: Group.MESSAGE, view: Message.COUNT_DAY) + " " + String(Date.getMonth(date: Date())) + ": 1 - " + String(getNumberDayOfMonth(month: Date.getMonth(date: Date()), year: Date.getYear(date: Date()))))
            }
        }
        else {
            Alert.show(type: ALERT_TYPE.ERROR, title: Language.BUILDER.get(group: Group.MESSAGE_TITLE, view: MessageTitle.NOTICE), msg: Language.BUILDER.get(group: Group.MESSAGE, view: Message.NOT_DONE))
        }
    }
    
    @IBAction func backButton_tapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func keyboardWillShow(notification: Notification) {
        if let contentInset = keyboard?.catchEventOfKeyboard(isScroll: true, notification: notification) {
            if isShow == 0 {
                isShow = 1
                self.scrollView.setContentOffset(contentInset, animated: true)
            }
        }
    }
    
    func keyboardWillHide(notification: Notification) {
        if let contentInset = keyboard?.catchEventOfKeyboard(isScroll: false, notification: notification) {
            isShow = 0
            self.scrollView.setContentOffset(contentInset, animated: true)
        }
    }
    
    // MARK: *** UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.moneyUnitLabel.text = "(" + ExchangeRate.BUILDER.RateType.rawValue + ")"
        
        self.backButton.setTitle(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.BACK_BUTTON), for: .normal)
        self.titleLabel.text = Language.BUILDER.get(group: Group.TITLE, view: TitleViews.STATS_DAY)
        
        self.notificationLabel.text = Language.BUILDER.get(group: Group.MESSAGE, view: Message.NO_DATA_CHARTS)
        self.givingDetailLabel.text = Language.BUILDER.get(group: Group.MESSAGE, view: Message.GIVING_DETAIL)
        
        self.givingDetailLabel.isHidden = true
        self.tableView.isHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        keyboard = Keyboard(arrTextField: [self.dateText])
        keyboard?.createDoneButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    private func getNumberDayOfMonth(month: Int, year: Int)->Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        
        return numDays
    }

    
    private func getTotalGivingMoney(date: String, type: JARS_TYPE, intent: [DTOIntent])->Double {
        var totalMoney = 0.0
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH-mm-ss"
        
        let fromTime = dateFormatter.date(from: date + " 00:00:00")?.ticks
        let toTime = dateFormatter.date(from: date + " 23:59:59")?.ticks
        
        for i in 0..<intent.count {
            if intent[i].type == type && intent[i].timestamp >= fromTime! && intent[i].timestamp <= toTime! {
                totalMoney = totalMoney + intent[i].money
            }
        }
        
        return totalMoney
    }
    
    
    
    private func createDataForGivingChart(date: String, intentData: [DTOIntent])->[Double] {
        var result = [Double]()
        
        result.append(getTotalGivingMoney(date: date, type: JARS_TYPE.NEC, intent: intentData))
        result.append(getTotalGivingMoney(date: date, type: JARS_TYPE.FFA, intent: intentData))
        result.append(getTotalGivingMoney(date: date, type: JARS_TYPE.LTSS, intent: intentData))
        result.append(getTotalGivingMoney(date: date, type: JARS_TYPE.EDU, intent: intentData))
        result.append(getTotalGivingMoney(date: date, type: JARS_TYPE.PLAY, intent: intentData))
        result.append(getTotalGivingMoney(date: date, type: JARS_TYPE.GIVE, intent: intentData))
        
        return result
    }
    
    
    func loadGivingDataOnDay(date: String) {
        if let intentData = DAOIntent.BUILDER.GetAll() as? [DTOIntent] {
            
            var entries: [BarChartDataEntry] = []
            let jar_Title = ["", "NEC", "FFA", "LTSS", "EDU", "PLAY", "GIVE"]
            let dataFromIntent = createDataForGivingChart(date: date, intentData: intentData)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH-mm-ss"
            
            let fromTime = dateFormatter.date(from: date + " 00:00:00")?.ticks
            let toTime = dateFormatter.date(from: date + " 23:59:59")?.ticks
            
            for i in 0..<intentData.count {
                if intentData[i].timestamp >= fromTime! && intentData[i].timestamp <= toTime! {
                    intentOnDay.append(intentData[i])
                }
            }
            
            var flag = 0
            
            for i in 0..<dataFromIntent.count {
                if dataFromIntent[i] != 0 {
                    flag = 1
                }
                entries.append(BarChartDataEntry(x: Double(i + 1), yValues: [dataFromIntent[i]]))
            }
            
            if flag == 1 {
                self.notificationLabel.isHidden = true
                self.givingDetailLabel.isHidden = false
                self.tableView.isHidden = false
                drawBarChart(entries: entries, titleEachBar: jar_Title, barChart: self.dayStats)
            }
            else {
                self.notificationLabel.isHidden = false
                self.givingDetailLabel.isHidden = true
                self.tableView.isHidden = true
            }
        }
    }
    
    private func drawBarChart(entries: [BarChartDataEntry], titleEachBar: [String], barChart:  BarChartView) {
        let dataSet = BarChartDataSet(values: entries, label: "")
        dataSet.axisDependency = .right
        dataSet.colors = [#colorLiteral(red: 0.2235294118, green: 0.2862745098, blue: 0.6705882353, alpha: 1), #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)]
        
        let data:BarChartData = BarChartData(dataSet: dataSet)
        barChart.data = data
        
        // *** Định dạng lại cho biểu đồ
        
        barChart.rightAxis.axisMinimum = 0
        barChart.rightAxis.granularity = 10
        barChart.rightAxis.axisMaximum = dataSet.yMax + dataSet.yMax / 5
        
        barChart.chartDescription?.text = ""
        barChart.xAxis.drawLabelsEnabled = true
        
        
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: titleEachBar)
        barChart.xAxis.granularity = 1
        
        barChart.animate(xAxisDuration: 2.0, easingOption: .easeInBounce)
        barChart.animate(yAxisDuration: 2.0, easingOption: .easeInBounce)
    }
}



extension SpendingDayStats: UITableViewDataSource, UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return intentOnDay.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = self.tableView.dequeueReusableCell(withIdentifier: "SpendingStatsCell", for: indexPath) as! SpendingStatsCell
        
        Cell.noteLabel.text = intentOnDay[indexPath.row].content
        Cell.moneyLabel.text = String(intentOnDay[indexPath.row].money) + "(" + ExchangeRate.BUILDER.RateType.rawValue + ")"
        
        if Cell.noteLabel.text! == "" {
            Cell.noteLabel.text = Language.BUILDER.get(group: Group.MESSAGE, view: Message.NO_NOTE)
            Cell.noteLabel.textColor = UIColor.lightGray
        }
        
        let borderColor = UIColor(colorLiteralRed: 224/255, green: 224/255, blue: 224/255, alpha: 1).cgColor
        
        Cell.jar_TypeView.layer.borderWidth = 1
        Cell.jar_TypeView.layer.borderColor = borderColor
        Cell.jar_TypeView.layer.cornerRadius = 15
        
        switch(intentOnDay[indexPath.row].type) {
        case .NEC:
            Cell.jar_TypeView.backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.2862745098, blue: 0.6705882353, alpha: 1)
            Cell.nameTypeLabel.text = "NEC"
            break;
        case .FFA:
            Cell.jar_TypeView.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            Cell.nameTypeLabel.text = "FFA"
            break;
        case .LTSS:
            Cell.jar_TypeView.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            Cell.nameTypeLabel.text = "LTSS"
            break
        case .EDU:
            Cell.jar_TypeView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            Cell.nameTypeLabel.text = "EDU"
            break
        case .PLAY:
            Cell.jar_TypeView.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            Cell.nameTypeLabel.text = "PLAY"
            break
        case .GIVE:
            Cell.jar_TypeView.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
            Cell.nameTypeLabel.text = "GIVE"
            break
        }
        
        return Cell
    }
}




