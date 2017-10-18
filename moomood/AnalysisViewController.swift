import UIKit
import RealmSwift

class AnalysisViewController: UIViewController {

    @IBOutlet weak var happyOverviewMessage: UILabel!
    @IBOutlet weak var sadOverviewMessage: UILabel!
    var happyMessage: [String] = []
    var sadMessage: [String] = []
    
    @IBOutlet weak var average: UILabel!
    
    func setUpOverviews (){
        let realm = try! Realm()
        let moods = realm.objects(Mood.self)
        print(moods)
        var sumOfMoods: Double = 0.0
        var startMoods: Double = 0.0
        if moods.count < 10 {
            startMoods = Double(moods.count)
        } else {
            startMoods = 10
        }
        for i in (moods.count - Int(startMoods)..<moods.count){
            sumOfMoods += Double(moods[i].rating)
            if moods[i].moodDescription != "" {
                if moods[i].rating > 3 {
                    happyMessage.append(moods[i].moodDescription)
                } else if moods[i].rating < 3 {
                    sadMessage.append(moods[i].moodDescription)
                }
            }
        }
        happyOverviewMessage.text = (happyMessage.map{String(describing: $0)}).joined(separator: ", ")
        sadOverviewMessage.text = (sadMessage.map{String(describing: $0)}).joined(separator: ", ")
        let unroundedAverage = sumOfMoods/startMoods
        let roundedAverage = Double(round(100*unroundedAverage)/100)
        average.text = String(roundedAverage)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpOverviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
