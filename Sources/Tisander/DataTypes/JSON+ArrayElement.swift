//
//  File.swift
//  
//
//  Created by Jakub Mazur on 07/02/2022.
//

import Foundation

extension JSON {
	/// Array element representation
	struct ArrayElement {
		/// Array element value
		let value: Value & JSONStringRepresentable
	}
}

extension JSON.ArrayElement: JSONElement, JSONStringRepresentable {
	/**
	 Return the string representation of this array element
	 - returns: string representation of this array element
	 */
	func stringRepresentation() -> String { return "\(self.value.stringRepresentation())" }
}

