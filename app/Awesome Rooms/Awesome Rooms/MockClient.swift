//
//  MockClient.swift
//  Awesome Rooms
//
//  Created by Ariel Burke on 9/21/18.
//  Copyright © 2018 Robert Cole. All rights reserved.
//

import Foundation

class MockClient: EventClient {
    var events = [Event]()
    
    enum SimulatedScenario: String {
        case greenLight
        case redLight 
        case greenLightLessThanSixtyMins
        case greenLightLessThanThirtyMins
        case yellowLight
    }
    
    init(scenario: SimulatedScenario) {
        switch scenario {
        case .greenLight:
            events = makeGreenLightMockObject()
        case .redLight:
            events = makeRedLightMockObject()
        case .greenLightLessThanSixtyMins:
            events = makeGreenLightLessThanSixtyMinsMockObject()
        case .greenLightLessThanThirtyMins:
            events = makeGreenLightLessThanThirtyMinsMockObject()
        case .yellowLight:
            events = makeYellowLightMockObject()
        }
    }
    
    func  makeGreenLightMockObject() -> [Event] {
        var events = [Event]()
        
        let now = Date()
        let cal = Calendar.current
        
        let startTime = cal.date(byAdding: .minute, value: 120, to: now)
        let endTime = cal.date(byAdding: .minute, value: 150, to: now)
        
        if let startTime = startTime, let endTime = endTime {
            let greenLightEvent = Event(title: "Manager Touchbase", city: "mob", description: "Bi-weekly touchbase with manager.", startDateTime: startTime, endDateTime: endTime, conferenceRoom: .apollo)
            
            events.append(greenLightEvent)
        }
       
        return events
    }
    
    func  makeRedLightMockObject() -> [Event] {
        var events = [Event]()
        
        let now = Date()
        let cal = Calendar.current
        
        
        let endTime = cal.date(byAdding: .minute, value: 60, to: now)
        
        if let endTime = endTime {
            let redLightEvent = Event(title: "Monthly Roundup", city: "mob", description: "Monthly updates about the dev center.", startDateTime: now, endDateTime: endTime, conferenceRoom: .leSabre)
            
            events.append(redLightEvent)
        }
        
        return events
    }
    
    func  makeGreenLightLessThanSixtyMinsMockObject() -> [Event] {
        var events = [Event]()
        
        let now = Date()
        let cal = Calendar.current
        
        let startTime = cal.date(byAdding: .minute, value: 35, to: now)
        let endTime = cal.date(byAdding: .minute, value: 95, to: now)
        
        if let startTime = startTime, let endTime = endTime {
            let greenLightLessThanSixtyMinsEvent = Event(title: "RSI Innovation Brainstorming Session", city: "mob", description: "INNOVATE!", startDateTime: startTime, endDateTime: endTime, conferenceRoom: .empire)
            
            events.append(greenLightLessThanSixtyMinsEvent)
        }
        
        return events
    }
    
    func  makeGreenLightLessThanThirtyMinsMockObject() -> [Event] {
        var events = [Event]()
        
        let now = Date()
        let cal = Calendar.current
        
        let startTime = cal.date(byAdding: .minute, value: 23, to: now)
        let endTime = cal.date(byAdding: .minute, value: 53, to: now)
        
        if let startTime = startTime, let endTime = endTime {
            let greenLightLessThanThiryMinsEvent = Event(title: "CA Meeting", city: "mob", description: "Go over events happening in October", startDateTime: startTime, endDateTime: endTime, conferenceRoom: .empire)
            
            events.append(greenLightLessThanThiryMinsEvent)
        }
        
        return events
    }
    
    func  makeYellowLightMockObject() -> [Event] {
        var events = [Event]()
        
        let now = Date()
        let cal = Calendar.current
        
        let startTime = cal.date(byAdding: .minute, value: 11, to: now)
        let endTime = cal.date(byAdding: .minute, value: 131, to: now)
        
        if let startTime = startTime, let endTime = endTime {
            let yellowLightEvent = Event(title: "Mario Kart Tourney", city: "mob", description: "Watch out for that blue shell. (Joshua cheats).", startDateTime: startTime, endDateTime: endTime, conferenceRoom: .leSabre)
            
            events.append(yellowLightEvent)
        }
        
        return events
    }
    
    
    
    func getEvents(completionHandler: @escaping ([Event]) -> (), errorHandler: @escaping (String) -> ()) {
        completionHandler(events)
    }
    
    func createEvent(_ event: Event, completionHandler: @escaping () -> (), errorHandler: @escaping (String) -> ()) {
        events.append(event)
        completionHandler()
    }
}

