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
    //Add event to default calendar
        var access = 0
        
        while access == 0{
            eventStore.requestAccess(to: .event, completion: { (granted, error) in
                if (granted) && (error == nil) {
                    event.title = title
                    event.startDate = startDate
                    event.endDate = endDate
                    event.notes = description
                    access = 1
                    event.calendar = eventStore.defaultCalendarForNewEvents
                    do {
                        try eventStore.save(event, span: .thisEvent, commit: true)
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
    }
    
    func findEvent(startDate: Date, endDate: Date) -> EKEvent? {
        var predicate:NSPredicate?
        var events = [EKEvent]()
        var access = 0
        while access == 0 {
            eventStore.requestAccess(to: .event, completion: { (granted, error) in
                if (granted) && (error == nil) {
                    predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
                    access = 1
                }else {
                    return
                }
            })
        }
        if predicate != nil {
            if let aPredicate = predicate {
                events = eventStore.events(matching: aPredicate)
            }
            return events[0]
        }
        else{
            return nil
        }
    }
    
    func removeEventFromCalendar(delEvent: EKEvent) -> Int?{
    //Remove event from default calendar !important! Will crash if no such event exists
        var calendars=[EKCalendar]()
        var success = 1
        var access = 0
        calendars.append(eventStore.defaultCalendarForNewEvents!)
        while access == 0{
            eventStore.requestAccess(to: .event, completion: { (granted, error) in
                if (granted) && (error == nil) {
                    do {
                        try eventStore.remove(delEvent, span: .thisEvent, commit: true)
                        access = 1
                    } catch let e as NSError {
                        success = 0
                        return
                    }
                    
                }else {
                    success = 0
                    return
                }
            })
        }
        return success
    }
}
