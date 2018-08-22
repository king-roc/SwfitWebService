

import MySQLStORM
import PerfectRequestLogger


#if os(Linux)
    
MySQLConnector.host = "localhost";
MySQLConnector.username = "root";
MySQLConnector.password = "123456";
MySQLConnector.port = 3306;
MySQLConnector.database = "WebService";
    
RequestLogFile.location="./RequestLog.log";
    
let server = NetworkServer.init(serverName: "localhost", serverPort: 80);
server.start();
    
#else
    
MySQLConnector.host = "localhost";
MySQLConnector.username = "root";
MySQLConnector.password = "123456";
MySQLConnector.port = 3306;
MySQLConnector.database = "WebService";
    
RequestLogFile.location="./RequestLog.log";
    
    
let server = NetworkServer.init(serverName: "localhost", serverPort: 8181);
server.start();
#endif
