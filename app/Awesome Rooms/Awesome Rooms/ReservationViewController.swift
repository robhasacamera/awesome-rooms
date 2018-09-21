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

    public var eventClient: EventClient?

    public var event: Event?

    var delegate: ReservationViewControllerDelegate?

    func setup(delegate: ReservationViewControllerDelegate, eventClient: EventClient, event: Event) {
        self.delegate = delegate
        self.eventClient = eventClient
        self.event = event
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
        guard var event = event else {
            return
        }

        guard let title = titleTextField?.text else {
            displayErrorPopup(title: "Error", message: "You must enter a title.")
            return
        }

        guard let description = descriptionTextView?.text else {
            displayErrorPopup(title: "Error", message: "You must enter a description.")
            return
        }

        event.title = title
        event.description = description

        eventClient?.createEvent(event, completionHandler: (delegate?.didCreateEvent)!, errorHandler: didNotCreateEvent)
    }

    func displayErrorPopup(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func didNotCreateEvent(error: String) {
        displayErrorPopup(title: "Error", message: error)
    }
}
