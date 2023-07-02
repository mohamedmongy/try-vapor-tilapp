//
//  File.swift
//  
//
//  Created by Mongy on 02/07/2023.
//

import Vapor

struct WebsiteController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        routes.get(use: indexHandler(req:))
        routes.get("acronyms", ":acronymID", use: acronymHandler(req:))
    }
    
    func indexHandler(req: Request) throws -> EventLoopFuture<View> {
        return Acronym.query(on: req.db).all().flatMap { acronyms in
            let context = HomeContext(title: "Home", acronyms: acronyms.isEmpty ? nil: acronyms)
            return req.view.render("index", context)
        }
       
    }
    
    func acronymHandler(req: Request) throws -> EventLoopFuture<View> {
        return Acronym.find(req.parameters.get("acronymID"), on: req.db).unwrap(or: Abort(.notFound)).flatMap { acronym in
            acronym.$user.get(on: req.db).flatMap({ user in
                let context = AcronymContext(title: "Acronym", acronym: acronym, user: user)
                return req.view.render("acronym", context)
            })
        }
    }
}

struct HomeContext: Codable {
    var title: String
    var acronyms: [Acronym]?
}

struct AcronymContext: Codable {
    var title: String
    var acronym: Acronym
    var user: User
}
