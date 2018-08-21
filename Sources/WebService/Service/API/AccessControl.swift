//
//  AccessControl.swift
//  WebServicePackageDescription
//
//  Created by chason on 2018/5/9.
//

import PerfectHTTP
import PerfectRequestLogger
import PerfectLib
import StORM

class AccessControlModel : DataModel {
    
    var id : Int = 0;
    var appName : String = "";
    var bundleId : String = "";
    var version : String = "";
    var password : String = "";
    var updateTime : String = "";
    var permission : Int = 0;
    
    // The name of the database table
    override open func table() -> String { return "AccessControl" }
    
    override func to(_ this: StORMRow) {
        let id32 = this.data["id"] as! Int32;
        id = Int(id32);
        appName = this.data["appName"] as! String;
        bundleId = this.data["bundleId"] as! String;
        version = this.data["version"] as! String;
        password = this.data["password"] as! String;
        let permission32 = this.data["permission"] as! Int32;
        permission = Int(permission32);
        updateTime = this.data["updateTime"] as! String;
    }

    func rows() -> [AccessControlModel] {
        var rows = [AccessControlModel]()
        for i in 0..<self.results.rows.count {
            let row = AccessControlModel()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
    
//    override func ignoreParams() -> [String] {
//        return ["password"];
//    }
}

class GetAccessControl: NetRequest {
    
    public static func requestHandler(request: HTTPRequest, response: HTTPResponse) {
        let appName :String! = request.paramSafe(name: "appName");
        let bundleId :String! = request.paramSafe(name: "bundleId");
        let version :String! = request.paramSafe(name: "version");
        let password :String! = request.paramSafe(name: "password");
    
        let control = AccessControlModel();
        
        try? control.find([("bundleId", bundleId)]);
    
        guard control.results.foundSetCount > 0 else {
            response.sendError(message: "该App不存在");
            return;
        }
        
        guard control.results.rows.count == 1 else {
            response.sendError(message: "数据出错了");
            return;
        }
        
        if password.length<0 || password != control.password {
            response.sendError(message: "密码错误");
            return;
        }
        
        let updateTime : String = try! formatDate(getNow(), format: "%Y-%m-%d %H:%M:%S");
        control.updateTime = updateTime;
     
        try? control.save();
        guard control.results.rows.count>0 else {
            response.sendError(message: "权限修改失败");
            return;
        }
        
        response.sendData(data: control);
        
        defer {
            LogToFile(self, success: true);
        }
    }
}


class SetAccessControl: NetRequest {
    
    public static func requestHandler(request: HTTPRequest, response: HTTPResponse) {
        let appName :String! = request.paramSafe(name: "appName");
        let bundleId :String! = request.paramSafe(name: "bundleId");
        let version :String! = request.paramSafe(name: "version");
        let password :String! = request.paramSafe(name: "password");
        let permission : Int! = request.paramSafe(name: "permission").toInt() ?? 1;
        
        let control = AccessControlModel();
        try? control.find([("bundleId", bundleId)]);
        
        if control.results.foundSetCount > 0 {
            if password.length<0 || password != control.password {
                response.sendError(message: "密码错误");
                return;
            }
        }
        else{
            control.password=password;
        }
        
        control.appName=appName;
        control.bundleId=bundleId;
        control.version=version;
        
        let updateTime : String = try! formatDate(getNow(), format: "%Y-%m-%d %H:%M:%S");
        control.updateTime = updateTime;
        control.permission=permission;
        
        try? control.save();
        guard control.results.rows.count>0 || control.results.insertedID>0 else {
            response.sendError(message: "权限添加失败");
            return;
        }
        
        response.sendData(data: control);
        
        defer {
            LogToFile(self, success: true);
        }
    }
}
