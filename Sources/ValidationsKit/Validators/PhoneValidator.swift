//
//  PhoneValidator.swift
//  ValidationKit
//
//  Created by Alex Legent on 12/02/2019.
//

import Foundation

extension Validator where T == String {

    /// Validates whether a `String` is a valid international phone number.
    public static var phone: Validator<T> {
        return PhoneValidator().validator()
    }
}

/// Validates whether a `String` is a valid phone number.
private struct PhoneValidator: ValidatorType {

    /// See `ValidatorType`.
    let readable = "phone"

    /// See `ValidatorType`.
    func validate(_ phone: String) throws {
        guard
            let range = phone.range(of: "^\\+[0-9]{1,15}$", options: [.regularExpression, .caseInsensitive]),
            range.lowerBound == phone.startIndex && range.upperBound == phone.endIndex
        else {
            throw BasicValidationError("isn't a valid phone number")
        }
    }

}
