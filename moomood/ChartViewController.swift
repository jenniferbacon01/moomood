import UIKit
import Charts
import RealmSwift

class ChartViewController: UIViewController {
    
    @IBOutlet weak var chtChart: LineChartView!
    var ratings: [Double] = []
    var dates: [String] = []
    let realm = try! Realm()
    
    func setUpLineChart (){
        let moods = realm.objects(Mood.self)

        for i in (0..<moods.count){
            let date = moods[i].date
            dates.append(date)
        }
        
        var lineChartEntry = [ChartDataEntry]()
        
        for i in (0..<moods.count){
            let value = ChartDataEntry(x: Double(i), y: Double(moods[i].rating))
            lineChartEntry.append(value)
        }
        
        let moodLine = LineChartDataSet(values: lineChartEntry, label: "Mood")
        formatLineChart(moodLine: moodLine)
        lineChartData(moodLine: moodLine)
        
        let when = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.chtChart.moveViewToX(Double(moods.count - 1))
        }
    }
    
    func lineChartData(moodLine: LineChartDataSet){
        let data = LineChartData()
        data.addDataSet(moodLine)
        chtChart.data = data
        chtChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:dates)
        chtChart.xAxis.granularity = 1
        chtChart.setVisibleXRangeMaximum(6)
    }
    
    func formatLineChart (moodLine: LineChartDataSet){
        formatMoodLine(moodLine: moodLine)
        formatGridLineChart()
    }
    
    func formatMoodLine(moodLine: LineChartDataSet){
        moodLine.colors = [NSUIColor.purple]
        moodLine.mode = .cubicBezier
        moodLine.lineWidth = 0.1
        moodLine.valueColors = [NSUIColor.orange]
        moodLine.drawValuesEnabled = false
        moodLine.circleRadius = 0
        moodLine.drawFilledEnabled = true
        moodLine.fillColor = NSUIColor.purple
        moodLine.fillAlpha = 0.3
    }
    
    func formatGridLineChart() {
        chtChart.xAxis.drawGridLinesEnabled = false
        chtChart.leftAxis.drawGridLinesEnabled = false
        chtChart.rightAxis.drawGridLinesEnabled = false
        chtChart.xAxis.drawAxisLineEnabled = false
        chtChart.leftAxis.drawAxisLineEnabled = true
        chtChart.rightAxis.drawAxisLineEnabled = false
        chtChart.chartDescription?.text = ""
        chtChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        chtChart.rightAxis.enabled = false
        chtChart.pinchZoomEnabled = true
        chtChart.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
        chtChart.leftAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
        chtChart.xAxis.avoidFirstLastClippingEnabled = true
        chtChart.leftAxis.axisMinimum = 0.5
        chtChart.leftAxis.axisMaximum = 5.3
        chtChart.leftAxis.granularityEnabled = true
        chtChart.leftAxis.granularity = 1.0
        chtChart.layer.shadowColor = UIColor.darkGray.cgColor
        chtChart.layer.shadowOpacity = 1
        chtChart.layer.shadowOffset = CGSize.zero
        chtChart.layer.shadowRadius = 10
        barChart.layer.shadowColor = UIColor.lightGray.cgColor
        barChart.layer.shadowOpacity = 1
        barChart.layer.shadowOffset = CGSize.zero
        barChart.layer.shadowRadius = 10
    }
    
    @IBOutlet weak var barChart: BarChartView!
    
    func setUpBarChart (){
        
        let moods = realm.objects(Mood.self)
        var count1 : Int = 0
        var count2 : Int = 0
        var count3 : Int = 0
        var count4 : Int = 0
        var count5 : Int = 0
        
        for i in (0..<moods.count){
            if moods[i].rating == 1 {
                count1 += 1
            } else if moods[i].rating == 2 {
                count2 += 1
            } else if moods[i].rating == 3 {
                count3 += 1
            } else  if moods[i].rating == 4 {
                count4 += 1
            } else if moods[i].rating == 5 {
                count5 += 1
            }
        }
        
        let frequency: [Int] = [count1, count2, count3, count4, count5]
        var barChartEntry = [BarChartDataEntry]()
            
        for i in (0..<frequency.count){
            let value = BarChartDataEntry(x: Double(i)+1, y: Double(frequency[i]))
            barChartEntry.append(value)
        }
        
        let frequencyBar = BarChartDataSet(values: barChartEntry, label: "Frequency")
        formatBarChart(frequencyBar: frequencyBar)
        barChartData(frequencyBar: frequencyBar)
        barChart.xAxis.axisMaximum = Double(barChartEntry.count) - 0.5;
    }
    
    func barChartData(frequencyBar: BarChartDataSet){
        let data = BarChartData()
        data.addDataSet(frequencyBar)
        barChart.data = data
        data.barWidth = 0.80
        barChart.xAxis.granularityEnabled = true
        barChart.xAxis.granularity = 1.0
        barChart.setVisibleXRangeMaximum(5)
        barChart.xAxis.axisMinimum = 0.5
        barChart.xAxis.axisMaximum = 5.5
    }
    
    func formatBarChart (frequencyBar: BarChartDataSet){
        formatFrequencyBar(frequencyBar: frequencyBar)
        formatGridBarChart()
    }
    
    func formatFrequencyBar(frequencyBar: BarChartDataSet){
        frequencyBar.colors = [NSUIColor.purple]
        frequencyBar.drawValuesEnabled = false
    }
    
    func formatGridBarChart(){
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.leftAxis.drawGridLinesEnabled = false
        barChart.rightAxis.drawGridLinesEnabled = false
        barChart.xAxis.drawAxisLineEnabled = false
        barChart.leftAxis.drawAxisLineEnabled = true
        barChart.rightAxis.drawAxisLineEnabled = false
        barChart.chartDescription?.text = ""
        barChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        barChart.rightAxis.enabled = false
        barChart.pinchZoomEnabled = true
        barChart.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
        barChart.leftAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
        barChart.xAxis.avoidFirstLastClippingEnabled = true
        barChart.leftAxis.axisMinimum = 0
        barChart.leftAxis.granularityEnabled = true
        barChart.leftAxis.granularity = 1.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpLineChart()
        setUpBarChart()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
