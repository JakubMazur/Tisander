//
//  File.swift
//  
//
//  Created by Jakub Mazur on 07/02/2022.
//

import Foundation

extension Bool: Value, JSONStringRepresentable {
	/**
	 Return the string representation of this boolean
	 - returns: either 'true' or 'false'
	 */
	public func stringRepresentation() -> String { return self ? "true" : "false" }
}
