//
//  File.swift
//  
//
//  Created by Jakub Mazur on 07/02/2022.
//

import Foundation

extension Double: Value, JSONStringRepresentable {
	/**
	 Return the string representation of this double precision floating point number
	 - returns: double as string. Uses default system number formatter
	 */
	public func stringRepresentation() -> String { return String(self) }
}
