//
//  File.swift
//  
//
//  Created by Jakub Mazur on 07/02/2022.
//

import Foundation

extension JSON {
	/**
	 Space parser
	 
	 Uses `isSpace` function
	 
	 - parameter jsonString: String representation of JSON
	 - parameter index: Current index in json document
	 - returns: spaces captured or nil if there was no spaces
	 */
	@discardableResult
	internal func spaceParser(_ jsonString: String, index: inout String.Index) -> String? {
		guard index != jsonString.endIndex, isSpace(jsonString[index]) else { return nil }
		
		let startingIndex = index
		
		while index != jsonString.endIndex {
			guard isSpace(jsonString[index]) else { break }
			
			index = jsonString.index(after: index)
		}
		
		return String(jsonString[startingIndex ..< index])
	}
	
	
	/**
	 Function to parse object
	 
	 Starts by checking for a {
	 Next checks for the key of the object
	 finally the value of the key
	 Uses - KeyParser,SpaceParser,valueParser and endofsetParser
	 Finally checks for the end of the main Object with a }
	 
	 - parameter jsonString: String representation of JSON
	 - parameter index: Current index in json document
	 - returns: An array of `ObjectElemet`s
	 - throws: `SerializationError.unterminatedObject`
	 */
	internal func objectParser(_ jsonString: String, index: inout String.Index) throws -> [ObjectElement]? {
		guard index != jsonString.endIndex, jsonString[index] == "{" else { return nil }
		
		var parsedDict = [ObjectElement]()
		index = jsonString.index(after: index)
		
		while true {
			if let key = try keyParser(jsonString,index: &index) {
				_ = spaceParser(jsonString, index: &index)
				
				guard let _ = colonParser(jsonString, index: &index) else { return nil }
				
				if let value = try valueParser(jsonString, index: &index) {
					parsedDict.append(ObjectElement(key: key, value: value))
				}
				
				_ = spaceParser(jsonString, index: &index)
				
				if let _ = endOfSetParser(jsonString, index: &index) {
					return parsedDict
				}
			} else if index == jsonString.endIndex {
				throw SerializationError.unterminatedObject
			} else if jsonString[index] == "}" || isSpace(jsonString[index]) {
				_ = spaceParser(jsonString, index: &index)
				
				guard let _ = endOfSetParser(jsonString, index: &index) else {
					throw SerializationError.unterminatedObject
				}
				
				return parsedDict
			} else {
				break
			}
		}
		
		return nil
	}
	
	/**
	 Function to parser an array
	 
	 Starts by checking for a [
	 After which it is passed to an elemParser store the returned value in another array called parsed array
	 Uses elemParser,SpaceParser,commaParser,endOfArrayParser
	 Finally checks for a ] to mark the end of the array
	 
	 - parameter jsonString: String representation of JSON
	 - parameter index: Current index in json document
	 - returns: an array of elements
	 - throws: `SerializationError`
	 */
	internal func arrayParser(_ jsonString: String, index: inout String.Index) throws -> [ArrayElement]? {
		guard jsonString[index] == "[" else { return nil }
		
		var parsedArray = [ArrayElement]()
		index = jsonString.index(after: index)
		
		while true {
			if let returnedElem = try elemParser(jsonString, index: &index) {
				parsedArray.append(ArrayElement(value: returnedElem))
				_ = spaceParser(jsonString, index: &index)
				
				if let _ = commaParser(jsonString, index: &index) {
					
				} else if let _ = endOfArrayParser(jsonString, index: &index) {
					return parsedArray
				} else {
					return nil
				}
			} else if index == jsonString.endIndex {
				throw SerializationError.unterminatedArray
			} else if jsonString[index] == "]" || isSpace(jsonString[index]) {
				_ = spaceParser(jsonString, index: &index)
				
				guard let _ = endOfArrayParser(jsonString, index: &index) else {
					throw SerializationError.unterminatedArray
				}
				
				return parsedArray
			} else {
				throw SerializationError.invalidArrayElement
			}
		}
	}
}

extension JSON {
	
	/**
	 Function to check key value in an object
	 
	 Uses SpaceParser and StringParser
	 
	 - parameter jsonString: String representation of JSON
	 - parameter index: Current index in json document
	 - returns: Key string or nil
	 - throws: `SerializationError`
	 */
	private func keyParser(_ jsonString: String, index: inout String.Index) throws -> String? {
		_ = spaceParser(jsonString, index: &index)
		
		return try stringParser(jsonString, index: &index) ?? nil
	}
	
	/**
	 Function to check for a colon
	 
	 - parameter jsonString: String representation of JSON
	 - parameter index: Current index in json document
	 - returns: Colon or null
	 */
	@discardableResult
	private func colonParser(_ jsonString: String, index: inout String.Index) -> String? {
		guard index != jsonString.endIndex, jsonString[index] == ":" else { return nil }
		
		index = jsonString.index(after: index)
		
		return ":"
	}
	
	/**
	 Function to check value in an object
	 
	 SpaceParser to remove spaces
	 pass it to the elemParser
	 stores the returned element in a variable called value
	 after which the string is then passed to the space and comma parser
	 
	 - parameter jsonString: String representation of JSON
	 - parameter index: Current index in json document
	 - returns: a JSON value
	 - throws: `SerializationError`
	 */
	private func valueParser(_ jsonString:String, index: inout String.Index) throws -> (Value & JSONStringRepresentable)? {
		_ = spaceParser(jsonString, index: &index)
		
		guard let value = try elemParser(jsonString, index: &index) else { return nil }
		
		_ = spaceParser(jsonString, index: &index)
		_ = commaParser(jsonString, index: &index)
		
		return value
	}
	
	/**
	 Function to check end of object
	 
	 Checks for a }
	 
	 - parameter jsonString: String representation of JSON
	 - parameter index: Current index in json document
	 - returns: a closing curley brace
	 */
	@discardableResult
	private func endOfSetParser(_ jsonString:String, index: inout String.Index) -> Bool? {
		guard jsonString[index] == "}" else { return nil }
		
		index = jsonString.index(after: index)
		
		return true
	}
	
	/**
	 Parsing elements in Array or value in a key/value pair
	 
	 Uses StringParser,numberParser,arrayParser,objectParser and nullParser
	 
	 - parameter jsonString: String representation of JSON
	 - parameter index: Current index in json document
	 - returns: element
	 - throws: `SerializationError`
	 */
	private func elemParser(_ jsonString:String, index: inout String.Index) throws -> (Value & JSONStringRepresentable)? {
		guard index != jsonString.endIndex else { throw SerializationError.unexpectedEndOfFile }
		_ = spaceParser(jsonString, index: &index)
		
		if let value = try stringParser(jsonString, index: &index) {
			return value
		} else if let value = try numberParser(jsonString, index: &index) {
			return value
		} else if let value = booleanParser(jsonString, index: &index) {
			return value
		} else if let value = try arrayParser(jsonString, index: &index) {
			return value
		} else if let value = try objectParser(jsonString, index: &index) {
			return value
		} else if let value = nullParser(jsonString, index: &index) {
			return value
		}
		
		return nil
	}
	
	/**
	 Function to check end of array
	 
	 - parameter jsonString: String representation of JSON
	 - parameter index: Current index in json document
	 - returns: boolean
	 */
	private func endOfArrayParser(_ jsonString:String, index: inout String.Index) -> Bool? {
		guard index != jsonString.endIndex, jsonString[index] == "]" else { return nil }
		
		index = jsonString.index(after: index)
		
		return true
	}
	
	/**
	 Function to check for a whitespace character
	 
	 - parameter character: Character to test for being a space
	 - returns: boolean
	 */
	private func isSpace(_ character: Character) -> Bool {
		return [" ", "\t", "\n"].contains(character)
	}
	
	/**
	 Function to check for a single digit
	 
	 - parameter character: Character to test if it is a digit
	 - returns: boolean for if the character is a digit
	 */
	private func isDigit(_ character: Character) -> Bool {
		return "0" ... "9" ~= character
	}
	
	/**
	 Function to consume a number
	 
	 - parameter jsonString: String representation of JSON
	 - parameter index: Current index in json document
	 - returns: spaces captured or nil if there was no spaces
	 */
	private func consumeNumber(_ jsonString: String, index: inout String.Index) {
		while isDigit(jsonString[index]) {
			guard jsonString.index(after: index) != jsonString.endIndex else { break }
			
			index = jsonString.index(after: index)
		}
	}
	
	/**
	 Number parser
	 
	 This method check all json valid numbers including exponents
	 
	 - parameter jsonString: String representation of JSON
	 - parameter index: Current index in json document
	 - returns: Number value, usually either `Double` or `Int`
	 - throws: `SerializationError`
	 */
	private func numberParser(_ jsonString: String, index: inout String.Index) throws -> (Value & JSONStringRepresentable)? {
		let startingIndex = index
		
		// When number is negative i.e. starts with "-"
		if jsonString[startingIndex] == "-" {
			guard jsonString.index(after: index) != jsonString.endIndex else { return nil }
			
			index = jsonString.index(after: index)
		}
		
		guard isDigit(jsonString[index]) else { return nil }
		
		consumeNumber(jsonString,index: &index)
		
		// For decimal points
		if jsonString[index] == "." {
			guard jsonString.index(after: index) != jsonString.endIndex else { return nil }
			
			index = jsonString.index(after: index)
			
			guard isDigit(jsonString[index]) else {
				throw SerializationError.invalidNumberMissingFractionalElement
			}
			
			consumeNumber(jsonString,index: &index)
		}
		
		// For exponents
		if String(jsonString[index]).lowercased() == "e" {
			guard jsonString.index(after: index) != jsonString.endIndex else { return nil }
			
			index = jsonString.index(after: index)
			
			if jsonString[index] == "-" || jsonString[index] == "+" {
				index = jsonString.index(after: index)
			}
			
			guard isDigit(jsonString[index]) else {
				throw SerializationError.invalidNumberMissingExponent
			}
			
			consumeNumber(jsonString,index: &index)
		}
		
		guard let double = Double(jsonString[startingIndex ..< index]) else { return nil }
		
		return (double.truncatingRemainder(dividingBy: 1.0) == 0.0 && double <= Double(Int.max)) ? Int(double) : double
	}
	
	/**
	 String parser
	 
	 - parameter jsonString: String representation of JSON
	 - parameter index: Current index in json document
	 - returns: String value that was parsed
	 - throws: `SerializationError`
	 */
	private func stringParser(_ jsonString: String, index: inout String.Index) throws -> String? {
		guard index != jsonString.endIndex, jsonString[index] == "\"" else { return nil }
		
		index = jsonString.index(after: index)
		let startingIndex = index
		
		while index != jsonString.endIndex {
			if jsonString[index] == "\\" {
				index = jsonString.index(after: index)
				
				if jsonString[index] == "\"" {
					index = jsonString.index(after: index)
				} else {
					continue
				}
			} else if jsonString[index] == "\"" {
				break
			} else {
				index = jsonString.index(after: index)
			}
		}
		
		let parsedString = String(jsonString[startingIndex ..< index])
		
		guard index != jsonString.endIndex else {
			index = startingIndex
			throw SerializationError.unterminatedString
		}
		
		index = jsonString.index(after: index)
		
		return parsedString
	}
	
	/**
	 Comma parser
	 
	 - parameter jsonString: String representation of JSON
	 - parameter index: Current index in json document
	 - returns: Comma or nil if none was found
	 */
	@discardableResult
	private func commaParser(_ jsonString: String, index: inout String.Index) -> String? {
		guard index != jsonString.endIndex, jsonString[index] == "," else { return nil }
		
		index = jsonString.index(after: index)
		return ","
	}
	
	/**
	 Boolean parser
	 
	 advances the index by 4 and checks for true or by 5 and checks for false
	 
	 - parameter jsonString: String representation of JSON
	 - parameter index: Current index in json document
	 - returns: Result of boolean parser or nil if wasn't found
	 */
	private func booleanParser(_ jsonString: String, index: inout String.Index) -> Bool? {
		let startingIndex = index
		
		if let advancedIndex = jsonString.index(index, offsetBy: 4, limitedBy: jsonString.endIndex) {
			index = advancedIndex
		} else {
			return nil
		}
		
		if jsonString[startingIndex ..< index] == "true" {
			return true
		}
		
		if index != jsonString.endIndex {
			index = jsonString.index(after: index)
			
			if jsonString[startingIndex ..< index]  == "false" {
				return false
			}
		}
		
		index = startingIndex
		
		return nil
	}
	
	/**
	 Null parser
	 
	 Advances the index by 4 and checks for null
	 
	 - parameter jsonString: String representation of JSON
	 - parameter index: Current index in json document
	 - returns: Result of boolean parser or nil if wasn't found
	 */
	private func nullParser(_ jsonString: String, index: inout String.Index) -> NULL? {
		let startingIndex = index
		
		if let advancedIndex = jsonString.index(index, offsetBy: 4, limitedBy: jsonString.endIndex) {
			index = advancedIndex
		} else {
			return nil
		}
		
		if jsonString[startingIndex ..< index].lowercased() == "null" {
			return NULL()
		}
		
		index = startingIndex
		
		return nil
	}
}
