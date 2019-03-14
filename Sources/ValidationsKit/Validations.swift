//
//  Validations.swift
//  ValidationKit
//
//  Created by Alex Legent on 11/02/2019.
//

import Foundation

/// Holds zero or more validations for a `Validatable` model.
public struct Validations<Model> where Model: Validatable {

    /// Internal `Validator`s storage.
    private var storage: [Validator<Model>]

    /// Create an empty `Validations` struct.
    public init(_ model: Model.Type) {
        storage = []
    }

    /// Adds a new `Validation` at the supplied key path.
    /// - parameter keyPath: `KeyPath` to validatable property.
    /// - parameter path: Readable path. Will be displayed when showing errors.
    /// - parameter validator: `Validator` to run on this property.
    public mutating func add<T>(_ keyPath: KeyPath<Model, T>, at path: [String], _ validator: Validator<T>) {
        add(keyPath, at: path, validator.readable, validator.validate)
    }

    /// Adds a custom validation at the supplied key path and readable.
    /// - parameter keyPath: `KeyPath` to validatable property.
    /// - parameter path: Readable path. Will be displayed when showing errors.
    /// - parameter readable: Readable message. Will be displayed when showing errors.
    /// - parameter custom: Validation closure.
    public mutating func add<T>(_ keyPath: KeyPath<Model, T>, at path: [String], _ readable: String = "", _ custom: @escaping (T) throws -> Void) {
        let validator = Validator<Model>(readable) { model in
            do { try custom(model[keyPath: keyPath]) }
            catch {
                guard var err = error as? ValidationError else { throw error }
                err.path = path
                throw err
            }
        }

        storage.append(validator)
    }

    /// Runs the `Validation`s on an instance of `Model`.
    func run(on model: Model) throws {
        for validation in storage {
            try validation.validate(model)
        }
    }

}