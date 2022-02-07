//
//  File.swift
//  
//
//  Created by Jakub Mazur on 07/02/2022.
//

import Foundation

extension JSON {
	/// Representation for null value
	class NULL { }
}

extension JSON.NULL: Value, JSONStringRepresentable {
	/**
	 Return the string representation of this null
	 - returns: "null"
	 */
	func stringRepresentation() -> String { return "null" }
}
