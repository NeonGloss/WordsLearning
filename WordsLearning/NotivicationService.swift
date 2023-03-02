//
//  NotivicationService.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 21/02/2023.
//

import Foundation
import UserNotifications

/// Тип нотификации
enum NotificationType: String {
    
    /// Переодическое предложение поучить слова
    case suggestionToLearn
    
    /// Разовое уведомление пользователя
    case single
}

/// Протокол сервиса отправки уведомлений
protocol NotificationServiceProtocol {
    
    /// Запросить разрешение на отправку уведомлений
    /// - Parameter completion: замыкание, возвращающее флаг того, что разрешение получено
    func requestRights(completion: @escaping (Bool) -> Void )
    
    /// Отправлять уведомление пользователю. Если будет передан интервал, то сообщение будет повторяться с данным интервалом
    /// - Parameters:
    ///   - title: Заголовок
    ///   - body: текст тела сообщения
    ///   - secondsInterval: интервал в секундах
    func sendNotificationWith(title: String, body: String, secondsInterval: Double?)
}

/// Сервис отправки уведомлений
final class NotificationService: NSObject,
                                 NotificationServiceProtocol,
                                 UNUserNotificationCenterDelegate {
    
    private let notificationCenter: UNUserNotificationCenter
    
    /// Инициализатор
    /// - Parameter notificationCenter: центр нотификации приложения
    init(notificationCenter: UNUserNotificationCenter) {
        self.notificationCenter = notificationCenter
    }
    
    func requestRights(completion: @escaping (Bool) -> Void ) {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] isGrantd, error in
            guard isGrantd else {
                completion(false)
                return
            }
            
            self?.notificationCenter.getNotificationSettings { receivedSettings in
                guard receivedSettings.authorizationStatus == .authorized else {
                    completion(false)
                    return
                }
                completion(true)
            }
        }
    }
    
    func sendNotificationWith(title: String, body: String, secondsInterval: Double?) {
        let content = UNMutableNotificationContent()
        content.sound = .default
        content.title = title
        content.body = body
        let trigger: UNTimeIntervalNotificationTrigger?
        let notificationType: NotificationType
        
        if let secondsInterval = secondsInterval {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: secondsInterval, repeats: true)
            notificationType = .suggestionToLearn
        } else {
            notificationType = .single
            trigger = nil
        }
        
        let request = UNNotificationRequest(identifier: notificationType.rawValue,
                                            content: content,
                                            trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // не отображать уведомление если приложение открыто на экране
        completionHandler([])
    }
        
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse) async {
        // вызывается когда пользователь нажал на уведомление
    }
}
