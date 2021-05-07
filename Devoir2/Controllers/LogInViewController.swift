//
//  ViewController.swift
//  Devoir2
//
//  Created by Mac11 on 2021-05-02.
//

import UIKit
import Darwin

class LogInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func unwindToMainMenu(sender: UIStoryboardSegue)
    {
        _ = sender.source
        // Pull any data from the view controller which initiated the unwind segue.
    }
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBAction func logIn(_ sender: Any) {
        connectedUser = ""
        let sema = DispatchSemaphore(value: 0)
        let email = self.username.text!
        let passwd = self.password.text!
        
        let headers = [
          "content-type": "application/json",
          "x-apikey": "a69b30815a22af7cf9dfc7ac0d7ba992673c2",
          "cache-control": "no-cache"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://colvalapis-9cfe.restdb.io/rest/radio-circulation-api")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
            print(error)
          } else {
            let httpResponse = response as? HTTPURLResponse
            print(httpResponse)
          }
            if let data = data{
              do{
                  let json = try JSONSerialization.jsonObject(with: data, options: [])
                  if let result = json as? [[String: Any]]{
                    for  item in result{
                        if (email == item["email"] as! String) {
                            if (verifyPassword(passwd: passwd, hash: item["passwd"] as! String)) {
                                connectedUser = email
                            }
                        }
                    }
                    sema.signal()
                  }
                  
              }catch{
                print(error)
              }
            }
        })
        dataTask.resume()
        sema.wait()
        if (connectedUser != "") {
            performSegue(withIdentifier: "toTabBar", sender: nil)
            return
        }
        let alert = UIAlertController(title: "Incorrect credentials", message: "Email or password is incorrect", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

