//
//  HttpLog.swift
//  WebServicePackageDescription
//
//  Created by chason on 2018/3/27.
//

import PerfectRequestLogger
import PerfectLogger

func LogToFile(_ message:String) -> Void {
     LogFile.info(message, logFile:RequestLogFile.location)
}

func LogToFile(_ api:Any,success:Bool) -> Void {
    let result = success ? "success" : "failure";
    let message = "\(api) : \(result)"
    LogFile.info(message, logFile:RequestLogFile.location)
}
