//
//  File.swift
//  
//
//  Created by Jakub Mazur on 07/02/2022.
//

import Foundation

extension Int: Value, JSONStringRepresentable {
	/**
	 Return the string representation of this integer
	 - returns: integer as string
	 */
	public func stringRepresentation() -> String { return String(self) }
}
