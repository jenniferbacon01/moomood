//
//  ChartViewController.swift
//  moomood
//
//  Created by Elizabeth Chan on 11/10/2017.
//  Copyright © 2017 Jennifer Bacon. All rights reserved.
//

import UIKit
import Charts
import RealmSwift

class ChartViewController: UIViewController {
    
    var ratings: [Double] = []
    var matchedDates: [String] = []
    
    @IBOutlet weak var chtChart: LineChartView!
    
    func setUpChart (){
//        let moodsObject = NSKeyedUnarchiver.unarchiveObject(withFile: Mood.ArchiveURL.path)
//
//        var moods: [Mood] = []
//
//        if let tempmoods = moodsObject as? [Mood] {
//            moods = tempmoods
//        }
//
        let realm = try! Realm()
        let moods = realm.objects(MoodDB.self)
        print(moods)

        
        // set up matched dates array
        for i in (0..<moods.count){
            let date = moods[i].date
            matchedDates.append(date)
        }
        
        //set up line array
        var lineChartEntry = [ChartDataEntry]()
        
        for i in (0..<moods.count){
            let value = ChartDataEntry(x: Double(i), y: Double(moods[i].rating))
            lineChartEntry.append(value)
        }
        
        let moodLine = LineChartDataSet(values: lineChartEntry, label: "Mood")
        formatGraph(moodLine: moodLine)
        let data = LineChartData()
        
        data.addDataSet(moodLine)
        
        chtChart.data = data
        
        chtChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:matchedDates)
        chtChart.xAxis.granularity = 1
        chtChart.setVisibleXRangeMaximum(6)
        
        // show the latest entries
        let when = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.chtChart.moveViewToX(Double(moods.count - 1))
        }
    }
    
    func formatGraph (moodLine: LineChartDataSet){
        moodLine.colors = [NSUIColor.purple]
        moodLine.mode = .cubicBezier
        
        moodLine.lineWidth = 0.1
        moodLine.valueColors = [NSUIColor.orange]
        moodLine.drawValuesEnabled = false
        
        //remove coordinate circles
        moodLine.circleRadius = 0
        
        //remove xAxis gridlines
        chtChart.xAxis.drawGridLinesEnabled = false
        
        //remove yAxis gridlines
        chtChart.leftAxis.drawGridLinesEnabled = false
        chtChart.rightAxis.drawGridLinesEnabled = false
        
        
        //remove xAxis
        chtChart.xAxis.drawAxisLineEnabled = false
        
        //keep left yAxis
        chtChart.leftAxis.drawAxisLineEnabled = true
        chtChart.rightAxis.drawAxisLineEnabled = false
        
        //remove description
        chtChart.chartDescription?.text = ""
        
        // label at the bottom
        chtChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        
        // fill in area below line
        moodLine.drawFilledEnabled = true
        moodLine.fillColor = NSUIColor.purple
        moodLine.fillAlpha = 0.3
        
        //remove label and color block
        
        // remove right y axis
        chtChart.rightAxis.enabled = false
        
        // pinch zoom enabled
        chtChart.pinchZoomEnabled = true
        
        // font size of x and y axis labels
        chtChart.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
        chtChart.leftAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
        
        
        // make sure x axis labels are visible
        chtChart.xAxis.avoidFirstLastClippingEnabled = true
       
        // setting scale and range on y axis
        chtChart.leftAxis.axisMinimum = 0.5
        chtChart.leftAxis.axisMaximum = 5.3
        chtChart.leftAxis.granularityEnabled = true
        chtChart.leftAxis.granularity = 1.0
        
    }
    
   
    
    @IBOutlet weak var barChart: BarChartView!
//    var exampleRatings: [Double] = [1,2,3,4,5]
//    var matchedRatings: [String] = []
//    var exampleQuantity: [Double] = [7,6,3,4,10]
    
    
    
    func setUpBarChart (){
        
        
        let realm = try! Realm()
        let moods = realm.objects(MoodDB.self)
        var count1 : Int = 0
        var count2 : Int = 0
        var count3 : Int = 0
        var count4 : Int = 0
        var count5 : Int = 0
        
        for i in (0..<moods.count){
            if moods[i].rating == 1 {
                count1 += 1
            }
        }
        for i in (0..<moods.count){
            if moods[i].rating == 2 {
                count2 += 1
            }
        }
        for i in (0..<moods.count){
            if moods[i].rating == 3 {
                count3 += 1
            }
        }
        for i in (0..<moods.count){
            if moods[i].rating == 4 {
                count4 += 1
            }
        }
        for i in (0..<moods.count){
            if moods[i].rating == 5 {
                count5 += 1
            }
        }
        let frequencies: [Int] = [count1, count2, count3, count4, count5]
        let barRatings: [Int]! = [1,2,3,4,5]
        
            
            
            //set up line array
            var barChartEntry = [BarChartDataEntry]()
            
            for i in (0..<frequencies.count){
                let value = BarChartDataEntry(x: Double(i), y: Double(frequencies[i]))
                barChartEntry.append(value)
            }
            
            print(barChartEntry)
            
            let frequencyBar = BarChartDataSet(values: barChartEntry, label: "Frequency")
            formatGraph(frequencyBar: frequencyBar)
            let data = BarChartData()
            
            data.addDataSet(frequencyBar)
            
            barChart.data = data
            
//            barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:[String(barRatings)])
            barChart.xAxis.axisMinimum = -0.5
            barChart.xAxis.axisMaximum = Double(barChartEntry.count) - 0.5;
            barChart.xAxis.axisMaximum = 4.5
            barChart.xAxis.granularityEnabled = true
            barChart.xAxis.granularity = 1.0
            barChart.setVisibleXRangeMaximum(5)
            data.barWidth = 0.80
            
            // show the latest entries
            //        let when = DispatchTime.now() + 0.1
            //        DispatchQueue.main.asyncAfter(deadline: when) {
            //            self.barChart.moveViewToX(Double(moods.count - 1))
            //        }
        }
    
    func formatGraph (frequencyBar: BarChartDataSet){
        frequencyBar.colors = [NSUIColor.purple]
        frequencyBar.drawValuesEnabled = false
        
        //remove xAxis gridlines
        barChart.xAxis.drawGridLinesEnabled = false
        
        //remove yAxis gridlines
        barChart.leftAxis.drawGridLinesEnabled = false
        barChart.rightAxis.drawGridLinesEnabled = false
        
        //remove xAxis
        barChart.xAxis.drawAxisLineEnabled = false
        
        //keep left yAxis
        barChart.leftAxis.drawAxisLineEnabled = true
        barChart.rightAxis.drawAxisLineEnabled = false
        
        //remove description
        barChart.chartDescription?.text = ""
        
        // label at the bottom
        barChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        
        // remove right y axis
        barChart.rightAxis.enabled = false
        
        // pinch zoom enabled
        barChart.pinchZoomEnabled = true
        
        // font size of x and y axis labels
        barChart.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
        barChart.leftAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
        
        
        // make sure x axis labels are visible
        barChart.xAxis.avoidFirstLastClippingEnabled = true
        
        // setting scale and range on y axis
        barChart.leftAxis.axisMinimum = 0
        barChart.leftAxis.granularityEnabled = true
        barChart.leftAxis.granularity = 1.0
        
    }
    
        
       
    override func viewDidAppear(_ animated: Bool) {
        setUpChart()
        setUpBarChart()
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
