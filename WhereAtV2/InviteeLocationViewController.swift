//
//  InviteeLocationViewController.swift
//  WhereAtV2
//
//  Created by Katia Hajjar on 4/9/17.
//  Copyright © 2017 Katia Hajjar. All rights reserved.
//

import UIKit
import CoreLocation

class InviteeLocationViewController: UIViewController {

    var long : String!
    var lat: String!
    var equidistLat : String!
    var equidistLong : String!
    
    @IBOutlet weak var timeEnd: UILabel!
    @IBOutlet weak var WhoWith: UILabel!
    @IBOutlet weak var Time: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBAction func submitLocation(_ sender: Any) {
 

        //myLocations.last & detailMeetup.owner_location
        //POST equidistant loc & suggestions array
    }
    
    var detailMeetup : Meetup!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navItem.title = "Meetup Invite!"
        titleLabel.text = detailMeetup.title_meetup
        Time.text = "From: \(detailMeetup.start_time)"
        timeEnd.text = "Until: \(detailMeetup.end_time)"
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let user_logged_in = appDelegate.username
        if (user_logged_in == detailMeetup.invitee_name) {
            WhoWith.text = "\(detailMeetup.owner_name) invited you to:"
        }
        else {
            WhoWith.text = detailMeetup.invitee_name
        }
        
        
//        let Coord1 = ("42.293635", "-83.712635")
//        let Coord2 = ("42.307288", "-83.691005")
//        let listCoords = [Coord1, Coord2]
//        
//        print(midPoint)

        // Do any additional setup after loading the view.
    }
    

    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendLocationsUpdate(invited_lat: String, invited_long: String, equidist_lat: String, equidist_long: String) {
        let url = URL(string: "https://tranquil-citadel-40512.herokuapp.com/update_event")
        
        let json: [String: Any] = ["_id": detailMeetup._id, "invitee_lat": invited_lat, "invitee_long": invited_long,
                                   "equidist_lat": equidist_lat, "equidist_long": equidist_long]
        
        
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
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

    
    
    func degreeToRadian(angle1:String) -> (CGFloat) {
        let n = NumberFormatter().number(from: angle1)
        let returnVal1 = ((CGFloat(n!) / 180.0) * CGFloat(Double.pi))
        return (returnVal1)
    }
    
    
    func radianToDegree(radian1:CGFloat) -> (CGFloat) {
        return (  (radian1 * CGFloat(180.0 / Double.pi))  )
    }
    
    func middlePoint(listCoords: [(String,String)]) -> (String, String){
        var x = 0.0 as CGFloat
        var y = 0.0 as CGFloat
        var z = 0.0 as CGFloat
        for coordinate in listCoords{
            let lat = degreeToRadian(angle1:coordinate.0)
            let lon = degreeToRadian(angle1:coordinate.1)
            x = x + cos(lat) * cos(lon)
            y = y + cos(lat) * sin(lon);
            z = z + sin(lat);
        }
        
        x = x/CGFloat(listCoords.count)
        y = y/CGFloat(listCoords.count)
        z = z/CGFloat(listCoords.count)

        let resultLon: CGFloat = atan2(y, x)
        
        let resultHyp: CGFloat = sqrt(x*x+y*y)
        
        let resultLat:CGFloat = atan2(z, resultHyp)

        let newLat = radianToDegree(radian1: resultLat)
        
        let newLon = radianToDegree(radian1: resultLon)
        
        let result1 = newLat
        let result2 = newLon
        let string1 = "\(result1)"
        let string2 = "\(result2)"
        
        return (string1, string2)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "invitePicks") {
  
            //meetupID send
            print("this happened before segue")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
      
     
                
            lat = "\(appDelegate.locationObj.coordinate.latitude)"
            long = "\(appDelegate.locationObj.coordinate.longitude)"
            
            
            print("LAT BEFORE REQUEST")
            print(lat, long)
            
            
            let Coord1 = ("\(detailMeetup.owner_lat)",
                "\(detailMeetup.owner_long)")
            let Coord2 = (lat!, long!)
            //now call find midpoint on the locations*
            let equidistantLoc = middlePoint(listCoords: [Coord1, Coord2])
            print("THIS IS EQIUDIST")
            print(equidistantLoc)
            equidistLat = equidistantLoc.0
            equidistLong = equidistantLoc.1
            //send equidistLoc too!
            
            
            //change the bool thing to false and POST location to database
            sendLocationsUpdate(invited_lat: lat, invited_long: long, equidist_lat: equidistLat, equidist_long: equidistLong)
            

            
            let newController = segue.destination as! InviteePicksViewController
            newController.finalLat = equidistLat
            newController.finalLong = equidistLong
            newController.meetupid = detailMeetup._id
            newController.meetuptitle = detailMeetup.title_meetup
            //google suggestions --> next page
            //submit array on the next view controller with picks & meetup ID
            closureReturn(isTest: true) { (result) -> Void in
                print(result)
            }

        }
        if (segue.identifier == "inviteeRejects") {
            let url = URL(string: "https://tranquil-citadel-40512.herokuapp.com/delete_event")
            
            let json: [String: Any] = ["event_id": detailMeetup._id]
            
            
            
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            
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
            let barViewControllers = segue.destination as! UITabBarController
            
            let navController = barViewControllers.viewControllers![0] as! UINavigationController
            //            navController.navigationBar.isHidden = true
            
            let secondViewController = navController.topViewController as! SecondViewController

        }

    }
    
    
    func closureReturn(isTest:Bool, withCompletionHandler:(_ result:String) -> Void) {
        if(isTest){
            withCompletionHandler("Yes")
        }
        else{
            withCompletionHandler("No")
        }
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
