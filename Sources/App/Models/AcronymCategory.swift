//
//  File.swift
//  
//
//  Created by Mongy on 30/06/2023.
//

import Fluent
import Vapor

final class AcronymCategory: Model {
    static let schema = "acronym-category-pivot"
    
    @ID(key: .id)
    var id: UUID?

    @Parent(key: "acronymID")
    var acronym: Acronym
    
    @Parent(key: "categoryID")
    var category: Category

    init() {}

    init(
        id: UUID? = nil,
        acronym: Acronym,
        category: Category
    )  throws {
        self.id = id
        self.$acronym.id = try acronym.requireID()
        self.$category.id = try category.requireID()
    }
}

extension AcronymCategory: Content {}
