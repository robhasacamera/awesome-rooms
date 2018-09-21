//
//  RoomStatusViewController.swift
//  Awesome Rooms
//
//  Created by Robert J Cole on 9/21/18.
//  Copyright © 2018 Robert Cole. All rights reserved.
//

import UIKit

class RoomStatusViewController: UIViewController, ReservationViewControllerDelegate {
    
    
    
    @IBOutlet weak var topStack: UIStackView!
    
    @IBOutlet weak var bottomStack: UIStackView!
    
    @IBOutlet var quickBookView: QuickBookView!
    
    @IBOutlet var topMessageView: MessageView!
    
    @IBOutlet var topMeetingView: MeetingView!
    
    @IBOutlet var bottomMessageView: MessageView!
    
    @IBOutlet var bottomMeetingView: MeetingView!
    
    var eventClient: EventClient?
    
    let eventToCreate: Event?
    
    func createEvent(withLength: Int) -> Event {
        let now = Date()
        
        let calendar = Calendar.current
        
        
        
    }
    
    @IBAction func book15MinuteMeeting(_ sender: Any) {
        
        
        performSegue(withIdentifier: "BookMeetingSegue", sender: nil)
    }
    
    @IBAction func book30MinuteMeeting(_ sender: Any) {
        performSegue(withIdentifier: "BookMeetingSegue", sender: nil)
    }
    
    @IBAction func book60MinuteMeeting(_ sender: Any) {
        performSegue(withIdentifier: "BookMeetingSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        topStack.addArrangedSubview(quickBookView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didCreateEvent() {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
        eventClient?.getEvents(completionHandler: didGetEvents, errorHandler: didNotGetEvents)
    }
    
    func didGetEvents(_: [Event]) {
        // TODO parse array of events to display current or upcoming events
    }
    
    func didNotGetEvents(message: String) {
        // Do nothing, just try again in one second
        return
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as? ReservationViewController, let eventClient = eventClient {
            controller?.setup(delegate: self, eventClient: eventClient, event: <#T##Event#>)
        }
        
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
 
    
}
