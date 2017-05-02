//
//  SecondViewController.swift
//  WhereAtV2
//
//  Created by Katia Hajjar on 4/3/17.
//  Copyright © 2017 Katia Hajjar. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var LatestMeetup : Meetup!
    var MeetupsTotal = [Meetup]()
    var hasLatest = false
    var username : String!
    var password : String!
    
    @IBAction func unwindToFeed(segue: UIStoryboardSegue) {
        
    }
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        username = appDelegate.username
        password = appDelegate.password
        print(username,password)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "SOMETHING")
        // Do any additional setup after loading the view.
        //load data
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SecondViewController.back(sender:)))
        newBackButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = newBackButton
        
        
        let button1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action: #selector(SecondViewController.refresh(sender:))) // action:#selector(Class.MethodName) for swift 3
        button1.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem  = button1
        
//        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsetsMake(self.tabBarController!.tabBar.frame.height, 0, 0, 0);
        //Where tableview is the IBOutlet for your storyboard tableview.
//        self.tableView.contentInset = adjustForTabbarInsets;
//        self.tableView.scrollIndicatorInsets = adjustForTabbarInsets;
        
        loadData()
        
        
    }
    
  

    func refresh(sender: UIBarButtonItem) {
        print("hallo hayley is ms swan!!!!!")
        loadData()
        self.tableView.reloadData()
    }


func back(sender: UIBarButtonItem) {
    let appDelegate = UIApplication.shared.delegate! as! AppDelegate
    appDelegate.username = nil
    appDelegate.password = nil
    let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
    let LoginPage = mainStoryBoard.instantiateViewController(withIdentifier: "LoginVC") as! ViewController
    self.present(LoginPage, animated: true, completion: nil)

    
    //stroyboard initialized
    
    


 

    
//from tab bar    performSegue(withIdentifier: "Logout", sender: (Any).self)
    
    // Perform your custom actions
    // ...
    // Go back to the previous ViewController
    print("Logging OUt")
}






    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var AddMeetup: UIButton!

//    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
//        if (segue.identifier == "CreateMeetUp") {
//                let newController = segue.destination as! MeetupTableViewController
//                newController.username = username
//                newController.password = password
//        }
//    }
    
    

    
    
    func loadData() {
        self.MeetupsTotal = []
        print("hello");
        let url = URL(string: "https://tranquil-citadel-40512.herokuapp.com/get_events")
        let json: [String: Any] = ["username": username]
        print("THIS IS A TEST")
        print(username)
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        
        request.httpBody = jsonData

        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }

            do {
//                let jsonData:NSArray = try! (JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSArray)!
////                print(jsonData)
//                for entry in jsonData {
//                    print(entry)
////                    let owner_name = (entry["owner_name"])
//                }
                let jsonData = try! JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]]
                    for json in jsonData! {
                        print(json)
                        print("THAT WAS THE JSON")
                        let owner_name = json["owner_name"] as? String
//                        let owner_pass = json["owner_password"] as? String
                        let titlemeet = json["title_meetup"] as? String
                        let start = json["start_time"] as? String
                        let end = json["end_time"] as? String
                        let owner_long = json["owner_longitude"] as? String
                        let owner_lat = json["owner_latitude"] as? String
                        let invitee = json["invitee_name"] as? String
                        let recipientLocKnown = json["recipientLocationKnown"] as? Bool
                        let invitee_lat = json["invitee_lat"] as? String
                        let invitee_long = json["invitee_long"] as? String
                        let equidist_lat = json["equidist_lat"] as? String
                        let equidist_long = json["equidist_long"] as? String
                        let test = json["_id"] as? [String:Any]
                        let _id = test?["$oid"] as? String
                        let owner_picked = json["owner_picked"] as? Bool
                        let invitee_picked = json["invitee_picked"] as? Bool
                        let final_location = json["final_location"] as? String
                        
                        

                        let new_meet = Meetup(owner_name: owner_name!,
//                                              owner_password: owner_pass!,
                                              title_meetup: titlemeet!, start_time: start!,
                                            end_time: end!, owner_long: owner_long!,
                                            owner_lat: owner_lat!, invitee_name: invitee!,
                                            recipientLocationKnown: recipientLocKnown!,
                                            invitee_lat: invitee_lat!,
                                            invitee_long: invitee_long!, equidist_lat: equidist_lat!,
                                            equidist_long: equidist_long!, _id: _id!, owner_picked: owner_picked!,
                                            invitee_picked: invitee_picked!, final_location:final_location!)
                       print("THIS IS THE METEUP")
                        print(new_meet)
                        self.MeetupsTotal.append(new_meet)
                        DispatchQueue.main.async{
                            self.tableView.reloadData()
                        }
                        

                        
                        
                        
                    }
                
                
            } catch let error as NSError {
                print(error)
            }
          
          
            

            //for every key value
        }
        task.resume()
    }
    
    
    
    
    
    //MARK -- TABLE VIEW
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (!MeetupsTotal.isEmpty) {
            return MeetupsTotal.count
        }
        return 1

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "SOMETHING", for: indexPath as IndexPath)
        var cell: FeedTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "SOMETHING") as? FeedTableViewCell
        tableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "SOMETHING")
        cell = tableView.dequeueReusableCell(withIdentifier: "SOMETHING") as? FeedTableViewCell
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate

        
        if (!MeetupsTotal.isEmpty) {
            cell.meetupTitle.text = MeetupsTotal[indexPath.row].title_meetup
            cell.Location.text = MeetupsTotal[indexPath.row].final_location
            if (MeetupsTotal[indexPath.row].invitee_name != username) {
            cell.Invitee.text = "With: \(MeetupsTotal[indexPath.row].invitee_name)"
            }
            else {
                cell.Invitee.text = "With: \(MeetupsTotal[indexPath.row].owner_name)"

            }
            //make sure doesn't break
            cell.Start.text = "From: \(MeetupsTotal[indexPath.row].start_time)"
            cell.End.text = "To: \(MeetupsTotal[indexPath.row].end_time)"
            
            
            if (MeetupsTotal[indexPath.row].invitee_picked == false) {

                if (MeetupsTotal[indexPath.row].owner_name == appDelegate.username)  {
                    cell.statusUpdate.text = "Waiting on Response"
                }
                else {
                    cell.statusUpdate.text = "New meetup!"
                }
                
            }
            else if (MeetupsTotal[indexPath.row].invitee_picked && !MeetupsTotal[indexPath.row].owner_picked) {

                if (MeetupsTotal[indexPath.row].owner_name == appDelegate.username)  {
                    cell.statusUpdate.text = "Suggestions needed"
                }
                else {
                    cell.statusUpdate.text = "Waiting on Response"
                }
            }
            else {
                cell.statusUpdate.text = "Good to go!"
            }
         
            
            
            
            
            
            
            
        }
        else {
            cell.meetupTitle.text = "You have no meetups!"
            cell.Location.isHidden = true
            cell.Invitee.isHidden = true
            cell.Start.isHidden = true
            cell.End.isHidden = true
            cell.statusUpdate.isHidden = true
            
        }
        return cell
//        
//        if (hasLatest) {
//            print("yesy")
//            print(LatestMeetup.title_meetup)
//            print(LatestMeetup.invitee_name)
//            cell.meetupTitle.text = LatestMeetup.title_meetup
//
//            //BOOL CHECK FOR IF WE GOT LOCATION YET!
//            cell.Location.text = "TBD"
//            cell.Invitee.text = "With: \(LatestMeetup.invitee_name)"
//            cell.Start.text = "From: \(LatestMeetup.start_time)"
//            cell.End.text = "To: \(LatestMeetup.end_time)"
//    
//        }
//        else {
//            cell.meetupTitle.isHidden = true
//            cell.Location.isHidden = true
//            cell.Invitee.isHidden = true
//            cell.Start.isHidden = true
//            cell.End.isHidden = true
//            
//        }
//        return cell
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.visibleViewController?.navigationItem.title = "Meetups"


    }

    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }
    
    
    func tableView(_ tableView: UITableView,
                            shouldSelectRow row: Int) -> Bool {
        if (MeetupsTotal.isEmpty) {
            return false
        }
        else {
            return true
        }
    }
    
    
 
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "DetailSegue", sender: LatestMeetup)
        //if MeetupsTotal[indexpath.row].needsLocation && username == invitee
        //segue to this other view controller.
        if (!MeetupsTotal.isEmpty){
        print("\(MeetupsTotal[indexPath.row].invitee_name)")
        print("this is the invitees name....")
        print(username)
        print("THIS IS THE USERNAME")
        print("Meetups indexPath")
        print(MeetupsTotal[indexPath.row])
        print(MeetupsTotal[indexPath.row].invitee_name)
        print(MeetupsTotal[indexPath.row].recipientLocationKnown)
        

        if (username == MeetupsTotal[indexPath.row].invitee_name) {
            
            if (MeetupsTotal[indexPath.row].recipientLocationKnown == false) {
            //if username == MeetupsTotal[indexPath.row].invitee_name
            //AND NEEDS LOCATION BOOL IS TRUE
            let next = self.storyboard?.instantiateViewController(withIdentifier:"LocationViewController") as! InviteeLocationViewController
            next.detailMeetup = MeetupsTotal[indexPath.row]
            self.present(next, animated: true, completion: nil)
            }
            else {
                let next = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
                //        next.detailMeetup = LatestMeetup
                next.detailMeetup = MeetupsTotal[indexPath.row] //might break
                print("THIS IS USERNAME ON DID SELECT ROW -- checking \(username)")
                self.present(next, animated: true, completion: nil)
            }
            
        }
            
         else if (username == MeetupsTotal[indexPath.row].owner_name) {
                if (MeetupsTotal[indexPath.row].recipientLocationKnown == true && MeetupsTotal[indexPath.row].owner_picked == false) {
            //ownerPicks = segue identifier
            //would be for user if username is owner && recipientLocation Known!
                
                    let next = self.storyboard?.instantiateViewController(withIdentifier:"OwnerSuggestions") as! OwnerSuggestionsViewController
                    next.detailMeetup = MeetupsTotal[indexPath.row]
                    self.present(next, animated: true, completion: nil)
                    
                }
                else {
                    
                    let next = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
                    //        next.detailMeetup = LatestMeetup
                    next.detailMeetup = MeetupsTotal[indexPath.row] //might break
                    print("THIS IS USERNAME ON DID SELECT ROW -- checking \(username)")
                    self.present(next, animated: true, completion: nil)
                    
                }
            
         }
        else {
        
            let next = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
//        next.detailMeetup = LatestMeetup
            next.detailMeetup = MeetupsTotal[indexPath.row] //might break
            print("THIS IS USERNAME ON DID SELECT ROW -- checking \(username)")
            self.present(next, animated: true, completion: nil)

        }

        
        //1. needs_invitee_location is true:
            //then instantiateController called
            //"INVITED PERSON SUBMITS LOCATION"
            //on that page, need to do an update on that meetup (given id)
        //2. then move to suggestions screen, do a get again --> do the parsing of data get halfway location
            //reach google api --> try doing that now on a seperate thing?
            //then display and pull the suggestions
            //then submit and update the same meetup with suggestions answers again
            //unwind or just go back to feed table
        
        
        
        
        //3. else if not invited person
        //if all the other things are false 
        //then segue to the suggestions page
        //same shit as above
        
        }
        
        
        
        
        
    }
    
    
    
   
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
////        return
//    }

    
    
     //MARK: - Navigation
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//       
//     
//        
//    }
 

}
