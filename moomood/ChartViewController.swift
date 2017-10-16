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
    
    override func viewDidAppear(_ animated: Bool) {
        setUpChart()
       
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
