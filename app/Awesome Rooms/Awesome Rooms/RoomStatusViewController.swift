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
    
    var eventToCreate: Event?
    
    var events = [Event]()
    
    func createEvent(withLength minutes: Int) -> Event {
        let now = Date()
        
        let calendar = Calendar.current
        
        let later = calendar.date(byAdding: .minute, value: minutes, to: now)!
        
        let event = Event(title: nil, city: "mob", description: "", startDateTime: now, endDateTime: later, conferenceRoom: .leSabre)
        
        return event
    }
    
    @IBAction func book15MinuteMeeting(_ sender: Any) {
        eventToCreate = createEvent(withLength: 15)
        
        performSegue(withIdentifier: "BookMeetingSegue", sender: nil)
    }
    
    @IBAction func book30MinuteMeeting(_ sender: Any) {
        eventToCreate = createEvent(withLength: 30)
        
        performSegue(withIdentifier: "BookMeetingSegue", sender: nil)
    }
    
    @IBAction func book60MinuteMeeting(_ sender: Any) {
        eventToCreate = createEvent(withLength: 60)
        
        performSegue(withIdentifier: "BookMeetingSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        topStack.addArrangedSubview(quickBookView)
        
        eventClient = MockClient(scenario: .greenLightLessThanThirtyMins)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
            self.eventClient?.getEvents(completionHandler: { (events) in
                self.events = events.sorted(by: { (lhs, rhs) -> Bool in
                    lhs.startDateTime < rhs.startDateTime
                })
                
                self.events = self.events.filter({ (event) -> Bool in
                    let now = Date()
                    
                    return event.endDateTime > now
                })
                
                self.refresh()
            }, errorHandler: { (errorMessage) in
                print("\(errorMessage)")
            })
        }
    }
    
    func refresh() {
        let now = Date()
        
        if let firstEvent = events.first {
            if now > firstEvent.startDateTime {
                // display first event on top
                setupMeetingInProgress(firstEvent)

                // display second event on bottom
                if events.count > 1 {
                    setupBottomView(events[1])
                }
            } else {
                // display message or buttons pending on timeframe
                if timeUntilMeeting(firstEvent) > 15 {
                    // display buttons
                    setupMeetingButtons(for: firstEvent)
                } else {
                    // display message
                    setupMessageView()
                }
                
                // display first event on bottom
                setupBottomView(firstEvent)
            }
        } else {
            // hide all views
        }
    }
    
    @IBOutlet weak var button15Minutes: UIButton!
    @IBOutlet weak var button30Minutes: UIButton!
    @IBOutlet weak var button60Minutes: UIButton!
    
    func setupMeetingButtons(for event: Event) {
        let timeUntilEvent = timeUntilMeeting(event)
        
        button60Minutes.isEnabled = timeUntilEvent >= 60
        button30Minutes.isEnabled = timeUntilEvent >= 30
        
        topStack.removeAllArrangedViews()
        topStack.addArrangedSubview(quickBookView)
    }
    
    func setupMessageView() {
        topMessageView.backgroundColor = UIColor.yellow
        topMessageView.messageLabel.text = "Next Meeting Will Begin Shortly"
        topStack.removeAllArrangedViews()
        topStack.addArrangedSubview(topMessageView)
    }
    
    func timeUntilMeeting(_ event: Event) -> Int {
        let calendar = Calendar.current
        
        let now = Date()
        
        let endTime = event.startDateTime
        
        let components = calendar.dateComponents([.minute], from: now, to: endTime)
        
        return components.minute!
    }
    
    func setupMeetingInProgress(_ event: Event) {
        topMeetingView.backgroundColor = UIColor.red
        topMeetingView.meetingStatusLabel.text = "Meeting in Progress"
        topMeetingView.meetingTitleLabel.text = event.title
        topMeetingView.meetingTimeLabel.text = getMeetingTimes(event)
        
        topStack.removeAllArrangedViews()
        topStack.addArrangedSubview(topMeetingView)
    }

    func setupBottomView(_ event: Event) {
        bottomMeetingView.alpha = 0.5
        bottomMeetingView.meetingStatusLabel.text = "Next Meeting: "
        bottomMeetingView.meetingTitleLabel.text = event.title
        bottomMeetingView.meetingTimeLabel.text = getMeetingTimes(event)

        bottomStack.removeAllArrangedViews()
        bottomStack.addArrangedSubview(bottomMeetingView)
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }
    
    func getMeetingTimes(_ event: Event) -> String {
        let startTime = dateFormatter.string(from: event.startDateTime)
        let endTime = dateFormatter.string(from: event.endDateTime)
        
        
        return "\(startTime) - \(endTime)"
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
        guard let controller = segue.destination as? ReservationViewController else {
            return
        }
        
        guard let eventClient = eventClient else {
            return
        }
        
        guard let event = eventToCreate else {
            return
        }
        
        controller.setup(delegate: self, eventClient: eventClient, event: event)
     }
 
    @IBAction func setupGreenLight(_ sender: Any) {
    }
    
    @IBAction func setupGreenLightLessThen60(_ sender: Any) {
    }
    
    @IBAction func setupGreenLightLessThen30(_ sender: Any) {
    }
    
    @IBAction func setupYellowLight(_ sender: Any) {
    }
    
    @IBAction func setupRedLight(_ sender: Any) {
    }
    
    @IBAction func setupLive(_ sender: Any) {
    }
}

extension UIStackView {
    func removeAllArrangedViews() {
        let subviews = self.subviews
        
        for view in subviews {
            self.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}
