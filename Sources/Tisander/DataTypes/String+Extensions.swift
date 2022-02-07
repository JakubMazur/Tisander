//
//  File.swift
//  
//
//  Created by Jakub Mazur on 07/02/2022.
//

import Foundation

extension String: Value, JSONStringRepresentable {
	/**
	 Return the string
	 - returns: string in quotes
	 */
	func stringRepresentation() -> String { return "\"\(self)\"" }
}
