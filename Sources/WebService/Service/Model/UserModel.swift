//
//  UserModel.swift
//  WebServicePackageDescription
//
//  Created by chason on 2018/3/30.
//

import StORM

class UserModel : DataModel {
    var id : Int = 0;
    var userName : String = "";
    var password : String = "";
    var loginTime : String = "";
    var registerTime : String = "";
    
    // The name of the database table
    override open func table() -> String { return "User" }
    
    override func to(_ this: StORMRow) {
        if this.data["id"] is Int {
            id = this.data["id"] as! Int;
        }
        else if this.data["id"] != nil {
            let id32 = this.data["id"] as! Int32;
            id = Int(id32);
        }
        userName = this.data["userName"] as! String;
        password = this.data["password"] as! String;
        loginTime = this.data["loginTime"] as! String;
        registerTime = this.data["registerTime"] as! String;
    }
    
    func rows() -> [UserModel] {
        var rows = [UserModel]()
        for i in 0..<self.results.rows.count {
            let row = UserModel()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
}
