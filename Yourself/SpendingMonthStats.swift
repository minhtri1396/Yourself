import UIKit
import Charts

class SpendingMonthStats: UIViewController {
    // MARK: *** Local variables
    
    // MARK: *** Data model
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var givingMoneyLabel: UILabel!
    @IBOutlet weak var replacingMoneyLabel: UILabel!
    @IBOutlet weak var moneyUnitLabel: UILabel!
    
    
    @IBOutlet weak var monthGivingStats: BarChartView!
    @IBOutlet weak var mongthReplacingStats: BarChartView!
    
    
    
    // MARK: *** UI events
    
    @IBAction func BackButton_Tapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backButton.setTitle(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.BACK_BUTTON), for: .normal)
        self.titleLabel.text = Language.BUILDER.get(group: Group.TITLE, view: TitleViews.STATS_MONTH)
        self.givingMoneyLabel.text = Language.BUILDER.get(group: Group.TITLE, view: TitleViews.MONEY_GIVING)
        self.replacingMoneyLabel.text = Language.BUILDER.get(group: Group.TITLE, view: TitleViews.MONEY_REPLACING)
        
        if ExchangeRate.BUILDER.RateType == .DOLLAR {
            self.moneyUnitLabel.text = "(Dollar)"
        }
        else if ExchangeRate.BUILDER.RateType == .EURO {
            self.moneyUnitLabel.text = "(Euro)"
        }
        else {
            self.moneyUnitLabel.text = "(VND)"
        }
        
        self.monthGivingStats.noDataText = Language.BUILDER.get(group: Group.MESSAGE, view: Message.NO_DATA_CHARTS)
        self.mongthReplacingStats.noDataText = Language.BUILDER.get(group: Group.MESSAGE, view: Message.NO_DATA_CHARTS)
        
        loadGivingDataOnMonth()
        loadReplacingDataOnMonth()
    }
    
    
    private func getTotalGivingMoney(type: JARS_TYPE, intent: [DTOIntent])->Double {
        var totalMoney = 0.0
        
        for i in 0..<intent.count {
            let date = Date(timeIntervalSince1970: TimeInterval(intent[i].timestamp))
            if intent[i].type == type /*&& Date.getMonth(date: date) == Date.getMonth(date: Date())*/ {
                totalMoney = totalMoney + intent[i].money
            }
        }
        
        return totalMoney
    }
    
    
    private func getTotalReplacingMoney(type: JARS_TYPE, alternatives: [DTOAlternatives])->Double {
        var totalMoney = 0.0
        
        for i in 0..<alternatives.count {
            let date = Date(timeIntervalSince1970: TimeInterval(alternatives[i].timestamp / 10))
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "dd-MM-yyyy"
            print("1412573_1412591 " + dateFormatter.string(from: date))
            
            if alternatives[i].alts == type /*&& Date.getMonth(date: date) == Date.getMonth(date: Date())*/ {
                totalMoney = totalMoney + alternatives[i].money
            }
        }
        
        return totalMoney
    }
    
    private func createDataForGivingChart(intentData: [DTOIntent])->[Double] {
        var result = [Double]()
        
        result.append(getTotalGivingMoney(type: JARS_TYPE.NEC, intent: intentData))
        result.append(getTotalGivingMoney(type: JARS_TYPE.FFA, intent: intentData))
        result.append(getTotalGivingMoney(type: JARS_TYPE.LTSS, intent: intentData))
        result.append(getTotalGivingMoney(type: JARS_TYPE.EDU, intent: intentData))
        result.append(getTotalGivingMoney(type: JARS_TYPE.PLAY, intent: intentData))
        result.append(getTotalGivingMoney(type: JARS_TYPE.GIVE, intent: intentData))
        
        return result
    }
    
    private func createDataForReplacingChart(replacingData: [DTOAlternatives])->[Double] {
        var result = [Double]()
        
        result.append(getTotalReplacingMoney(type: JARS_TYPE.NEC, alternatives: replacingData))
        result.append(getTotalReplacingMoney(type: JARS_TYPE.FFA, alternatives: replacingData))
        result.append(getTotalReplacingMoney(type: JARS_TYPE.LTSS, alternatives: replacingData))
        result.append(getTotalReplacingMoney(type: JARS_TYPE.EDU, alternatives: replacingData))
        result.append(getTotalReplacingMoney(type: JARS_TYPE.PLAY, alternatives: replacingData))
        result.append(getTotalReplacingMoney(type: JARS_TYPE.GIVE, alternatives: replacingData))
        
        return result
    }
    
    
    func loadGivingDataOnMonth() {
        if let intentData = DAOIntent.BUILDER.GetAll() as? [DTOIntent] {
            
            var entries: [BarChartDataEntry] = []
            let jar_Title = ["", "NEC", "FFA", "LTSS", "EDU", "PLAY", "GIVE"]
            let dataFromIntent = createDataForGivingChart(intentData: intentData)
            
            
            for i in 0..<dataFromIntent.count {
                entries.append(BarChartDataEntry(x: Double(i + 1), yValues: [dataFromIntent[i]]))
            }
            
            drawBarChart(entries: entries, titleEachBar: jar_Title, barChart: self.monthGivingStats)
        }
    }
    
    func loadReplacingDataOnMonth() {
        if let alternativesData = DAOAlternatives.BUILDER.GetAll() as? [DTOAlternatives] {
            
            var entries: [BarChartDataEntry] = []
            let jar_Title = ["", "NEC", "FFA", "LTSS", "EDU", "PLAY", "GIVE"]
            let dataFromAlter = createDataForReplacingChart(replacingData: alternativesData)
            
            
            for i in 0..<dataFromAlter.count {
                entries.append(BarChartDataEntry(x: Double(i + 1), yValues: [dataFromAlter[i]]))
            }
            
            drawBarChart(entries: entries, titleEachBar: jar_Title, barChart: self.mongthReplacingStats)
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
