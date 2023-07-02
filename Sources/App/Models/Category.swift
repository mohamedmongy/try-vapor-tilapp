//
//  File.swift
//  
//
//  Created by Mongy on 30/06/2023.
//

import Fluent
import Vapor

final class Category: Model {
    static let schema = "categories"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Siblings(through: AcronymCategory.self, from: \.$category, to: \.$acronym)
    var acronyms: [Acronym]
    
    init() { }

    init(
        id: UUID? = nil,
        name: String
    ) {
        self.id = id
        self.name = name
    }
}

extension Category: Content {}
