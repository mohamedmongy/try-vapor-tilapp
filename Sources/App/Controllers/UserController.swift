//
//  File.swift
//  
//
//  Created by Mongy on 30/06/2023.
//

import Vapor

struct UserController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let userRoutes = routes.grouped("api", "users")
        userRoutes.get(use: getUsers(req:))
        userRoutes.post(use: createUser(req:))
        userRoutes.get(":userID", use: getUserById(req:))
        userRoutes.get(":userID", "acronyms", use: getUserAcronyms(req:))
    }
    
    func getUsers(req: Request) throws -> EventLoopFuture<[User]> {
        User.query(on: req.db).all()
    }
    
    func createUser(req: Request) throws -> EventLoopFuture<User> {
        let user = try req.content.decode(User.self)
        return user.save(on: req.db).map { _  in
            return user
        }
    }
    
    func getUserById(req: Request) throws ->  EventLoopFuture<User> {
        return User.find(req.parameters.get("userID"), on: req.db).unwrap(or: Abort(.notFound))
    }
    
    func getUserAcronyms(req: Request) throws ->  EventLoopFuture<[Acronym]> {
        return User.find(req.parameters.get("userID"), on: req.db).unwrap(or: Abort(.notFound)).flatMap { user in
            return user.$acronyms.get(on: req.db)
        }
    }
}
