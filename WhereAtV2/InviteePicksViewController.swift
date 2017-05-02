//
//  InviteePicksViewController.swift
//  WhereAtV2
//
//  Created by Katia Hajjar on 4/10/17.
//  Copyright © 2017 Katia Hajjar. All rights reserved.
//

import UIKit

class InviteePicksViewController: UIViewController {


    var finalLat: String!
    var finalLong : String!
    var meetupid : String!
    var meetuptitle : String!
    var names = [String]()
    var userPicks = [String]()
    var counter = 0
    
    @IBOutlet weak var option1Accept: UILabel!
    @IBOutlet weak var option2Accept: UILabel!
    @IBOutlet weak var option3Accept: UILabel!
    @IBOutlet weak var switch1: UISwitch!
    @IBOutlet weak var switch2: UISwitch!
    @IBOutlet weak var switch3: UISwitch!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var option1: UILabel!
    @IBOutlet weak var option2: UILabel!
    @IBOutlet weak var option3: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        option1.text = "Loading..."
        option2.text = "Loading..."
        option3.text = "Loading..."
        option1Accept.isHidden = true
        option2Accept.isHidden = true
        option3Accept.isHidden = true

        google_suggestions(isTest: true) { (results) -> Void in
            for result in results {
                self.counter = self.counter + 1
                if let name = result["name"] as? String {
                    print(name)
                    if (self.counter <= 3) {
                        self.names.append(name)
                    }
                    else {
                        break
                    }
                }
            }
            DispatchQueue.main.async() {
                self.option1.text = self.names[0]
                self.option2.text = self.names[1]
                self.option3.text = self.names[2]
    
            }
            
        }


        titleLabel.text = meetuptitle

      
    }
    
    @IBAction func switched(_ sender: UISwitch) {
        if (sender.tag == 5) {//means first buton
            option1Accept.isHidden = false

            if switch1.isOn {
                option1Accept.text = "I'd go!"

            }
            else
            {
                option1Accept.text = "No way!"
                
            }
        }
        else if (sender.tag == 6) {
            option2Accept.isHidden = false

            if switch2.isOn {
                option2Accept.text = "I'd go!"
            } else {
                option2Accept.text = "No way!"
            }
        }
        else if (sender.tag == 7) {
            option3Accept.isHidden = false

            if switch3.isOn {
                option3Accept.text = "I'd go!"
            } else {
                option3Accept.text = "No way!"
            }
        }
        
    
    }
    
    func send_suggestions() {
        let url = URL(string: "https://tranquil-citadel-40512.herokuapp.com/suggestions")
        
        let json: [String: Any] = ["event_id": meetupid, "owner_picks": [], "invitee_picks": userPicks]
        
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        
        request.httpBody = jsonData
        
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
                
            }
        }
        
        task.resume()
    }

    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //prepare an array, send it to JJ
        if (segue.identifier == "unwindPicksToFeed") {
            send_suggestions()
            let barViewControllers = segue.destination as! UITabBarController
        
            let navController = barViewControllers.viewControllers![0] as! UINavigationController
            //            navController.navigationBar.isHidden = true
        
            let secondViewController = navController.topViewController as! SecondViewController
        }

    }
    
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == "unwindPicksToFeed") {
            if (switch1.isOn) {
                userPicks.append(option1.text!)
            }
            if (switch2.isOn) {
                userPicks.append(option2.text!)
                
            }
            if (switch3.isOn) {
                userPicks.append(option3.text!)
            }
            print("ACCEPTED PICKS")
            print(userPicks)
        
            if (userPicks.isEmpty) {
                return false
            }
        }
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    
    func google_suggestions(isTest:Bool, withCompletionHandler:@escaping (_ something:[[String:Any]]) -> Void) {
        let lat = "\(finalLat!)"
        let long = "\(finalLong!)"
        
    
        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(long)&radius=500&type=restaurant&key=AIzaSyB6Se0XkW8UlOHzo56Tb5cE2sjW8mLMhjM&sensor=true"
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)

        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            do {

                if let data = data,
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let results = json["results"] as? [[String: Any]] {
                    for result in results {
                        if let name = result["name"] as? String {
                            print(name)
                        }
                    }
                    if (isTest) {
                        withCompletionHandler(results)
                    }
                }
            }
            catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()


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
