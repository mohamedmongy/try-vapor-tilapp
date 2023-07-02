import NIOSSL
import Fluent
import FluentPostgresDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.logger.logLevel = .debug
    app.databases.use(.postgres(configuration: SQLPostgresConfiguration(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor-user",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor-password",
        database: Environment.get("DATABASE_NAME") ?? "vapor-db",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)
    
    app.migrations.add(CreateUser())
    app.migrations.add(CreateAcronym())
    app.migrations.add(CreateCategory())
    app.migrations.add(CreateAcronymCategoryPivot())
    app.views.use(.leaf)

    // register routes
    try routes(app)
    try app.autoMigrate().wait()
}
