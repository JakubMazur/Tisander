//
//  File.swift
//  
//
//  Created by Jakub Mazur on 07/02/2022.
//

import Foundation

/**
 Errors when parsing JSON string
 */
public enum SerializationError: String, Error {
	/// Unterminated object. Opening curley brace without a close
	case unterminatedObject
	/// Unterminated Array. Opening square brackets without a close
	case unterminatedArray
	/// Unterminated string. Opening double quote without matching ending one
	case unterminatedString
	/// Invalid JSON
	case invalidJSON
	/// Invalid array element. One of the elements in the array was not valid
	case invalidArrayElement
	/// Number missing it's exponent part
	case invalidNumberMissingExponent
	/// Number was missing it's fractional element
	case invalidNumberMissingFractionalElement
	/// Reached the end of the file unexpectedly
	case unexpectedEndOfFile
}
