//
//  DetailViewController.swift
//  WhereAtV2
//
//  Created by Katia Hajjar on 4/5/17.
//  Copyright © 2017 Katia Hajjar. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

 
    @IBOutlet weak var titleMeetup: UILabel!
    @IBOutlet weak var inputtedLoc: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var end: UILabel!
    
    
    @IBOutlet weak var navBar: UINavigationBar!

    var detailMeetup : Meetup!
    override func viewDidLoad() {
        super.viewDidLoad()
        //IF NOT LOCATIONFINAL
        inputtedLoc.text = detailMeetup.final_location
        titleMeetup.text = detailMeetup.title_meetup
        time.text = detailMeetup.start_time
        end.text = detailMeetup.end_time
        self.navigationItem.title = detailMeetup.title_meetup
        self.navBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 60.0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
