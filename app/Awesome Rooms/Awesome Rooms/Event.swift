//
//  Event.swift
//  Awesome Rooms
//
//  Created by Ariel Burke on 9/21/18.
//  Copyright © 2018 Robert Cole. All rights reserved.
//

import Foundation

struct Event: Codable {
    var title: String?
    var city: String = "mob"
    var description: String
    var startDateTime: Date
    var endDateTime: Date
    var conferenceRoom: ConferenceRoom
}
