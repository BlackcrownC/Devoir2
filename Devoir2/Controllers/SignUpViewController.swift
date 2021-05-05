//
//  SignUpViewController.swift
//  Devoir2
//
//  Created by Mac11 on 2021-05-03.
//

import UIKit
import BCryptSwift

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var retype: UITextField!
    
    @IBAction func createAccount(_ sender: Any) {
        if(!isAnEmail(email: username.text!)) {
            let alert = UIAlertController(title: "Incorrect email", message: "Please enter a correct email", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
            
        } else if(password.text! != retype.text! || password.text!.count < 4) {
            let alert = UIAlertController(title: "Incorrect password", message: "Please retype your password correctly and enter at least 4 characters", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            retype.text = ""
            return
        }
        
        let sema = DispatchSemaphore(value: 0)
        var emailError = false
        
        let headers = [
          "content-type": "application/json",
          "x-apikey": "a69b30815a22af7cf9dfc7ac0d7ba992673c2",
          "cache-control": "no-cache"
        ]
        let parameters = [
            "email": username.text!,
            "passwd": encrypt(passwd: password.text!)
        ] as [String : Any]

        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])

        let request = NSMutableURLRequest(url: NSURL(string: "https://colvalapis-9cfe.restdb.io/rest/radio-circulation-api")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData! as Data

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
            print(error)
          } else {
            let httpResponse = response as? HTTPURLResponse
            print(httpResponse)
            if (httpResponse?.statusCode == 400) {
                emailError = true
            }
            sema.signal()
          }
        })
        dataTask.resume()
        sema.wait()
        if (emailError) {
            let alert = UIAlertController(title: "Incorrect email", message: "This email is already taken. Please use another one", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.username.text = ""
            return
        }
        let alert = UIAlertController(title: "Nice job", message: "Account successfully created", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Well thanks", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            self.performSegue(withIdentifier: "toLogIn", sender: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
