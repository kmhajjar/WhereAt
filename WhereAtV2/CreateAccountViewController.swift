//
//  CreateAccountViewController.swift
//  WhereAtV2
//
//  Created by Katia Hajjar on 4/12/17.
//  Copyright © 2017 Katia Hajjar. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "createdAccount") {
            createAccount()
        }
    }
    
    
    func createAccount() {
        
        let username = usernameField.text
        let password = passwordField.text
        let url = URL(string: "https://tranquil-citadel-40512.herokuapp.com/create_account")
        
        let json: [String: Any] = ["username": username!,
                                   "password": password!]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                if ("\(httpResponse.statusCode)" == "200") {
                    
                }
                else if ("\(httpResponse.statusCode)" == "403") {
                }
                print("statusCode: \(httpResponse.statusCode)")
            }
            //then perform segue and pass user data
        }
        
        task.resume()
        
    }

    
    
    
    func keyboardWillShow(sender: Notification) {
        self.view.frame.origin.y = -150 // Move view 150 points upward
    }
    
    func keyboardWillHide(sender: Notification) {
        self.view.frame.origin.y = 0 // Move view to original position
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
