//
//  DBProtocol.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/2/23.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation
import SQLite

public protocol DBOperation {
    
    static func dbBind(_ builder: TableBuilder) -> Void
}

extension DBOperation {

    /**
     获取数据库
     */
    static var db: Connection? {
        do {
            return try Connection(dbFullPath)
        } catch {
            PrintLog("连接到数据库失败")
        }
        return nil
    }
    
}

extension DBOperation {
    
    //MARK:
    //MARK: 增加数据
    @discardableResult
    static func dbInster(_ setters: [Setter], _ tbName: String) -> Bool {

        guard let DB = db else {
            PrintLog("数据库连接失败：\(tbName)")
            return false
        }
        
        let table = Table(tbName)
        
        do {
            try DB.run(table.insert(setters))
            PrintLog("增加数据成功：\(tbName)")
        } catch {
            PrintLog("insertion failed: \(error)")
            return false
        }
        
        return true
    }
    
    @discardableResult
    static func dbInsterOrUpdate(_ filier: Expression<Bool>? = nil,
                                 _ setters: [Setter],
                                 _ tbName: String) ->Bool {

        if let _filier = filier {
            if dbExist(_filier, tbName) == true {
                return dbUpdate(_filier, setters, tbName)
            }else {
                return dbInster(setters, tbName)
            }
        }else {
            return dbInster(setters, tbName)
        }
    }
    
    //MARK:
    //MARK: 查询所有数据
    static func dbSelectAll(_ tbName: String) -> [Row]? {
        guard let db = db else {
            return nil
        }
        
        let table = Table(tbName)
        
        do {
           return Array(try db.prepare(table))
        } catch  {
            PrintLog("查询所有数据失败")
        }
        return nil
    }

    // 根据 filier 查询数据
    static func dbSelect(_ filier: Expression<Bool>,
                         order aorder: [Expressible]? = nil,
                         _ tbName: String,
                         limit alimit: Int? = nil) -> Table? {
        guard let _ = db else {
            return nil
        }

        let table = Table(tbName)

        if aorder != nil && alimit != nil {
            return table.filter(filier)
                .order(aorder!)
                .limit(alimit!)
        }
        
        if aorder != nil && alimit == nil {
            return table.filter(filier)
                .order(aorder!)
        }
        
        if aorder == nil && alimit != nil {
            return table.filter(filier)
                .limit(alimit!)
        }

        return table.filter(filier)
    }
    
    // 查询是否存在
    static func dbExist(_ filier: Expression<Bool>, _ tbName: String) ->Bool {
        guard let DB = db else {
            PrintLog("数据库连接失败\(tbName)")
            return false
        }

        let table = Table(tbName)

        do {
            let allDatas = try Array(DB.prepare(table.filter(filier)))
            return allDatas.count > 0
        } catch {
            PrintLog(error)
            return false
        }
    }
    
    //MARK:
    //MARK: 删除所有数据
    static func deleteAll(_ tbName: String) ->Bool {
        guard let DB = db else {
            PrintLog("数据库连接失败：\(tbName)")
            return false
        }
        
        let table = Table(tbName)

        do {
            try DB.run(table.delete())
            PrintLog("删除数据成功：\(tbName)")
        } catch  {
            PrintLog(error)
            return false
        }
        
        return true
    }
    
    //根据 filier 删除数据
    @discardableResult
    static func db_deleteRow(_ filier: Expression<Bool>, _ tbName: String) ->Bool {
        guard let DB = db else {
            PrintLog("数据库连接失败：\(tbName)")
            return false
        }
        
        let table = Table(tbName)

        do {
            try DB.run(table.filter(filier).delete())
            PrintLog("删除数据成功：\(tbName)")
        } catch  {
            PrintLog(error)
            return false
        }
        
        return true
    }
    
    // 删除所有数据
    @discardableResult
    static func db_deleteAll(_ tbName: String) ->Bool {
        guard let DB = db else {
            PrintLog("数据库连接失败：\(tbName)")
            return false
        }
        
        let table = Table(tbName)

        do {
            try DB.run(table.delete())
            PrintLog("删除数据成功：\(tbName)")
        } catch  {
            PrintLog(error)
            return false
        }
        
        return true
    }

    
    //MARK:
    //MARK: 根据 filier 更新数据
    @discardableResult
    static func dbUpdate(_ filier: Expression<Bool>, _ setters: [Setter], _ tbName: String) ->Bool {
    
        guard let DB = db else {
            PrintLog("数据库连接失败\(tbName)")
            return false
        }
        
        let table = Table(tbName)

        do {
            try DB.run(table.filter(filier).update(setters))
            PrintLog("数据更新成功：\(tbName)")
        }catch {
            PrintLog("数据更新失败：\(error)")
            return false
        }
        
        return true
    }
}

//MARK
//MARK: 工具方法
extension DBOperation {

    /// 增加数据之前的查询操作
    ///
    /// - Parameters:
    ///   - filiers: 增加一条数据之前根据这个条件进行查询，无则增加
    ///     [("id", "10"),("name", "jim")]
    ///   - tbName: 表名
    /// - Returns: 查询 sql 语句
    fileprivate static func sql_count(_ filiers:[(String, String)], _ tbName: String) ->String {
        if filiers.count > 0 { return sql("SELECT count(*) FROM \(tbName) WHERE", filiers) }
        return "SELECT count(*) FROM \(tbName)"
    }
    
    fileprivate static func sql_select(_ filiers:[(String, String)], _ tbName: String) ->String {
        if filiers.count > 0 { return sql("SELECT * FROM \(tbName) WHERE", filiers) }
        return "SELECT * FROM \(tbName)"
    }

    private static func sql(_ baseSql: String, _ filiers:[(String, String)]) ->String {
        var filierString = baseSql
        
        if filiers.count == 1 {
            let (key, value) = filiers.first!
            return filierString.appending(" \(key) = '\(value)'")
        }else if(filiers.count == 2){
            let (key1, value1) = filiers.first!
            let (key2, value2) = filiers.last!
            return filierString.appending(" \(key1) = '\(value1)' AND \(key2) = '\(value2)'")
        }
        
        // >2
        for (index, (key, value)) in filiers.enumerated() {
            var appendString = ""
            if index == filiers.count - 2  {
                appendString = " AND "
            }else if index == filiers.count - 1 {
                appendString = ""
            }else {
                appendString = ", "
            }
            
            filierString = filierString.appending("\(key)='\(value)'\(appendString)")
        }
        return filierString
    }

}
