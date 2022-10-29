//
//  LocalNotificationsService.swift
//  Vk
//
//  Created by Табункин Вадим on 28.10.2022.
//
import UIKit
import UserNotifications

class LocalNotificationsService: NSObject, UNUserNotificationCenterDelegate {

    func registeForLatestUpdatesIfPossible() {
        self.registerUpdatesCategory()
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.sound, .badge, .provisional]) { granted, error in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = "Посмотрите последние обновления"
                content.body = "Есть новые записи..."
                content.categoryIdentifier = "update"
                content.badge = 1
                content.sound = .default
                var dateComponents = DateComponents()
                dateComponents.hour = 19
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                center.add(request)
            }
            else {
                print("Ошибка \(String(describing: error))")
            }
        }
    }

    private func registerUpdatesCategory() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        let show = UNNotificationAction(identifier: "Показать", title: "Показать больше", options: .destructive)
        let category = UNNotificationCategory(identifier: "update", actions: [show], intentIdentifiers: [], options: [])
        center.setNotificationCategories([category])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
            print("Default Identifier")
        case "Показать":
            print("Показать больше информации")
        default:
            break
        }
        completionHandler()
    }
}
