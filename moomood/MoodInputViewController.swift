import UIKit
import RealmSwift

class MoodInputViewController: UIViewController, UITextFieldDelegate {
    
    var moodInputViewDisplay: MoodInputViewDisplay = MoodInputViewDisplay()
    @IBOutlet weak var chosenMoodMessage: UILabel!
    @IBOutlet weak var whyMessage: UILabel!
    var number: Int?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    
    @IBAction func button1(_ sender: Any) {
        number = 1
        buttonMethod(number: number!)
    }
    @IBAction func button2(_ sender: Any) {
        number = 2
        buttonMethod(number: number!)
    }
    @IBAction func button3(_ sender: UIButton) {
        number = 3
        buttonMethod(number: number!)
    }
    @IBAction func button4(_ sender: UIButton) {
        number = 4
        buttonMethod(number: number!)
    }
    @IBAction func button5(_ sender: UIButton) {
        number = 5
        buttonMethod(number: number!)
    }
    func buttonMethod(number: Int) {
        moodInputViewDisplay.displayChosenMoodMessage(number: number, chosenMoodMessage: chosenMoodMessage )
        whyMessage.isHidden = false
        moodInputViewDisplay.hideButtons(buttons: [button1, button2, button3, button4, button5])
        moodInputViewDisplay.showButtons(buttons: [workButton,familyButton, partnerButton, healthButton, homeButton, financesButton, weatherButton, otherButton, preferNotToSayButton])
    }
    @IBAction func workButton(_ sender: Any) {
        causeButtonMethod(cause: "Work")
    }
    @IBAction func familyButton(_ sender: Any) {
        causeButtonMethod(cause: "Family")
    }
    @IBAction func partnerButton(_ sender: Any) {
        causeButtonMethod(cause: "Partner")
    }
    @IBAction func healthButton(_ sender: Any) {
        causeButtonMethod(cause: "Health")
    }
    @IBAction func homeButton(_ sender: Any) {
        causeButtonMethod(cause: "Home")
    }
    @IBAction func financesButton(_ sender: Any) {
        causeButtonMethod(cause: "Finances")
    }
    @IBAction func weatherButton(_ sender: Any) {
        causeButtonMethod(cause: "Weather")
    }
    @IBAction func otherButton(_ sender: Any) {
        causeButtonMethod(cause: "Other")
    }
    @IBAction func ratherNotSayButton(_ sender: Any) {
        causeButtonMethod(cause: "")
    }
    func causeButtonMethod(cause: String) {
        let unformattedDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: unformattedDate)
        addMood(formattedDate, rating: number!, cause: cause, moodDescription: "", others: "")
        performSegue(withIdentifier: "goToChat", sender: nil)
    }
    
    func addMood(_ date: String, rating: Int, cause: String, moodDescription: String, others: String) {
        let mood = Mood()
        mood.date = date
        mood.rating = rating
        mood.cause = cause
        mood.moodDescription = moodDescription
        mood.others = others
        let realm = try! Realm()
        try! realm.write {
            realm.add(mood)
        }
    }

    @IBOutlet weak var workButton: UIButton!
    @IBOutlet weak var familyButton: UIButton!
    @IBOutlet weak var partnerButton: UIButton!
    @IBOutlet weak var healthButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var financesButton: UIButton!
    @IBOutlet weak var weatherButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    @IBOutlet weak var preferNotToSayButton: UIButton!

    override func viewDidAppear(_ animated: Bool) {
        chosenMoodMessage.text = nil
        whyMessage.isHidden = true
        moodInputViewDisplay.hideButtons(buttons: [workButton,familyButton, partnerButton, healthButton, homeButton, financesButton, weatherButton, otherButton, preferNotToSayButton])
        moodInputViewDisplay.showButtons(buttons: [button1, button2, button3, button4, button5])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        moodInputViewDisplay.formatButton(button: button1, colorOne: UIColor.black, colorTwo: UIColor.purple)
        moodInputViewDisplay.formatButton(button: button2, colorOne: UIColor.darkGray, colorTwo: UIColor.purple)
        moodInputViewDisplay.formatButton(button: button3, colorOne: UIColor.gray, colorTwo: UIColor.purple)
        moodInputViewDisplay.formatButton(button: button4, colorOne: UIColor.lightGray, colorTwo: UIColor.purple)
        moodInputViewDisplay.formatButton(button: button5, colorOne: UIColor.white, colorTwo: UIColor.purple)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
