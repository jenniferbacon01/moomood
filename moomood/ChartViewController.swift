//
//  ChartViewController.swift
//  moomood
//
//  Created by Elizabeth Chan on 11/10/2017.
//  Copyright © 2017 Jennifer Bacon. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController {
    
    var ratings: [Double] = []
    var matchedDates: [String] = []
    var dateArray: [String] = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
    
 

    
    
    @IBOutlet weak var chtChart: LineChartView!
    
    func setUpChart (){
        let moodsObject = NSKeyedUnarchiver.unarchiveObject(withFile: Mood.ArchiveURL.path)
        
        var moods: [Mood] = []
        
        if let tempmoods = moodsObject as? [Mood] {
            moods = tempmoods
        }
        
        // set up matched dates array
        let formatter = DateFormatter()
        formatter.dateFormat="dd MMM"
        
        
        for i in (0..<moods.count){
            let date = moods[i].date
//            let cleanDate = formatter.string(from: date)
            print("LOOK HERE")
//            print(cleanDate)
            matchedDates.append(date)
        }
        
        //set up line array
        var lineChartEntry = [ChartDataEntry]()
        
        for i in (0..<moods.count){
            let value = ChartDataEntry(x: Double(i), y: Double(moods[i].rating))
            lineChartEntry.append(value)
        }
        
        let moodLine = LineChartDataSet(values: lineChartEntry, label: "Mood")
        
        let data = LineChartData()
        
        data.addDataSet(moodLine)
        
        chtChart.data = data
        
        chtChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:matchedDates)
        chtChart.xAxis.granularity = 1

        

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
