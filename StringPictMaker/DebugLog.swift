//
//  DebugLog.swift
//  StringPictMaker
//
//  Created by 杉山智之 on 2018/02/05.
//  Copyright © 2018年 杉山智之. All rights reserved.
//

import Foundation
class Log {
	class func d(item:Any...,file: String = #file,line: Int = #line,function: String = #function,separator: String = " ") {
		#if DEBUG
			let path = NSString(string: file)
			print(path.lastPathComponent,function,line,item.description,separator:separator)
		#endif
	}
	
}
