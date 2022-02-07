//
//  File.swift
//  
//
//  Created by Jakub Mazur on 07/02/2022.
//

import Foundation

/// Any value for JSON, can be Object, array, number, string, boolean or null
public protocol Value {
	/**
	 Subscript for getting values from keys
	 - parameter key: key for value
	 - returns: value for key. Also returns nil if it is not a key/value structure
	 */
	subscript(key: String) -> Value? { get }
	/**
	 Subscript for retrieving items from an array at index
	 - parameter index: index for value
	 - returns: value at index
	 */
	subscript(index: Int) -> Value? { get }
}

public extension Value {
	/**
	 Subscript for getting values from keys
	 - parameter key: key for value
	 - returns: value for key. Also returns nil if it is not a key/value structure
	 */
	subscript(key: String) -> Value? {
		get {
			return (self as? [JSON.ObjectElement])?.reduce(nil, { (result, element) -> Value? in
				guard result == nil else { return result }
				
				return element.key == key ? element.value : nil
			})
		}
	}
	/**
	 Subscript for getting values from indexes
	 - parameter index: index to retrieve
	 - returns: value if index is valid and the subject is an array of `JSON.ArrayElement`s
	 */
	subscript(index: Int) -> Value? {
		get {
			guard let elementArray = self as? [JSON.ArrayElement],
				index >= 0,
				index <  elementArray.count
				else { return nil }
			
			return ((elementArray as [Any])[index] as? JSON.ArrayElement)?.value
		}
	}
	
	/// Get all keys in the key/value set, returns nil if the array is not keys/values.
	var keys: [String]? {
		return (self as? [JSON.ObjectElement])?.compactMap { $0.key }
	}
	
	/// Get all values in the current structure
	var values: [Value]? {
		return (self as? [JSON.ArrayElement])?.map { $0.value } ?? (self as? [JSON.ObjectElement])?.map { $0.value }
	}
}

extension Value {
	/**
	 Convert a JSON object or array into a string
	 - returns: String representation of the entire object
	 */
	public func toJSONString() -> String {
		if type(of: self) is [JSON.ObjectElement].Type {
			return (self as? [JSON.ObjectElement])?.stringRepresentation() ?? ""
		} else if type(of: self) is [JSON.ArrayElement].Type {
			return (self as? [JSON.ArrayElement])?.stringRepresentation() ?? ""
		}
		
		return ""
	}
}
