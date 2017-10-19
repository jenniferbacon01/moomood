import UIKit
import RealmSwift
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var _username: UITextField!
    @IBOutlet var _password: UITextField!
    @IBOutlet var loginSignUpButton: UIButton!
    @IBOutlet var switchLoginSignUpButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    
    var signUpMode = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.isHidden = true
        self._username.delegate = self
        self._password.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func switchLoginSignUpButtonTapped(_ sender: Any) {
        if signUpMode {
            loginSignUpButton.setTitle("Log In", for: .normal)
            switchLoginSignUpButton.setTitle("Sign Up", for: .normal)
            signUpMode = false
        } else {
            loginSignUpButton.setTitle("Sign Up", for: .normal)
            switchLoginSignUpButton.setTitle("Log In", for: .normal)
            signUpMode = true
        }
    }
    
    @IBAction func loginSignUpButtonTapped(_ sender: Any) {
        if signUpMode {
            let user = PFUser()
            
            user.username = _username.text
            user.password = _password.text

            user.signUpInBackground(block: { (success, error) in
                if error != nil {
                    var errorMessage = "Sign up Failed - Try Again"
                    if let newError = error as NSError? {
                        if let detailError = newError.userInfo["error"] as? String {
                            errorMessage = detailError
                        }
                    }
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = errorMessage
                } else {
                    print("Sign Up Successful")
                    self.performSegue(withIdentifier: "updateSegue", sender: nil)
                }
            })
            
        } else {
            if let username = _username.text {
                if let password = _password.text{
                    PFUser.logInWithUsername(inBackground: username, password: password, block: { (user, error) in
                        if error != nil {
                            var errorMessage = "Login Failed - Try Again"
                            if let newError = error as NSError? {
                                if let detailError = newError.userInfo["error"] as? String {
                                    errorMessage = detailError
                                }
                            }
                            self.errorLabel.isHidden = false
                            self.errorLabel.text = errorMessage
                        } else {
                            print("Login Successful")
                            self.performSegue(withIdentifier: "updateSegue", sender: nil)
                        }
                    })
                }
            }
            
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        if PFUser.current() != nil {
//            self.performSegue(withIdentifier: "updateSegue", sender: nil)
//        }
//    }
    
    
//    
//    func startSession(userId: String){
//        UserDefaults.standard.set(userId, forKey:"userId");
//        UserDefaults.standard.synchronize();
//    }


}



