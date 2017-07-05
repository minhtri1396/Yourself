import UIKit
import Charts
import SCLAlertView



class SpendingMonthStats: UIViewController {
    // MARK: *** Local variables
    
    var month:Int = -1
    var preButton: UIButton?
    
    // MARK: *** Data model
    
    @IBOutlet weak var chooseMonth: UITextField!
    
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var givingMoneyLabel: UILabel!
    @IBOutlet weak var replacingMoneyLabel: UILabel!
    @IBOutlet weak var moneyUnitLabel: UILabel!
    
    
    @IBOutlet weak var monthGivingStats: BarChartView!
    @IBOutlet weak var mongthReplacingStats: BarChartView!
    
    
    @IBOutlet weak var chooseMonthView: UIView!
    @IBOutlet weak var centerPopupContants: NSLayoutConstraint!
    
    
    @IBOutlet weak var janButton: UIButton!
    @IBOutlet weak var febButton: UIButton!
    @IBOutlet weak var marchButton: UIButton!
    @IBOutlet weak var aprilButton: UIButton!
    @IBOutlet weak var mayButton: UIButton!
    @IBOutlet weak var juneButton: UIButton!
    @IBOutlet weak var julyButton: UIButton!
    @IBOutlet weak var augButton: UIButton!
    @IBOutlet weak var sepButton: UIButton!
    @IBOutlet weak var octButton: UIButton!
    @IBOutlet weak var novButton: UIButton!
    @IBOutlet weak var decButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    
    
    // MARK: *** UI events
    
    @IBAction func BackButton_Tapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func janButton_Tapped(_ sender: AnyObject) {
        preventChooseMany(button: janButton)
        if janButton.backgroundColor == UIColor.white {
            choose(button: janButton)
        }
        else {
            unChoose(button: janButton)
        }
    }
    
    
    @IBAction func febButton_Tapped(_ sender: AnyObject) {
        preventChooseMany(button: febButton)
        if febButton.backgroundColor == UIColor.white {
            choose(button: febButton)
        }
        else {
            unChoose(button: febButton)
        }
    }
    
    @IBAction func marchButton_Tapped(_ sender: AnyObject) {
        preventChooseMany(button: marchButton)
        if marchButton.backgroundColor == UIColor.white {
            choose(button: marchButton)
        }
        else {
            unChoose(button: marchButton)
        }
    }
    
    
    @IBAction func aprilButton_Tapped(_ sender: AnyObject) {
        preventChooseMany(button: aprilButton)
        if aprilButton.backgroundColor == UIColor.white {
            choose(button: aprilButton)
        }
        else {
            unChoose(button: aprilButton)
        }
    }
    
    @IBAction func mayButton_Tapped(_ sender: AnyObject) {
        preventChooseMany(button: mayButton)
        if mayButton.backgroundColor == UIColor.white {
            choose(button: mayButton)
        }
        else {
            unChoose(button: mayButton)
        }
    }
    
    
    @IBAction func juneButton_Tapped(_ sender: AnyObject) {
        preventChooseMany(button: juneButton)
        if juneButton.backgroundColor == UIColor.white {
            choose(button: juneButton)
        }
        else {
            unChoose(button: juneButton)
        }
    }
    
    @IBAction func julyButton_Tapped(_ sender: AnyObject) {
        preventChooseMany(button: julyButton)
        if julyButton.backgroundColor == UIColor.white {
            choose(button: julyButton)
        }
        else {
            unChoose(button: julyButton)
        }
    }
    
    @IBAction func augButton_Tapped(_ sender: AnyObject) {
        preventChooseMany(button: augButton)
        if augButton.backgroundColor == UIColor.white {
            choose(button: augButton)
        }
        else {
            unChoose(button: augButton)
        }
    }
    
    
    @IBAction func sepButton_Tapped(_ sender: AnyObject) {
        preventChooseMany(button: sepButton)
        if marchButton.backgroundColor == UIColor.white {
            choose(button: sepButton)
        }
        else {
            unChoose(button: sepButton)
        }
    }
    
    @IBAction func octButton_Tapped(_ sender: AnyObject) {
        preventChooseMany(button: octButton)
        if octButton.backgroundColor == UIColor.white {
            choose(button: octButton)
        }
        else {
            unChoose(button: octButton)
        }
    }
    
    @IBAction func novButton_Tapped(_ sender: AnyObject) {
        preventChooseMany(button: novButton)
        if novButton.backgroundColor == UIColor.white {
            choose(button: novButton)
        }
        else {
            unChoose(button: novButton)
        }
    }
    
    @IBAction func decButton_Tapped(_ sender: AnyObject) {
        preventChooseMany(button: decButton)
        if marchButton.backgroundColor == UIColor.white {
            choose(button: decButton)
        }
        else {
            unChoose(button: decButton)
        }
    }
    
    
    @IBAction func doneButton_Tapped(_ sender: AnyObject) {
        if month != -1 {
            let intentData = loadGivingDataOnMonth(month: month)
            loadReplacingDataOnMonth(intentData: intentData)
        }
        self.centerPopupContants.constant = -300
        UIView.animate(withDuration: 0.3, animations:{
            self.view.layoutIfNeeded()
        })
    }
    
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backButton.setTitle(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.BACK_BUTTON), for: .normal)
        self.titleLabel.text = Language.BUILDER.get(group: Group.TITLE, view: TitleViews.STATS_MONTH)
        self.givingMoneyLabel.text = Language.BUILDER.get(group: Group.TITLE, view: TitleViews.MONEY_GIVING)
        self.replacingMoneyLabel.text = Language.BUILDER.get(group: Group.TITLE, view: TitleViews.MONEY_REPLACING)
        self.notificationLabel.text = Language.BUILDER.get(group: Group.MESSAGE, view: Message.NO_DATA_CHARTS)
        
        self.givingMoneyLabel.isHidden = true
        self.replacingMoneyLabel.isHidden = true
        
        self.doneButton.setTitle(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.DONE), for: .normal)
        self.moneyUnitLabel.text = "(" + ExchangeRate.BUILDER.RateType.rawValue + ")"
        self.chooseMonth.placeholder = Language.BUILDER.get(group: Group.PLACEHOLDER, view: PlaceholderViews.INPUT_MONTH)
        
        let borderColor = UIColor(colorLiteralRed: 224/255, green: 224/255, blue: 224/255, alpha: 1).cgColor
        
        self.chooseMonthView.layer.borderWidth = 1
        self.chooseMonthView.layer.borderColor = borderColor
        self.chooseMonthView.layer.cornerRadius = 10
        self.chooseMonthView.layer.masksToBounds = true
        
        self.chooseMonth.delegate = self
        self.doneButton.setTitle(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.DONE), for: .normal)
        
        unChoose(button: janButton)
        unChoose(button: febButton)
        unChoose(button: marchButton)
        unChoose(button: aprilButton)
        unChoose(button: mayButton)
        unChoose(button: juneButton)
        unChoose(button: julyButton)
        unChoose(button: augButton)
        unChoose(button: sepButton)
        unChoose(button: octButton)
        unChoose(button: novButton)
        unChoose(button: decButton)
    }
    
    private func preventChooseMany(button: UIButton) {
        if preButton != nil {
            unChoose(button: preButton!)
        }
        preButton = button
    }
    
    private func choose(button: UIButton) {
        button.backgroundColor = UIColor.blue
        button.titleLabel?.textColor = UIColor.white
        month = Int((button.titleLabel?.text!)!)!
        self.chooseMonth.text = button.titleLabel?.text!
    }
    
    private func unChoose(button: UIButton) {
        button.backgroundColor = UIColor.white
        button.titleLabel?.textColor = UIColor.blue
        month = -1
        self.chooseMonth.text! = ""
    }
    
    private func getTotalGivingMoney(month: Int, type: JARS_TYPE, intent: [DTOIntent])->Double {
        var totalMoney = 0.0
        
        for i in 0..<intent.count {
            let date = Date(timeIntervalSince1970: TimeInterval(intent[i].timestamp / 10))
            
            if intent[i].type == type && Date.getMonth(date: date) == month {
                totalMoney = totalMoney + intent[i].money
            }
        }
        
        return totalMoney
    }
    
    
    private func getTotalReplacingMoney(intentData: [DTOIntent], type: JARS_TYPE, alternatives: [DTOAlternatives])->Double {
        var totalMoney = 0.0
        
        for i in 0..<intentData.count {
            for j in 0..<alternatives.count {
                if intentData[i].timestamp == alternatives[j].timestamp {
                    totalMoney = totalMoney + alternatives[i].money
                }
            }
        }
        
        return totalMoney
    }
    
    private func createDataForGivingChart(month: Int, intentData: [DTOIntent])->[Double] {
        var result = [Double]()
        
        result.append(getTotalGivingMoney(month: month, type: JARS_TYPE.NEC, intent: intentData))
        result.append(getTotalGivingMoney(month: month, type: JARS_TYPE.FFA, intent: intentData))
        result.append(getTotalGivingMoney(month: month,type: JARS_TYPE.LTSS, intent: intentData))
        result.append(getTotalGivingMoney(month: month,type: JARS_TYPE.EDU, intent: intentData))
        result.append(getTotalGivingMoney(month: month,type: JARS_TYPE.PLAY, intent: intentData))
        result.append(getTotalGivingMoney(month: month,type: JARS_TYPE.GIVE, intent: intentData))
        
        return result
    }
    
    private func createDataForReplacingChart(intentData: [DTOIntent], replacingData: [DTOAlternatives])->[Double] {
        var result = [Double]()
        
        result.append(getTotalReplacingMoney(intentData: intentData,type: JARS_TYPE.NEC, alternatives: replacingData))
        result.append(getTotalReplacingMoney(intentData: intentData,type: JARS_TYPE.FFA, alternatives: replacingData))
        result.append(getTotalReplacingMoney(intentData: intentData,type: JARS_TYPE.LTSS, alternatives: replacingData))
        result.append(getTotalReplacingMoney(intentData: intentData,type: JARS_TYPE.EDU, alternatives: replacingData))
        result.append(getTotalReplacingMoney(intentData: intentData,type: JARS_TYPE.PLAY, alternatives: replacingData))
        result.append(getTotalReplacingMoney(intentData: intentData,type: JARS_TYPE.GIVE, alternatives: replacingData))
        
        return result
    }
    
    
    func loadGivingDataOnMonth(month: Int)->[DTOIntent] {
        let intentData = DAOIntent.BUILDER.GetAll(hasState: .DONE)
        if intentData.count > 0 {
            
            var entries: [BarChartDataEntry] = []
            let jar_Title = ["", "NEC", "FFA", "LTSS", "EDU", "PLAY", "GIVE"]
            let dataFromIntent = createDataForGivingChart(month: month, intentData: intentData)
            
            var flag = 0
            
            for i in 0..<dataFromIntent.count {
                if dataFromIntent[i] != 0 {
                    flag = 1
                }
                entries.append(BarChartDataEntry(x: Double(i + 1), yValues: [dataFromIntent[i]]))
            }
            
            if flag == 1 {
                self.givingMoneyLabel.isHidden = false
                self.replacingMoneyLabel.isHidden = false
                self.notificationLabel.isHidden = true
                drawBarChart(entries: entries, titleEachBar: jar_Title, barChart: self.monthGivingStats)
            }
            else {
                self.givingMoneyLabel.isHidden = true
                self.replacingMoneyLabel.isHidden = true
                self.notificationLabel.isHidden = false
            }
        }
        return intentData
    }
    
    func loadReplacingDataOnMonth(intentData: [DTOIntent]) {
        if let alternativesData = DAOAlternatives.BUILDER.GetAll() as? [DTOAlternatives] {
            
            var entries: [BarChartDataEntry] = []
            let jar_Title = ["", "NEC", "FFA", "LTSS", "EDU", "PLAY", "GIVE"]
            let dataFromAlter = createDataForReplacingChart(intentData: intentData, replacingData: alternativesData)
            
            var flag = 0
            
            for i in 0..<dataFromAlter.count {
                if dataFromAlter[i] != 0 {
                    flag = 1
                }
                entries.append(BarChartDataEntry(x: Double(i + 1), yValues: [dataFromAlter[i]]))
            }
            
            if flag == 1 {
                self.givingMoneyLabel.isHidden = false
                self.replacingMoneyLabel.isHidden = false
                self.notificationLabel.isHidden = true
               drawBarChart(entries: entries, titleEachBar: jar_Title, barChart: self.mongthReplacingStats)
            } else {
                self.givingMoneyLabel.isHidden = true
                self.replacingMoneyLabel.isHidden = true
                self.notificationLabel.isHidden = false
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

extension SpendingMonthStats: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder() // chan ban phim xuat hien
        self.centerPopupContants.constant = 0
        UIView.animate(withDuration: 0.3, animations:{
            self.view.layoutIfNeeded()
            })
        //chooseOneMonth()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false // khong cho nhap bat cu gi
    }
}
