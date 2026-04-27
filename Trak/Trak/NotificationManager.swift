//
//  NotificationManager.swift
//  Trak
//
//  Created by James Price on 21/04/2026.
//

import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error {
                print(error)
            } else {
                print(granted)                          // requests authroiston and types for notification
            }
        }
    }
    
    func taskReminders(for task: ToDoTask) {
        let content = UNMutableNotificationContent()
        content.title = "Due tomorrow:"
        content.body = task.title                       // what goes in notification
        
        guard let date = Calendar.current.date(byAdding: .hour, value: -24, to: task.dueDate) else { return }   // calculates remminider time
                                                                                                                // if in past no scchedule
        guard date > Date() else { return }     // if due sooner than 24 hours already gone
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
                                                                                                    // one time trigger with ios calendar use
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: task.id.uuidString, content: content, trigger: trigger)        // identifies with ID
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                print(error)            // adds request to system
            }
        }
    }
    
    func removeReminder(for task: ToDoTask) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.id.uuidString])     // removes pending
    }                                                                                                                   // from task
    
    func removeAllReminders() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()   // removes all pending reminders
    }
}
