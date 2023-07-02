//
//  File.swift
//  
//
//  Created by Mongy on 29/06/2023.
//

import Vapor

struct AcronymController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let acronumsRoutes = routes.grouped("api", "acronyms")
        acronumsRoutes.get(use: getAcronyms(req:))
        acronumsRoutes.post(use: createAcronyms(req:))
        //http://127.0.0.1:8080/api/acronyms/:acronymID
        //http://127.0.0.1:8080/api/acronyms/980339FA-8F90-4B31-9DE3-A3A57C94C422
        acronumsRoutes.get(":acronymID", use: getAcronymById(req:))
        acronumsRoutes.put(":acronymID", use: updateAcronymById(req:))
        acronumsRoutes.delete(":acronymID", use: deleteAcronymById(req:))
        acronumsRoutes.get(":acronymID", "user", use: getUser(req:))
        acronumsRoutes.get(":acronymID", "categories", use: getCategories(req:))
        acronumsRoutes.get(":acronymID", "categories", ":categoryID", use: createAcronymCategoryLink(req:))
//        acronumsRoutes.get("search", use: search(req:))
    }
    
    func getAcronyms(req: Request) throws -> EventLoopFuture<[Acronym]> {
        Acronym.query(on: req.db).all()
    }
    
    func createAcronyms(req: Request) throws -> EventLoopFuture<Acronym> {
        let data = try req.content.decode(CreateAcronymData.self)
        let acronym = Acronym(short: data.short, long: data.long, userID: data.userID)
        return acronym.save(on: req.db).map { _  in
            return acronym
        }
    }
    
    func getAcronymById(req: Request) throws ->  EventLoopFuture<Acronym> {
        return Acronym.find(req.parameters.get("acronymID"), on: req.db).unwrap(or: Abort(.notFound))
    }
    
    func deleteAcronymById(req: Request) throws ->  EventLoopFuture<HTTPStatus> {
        Acronym.find(req.parameters.get("acronymID"), on: req.db)
            .unwrap(or: Abort(.notFound)).flatMap { ac in
            ac.delete(on: req.db).transform(to: .noContent)
        }
    }
    
    func updateAcronymById(req: Request) throws ->  EventLoopFuture<Acronym> {
        let updateAcronym = try req.content.decode(Acronym.self)
        return Acronym.find(req.parameters.get("acronymID"), on: req.db).unwrap(or: Abort(.notFound)).flatMap { acr in
            acr.short = updateAcronym.short
            acr.long = updateAcronym.long
            return acr.save(on: req.db).map {
                acr
            }
        }
    }
    
    func getUser(req: Request) throws ->  EventLoopFuture<User> {
        Acronym.find(req.parameters.get("acronymID"), on: req.db)
            .unwrap(or: Abort(.notFound)).flatMap { ac in
                ac.$user.get(on: req.db)
        }
    }
    
    func getCategories(req: Request) throws ->  EventLoopFuture<[Category]> {
        Acronym.find(req.parameters.get("acronymID"), on: req.db)
            .unwrap(or: Abort(.notFound)).flatMap { ac in
                ac.$categories.get(on: req.db)
        }
    }
    
    func createAcronymCategoryLink(req: Request) throws ->  EventLoopFuture<HTTPStatus> {
        let acrQuery = Acronym.find(req.parameters.get("acronymID"), on: req.db)
            .unwrap(or: Abort(.notFound))
                    
       let catQuery = Category.find(req.parameters.get("categoryID"), on: req.db)
                        .unwrap(or: Abort(.notFound))
        
        return acrQuery.and(catQuery).flatMap { acronym, category in
            acronym.$categories.attach(category, on: req.db).transform(to: .created)
        }
    }
    
//    func search(req: Request) throws ->  EventLoopFuture<[Acronym]> {
//        guard let searchTerm = req.query[String.self, at: "term"] else {
//            throw Abort(.badRequest)
//        }
//        return Acronym.query(on: req.db).group(.or) { or in
//            or.filter(\.$short == searchTerm)
////            or.filter(\.$long == searchTerm)
//        }.all()
//    }
    
}

struct CreateAcronymData: Content {
    var short: String
    var long: String
    var userID: UUID
}
