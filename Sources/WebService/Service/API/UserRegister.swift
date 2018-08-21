//
//  UserRegister.swift
//  WebServicePackageDescription
//
//  Created by chason on 2018/3/27.
//

import PerfectHTTP
import PerfectRequestLogger
import PerfectLib
import StORM

class UserRegisterModel : DataModel {
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
    
    func rows() -> [UserRegisterModel] {
        var rows = [UserRegisterModel]()
        for i in 0..<self.results.rows.count {
            let row = UserRegisterModel()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
}

class UserRegister: NetRequest {
    
    public static func requestHandler(request: HTTPRequest, response: HTTPResponse) {
        // need to make sure something is available.
        
        let userName :String! = request.paramSafe(name: "userName");
        let password :String! = request.paramSafe(name: "password");
        
        let user = UserRegisterModel();
        
        user.userName=userName;
        user.password=password;
       
        let registerTime : String = try! formatDate(getNow(), format: "%Y-%m-%d %H:%M:%S");
        user.registerTime = registerTime;
        try? user.find([("userName", userName)]);
        
        guard user.results.foundSetCount <= 0 else {
            response.sendError(message: "该用户已存在");
            return;
        }
        
        try? user.save(set: { (id) in
            user.id=id as! Int;
        })
        
        guard user.results.insertedID > 0  else {
            response.sendError(message: "注册失败");
            return;
        }
        
        LogToFile(self, success: true);
        UserLogin.requestHandler(request: request, response: response);
    }
}
