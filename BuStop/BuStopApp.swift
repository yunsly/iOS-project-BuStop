//
//  BuStopApp.swift
//  BuStop
//
//

import SwiftUI

@main
struct BuStopApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            var busStop = BusStopInfo(filePath: "/Users/hwistarrrrr/Desktop/11.txt")
            var busStopList: [String]? = busStop.FindBusStop(200)
            var checkDest = CheckDest()
            ContentView(busStop: busStop, busStopList: busStopList, checkDest: checkDest)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // 앱이 실행 중 일때 처리하는 메서드
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner])
    }
}
