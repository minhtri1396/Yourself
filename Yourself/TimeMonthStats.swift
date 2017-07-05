import UIKit
import Charts

class TimeMonthStats: UIViewController {
    // MARK: *** Local variables
    
    var month:Int = -1
    var preButton: UIButton?
    
    // MARK: *** Data model
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var chooseMonth: UITextField!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var timeMonthStats: BarChartView!
    
    @IBOutlet weak var viewCenterContrant: NSLayoutConstraint!
    @IBOutlet weak var chooseMonthView: UIView!
    
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
    
    
    
    
    @IBAction func backButton_Tapped(_ sender: AnyObject) {
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
            loadDataOnMonth(month: month)
        }
        self.viewCenterContrant.constant = -300
        UIView.animate(withDuration: 0.3, animations:{
            self.view.layoutIfNeeded()
        })
    }
    
    
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backButton.setTitle(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.BACK_BUTTON), for: .normal)
        self.titleLabel.text = Language.BUILDER.get(group: Group.TITLE, view: TitleViews.STATS_MONTH)
        self.notificationLabel.text = Language.BUILDER.get(group: Group.MESSAGE, view: Message.NO_DATA_CHARTS)
        self.doneButton.setTitle(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.DONE), for: .normal)
        self.chooseMonth.placeholder = Language.BUILDER.get(group: Group.PLACEHOLDER, view: PlaceholderViews.INPUT_MONTH)
        self.doneButton.setTitle(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.DONE), for: .normal)
        self.chooseMonth.delegate = self
        self.timeMonthStats.noDataText = ""
        
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
    
    private func getData(month: Int, timeStats: [DTOTimeStats])->[Int64] {
        var result:[Int64] = [0, 0, 0]
        
        for i in 0..<timeStats.count {
            let m = Date.getMonth(date: Date(timeIntervalSince1970: TimeInterval(timeStats[i].timestamp / 10)))
            let y = Date.getYear(date: Date(timeIntervalSince1970: TimeInterval(timeStats[i].timestamp / 10)))
            let nowY = Date.getYear(date: Date())
            
            if m == month && y == nowY {
                result[0] = result[0] + Int64(timeStats[i].numberSuccessNotes)
                result[1] = result[1] + Int64(timeStats[i].numberFailNotes)
                result[2] = result[2] + Int64(timeStats[i].totalNumberNotes)
            }
        }
        
        return result
    }
    
    
    func loadDataOnMonth(month: Int) {
        if let timeStats = DAOTimeStats.BUILDER.GetAll() as? [DTOTimeStats] {
            
            var entries: [BarChartDataEntry] = []
            let titles = ["", "Success", "Fail", "Total note"]
            var result = getData(month: month, timeStats: timeStats)
            
            var flag = 0
            
            for i in 0..<result.count {
                if result[i] != 0 {
                    flag = 1
                }
                entries.append(BarChartDataEntry(x: Double(i + 1), yValues: [Double(result[i])]))
            }
            
            if flag == 1 {
                self.notificationLabel.isHidden = true
                drawBarChart(entries: entries, titleEachBar: titles, barChart: self.timeMonthStats)
            }
            else {
                self.notificationLabel.isHidden = false
            }
        }
    }
    
    private func drawBarChart(entries: [BarChartDataEntry], titleEachBar: [String], barChart:  BarChartView) {
        let dataSet = BarChartDataSet(values: entries, label: "")
        dataSet.axisDependency = .right
        dataSet.colors = [#colorLiteral(red: 0.2235294118, green: 0.2862745098, blue: 0.6705882353, alpha: 1), #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)]
        
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

extension TimeMonthStats: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder() // chan ban phim xuat hien
        self.viewCenterContrant.constant = 0
        UIView.animate(withDuration: 0.3, animations:{
            self.view.layoutIfNeeded()
        })
        //chooseOneMonth()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false // khong cho nhap bat cu gi
    }
}
