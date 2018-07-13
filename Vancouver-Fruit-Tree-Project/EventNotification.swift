//
//  EventNotification.swift
//  Vancouver-Fruit-Tree-Project
//
//  Created by Argus Li on 2018-07-08.
//  Copyright © 2018 Harvest8. All rights reserved.
//

import UIKit
import EventKit

let eventStore = EKEventStore()
let event = EKEvent(eventStore: eventStore)

class EventNotification: NSObject {
    
    
    func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let e as NSError {
                    completion?(false, e)
                    return
                }
                completion?(true, nil)
            } else {
                completion?(false, error as NSError?)
            }
        })
    }
    
    func removeEventFromCalendar(startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil){
        var predicate:NSPredicate?
        var events = [EKEvent]()
        var delEvent:EKEvent?
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars:nil)
                events = eventStore.events(matching: predicate!)
                delEvent = events[0]
            }else {
                completion?(false, error as NSError?)
            }
        })
    }
}
