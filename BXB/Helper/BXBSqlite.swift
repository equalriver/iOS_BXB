//
//  BXBSqlite.swift
//  BXB
//
//  Created by equalriver on 2018/7/15.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation
/*
import SQLite

struct SQLiteManager {
    
    private var db: Connection!
    private let users = Table("users") //表名
    private let id = Expression<Int64>("id")      //主键
    private let name = Expression<String>("name")  //列表1
    private let email = Expression<String>("email") //列表2
    
    
    init() {
        createdsqlite3()
    }
    
    //创建数据库文件
    mutating func createdsqlite3(filePath: String = "/Documents")  {
        
        let sqlFilePath = NSHomeDirectory() + filePath + "/client_db.sqlite3"
        do {
            db = try Connection(sqlFilePath)
            try db.run(users.create(ifNotExists: true) { (t) in
                t.column(id, primaryKey: true)
         
            })
        } catch { print(error) }
    }
    
    //插入数据
    func insertData(_name: String, _email: String){
        do {
            
            let insert = users.insert(name <- _name, email <- _email)
            try db.run(insert)
        } catch {
            print(error)
        }
    }
    
    //读取数据
    func readData() -> [(id: String, name: String, email: String)] {
        var userData = (id: "", name: "", email: "")
        var userDataArr = [userData]
        for user in try! db.prepare(users) {
            userData.id = String(user[id])
            userData.name = user[name]
            userData.email = user[email]
            userDataArr.append(userData)
        }
        return userDataArr
    }
    
    //更新数据
    func updateData(userId: Int64, old_name: String, new_name: String) {
        let currUser = users.filter(id == userId)
        do {
            try db.run(currUser.update(name <- name.replace(old_name, with: new_name)))
        } catch {
            print(error)
        }
        
    }
    
    //删除数据
    func delData(userId: Int64) {
        let currUser = users.filter(id == userId)
        do {
            try db.run(currUser.delete())
        } catch {
            print(error)
        }
    }
}
*/

