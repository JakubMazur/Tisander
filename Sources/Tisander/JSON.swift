//
//  File.swift
//  
//
//  Created by Jakub Mazur on 07/02/2022.
//

import Foundation

/**
 Create a representation of the JSON document that is parsed. Does not use Apple's `JSONSerialization` class and therefore keeps the order of the keys in the set as it's enountered.
 */
open class JSON {
	/**
	 Return a JSON structure value
	 
	 - parameter string: String representation of JSON
	 - returns: An array of `ArrayElement`s or `ObjectElemet`s
	 - throws: `SerializationError`
	 */
	public static func parse(string: String) throws -> Value {
		
		let json = JSON()
		
		var index = string.startIndex
		
		// Run space parser to remove beginning spaces
		_ = json.spaceParser(string, index: &index)
		
		if let arrayElements = try json.arrayParser(string, index: &index) {
			return arrayElements
		} else if let objectElements = try json.objectParser(string, index: &index) {
			return objectElements
		}
		
		throw SerializationError.invalidJSON
	}
}
