//
//  AppDelegate.swift
//  Todoey
//
//  Created by StartupBuilder.INFO on 9/2/20.
//  Copyright © 2020 StartupBuilder.INFO. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        print("Real Location: \(Realm.Configuration.defaultConfiguration.fileURL?.absoluteString ?? "Unknown")")
        
        let demo = Demo()
        let item = DemoItem()
        demo.items.append(item)
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(demo)
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodoeyData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

class DemoItem: Object {
    @objc dynamic var name = "Test"
    @objc dynamic var age = 0
}

class Demo: Object {
    @objc dynamic var name = "Test"
    @objc dynamic var age = 0
    var items = List<DemoItem>()
}


