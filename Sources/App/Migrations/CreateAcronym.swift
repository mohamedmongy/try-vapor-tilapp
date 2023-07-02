//
//  File.swift
//  
//
//  Created by Mongy on 29/06/2023.
//

import Fluent

struct CreateAcronymCategoryPivot: Migration {
    func prepare(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema("acronym-category-pivot")
            .id()
            .field("acronymID", .uuid, .required, .references("acronyms", "id", onDelete: .cascade))
            .field("categoryID", .uuid, .required, .references("categories", "id", onDelete: .cascade))
            .create()
    }
    
    func revert(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema("acronym-category-pivot")
            .delete()
    }
    
    
}

struct CreateAcronym: Migration {
    func prepare(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema("acronyms")
            .id()
            .field("short", .string, .required)
            .field("long", .string, .required)
            .field("userID", .uuid, .required, .references("users", "id"))
            .create()
    }
    
    func revert(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema("acronyms")
            .delete()
    }
    
    
}

struct CreateUser: Migration {
    func prepare(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema("users")
            .id()
            .field("name", .string, .required)
            .field("username", .string, .required)
            .create()
    }
    
    func revert(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema("users")
            .delete()
    }
    
    
}

struct CreateCategory: Migration {
    func prepare(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema("categories")
            .id()
            .field("name", .string, .required)
            .create()
    }
    
    func revert(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema("categories")
            .delete()
    }
    
    
}
