//
//  CoreDataHelper.swift
//  Answerer
//
//  Created by negar on 7/29/1397 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataHelper {

    func fetchUserFromCoreDate() -> Student? {
        var userDatas = [NSManagedObject]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        //fetching Datas

        let fechtRequest = NSFetchRequest<NSManagedObject>(entityName: "Student")

        //check if data exists or not


        do {
            //if exists fill the array
            userDatas = try managedContext.fetch(fechtRequest)
            if userDatas.count > 0 {
                let userInfo = Student()
                userInfo.email = userDatas[0].value(forKey: "email") as? String ?? ""
                userInfo.password = userDatas[0].value(forKey: "password") as? String ?? ""
                userInfo.phone = userDatas[0].value(forKey: "phone") as? String ?? ""
                userInfo.userName = userDatas[0].value(forKey: "userName") as? String ?? ""
                userInfo.profile = userDatas[0].value(forKey: "profile") as? String ?? ""
                userInfo.fcmToken = userDatas[0].value(forKey: "fireBaseId") as? String ?? ""
                userInfo.active = userDatas[0].value(forKey: "active") as? Bool ?? true
                return userInfo
            }
            else {
                return nil
            }
        }
        catch let error as NSError {
            //if not shows the error
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }

    func fetchFCMTokenFromCoreDate() -> String? {
        var tokenData = [NSManagedObject]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        //fetching Datas
        let fechtRequest = NSFetchRequest<NSManagedObject>(entityName: "Token")
        //check if data exists or not
        do {
            //if exists fill the array
            tokenData = try managedContext.fetch(fechtRequest)
            if tokenData.count > 0 {
                var tokenInfo = String()
                tokenInfo = tokenData[0].value(forKey: "fcm") as? String ?? ""
                return tokenInfo
            }
            else {
                return nil
            }
        }
        catch let error as NSError {
            //if not shows the error
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }

    func saveUserToCoreData(info: Student) -> Bool {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext

        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Student",
                in: managedContext)!

        let student = NSManagedObject(entity: entity,
            insertInto: managedContext)

        student.setValue(info.email, forKeyPath: "email")
        student.setValue(info.password, forKeyPath: "password")
        student.setValue(info.phone, forKeyPath: "phone")
        student.setValue(info.userName, forKeyPath: "userName")
        student.setValue(info.profile, forKeyPath: "profile")
        student.setValue(info.fcmToken, forKeyPath: "fireBaseId")
        student.setValue(info.active, forKeyPath: "active")
        // 4
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }

    }

    func saveFCMTokenToCoreData(info: String) -> Bool {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext

        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Token",
                in: managedContext)!

        let token = NSManagedObject(entity: entity,
            insertInto: managedContext)

        token.setValue(info, forKeyPath: "fcm")
        // 4
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }

    }

    func deleteCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        //fetching Datas

        let fechtRequest = NSFetchRequest<NSManagedObject>(entityName: "UsersInfo")

        //check if data exists or not
        do {
            //if exists fill the array
            let nationalCode = try managedContext.fetch(fechtRequest)
            for managedObject in nationalCode
            {
                let managedObjectData: NSManagedObject = managedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in IsLoggedIn error : \(error) \(error.userInfo)")
        }
    }
}

