//
//  EventClient.swift
//  Awesome Rooms
//
//  Created by Ariel Burke on 9/21/18.
//  Copyright © 2018 Robert Cole. All rights reserved.
//

import Foundation

protocol EventClient {
    func getEvents(completionHandler: ([Event]) -> (), errorHandler: (String) -> ())
    func createEvent(_ event: Event, completionHandler: () -> (), errorHandler: (String) -> ())
}
