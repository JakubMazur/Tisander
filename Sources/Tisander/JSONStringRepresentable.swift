//
//  JSON.swift
//  Tisander
//
//  Created by Mike Bignell on 22/06/2018.
//  Copyright © 2018 Mike Bignell. All rights reserved.
//

import Foundation

/// Element of JSON structure, can be an array element or a key/value
internal protocol JSONElement: Value {}

/// Protocol to provide a string representation of the JSON structure
internal protocol JSONStringRepresentable {
    /**
     String representation of the JSON
     - returns: string with the json sub-value
     */
    func stringRepresentation() -> String
}

extension Array: Value, JSONStringRepresentable where Array.Element: JSONElement {
    /**
     Return the string representation of this JSON structure
     - returns: string representation of this JSON structure
     */
    func stringRepresentation() -> String {
        if Array.Element.self == JSON.ObjectElement.self {
            return "{\( (self as? [JSON.ObjectElement])?.map { $0.stringRepresentation() }.joined(separator: ",") ?? "" )}"
        } else if Array.Element.self == JSON.ArrayElement.self {
            return "[\( (self as? [JSON.ArrayElement])?.map { $0.stringRepresentation() }.joined(separator: ",") ?? "" )]"
        }
        
        return ""
    }
}
