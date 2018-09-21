//
//  GoogleClient.swift
//  Awesome Rooms
//
//  Created by David Mullen on 9/21/18.
//  Copyright © 2018 Robert Cole. All rights reserved.
//

import Foundation

class GoogleClient: EventClient {
    
    struct WebserviceEvent: Codable {
        let name: String
        let start: String
        let end: String
    }
    
    let webserviceUrl = "http://devjam.seltzer.tech:5000/devjam/list?city=mob&room=empire"
    
    func getEvents(completionHandler: @escaping ([Event]) -> (), errorHandler: @escaping (String) -> ()) {
        let url = URL(string: webserviceUrl)

        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    errorHandler(error.localizedDescription)
                } else if let jsonData = data {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    
                    do {
                        print(String(data: jsonData, encoding: String.Encoding.utf8) as String!)
                        let events = try decoder.decode([Event].self, from: jsonData)
                        
                        completionHandler(events)
                    } catch {
                        errorHandler("Could not decode JSON")
                    }
                } else {
                    errorHandler("Response was nil")
                }
        }
        
        task.resume()
    }
    
    func createEvent(_ event: Event, completionHandler: @escaping () -> (), errorHandler: @escaping (String) -> ()) {
        let url = URL(string: webserviceUrl)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            let jsonData = try encoder.encode(event)
            request.httpBody = jsonData
        } catch {
            errorHandler("Could not encode event as JSON")
        }

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                errorHandler(error.localizedDescription)
            } else {
                completionHandler()
            }
        }
        
        task.resume()
    }
}
