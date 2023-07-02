import Fluent
import Vapor

final class Acronym: Model {
    static let schema = "todos"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "short")
    var short: String
    
    @Field(key: "long")
    var long: String

    init() { }

    init(id: UUID? = nil,
         short: String,
         long: String
    ) {
        self.id = id
        self.short = short
        self.long = long
    }
}

extension Acronym: Content { }
