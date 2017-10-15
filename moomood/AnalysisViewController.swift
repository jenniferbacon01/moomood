//
//  AnalysisViewController.swift
//  moomood
//
//  Created by Elizabeth Chan on 11/10/2017.
//  Copyright © 2017 Jennifer Bacon. All rights reserved.
//

import UIKit
import Charts

class AnalysisViewController: UIViewController {
    
    var ratings: [Double] = [1,2,3,4,5]
    var matchedRatings: [String] = []
    var quantity: [Double] = [7,6,3,4,10]
    
    @IBOutlet weak var barChart: BarChartView!
    
    func setUpChart (){
        let moodsObject = NSKeyedUnarchiver.unarchiveObject(withFile: Mood.ArchiveURL.path)
        
        var moods: [Mood] = []
        
        if let tempmoods = moodsObject as? [Mood] {
            moods = tempmoods
        }
        
        // set up rating array
        for i in (0..<ratings.count){
            let rating = ratings[i]
            matchedRatings.append(String(rating))
        }
        
        //set up line array
        var barChartEntry = [BarChartDataEntry]()
        
        for i in (0..<quantity.count){
            let value = BarChartDataEntry(x: Double(i), y: Double(quantity[i]))
            barChartEntry.append(value)
        }
        
        print(barChartEntry)
        
        let frequencyBar = BarChartDataSet(values: barChartEntry, label: "Frequency")
        formatGraph(frequencyBar: frequencyBar)
        let data = BarChartData()
        
        data.addDataSet(frequencyBar)
        
        barChart.data = data
        
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:matchedRatings)
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

