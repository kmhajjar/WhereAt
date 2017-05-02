//
//  MeetupTableViewController.swift
//  WhereAtV2
//
//  Created by Katia Hajjar on 4/2/17.
//  Copyright © 2017 Katia Hajjar. All rights reserved.
//

import UIKit
import CoreLocation

class MeetupTableViewController: UITableViewController
//, CLLocationManagerDelegate
, UISearchBarDelegate, UITextFieldDelegate, UITabBarDelegate {
    var invitee : String!
    var username_test: String!
    var password_test: String!
    var Meetups = [Meetup]()
    var valid_meetup : Bool!
    
    @IBOutlet weak var whoKnows: UINavigationItem!
    @IBAction func unwindToCreateMeetup(segue: UIStoryboardSegue) {
     
        let testView:TestViewController = segue.source as! TestViewController
        invitee = testView.somethingelse
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            if (selectedIndexPath.section == 2) {
                //if were in the search bar guy
                //createcellagain

                let cell = tableView.dequeueReusableCell(withIdentifier: "SearchBar")!
                print("PASSBACK DATA", invitee)
                cell.detailTextLabel!.text = invitee
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                print("USERNAMENOW", username_test)
                ///nil at this point?

            }
        }
        
    }
    

    
    @IBAction func testFuction(_ sender: Any, segue: UIStoryboardSegue) {
        if ((sender as AnyObject).tag == 8) {
            let barViewControllers = segue.destination as! UITabBarController
            
            let navController = barViewControllers.viewControllers![0] as! UINavigationController
//            navController.navigationBar.isHidden = true
            
            let secondViewController = navController.topViewController as! SecondViewController
            secondViewController.username = username_test
            secondViewController.password = password_test
            //MeetupSend over Into MeetupVar
        
        }
    
    }
    
    
    var username : String!
    var password : String!
    
//    var locationManager : CLLocationManager?
//    var currentLocation = CLLocation()
    
    var myLocations = [CLLocation]()
    var long : String!
    var lat: String!


    var events = [Event]()
    var dateFormatter = DateFormatter()
    var datePickerIndexPath: IndexPath?


    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        username_test = appDelegate.username
        password_test = appDelegate.password
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tableView.tableFooterView?.isHidden = true
        
//        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height:60)) // Offset by 20 pixels vertically to take the status bar into account
//        navigationBar.backgroundColor = UIColor(colorLiteralRed: 48, green: 18, blue: 140, alpha: 1)
//        // Create a navigation item with a title
//        let navigationItem = UINavigationItem()
//        navigationItem.title = "New Meetup LALASOMETHING"
//        navigationItem.titleView?.tintColor = UIColor.white
//        navigationBar.items = [navigationItem]
//        
//        self.view.addSubview(navigationBar)
//        
        
        self.navigationController?.navigationBar.topItem?.title = "Create Meetup"
        self.navigationController?.navigationBar.topItem?.titleView?.tintColor = UIColor.white


        setDateFormatter()
        createEvents()
        
//        self.tableView.contentInset = UIEdgeInsets.zero
//        self.tableView.scrollIndicatorInsets = UIEdgeInsets.zero
        

        
        tableView.backgroundColor = UIColor.init(red: 240/255, green: 244/255, blue: 246/255, alpha: 1.0)
        print(username_test, password_test)
//        self.navigationController?.navigationBar.topItem?.title = "New Meetup"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//         self.navigationItem.rightBarButtonItem = self.editButtonItem()
       

    
    }
    
//    override func viewWillLayoutSubviews() {
////            self.tableView.contentInset = UIEdgeInsetsMake(70, 0, 0, 0)
//    }


    func handleMeetup() -> Meetup {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell  = self.tableView.cellForRow(at: indexPath) as UITableViewCell?
        let titleField = cell?.viewWithTag(4) as! UITextField
        let title = titleField.text
    
    
    //handle start and end times:
        let startDATE = events[0].time
        let endDATE = events[1].time
        dateFormatter.dateFormat = "EEE, dd MMM yyyy hh:mm"
    
        let start = dateFormatter.string(from:startDATE)
    
        let end = dateFormatter.string(from:endDATE)
       

    //okay we got everything here
    //test 12345 JACK LUNCH Fri, 06 Jun 2014 12:00:00 +Eastern Daylight Time Wed, 16 Sep 2015 06:00:00 +Eastern Daylight Time -0.1337 51.50998 Jack
    
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        lat = "\(appDelegate.locationObj.coordinate.latitude)"
        long = "\(appDelegate.locationObj.coordinate.longitude)"
        
        let newMeetup = Meetup(owner_name: username_test,
//                               owner_password: password_test,
                               title_meetup: title!, start_time: start,
                               end_time: end, owner_long: long,
                               owner_lat: lat, invitee_name: invitee, recipientLocationKnown: false,
                               invitee_lat: "0.0", invitee_long: "0.0", equidist_lat: "0.0", equidist_long: "0.0", _id: "-1",
                               owner_picked: false, invitee_picked: false, final_location: "TBD")
        print(newMeetup.owner_name, newMeetup.title_meetup, newMeetup.start_time, newMeetup.end_time, newMeetup.owner_lat, newMeetup.owner_long, newMeetup.invitee_name)
        return newMeetup
        
        

        
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        
//        self.tableView.reloadData()
//    }

    @IBAction func createMeetup(_ sender: Any) {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell  = self.tableView.cellForRow(at: indexPath) as UITableViewCell?
        //error checking
        let titleField = cell?.viewWithTag(4) as! UITextField
        let startDATE = events[0].time
        let endDATE = events[1].time
        dateFormatter.dateFormat = "EEE, dd MMM yyyy hh:mm"
        
        let start = dateFormatter.string(from:startDATE)
        
        let end = dateFormatter.string(from:endDATE)
        
        
        if (titleField.text == "") {
            valid_meetup = false
            //then don't make meetup
            print("title text is empty")
            
        }

        
        else if (start == "" || end == "") {
            valid_meetup = false
        }
        else if (password_test == nil || username_test == nil || invitee == nil) {
            valid_meetup = false
        }
            
      
        else  {
            valid_meetup = true
            let meetup = handleMeetup()
            Meetups.append(meetup)
        //data is ready to send!
        //PUT FUNCTION
        


        
            submitMeetup(meetup: meetup)
                
            print("YAY")
            DispatchQueue.main.async(execute: {
                self.tabBarController!.selectedIndex = 0
                
//                super.performSegue(withIdentifier:"testingSomething", sender: sender)
//                
//                let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
//
//                let tabBarController = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarTest") as! UITabBarController
//               
//                let someTabIndex = 0
//                tabBarController.selectedIndex = someTabIndex
//                // Get the tabBar
//                // Change the selected tab item to what you want
//                
//                
//                let detailController = tabBarController.viewControllers![0] as! UINavigationController
//                if let n = detailController.navigationController {
//                    n.navigationController?.popToRootViewController(animated: true)
//
//                }
//                    self.tabBarController?.selectedIndex = 1
//                    self.navigationController?.popToRootViewController(animated: true)
                
            })
                    
//                let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
//                let tabBarController = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarTest") as! UITabBarController
                 
            
            
            
//            let v = t?.viewControllers?[someTabIndex]
//            if let n = v?.navigationController {
//                n.popToRootViewControllerAnimated(true)
//            }
//            
          
        //perform segue to feed, display meetup
//        tableView.reloadData()
        
        }
        
        
        //then also clear the meetup page
        
    }
    
    func submitMeetup(meetup: Meetup) {
        print("hello");
        let url = URL(string: "https://tranquil-citadel-40512.herokuapp.com/add_event")
        
        let json: [String: Any] = ["owner_name": meetup.owner_name,
//                                   "owner_password": meetup.owner_password,
                                   "title_meetup": meetup.title_meetup,
                                   "start_time": meetup.start_time,
                                   "end_time": meetup.end_time,
                                   "owner_longitude": meetup.owner_long,
                                   "owner_latitude": meetup.owner_lat,
                                   "invitee_name": meetup.invitee_name,
                                   "recipientLocationKnown": meetup.recipientLocationKnown,
                                   "invitee_lat" : meetup.invitee_lat,
                                   "invitee_long": meetup.invitee_long,
                                   "equidist_lat": meetup.equidist_lat,
                                   "equidist_long": meetup.equidist_long,
                                   "owner_picked": meetup.owner_picked,
                                   "invitee_picked": meetup.invitee_picked,
                                   "final_location": meetup.final_location
                                   ]
        
  
        
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
    
    
    
    
    @IBAction func myLocation(_ sender: Any) {
     
//        let anotherCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2))!
//        let this_thing = anotherCell.viewWithTag(3) as! UILabel // set the tag of Date Picker to be 1 in the Attributes Inspector
//        
//        
//        
//        if let containsPlacemark = appDelegate.placemark {
//            //stop updating location to save battery life
//            
//           let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
//            this_thing.text = locality
//
//            //this is where all of it happens
//        }
        

   

    }
   

    //this function is going to be in the view controller for Location View!
    
    func google_suggestions(lat: String, long: String) {
        let lat_hardcode = "42.273945"
        let long_hardcode = "-83.734154"
        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat_hardcode),\(long_hardcode)&radius=500&type=restaurant&key=AIzaSyB6Se0XkW8UlOHzo56Tb5cE2sjW8mLMhjM&sensor=true"
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
                //                    guard let placeData = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments)
                //                        as? [String: Any] else {
                //                            print("error trying to convert data to JSON")
                //                            return
                //                    }
                //                    print("The placeData is: \(placeData.description)")
                
                if let data = data,
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let results = json["results"] as? [[String: Any]] {
                    for result in results {
                        if let name = result["name"] as? String {
                            print(name)
                        }
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
    
    
    func setDateFormatter() { // called in viewDidLoad()
        dateFormatter.dateStyle = .short
    }
    
    func createEvents() { // called in viewDidLoad()
        let date = NSDate()
        
        // *** create calendar object ***
        var calendar = NSCalendar.current
        
        // *** Get components using current Local & Timezone ***
        print(calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date as Date))
        let unitFlags = Set<Calendar.Component>([.hour, .year, .minute])
        let components = calendar.dateComponents(unitFlags, from: date as Date)
        let month = calendar.component(.month, from: date as Date)
        let day = calendar.component(.day, from: date as Date)
        let year = calendar.component(.year, from: date as Date)

        
        let event1 = Event(title: "I'm free from...", time: dateFormatter.date(from: "\(month)/\(day)/\(year)")! as Date)
        let event2 = Event(title: "to...", time: dateFormatter.date(from: "\(month)/\(day)/\(year)")! as Date)
        
        events.append(event1)
        events.append(event2)
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
        
        //TITLE SECTION & THE PICKER SECTIONS
        
//        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 1 {
            var rows = events.count
            if datePickerIndexPath != nil {
                rows += 1
            }
            return rows
        }
        else {
            return 1
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let inputTitleField = titleCell.viewWithTag(2) as! UITextField //set textfield as 2 in attributes inspector
        var cell: UITableViewCell

        if (indexPath.section == 1) {
            if datePickerIndexPath != nil && datePickerIndexPath!.row == indexPath.row {
                cell = tableView.dequeueReusableCell(withIdentifier: "DatePickerCell")!
                let datePicker = cell.viewWithTag(1) as! UIDatePicker // set the tag of Date Picker to be 1 in the Attributes Inspector
                datePicker.tintColor = UIColor.init(red: 240/255, green: 244/255, blue: 246/255, alpha: 1)
                let event = events[indexPath.row - 1]
                datePicker.setDate(event.time as Date, animated: true)
            }
        
            else {
                cell = tableView.dequeueReusableCell(withIdentifier: "EventCell")!
                let event = events[indexPath.row]
                cell.textLabel!.text = event.title
                cell.detailTextLabel!.text = dateFormatter.string(from: event.time as Date)
            }
            return cell
        }
        
        
        else if (indexPath.section == 0) {
            cell = tableView.dequeueReusableCell(withIdentifier: "MeetupTitleCell")!
            let textField = cell.viewWithTag(4) as! UITextField
            textField.text = ""
        
            return cell
        }
//        else if (indexPath.section == 2) {
//            cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell")!
////            let locationText = cell.viewWithTag(3) as! UILabel
//////            locationText.text = "testin"
////            if (myLocations.isEmpty) {
////                print("its empty")
////            }
////            else {
////                print("not anymore")
////            }
//            return cell
//        }
        else if (indexPath.section == 2) {
            cell = tableView.dequeueReusableCell(withIdentifier: "SearchBar")!
            print("PASSBACK DATA", invitee)
            cell.detailTextLabel!.text = invitee
            cell.detailTextLabel!.textColor = UIColor.init(red: 94/255, green: 101/255, blue: 124/255, alpha: 1)
            return cell
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: "CreateCell")!
            tableView.separatorStyle = .none
            return cell
        }

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell  = self.tableView.cellForRow(at: indexPath) as UITableViewCell?
        let something = cell?.viewWithTag(4) as! UITextField
        print(something.text)
      
//        print(textField.text)
    }
    
    
    
    
    override  func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath){
        
        
        if (indexPath.section == 1) {
        tableView.beginUpdates() // because there are more than one action below
        if datePickerIndexPath != nil && datePickerIndexPath!.row - 1 == indexPath.row { // case 2
            tableView.deleteRows(at: [datePickerIndexPath!], with: .fade)
            datePickerIndexPath = nil
        } else { // case 1、3
            if datePickerIndexPath != nil { // case 3
                tableView.deleteRows(at: [datePickerIndexPath!], with: .fade)
            }
            datePickerIndexPath = calculateDatePickerIndexPath(indexPathSelected: indexPath)
            tableView.insertRows(at: [datePickerIndexPath!], with: .fade)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.endUpdates()
        }
        if (indexPath.section == 3) {
//            performSegue(withIdentifier: "SearchFriends", sender: nil)
        }
    }
    
    
    func calculateDatePickerIndexPath(indexPathSelected: IndexPath) -> IndexPath {
        if datePickerIndexPath != nil && datePickerIndexPath!.row  < indexPathSelected.row { // case 3.2
            return IndexPath(row: indexPathSelected.row, section: 1)
        } else { // case 1、3.1
            return IndexPath(row: indexPathSelected.row + 1, section: 1)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (indexPath.section == 1) {
            var rowHeight = tableView.rowHeight
            if datePickerIndexPath != nil && datePickerIndexPath!.row == indexPath.row {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DatePickerCell")!
                rowHeight = cell.frame.height
            }
            return rowHeight
        }
        else if (indexPath.section == 3) {
            return 140
        }
        else {
            return 45
        }
        
     
    }

    @IBAction func changeDate(_ sender: UIDatePicker) {
        let parentIndexPath = IndexPath(row: datePickerIndexPath!.row - 1, section: 1)
        // change model
        let event = events[parentIndexPath.row]
        event.time = sender.date
        // change view
        let eventCell = tableView.cellForRow(at: parentIndexPath)!
        eventCell.detailTextLabel!.text = dateFormatter.string(from: sender.date)
    }
    
    //Two things left to do
    //1. make a create button!
    //2. make a search for friends button 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if (segue.identifier == "SearchFriends") {
//            let newController = segue.destination as! TestViewController
            let newController: TestViewController = (segue.destination as! UINavigationController).topViewController as! TestViewController
            //do stuff with this guy
        }
//        if (segue.identifier == "CreateToFeed") {
//            let tabBarController = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarTest") as! UITabBarController
//            let barViewControllers = segue.destination as! UITabBarController
            
//            let navController = barViewControllers.viewControllers![0] as! UINavigationController
//            navController.navigationBar.isHidden = true

//            let secondViewController = navController.topViewController as! SecondViewController
            //MeetupSend over Into MeetupVar
            
            
//            self.navigationController?.popToRootViewController(animated: true)
            

            
            
//
//            let meetupToSend = Meetups.last
//            
//            
//            
//            
//            //BASICALLY IN PREPARE FOR SEGUE ON CREATE MEETUP PAGE SHOULD ONLY SEND BACK THE LOGIN INFO I GUESS
//            secondViewController.LatestMeetup = meetupToSend
//            secondViewController.hasLatest = true
//            secondViewController.username = username_test
//            secondViewController.password = password_test
//            
   
//        }
        
      

        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool{
        if (identifier == "CreateToFeed") {
            if (valid_meetup == false) {
                print("the meetup was invalid")
                return false
            }
            else {
                return true
            }
        }
        return true
        
    }


}
