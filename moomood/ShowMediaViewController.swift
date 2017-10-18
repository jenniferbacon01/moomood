import UIKit

class ShowMediaViewController: UIViewController {
    var image: UIImage? = nil
    var titreText: String!
    
    @IBOutlet weak var imageView: UIImageView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        if image != nil {
            imageView.image = image
        } else {
            print("image not found")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
