//
//  NotificationManager.swift
//  BuStop
//
//  https://developer.apple.com/forums/thread/653737

import SwiftUI
import UserNotifications
import AVFoundation
import CoreLocation

class NotificationManager: UIViewController, ObservableObject {
    
    static let notificationManager = NotificationManager()
    
    let userNotificationCenter = UNUserNotificationCenter.current()

    let synthesizer = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        requestNotificationAuthorization()
    }    

    func requestNotificationAuthorization() {
//        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
//
//        print("auth ok")
//        userNotificationCenter.requestAuthorization(options: authOptions) { success, error in
//            if let error = error {
//                print("Error: \(error)")
//            }
//        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {didAllow,Error in
                if didAllow {
                    print("Push: 권한 허용")
                } else {
                    print("Push: 권한 거부")
                }
            })
    }

    func sendNotification(busStopInfo: BusStopInfo, place: String) {
        
        print("OK")
        userNotificationCenter.removeAllPendingNotificationRequests()
        
        let notificationContent = UNMutableNotificationContent()

        notificationContent.title = "도착 알림"
        notificationContent.body = "\(place) 전 정류장 도착"
        
        let location_name = place
//
//        let audioData = SpeechService.shared.makeSoundData(text: "이번 정류장은    " + location_name + "    전 정류장 입니다. ") {
//        }
//
 
        var index = busStopInfo.busIndex[place]!
        let busStopLatitude = Double(busStopInfo.latitude[index])!
        let busStopLongitude = Double(busStopInfo.longitude[index])!
        let center = CLLocationCoordinate2D(latitude: busStopLatitude, longitude: busStopLongitude)
        //let center = CLLocationCoordinate2D(latitude: 35.893081, longitude: 128.61016)
        
        let region = CLCircularRegion(center: center, radius: 50.0, identifier: "destination")
        region.notifyOnEntry = true
                
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
        let request = UNNotificationRequest(identifier: "testNotification",
                                            content: notificationContent,
                                            trigger: trigger)
        
        userNotificationCenter.add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
}
