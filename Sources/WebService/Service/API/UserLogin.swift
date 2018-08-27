//
//  UserLogin.swift
//  WebServicePackageDescription
//
//  Created by chason on 2018/3/24.
//
import PerfectHTTP
import PerfectLib
import MySQLStORM
import Foundation

class UserLogin : NetRequest {
    
    public static func requestHandler(request: HTTPRequest, response: HTTPResponse) {
        
        let userName :String! = request.paramSafe(name: "userName");
        let password :String! = request.paramSafe(name: "password");
        
        let user = UserModel();
        let nameString = NSString.init(string: userName)
        try? user.find(["userName":nameString])

        guard user.results.foundSetCount>0 else {
            response.sendError(message: "用户名不存在");
            return;
        }


        if user.password != password {
            response.sendError(message: "密码错误");
            return;
        }

        let loginTime : String = try! formatDate(getNow(), format: "%Y-%m-%d %H:%M:%S");
        user.loginTime = loginTime;
        try? user.save();
        guard user.results.rows.count>0 else {
            response.sendError(message: "登录失败");
            return;
        }
        
        response.sendData(data: user.asDataDict());
        
        defer {
            LogToFile(self, success: true);
        }
    }
}



