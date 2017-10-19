
import UIKit
import RealmSwift

class JournalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var moods: Results<Mood>!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        loadData()
        return moods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        loadData()
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = String(describing: moods[indexPath.row].date + String(describing:moods[indexPath.row].moodDescription))
        return cell
    }
    
    func loadData(){
        let realm = try! Realm()
        moods = realm.objects(Mood.self)
    }

    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        print(moods)
        table.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func test(_ sender: Any) {
        print(moods)
    }
}
