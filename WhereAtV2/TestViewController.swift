//
//  TestViewController.swift
//  WhereAtV2
//
//  Created by Katia Hajjar on 4/3/17.
//  Copyright © 2017 Katia Hajjar. All rights reserved.
//

import UIKit

class TestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating
{
    //    var users = [User]()
  
    
    var somethingelse : String!
    var users = [String]()
    var filteredTableData = [String]()
    var resultSearchController = UISearchController()
    
    @IBOutlet weak var tableView: UITableView!
    
    let controller = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //user_list send back json
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //check this
        self.navigationController?.navigationBar.topItem?.title = "Search Friends"


    
        //check what the app delegate is
        
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        //appDelegate.username
        
//        users = ["paul", "katia", "jack", "jacob"]
        let itemToRemove = appDelegate.username

       

        self.resultSearchController = ({
            
            controller.searchResultsUpdater = self as? UISearchResultsUpdating
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.barStyle = UIBarStyle.black
            controller.searchBar.barTintColor =  UIColor.init(red: 240/255, green: 244/255, blue: 246/255, alpha: 1.0)
            controller.searchBar.backgroundColor = UIColor.init(red: 240/255, green: 244/255, blue: 246/255, alpha: 1.0)

            
            controller.searchBar.autocapitalizationType = .none
            self.tableView.tableHeaderView = controller.searchBar
            
            

            return controller
            
            
            
            
            
        })()
        
        findUsers()
        
        self.tableView.reloadData()

        // Do any additional setup after loading the view.
    }
    
    
    func findUsers() {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate

        
        let url = URL(string: "https://tranquil-citadel-40512.herokuapp.com/user_list")
        
        let json: [String: Any] = ["username": appDelegate.username]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            do {
        
                let jsonData = try! JSONSerialization.jsonObject(with: data, options: []) as? [String]
                print(jsonData)
                
                
                
                for name in jsonData! {
                    self.users.append(name)
                }
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            
            
            }
            catch let error as NSError {
                print(error)
            }
            
            
            
            
            //for every key value
        }
        
    
        task.resume()
    
    }



    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(controller.searchBar.text != "") {
            return filteredTableData.count
        }
        
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friend", for: indexPath as IndexPath)
        if (controller.searchBar.text != ""){
            cell.textLabel!.text = filteredTableData[indexPath.row]
        } else {
            cell.textLabel!.text = users[indexPath.row]
        }

//        let user = self.users[indexPath.row]
//        cell.textLabel!.text = user
        return cell
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filteredTableData.removeAll(keepingCapacity: false)
        
        //        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        //        let array = (users as NSArray).filtered(using: searchPredicate)
        
        let searchTerm = searchController.searchBar.text!
        print(searchTerm)
        
        let array = users.filter { $0.contains(searchTerm) }
        
        
        filteredTableData = array
        
        self.tableView.reloadData()
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var object :String
        //FOR NOW ONLY
    
        if resultSearchController.isActive && resultSearchController.searchBar.text != ""{
            let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
            object = filteredTableData[(indexPath?.row)!]
            print(object)
            performSegue(withIdentifier: "BackToMeetup", sender: object)

            
        }
        else {
            let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
            object = users[(indexPath?.row)!]
            print(object)
            performSegue(withIdentifier: "BackToMeetup", sender: object)
        }


        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "BackToMeetup") {
            resultSearchController.isActive = false
            let secondViewController = segue.destination as! MeetupTableViewController
            somethingelse = sender as! String
            print("THIS IS PERSON TEXT" , somethingelse)
            secondViewController.invitee = somethingelse
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
