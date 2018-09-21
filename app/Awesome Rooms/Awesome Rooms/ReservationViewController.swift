//
//  ReservationViewController.swift
//  Awesome Rooms
//
//  Created by David Mullen on 9/21/18.
//  Copyright © 2018 Robert Cole. All rights reserved.
//

import UIKit

class ReservationViewController: UIViewController {

    @IBOutlet var titleTextField: UITextField?

    @IBOutlet var descriptionTextView: UITextView?

    var eventClient: EventClient?

    init(eventClient: EventClient) {
        this.eventClient = eventClient
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickedSubmit() {
        var event = Event(title: titleTextField.text, description: descriptionTextView.text)
        eventClient.createEvent(event: event, completionHandler: didCreateEvent, errorHandler: didNotCreateEvent)
    }

    func didCreateEvent() {
        
    }

    func didNotCreateEvent(error: Error) {
        
    }
}
