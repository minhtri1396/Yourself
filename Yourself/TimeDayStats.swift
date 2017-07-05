import UIKit
import Charts

class TimeDayStats: UIViewController {
    // MARK: *** Local variables
    
    var keyboard: Keyboard?
    var isShow = 0
    
    // MARK: *** Data model
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var chooseDay: UITextField!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var timeDayStats: BarChartView!
    
    
    // MARK: *** UI events
    
    
    @IBAction func doneButton_Tapped(_ sender: AnyObject) {
        
    }
    
    @IBAction func backButton_Tapped(_ sender: AnyObject) {
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
        
        
        self.backButton.setTitle(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.BACK_BUTTON), for: .normal)
        self.titleLabel.text = Language.BUILDER.get(group: Group.TITLE, view: TitleViews.STATS_DAY)
        
        self.notificationLabel.text = Language.BUILDER.get(group: Group.MESSAGE, view: Message.NO_DATA_CHARTS)
        
        
        keyboard = Keyboard(arrTextField: [self.chooseDay])
        keyboard?.createDoneButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    
    func loadGivingDataOnDay(date: String) {
        if let intentData = DAOIntent.BUILDER.GetAll() as? [DTOIntent] {
            
//            var entries: [BarChartDataEntry] = []
//            let jar_Title = ["", "NEC", "FFA", "LTSS", "EDU", "PLAY", "GIVE"]
//            let dataFromIntent = createDataForGivingChart(date: date, intentData: intentData)
//            
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "dd-MM-yyyy HH-mm-ss"
//            
//            let fromTime = dateFormatter.date(from: date + " 00:00:00")?.ticks
//            let toTime = dateFormatter.date(from: date + " 23:59:59")?.ticks
//            
//            var flag = 0
//            
//            for i in 0..<dataFromIntent.count {
//                if dataFromIntent[i] != 0 {
//                    flag = 1
//                }
//                entries.append(BarChartDataEntry(x: Double(i + 1), yValues: [dataFromIntent[i]]))
//            }
//            
//            if flag == 1 {
//                self.notificationLabel.isHidden = true
//                drawBarChart(entries: entries, titleEachBar: jar_Title, barChart: self.timeDayStats)
//            }
//            else {
//                self.notificationLabel.isHidden = false
//            }
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
