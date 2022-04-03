//
//  File.swift
//  
//
//  Created by Jakub Mazur on 07/02/2022.
//

import Foundation

extension JSON {
	/// Object element representation
	public struct ObjectElement {
		/// Object element key
		public let key: String
		/// Object element value
		public let value: Value & JSONStringRepresentable
	}
}

extension JSON.ObjectElement: JSONElement, JSONStringRepresentable {
	/**
	 Return the string representation of this object
	 - returns: string representation of this object with a "key":value
	 */
	public func stringRepresentation() -> String { return "\"\(self.key)\":\(self.value.stringRepresentation())" }
}
