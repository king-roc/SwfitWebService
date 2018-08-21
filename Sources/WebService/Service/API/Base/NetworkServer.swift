//
//  NetworkServer.swift
//  WebServicePackageDescription
//
//  Created by chason on 2018/3/27.
//

import PerfectHTTP
import PerfectHTTPServer
import PerfectRequestLogger

open class NetworkServer {
    
    let server = HTTPServer();
    let httplogger = RequestLogger();
    let requestFilter = RequestFilter();
    let responseFilter = ResponseFilter();
    
    var routes : Routes = Routes.init(baseUri: "/v1");
    
    init(serverName:String,serverPort:UInt16) {
        server.serverPort = serverPort;
        server.serverName=serverName;
        self.initRoutes();
        server.addRoutes(routes);
        server.documentRoot="./webroot";
        server.setRequestFilters([(httplogger, .high),(RequestFilter(), .low)]);
        server.setResponseFilters([(ResponseFilter(), .high),(httplogger, .low)]); 
    }
    
    func start() -> Void {
        do {
            try server.start();
        } catch {
            fatalError("\(error)"); // fatal error launching one of the servers
        }
    }
    
    func initRoutes() -> Void {
        routes.add(Route.init(methods: [.get,.post], uri: "/**", handler: handler));
        routes.add(Route.init(methods: [.get,.post], uri: "/api/login", handler: UserLogin.requestHandler));
        routes.add(Route.init(methods: [.get,.post], uri: "/api/register", handler: UserRegister.requestHandler));
        routes.add(Route.init(methods: [.get,.post], uri: "/api/getAccessControl", handler: GetAccessControl.requestHandler));
        routes.add(Route.init(methods: [.get,.post], uri: "/api/setAccessControl", handler: SetAccessControl.requestHandler));
    }
    
    func handler(request: HTTPRequest, response: HTTPResponse) {
        response.sendError(message: "接口不存在");
    }
    
    struct RequestFilter : HTTPRequestFilter {
        func filter(request: HTTPRequest, response: HTTPResponse, callback: (HTTPRequestFilterResult) -> ()) {
            request.setHeader(.contentType, value: "text/html;charset=UTF-8");
            callback(.continue(request, response))
        }
    }
    
    struct ResponseFilter : HTTPResponseFilter {
        func filterHeaders(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
            response.setHeader(.contentType, value: "text/html;charset=UTF-8");
            callback(.continue);
        }
        func filterBody(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
            callback(.continue);
        }
    }
}
