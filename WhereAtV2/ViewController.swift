//
//  ViewController.swift
//  WhereAtV2
//
//  Created by Katia Hajjar on 3/31/17.
//  Copyright © 2017 Katia Hajjar. All rights reserved.
//

import UIKit
import FacebookLogin
import GoogleMaps
import GooglePlaces

//let secondViewController = navController.topViewController as! SecondViewController


class ViewController: UIViewController {
   
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)


//        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
//        loginButton.center = view.center
//        
//        view.addSubview(loginButton)
        
//        let segue_button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
//        segue_button.backgroundColor = UIColor.red
//        segue_button.addTarget(self, action: #selector(sometest), for:.touchUpInside)
//        self.view.addSubview(segue_button)
//        
        
//        NotificationCenter.default.addObserver(self, selector: Selector(("keyboardWillShow:")), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
//        NotificationCenter.default.addObserver(self, selector: Selector(("keyboardWillHide:")), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func sometest(sender: UIButton!) {
//        print("button tapped")
//    }

    
    var counter = 0
    var loggedin = false


    
    
    @IBOutlet weak var new_button: UIButton!
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        print("hello");
        let url = URL(string: "http://127.0.0.1:5000/create_event")
        

    
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil
                
                else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            print(json)
        }

        
        task.resume()
    }
    
    
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var testLogin: UIButton!
    
//    @IBAction func testLogin(_ sender: Any) {
//        let username = usernameField.text
//        let password = passwordField.text
//        
////SAFETY CHECK
////        let username = "test"
////        let password = "12345"
//        
//        let url = URL(string: "http://127.0.0.1:5000/create_event")
//        
//        let json: [String: Any] = ["username": username!,
//                                   "password": password!]
//        
//        
//        let jsonData = try? JSONSerialization.data(withJSONObject: json)
//        var request = URLRequest(url: url!)
//        request.httpMethod = "POST"
//        
//        // insert json data to the request
//        request.httpBody = jsonData
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                print(error?.localizedDescription ?? "No data")
//                return
//            }
//            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//            if let responseJSON = responseJSON as? [String: Any] {
//                print(responseJSON)
//
//            }
//            if let httpResponse = response as? HTTPURLResponse {
//                if ("\(httpResponse.statusCode)" == "200") {
////                    self.LoginUser(user: username!, password: password!)
//                    self.loggedin = true
//                }
//                else if ("\(httpResponse.statusCode)" == "404") {
//                    self.loggedin = false
//                }
//                print("statusCode: \(httpResponse.statusCode)")
//            }
//            //then perform segue and pass user data
//        }
//    
//        
//        task.resume()
//        
//
//    }
    
    
    @IBAction func testLoginFunction(_ sender: Any) {
        authenticate(isTest:true) {
            (result) -> Void in
            print(result)
            if (result) {
                self.loggedin = true
                DispatchQueue.main.async(execute: {
                super.performSegue(withIdentifier: "LoggedIn", sender: sender)
                })
                print("youre loggedin")
            }
            else {
                self.loggedin = false
                print("hello")
            }
            
        }
    }
    
    //button that calls authenticat
    //perform segue --> calls prepare
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if (segue.identifier == "LoggedIn") {

            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
            let tabBarController = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarTest") as! UITabBarController
            tabBarController.selectedIndex = 2
            appDelegate.username = self.usernameField.text
            appDelegate.password = self.passwordField.text
            appDelegate.window?.rootViewController!.present(tabBarController, animated:true, completion:nil)
            
        }
//        if (segue.identifier == "LoggedIn") {
        
          
          
            
            
//            let barViewControllers = segue.destination as! UITabBarController
//        let tabBarController = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarTest") as! UITabBarController

//            let detailController = tabBarController?.viewControllers![1] as! MeetupTableViewController
//            appDelegate.tabBarController.selectedIndex = 1;
//            detailController.username_test = usernameField.text
//            detailController.password_test = passwordField.text
            //need to have the username password fields with the other thing.
            //then on create pass back
            

//        }
    
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == "LoggedIn") {
            if (loggedin) {
//                self.errorLabel.text = ""

                return true
            }
            else {
                //set text
//                self.errorLabel.text = "Username taken or does not exist"
//                self.errorLabel.textColor = UIColor.init(red: 254/255, green: 164/255, blue: 178/255, alpha: 1.0)

//                self.errorLabel.isHidden = false
                return false
            }
        }
        
        if (identifier == "createAccount") {
            return true
        }
        return false
    }
    
    
    func authenticate(isTest:Bool, withCompletionHandler:@escaping (_ result:Bool) -> Void) {
        
            let username = usernameField.text
            let password = passwordField.text
            let url = URL(string: "https://tranquil-citadel-40512.herokuapp.com/login")
            
            let json: [String: Any] = ["username": username!,
                                       "password": password!]
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            
            // insert json data to the request
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    if ("\(httpResponse.statusCode)" == "200") {
//                        self.loggedin = true
                        
                        
                        
                        
                        withCompletionHandler(true)
                    }
                    else if ("\(httpResponse.statusCode)" == "403") {
                        self.loggedin = false
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
//
    
    
    



}

