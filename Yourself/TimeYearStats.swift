import UIKit
import Charts

class TimeYearStats: UIViewController {
    // MARK: *** Local variables
    
    var keyboard: Keyboard?
    var isShow = 0
    
    // MARK: *** Data model
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    
    @IBOutlet weak var startDay: UITextField!
    @IBOutlet weak var endDay: UITextField!
    @IBOutlet weak var to: NSLayoutConstraint!
    
    @IBOutlet weak var yearTimeStats: BarChartView!
    @IBOutlet weak var notificationLabel: UILabel!

    // MARK: *** UI events
    
    @IBAction func backButton_Tapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButton_Tapped(_ sender: AnyObject) {
        if self.startDay.text! != "" && self.endDay.text! != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            if dateFormatter.date(from: self.startDay.text!) == nil {
                Alert.show(type: ALERT_TYPE.ERROR, title: Language.BUILDER.get(group: Group.MESSAGE_TITLE, view: MessageTitle.NOTICE), msg: self.startDay.text! + " " + Language.BUILDER.get(group: Group.MESSAGE, view: Message.NOT_EXIST_DAY))
                return
            }
            
            if dateFormatter.date(from: self.endDay.text!) == nil {
                Alert.show(type: ALERT_TYPE.ERROR, title: Language.BUILDER.get(group: Group.MESSAGE_TITLE, view: MessageTitle.NOTICE), msg: self.endDay.text! + " " + Language.BUILDER.get(group: Group.MESSAGE, view: Message.NOT_EXIST_DAY))
                return
            }
            
            loadDataOnYear(strDay: self.startDay.text!, endDay: self.endDay.text!)
        }
        else {
            Alert.show(type: ALERT_TYPE.ERROR, title: Language.BUILDER.get(group: Group.MESSAGE_TITLE, view: MessageTitle.NOTICE), msg: Language.BUILDER.get(group: Group.MESSAGE, view: Message.NOT_DONE))
        }
    }
    
    // MARK: *** UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backButton.setTitle(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.BACK_BUTTON), for: .normal)
        self.titleLabel.text = Language.BUILDER.get(group: Group.TITLE, view: TitleViews.STATS_YEAR)
        
        
        self.startDay.delegate = self
        self.endDay.delegate = self
        
        
        self.notificationLabel.text = Language.BUILDER.get(group: Group.MESSAGE, view: Message.NO_DATA_CHARTS)
        
        self.doneButton.setTitle(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.DONE), for: <#T##UIControlState#>)
        self.startDay.placeholder = Language.BUILDER.get(group: Group.PLACEHOLDER, view: PlaceholderViews.STR_DAY)
        self.endDay.placeholder = Language.BUILDER.get(group: Group.PLACEHOLDER, view: PlaceholderViews.END_DAY)
        
        keyboard = Keyboard(arrTextField: [self.startDay, self.endDay])
        keyboard?.createDoneButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
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
    
    private func getData(strDay: String, endDay: String, timeStats: [DTOTimeStats])->[Int64] {
        var result:[Int64] = [0, 0, 0, 0]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH-mm-ss"
        
        let fromTime = dateFormatter.date(from: strDay + " 00:00:00")?.ticks
        let toTime = dateFormatter.date(from: endDay + " 23:59:59")?.ticks
        
        for i in 0..<timeStats.count {
           if timeStats[i].timestamp >= fromTime! && timeStats[i].timestamp <= toTime! {
                result[0] = result[0] + Int64(timeStats[i].numberSuccessNotes)
                result[1] = result[1] + Int64(timeStats[i].numberFailNotes)
                result[2] = result[2] + timeStats[i].totalCompletionTime
                result[3] = result[3] + Int64(timeStats[i].totalNumberNotes)
            }
        }
        
        return result
    }
    
    
    func loadDataOnYear(strDay: String, endDay: String) {
        if let timeStats = DAOTimeStats.BUILDER.GetAll() as? [DTOTimeStats] {
            
            var entries: [BarChartDataEntry] = []
            let titles = ["", "Success", "Fail", "Total time", "Total note"]
            var result = getData(strDay: strDay, endDay: strDay, timeStats: timeStats)
            
            var flag = 0
            
            for i in 0..<result.count {
                if result[i] != 0 {
                    flag = 1
                }
                entries.append(BarChartDataEntry(x: Double(i + 1), yValues: [Double(result[i])]))
            }
            
            if flag == 1 {
                self.notificationLabel.isHidden = true
                drawBarChart(entries: entries, titleEachBar: titles, barChart: self.yearTimeStats)
            }
            else {
                self.notificationLabel.isHidden = false
            }
        }
    }
    
    private func drawBarChart(entries: [BarChartDataEntry], titleEachBar: [String], barChart:  BarChartView) {
        let dataSet = BarChartDataSet(values: entries, label: "")
        dataSet.axisDependency = .right
        dataSet.colors = [#colorLiteral(red: 0.2235294118, green: 0.2862745098, blue: 0.6705882353, alpha: 1), #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)]
        
        let data:BarChartData = BarChartData(dataSet: dataSet)
        barChart.data = data
        
        // *** Định dạng lại cho biểu đồ
        
        barChart.doubleTapToZoomEnabled = false
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

extension TimeYearStats: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !(string == "") && Int(string) == nil {
            return false
        }
        
        if (textField == self.startDay) || (textField == self.endDay) {
            // check the chars length dd -->2 at the same time calculate the dd-MM --> 5
            if (textField.text?.characters.count == 2) || (textField.text?.characters.count == 5) {
                //Handle backspace being pressed
                if !(string == "") {
                    textField.text = (textField.text)! + "-" // append the text
                }
            }
            // check the condition not exceed 9 chars
            return !(textField.text!.characters.count > 9 && (string.characters.count ) > range.length)
        } else {
            if (textField.text?.characters.count == 2) {
                if !(string == "") {
                    textField.text = (textField.text)! + ":" // append the text
                }
            }
            return !(textField.text!.characters.count > 4 && (string.characters.count ) > range.length)
        }
    }
}
