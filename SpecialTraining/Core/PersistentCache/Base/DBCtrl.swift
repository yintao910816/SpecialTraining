//
//  DBCtrl.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/2/22.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import SQLite

class DbManager {

// MARK: - 创建 数据库、表
    
    class public func dbSetup() -> Void {
//        do {
//            PrintLog(dbFullPath1)
//            let db = try Connection(dbFullPath1)
//            
//        } catch {
//            PrintLog("\(error)")
//        }

        do {
            PrintLog(dbFullPath)
            let db = try Connection(dbFullPath)
            
            // 创建用户表
            var table = Table(userTB)
            try db.run(table.create { t in
//                UserInfoModel.dbBind(t)
            })

            
            update(db)
            PrintLog("数据库版本：\(db.userVersion)")
            
        } catch {
            PrintLog("\(error)")
        }
    }
    
    class private func update(_ db: Connection) {
        switch db.userVersion {
        case 0:
            // 数据库版本为0，说明首次安装，直接设置数据库为最新版本
            db.userVersion = 2
            break
        case 1:
            let users = Table(userTB)
            do {
                let ret = try db.run(users.addColumn(Expression<Bool>("isSign"), defaultValue: false))
                PrintLog(ret)
                db.userVersion = 2
            }catch {
                PrintLog("向表 userTB 插入 row：isSign失败")
            }
            break
        case 2:
            PrintLog("已是最新数据库")
            break
        default:
            break
        }
    }
}
