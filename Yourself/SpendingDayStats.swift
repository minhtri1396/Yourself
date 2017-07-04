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
    
    var date = Date()
    
    // MARK: *** Data model
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var moneyUnitLabel: UILabel!
    
    @IBOutlet weak var dayStats: BarChartView!
    
    // MARK: *** UI events
    
    
    
   
    
    @IBAction func backButton_tapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backButton.setTitle(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.BACK_BUTTON), for: .normal)
        self.titleLabel.text = Language.BUILDER.get(group: Group.TITLE, view: TitleViews.STATS_DAY)
        
        if ExchangeRate.BUILDER.RateType == .DOLLAR {
            self.moneyUnitLabel.text = "(Dollar)"
        }
        else if ExchangeRate.BUILDER.RateType == .EURO {
            self.moneyUnitLabel.text = "(Euro)"
        }
        else {
            self.moneyUnitLabel.text = "(VND)"
        }
        
        
        
        self.dayStats.noDataText = Language.BUILDER.get(group: Group.MESSAGE, view: Message.NO_DATA_CHARTS)
        loadGivingDataOnDay(date: date)
    }
    
    
    
    private func getTotalGivingMoney(date: Date, type: JARS_TYPE, intent: [DTOIntent])->Double {
        var totalMoney = 0.0
        
        for i in 0..<intent.count {
            if intent[i].type == type && intent[i].timestamp == date.ticks {
                totalMoney = totalMoney + intent[i].money
            }
        }
        
        return totalMoney
    }
    
    
    private func createDataForGivingChart(date: Date, intentData: [DTOIntent])->[Double] {
        var result = [Double]()
        
        result.append(getTotalGivingMoney(date: date, type: JARS_TYPE.NEC, intent: intentData))
        result.append(getTotalGivingMoney(date: date, type: JARS_TYPE.FFA, intent: intentData))
        result.append(getTotalGivingMoney(date: date, type: JARS_TYPE.LTSS, intent: intentData))
        result.append(getTotalGivingMoney(date: date, type: JARS_TYPE.EDU, intent: intentData))
        result.append(getTotalGivingMoney(date: date, type: JARS_TYPE.PLAY, intent: intentData))
        result.append(getTotalGivingMoney(date: date, type: JARS_TYPE.GIVE, intent: intentData))
        
        return result
    }
    
    
    func loadGivingDataOnDay(date: Date) {
        if let intentData = DAOIntent.BUILDER.GetAll() as? [DTOIntent] {
            
            var entries: [BarChartDataEntry] = []
            let jar_Title = ["", "NEC", "FFA", "LTSS", "EDU", "PLAY", "GIVE"]
            let dataFromIntent = createDataForGivingChart(date: date, intentData: intentData)
            
            
            for i in 0..<dataFromIntent.count {
                entries.append(BarChartDataEntry(x: Double(i + 1), yValues: [dataFromIntent[i]]))
            }
            
            drawBarChart(entries: entries, titleEachBar: jar_Title, barChart: self.dayStats)
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
