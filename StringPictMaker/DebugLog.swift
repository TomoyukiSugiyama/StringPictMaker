//
//  DebugLog.swift
//  StringPictMaker
//
//  Created by 杉山智之 on 2018/02/05.
//  Copyright © 2018年 杉山智之. All rights reserved.
//

import Foundation
class Log {
	class func d(_ item:Any...,file: String = #file,line: Int = #line,function: String = #function,separator: String = ":") {
		#if DEBUG
			var path = NSString(string: file).lastPathComponent
			path.removeSubrange(path.range(of: ".swift")!)
			let pattern = "(\\(.*?\\))"
			let replace = ""
			var replaceString:String!
			replaceString = function.replacingOccurrences(of: pattern, with: replace, options: NSString.CompareOptions.regularExpression, range: nil)
			print(path,replaceString,line,item.description,separator:separator)
		#endif
	}
	
}
