//
//  File.swift
//  
//
//  Created by Jakub Mazur on 07/02/2022.
//

import Foundation

extension JSON {
	/// Array element representation
	public struct ArrayElement {
		/// Array element value
		public let value: Value & JSONStringRepresentable
	}
}

extension JSON.ArrayElement: JSONElement, JSONStringRepresentable {
	/**
	 Return the string representation of this array element
	 - returns: string representation of this array element
	 */
	public func stringRepresentation() -> String { return "\(self.value.stringRepresentation())" }
}

