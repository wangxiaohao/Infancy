//
//  SQLManger.swift
//  anbangke
//
//  Created by 王浩 on 2017/12/4.
//  Copyright © 2017年 Shanghai curtain state network technology Co., Ltd. All rights reserved.


import Foundation
import FMDB
import SwiftyJSON
let sql_path = AppInfo.document_path + "/" + AppInfo.product_Name + ".sqlite"
class SQLManger  {
    static let shared = SQLManger()
    var  query : FMDatabaseQueue
    var dbBase : FMDatabase

    fileprivate init() {
        query = FMDatabaseQueue(path: sql_path)
        dbBase = FMDatabase(path: sql_path)
        createTables()
    }
    
    /// 创建数据表
    ///
    /// - Parameters:
    ///   - tableArray: <#tableArray description#>
    ///   - tableNames:
    func createTables(){
        let path = Bundle.main.path(forResource: "SQLTableList", ofType: "json")
        let data  =  try? Data(contentsOf: URL(fileURLWithPath: path!))
        let json = JSON(data!)
        query.inTransaction { (db, rollback) in
            do{
               
                for sub in json.dictionaryValue {
                    guard !db.tableExists(sub.key) else  {
                        continue
                    }
                    try db.executeUpdate(sub.value.stringValue, values: nil)
                }
            }
            catch{
                rollback.pointee = true
                print("SQL=======>失败了")
            }
        }
    }
    
    /// 插入数据
    ///
    /// - Parameters:
    ///   - array: <#array description#>
    ///   - tableName: <#tableName description#>
    func insertValue<T:Codable>(_ array:[T],_ tableName:String){
        
         query.inTransaction { (db, rollback) in
            do{
                guard db.tableExists(tableName) else {
                    return
                }
                for sub in array {
                    let data = try JSONEncoder().encode(sub)
                    let dic = JSON(data).dictionaryObject
                    var  keys : [String] = []
                    var placeValue : [String] = []
                    var  Value : [Any] = []
                    for sub in dic! {
                        keys.append(sub.key)
                        Value.append(sub.value)
                        placeValue.append("?")
                    }
                    let sql = "INSERT INTO \(tableName)( \n"
                        + keys.joined(separator: ",") +
                        ")" + " VALUES (\(placeValue.joined(separator: ",")));"
                   try db.executeUpdate(sql, values: Value)
                }
            }
            catch{
                rollback.pointee = true
                print("SQL=======>失败了")
            }
        }
    }
    
    /// 更新数据
    ///
    /// - Parameters:
    ///   - dic: <#dic description#>
    ///   - tableName: <#tableName description#>
    func updateValue<T:Codable>(_ datas:[T],_ condition:[String:Any],_ tableName:String){
        query.inTransaction { (db, rollback) in
            do{
                guard db.tableExists(tableName) else {
                    return
                }
              
                var conKey : [String] = []
                var conValue:[Any] = []
                for sub in condition {
                    conKey.append(sub.key + " = ? ")
                    conValue.append(sub.value)
                }
                
                
                for sub in datas {
                    var values: [Any] = []
                    var keys : [String] = []

                    let data = try JSONEncoder().encode(sub)
                    let dic = JSON(data).dictionaryObject
                    for keyvalue  in dic! {
                        keys.append(keyvalue.key + "= ?")
                        values.append(keyvalue.value)
                    }
                    let sql = "update \(tableName) set \(keys.joined(separator: ",")) where \(conKey.joined(separator: " and ")) "
                    values.append(contentsOf: conValue)
                    try db.executeUpdate(sql, values: values)
                }
            }
            catch{
                rollback.pointee = true
                print("SQL=======>失败了")
            }
        }
    }
    
    /// 查询
    ///
    /// - Parameters:
    ///   - dic: <#dic description#>
    ///   - condic: <#condic description#>
    ///   - tableName: <#tableName description#>
    /// - Returns: <#return value description#>
    func selectValue(_ dic:[String : Any]?,_ condic:String? = "=",tableName:String)->JSON? {

        if dbBase.open() {
            do {
                var sql = "select * from \(tableName)"
                var valueArray : [Any] = []
                if dic != nil{
                    var whereSQL = ""
                    for sub in dic! {
                        whereSQL += sub.key + condic! + " ? " + " and "
                        valueArray.append(sub.value)
                    }
                    whereSQL =  String(whereSQL.prefix(whereSQL.count - 5 ))
                     sql = "select * from \(tableName) where " + whereSQL

                }
                let result = try dbBase.executeQuery(sql, values: valueArray)
                var json : JSON!
                while result.next() {
                     let dic =  result.resultDictionary
                     json = JSON.init(dic)
                }
                dbBase.close()
                return json
            }
            catch {
                deprint("查询错误")
                return nil
            }
           
        }
        return nil
    }
    
    /// 删除所有表
    ///
    /// - Parameter tableNames: <#tableNames description#>
    func deleteTables(){
        let path = Bundle.main.path(forResource: "SQLTableList", ofType: "json")
        let data  =  try? Data(contentsOf: URL(fileURLWithPath: path!))
        let json = JSON(data!)
        query.inTransaction { (db, rollback) in
                for sub in json.dictionaryValue {
                    let sql = "DROP TABLE IF EXISTS \(sub.key);"
                        try? db.executeUpdate(sql, values: nil)
                    
                }
        }
    }
    
    /// 删除某一数据
    func deleteSomeDataOfTable(_ block:@escaping (FMDatabase)->Void){
        deprint(sql_path)

        query.inTransaction { (trandb, rollback) in
             block(trandb)
        }
    }
    
    /// 返回某张表的总条数
    ///
    /// - Parameters:
    ///   - condition: <#condition description#>
    ///   - name: <#name description#>
    /// - Returns: <#return value description#>
    func getTableCount(_ condition:[String:Any]?,_ name:String )->Int{
        deprint(sql_path)

        if dbBase.open(){
            do {
                var sql  = "select Count(*) from \(name)"
                var value : [Any] = []

                if condition != nil {
                    var whereSQL = ""
                    for sub in condition! {
                        whereSQL += sub.key + " = ?" + " and "
                        value.append(sub.value)
                    }
                    whereSQL =  String(whereSQL.prefix(whereSQL.count - 5 ))
                    sql = "select Count(*) as Count from \(name) where \(whereSQL) "
                }
                
               let result =     try dbBase.executeQuery(sql, values: value)
                var count = 0
                while result.next(){
                    count =  Int(result.int(forColumn: "count"))
                }
                dbBase.close()
                return count
            }
            catch{
                return 0
            }
        }
        return 0
    }
}
extension SQLManger {
    static func deleteCacheAndSaveUpdate<T:Codable>(_ array:[T],_ condition:[String:Any],_ tableName:String){

        DispatchQueue.global().async(execute: {
            SQLManger.shared.deleteSomeDataOfTable {
                db in
                do{
                    if db.open() {
                        var valueArray : [String] = []
                        for sub in condition {
                            let str = sub.key + " = " + "\(sub.value)"
                            valueArray.append(str)
                        }
                        let sql = "DELETE FROM \(tableName) WHERE \(valueArray.joined(separator: " and "))"
                        try db.executeUpdate(sql, values: nil)
                    }
                }
                catch{
                    print("失败了。。。")
                }
            }
            SQLManger.shared.insertValue(array, tableName)
        })
        
    }
}
