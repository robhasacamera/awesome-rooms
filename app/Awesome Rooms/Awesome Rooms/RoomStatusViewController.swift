//
//  RoomStatusViewController.swift
//  Awesome Rooms
//
//  Created by Robert J Cole on 9/21/18.
//  Copyright © 2018 Robert Cole. All rights reserved.
//

import UIKit

class RoomStatusViewController: UIViewController, ReservationViewControllerDelegate {
  @IBOutlet var quickBookView: QuickBookView!
  
  @IBOutlet weak var topStack: UIStackView!
  
  @IBOutlet weak var bottomStack: UIStackView!

    var eventClient: EventClient?

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
