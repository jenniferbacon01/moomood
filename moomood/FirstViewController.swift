import UIKit
import RealmSwift

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var table: UITableView!
    var moods: Results<Mood>!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        loadData()
        return moods.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Date                            Rating               Reason"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        loadData()
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = String(describing: moods[indexPath.row].date + "                        " + String(describing:moods[indexPath.row].rating) + "/5" + "                    " + String(describing:moods[indexPath.row].cause.capitalized))
        cell.textLabel?.font = UIFont(name: "Avenir Next Ultra Light", size: 17)
        cell.textLabel?.textColor = UIColor.purple
        return cell
    }
    
    func loadData(){
        let realm = try! Realm()
        moods = realm.objects(Mood.self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            table.reloadData()
            loadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        table.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}



