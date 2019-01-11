//
//  DBQueue.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/7/19.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation

class DBQueue {
    
    static let share = DBQueue()
    
    public let queue = DispatchQueue.init(label: "queue", qos: .default)

}

import SQLite
extension DBQueue {

    public final func insterQueue<T: DBOperation>(_ setters: [Setter], _ tbName: String, _ type: T.Type) {
        queue.async {
            type.dbInster(setters, tbName, type)
        }
    }

    public final func insterOrUpdateQueue<T: DBOperation>(_ filier: Expression<Bool>? = nil,
                                          _ setters: [Setter],
                                          _ tbName: String,
                                          _ type: T.Type){
        queue.async {
            type.dbInsterOrUpdate(filier, setters, tbName, type)
        }
    }
    
    public final func selectQueue<T: DBOperation>(_ filier: Expression<Bool>,
                                  order aorder: [Expressible]? = nil,
                                  _ tbName: String,
                                  limit alimit: Int? = nil,
                                  _ type: T.Type,
                                  complement: @escaping ((Table?) ->())){
        queue.async {
            let table = type.dbSelect(filier, order: aorder, tbName, limit: alimit, type)
            DispatchQueue.main.async {
                complement(table)
            }
        }
    }
    
    public final func updateQueue<T: DBOperation>(_ filier: Expression<Bool>,
                             _ setters: [Setter],
                             _ tbName: String,
                             _ type: T.Type) {
    
        queue.async {
            type.dbUpdate(filier, setters, tbName, type)
        }
    }
    
    public final func deleteRowQueue<T: DBOperation>(_ filier: Expression<Bool>, _ tbName: String, _ type: T.Type) {
        queue.async {
            type.db_deleteRow(filier, tbName, type)
        }
    }

}
