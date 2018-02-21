//
//  Header.swift
//  StringPictMaker
//
//  Created by 杉山智之 on 2018/02/21.
//  Copyright © 2018年 杉山智之. All rights reserved.
//

import Foundation

/*enum TagIDs : Int{
	case GPS = 1
	case CITY = 2
	case FREE = 3
	case ITEM_MASK = 0xFF
	case Scale = 0x100
	case Rect = 0x200
	case TAG_MASK = 0x3FF
}*/
let TagGPS = 0x1
let TagCity = 0x2
let TagFree = 0x3
let TagItemMask = 0xFF
let TagScale = 0x100
let TagRect = 0x200
let TagMaskAll = 0x3FF

// メニューを管理
enum MenuTypes : Int{
	case SETTING = 1
	case PEN
	case TEXT
	case COLOR
	case DUMMY
}

let LayerPen = 2
let LayerText = 3


