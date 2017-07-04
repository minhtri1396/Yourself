import UIKit
import Charts

class SpendingYearStats: UIViewController {
    // MARK: *** Local variables
    
    // MARK: *** Data model
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var moneyGivingLabel: UILabel!
    
  
    @IBOutlet weak var yearGivingStats: BarChartView!
    
    // MARK: *** UI events
    
    @IBAction func backButton_Tapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backButton.setTitle(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.BACK_BUTTON), for: .normal)
        self.titleLabel.text = Language.BUILDER.get(group: Group.TITLE, view: TitleViews.STATS_YEAR)
        self.moneyGivingLabel.text = Language.BUILDER.get(group: Group.TITLE, view: TitleViews.MONEY_GIVING)
        
        self.yearGivingStats.noDataText = Language.BUILDER.get(group: Group.MESSAGE, view: Message.NO_DATA_CHARTS)
        
        
        loadGivingDataOnYear()
        //loadReplacingDataOnYear()
    }
    
    private func getTotalGivingMoney(month: Int, type: JARS_TYPE, intent: [DTOIntent])->Double {
        var totalMoney = 0.0
        
        for i in 0..<intent.count {
            if intent[i].type == type /*&& Date.getMonth(date: date) == month*/ {
                totalMoney = totalMoney + intent[i].money
            }
        }
        
        return totalMoney
    }
    
    
    private func getTotalReplacingMoney(month: Int, type: JARS_TYPE, alternatives: [DTOAlternatives])->Double {
        var totalMoney = 0.0
        
        for i in 0..<alternatives.count {
            if alternatives[i].alts == type /*&& Date.getMonth(date: date) == month*/ {
                totalMoney = totalMoney + alternatives[i].money
            }
        }
        
        return totalMoney
    }
    
    private func createDataForGivingChart(intentData: [DTOIntent])->[[Double]] {
        var result = [[Double]]()
        
        for i in 0..<12 {
            var tmp = [Double]()
            tmp.append(getTotalGivingMoney(month: i + 1, type: JARS_TYPE.NEC, intent: intentData))
            tmp.append(getTotalGivingMoney(month: i + 1, type: JARS_TYPE.FFA, intent: intentData))
            tmp.append(getTotalGivingMoney(month: i + 1, type: JARS_TYPE.LTSS, intent: intentData))
            tmp.append(getTotalGivingMoney(month: i + 1, type: JARS_TYPE.EDU, intent: intentData))
            tmp.append(getTotalGivingMoney(month: i + 1, type: JARS_TYPE.PLAY, intent: intentData))
            tmp.append(getTotalGivingMoney(month: i + 1, type: JARS_TYPE.GIVE, intent: intentData))
            
            result.append(tmp)
        }
        
        return result
    }
    
    private func createDataForReplacingChart(replacingData: [DTOAlternatives])->[[Double]] {
        var result = [[Double]]()
        
        for i in 0..<12 {
            var tmp = [Double]()
            tmp.append(getTotalReplacingMoney(month: i + 1, type: JARS_TYPE.NEC, alternatives: replacingData))
            tmp.append(getTotalReplacingMoney(month: i + 1, type: JARS_TYPE.FFA, alternatives: replacingData))
            tmp.append(getTotalReplacingMoney(month: i + 1, type: JARS_TYPE.LTSS, alternatives: replacingData))
            tmp.append(getTotalReplacingMoney(month: i + 1, type: JARS_TYPE.EDU, alternatives: replacingData))
            tmp.append(getTotalReplacingMoney(month: i + 1, type: JARS_TYPE.PLAY, alternatives: replacingData))
            tmp.append(getTotalReplacingMoney(month: i + 1, type: JARS_TYPE.GIVE, alternatives: replacingData))
            
            result.append(tmp)
        }
        
        return result
    }
    
    private func calTotal(data: [Double])->Double {
        var total = 0.0
        for i in 0..<data.count {
            total += data[i]
        }
        return total
    }
    
    private func convertToPercent(data: inout [[Double]]) {
        for i in 0..<data.count {
            let total = calTotal(data: data[i])
            for j in 0..<data[i].count {
                data[i][j] = data[i][j] / total * 100
            }
        }
    }
    
    
    func loadGivingDataOnYear() {
        if let intentData = DAOIntent.BUILDER.GetAll() as? [DTOIntent] {
            
            var entries: [BarChartDataEntry] = []
            
            let month = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
            var dataFromIntent = createDataForGivingChart(intentData: intentData)
            
            convertToPercent(data: &dataFromIntent)
            
            for i in 0..<dataFromIntent.count {
                entries.append(BarChartDataEntry(x: Double(i), yValues: dataFromIntent[i]))
            }
            
            drawBarChart(entries: entries, titleEachBar: month, barChart: self.yearGivingStats)
        }
    }
    
    func loadReplacingDataOnYear() {
        if let alternativesData = DAOAlternatives.BUILDER.GetAll() as? [DTOAlternatives] {
            
            var entries: [BarChartDataEntry] = []
            
            let month = ["", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
            var dataFromAlter = createDataForReplacingChart(replacingData: alternativesData)
            
            convertToPercent(data: &dataFromAlter)
            
            for i in 0..<dataFromAlter.count {
                entries.append(BarChartDataEntry(x: Double(i + 1), yValues: dataFromAlter[i]))
            }
            
            //drawBarChart(entries: entries, titleEachBar: month, barChart: self.yearReplacingStats)
        }
    }
    
    private func drawBarChart(entries: [BarChartDataEntry], titleEachBar: [String], barChart:  BarChartView) {
        let dataSet = BarChartDataSet(values: entries, label: "")
        dataSet.axisDependency = .right
        dataSet.colors = [#colorLiteral(red: 0.2235294118, green: 0.2862745098, blue: 0.6705882353, alpha: 1), #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)]
        dataSet.stackLabels = ["NEC", "FFA", "LTSS", "EDU", "PLAY", "GIVE"]
        
        let data:BarChartData = BarChartData(dataSet: dataSet)
        barChart.data = data
        
        // *** Định dạng lại cho biểu đồ
        
        barChart.rightAxis.axisMinimum = 0
        barChart.rightAxis.granularity = 10
        barChart.rightAxis.axisMaximum = 120
        
        barChart.chartDescription?.text = ""
        
        barChart.xAxis.drawLabelsEnabled = true
        //barChart.xAxis.labelPosition = .bottom
        
        
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: titleEachBar)
        barChart.xAxis.granularity = 1
        
        let ll = ChartLimitLine(limit: 50.0, label: "Limit")
        barChart.rightAxis.addLimitLine(ll)
        
        barChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
}
