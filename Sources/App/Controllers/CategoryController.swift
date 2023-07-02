//
//  File.swift
//  
//
//  Created by Mongy on 30/06/2023.
//

import Foundation

import Vapor

struct CategoryController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let categoryRoutes = routes.grouped("api", "categories")
        categoryRoutes.get(use: getCategory(req:))
        categoryRoutes.post(use: createCategory(req:))
        categoryRoutes.get(":categroyID", use: getCategoryById(req:))
        categoryRoutes.get(":categroyID", "acronyms", use: getAcronyms(req:))
    }
    
    func getCategory(req: Request) throws -> EventLoopFuture<[Category]> {
        Category.query(on: req.db).all()
    }
    
    func createCategory(req: Request) throws -> EventLoopFuture<Category> {
        let cat = try req.content.decode(Category.self)
        return cat.save(on: req.db).map { _  in
            return cat
        }
    }
    
    func getCategoryById(req: Request) throws ->  EventLoopFuture<Category> {
        return Category.find(req.parameters.get("categroyID"), on: req.db).unwrap(or: Abort(.notFound))
    }
    
    func getAcronyms(req: Request) throws ->  EventLoopFuture<[Acronym]> {
        Category.find(req.parameters.get("categroyID"), on: req.db)
            .unwrap(or: Abort(.notFound)).flatMap { cat in
                cat.$acronyms.get(on: req.db)
        }
    }
}
