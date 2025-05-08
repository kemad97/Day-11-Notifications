//
//  ViewController.swift
//  Day 11 Notifications
//
//  Created by Kerolos on 08/05/2025.
//

import UIKit

class ViewController: UIViewController , UNUserNotificationCenterDelegate {
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var btnTimeOut: UIButton!
    @IBOutlet weak var btnSetReminder: UIButton!
    
    let userNotificationCenter = UNUserNotificationCenter.current()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.userNotificationCenter.delegate=self
        self.requestNotificationAuthorization()


    }
    
    func requestNotificationAuthorization() {
        let authOptions=UNAuthorizationOptions.init(arrayLiteral: .alert,.badge,.sound)
        
        self.userNotificationCenter.requestAuthorization(options: authOptions){
            (success,error) in
            if let error=error{
                print ("Error:",error)
            }
        }
        
    }



    @IBAction func btnTimeoutPressed(_ sender: Any) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "10 sec Notification"
        notificationContent.body = "Body of notifcation ................."
        notificationContent.badge=NSNumber(value: 9)
        notificationContent.sound = .default
        notificationContent.userInfo=["notificationType":"timer"]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let request = UNNotificationRequest(identifier: "timerNotification", content: notificationContent, trigger: trigger)

        // Add request to notification center
                userNotificationCenter.add(request) { (error) in
                    if let error = error {
                        print("Notification Error: ", error)
                    }
                }

    }
    
    
    
    @IBAction func btnSetReminderPressed(_ sender: Any) {
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Reminder"
        notificationContent.body = "Your scheduled reminder!"
        notificationContent.badge = NSNumber(value: 1)
        notificationContent.sound = .default
        
        notificationContent.userInfo = ["notificationType": "reminder"]
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from:datePicker.date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "reminderNotification",
            content: notificationContent,
            trigger: trigger
        )
        

        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }

    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let notificationType = userInfo["notificationType"] as? String {
            if notificationType == "timer" {
                performSegue(withIdentifier: "showTimerDetails", sender: nil)
            } else if notificationType == "reminder" {
                performSegue(withIdentifier: "showReminderDetails", sender: nil)
            }
        }
        
        // Reset badge count
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        completionHandler()
    }

}

