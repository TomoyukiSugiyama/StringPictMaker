//
//  Header.swift
//  StringPictMaker
//
//  Created by 杉山智之 on 2018/02/21.
//  Copyright © 2018年 杉山智之. All rights reserved.
//

import Foundation

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
//
let MenuSettingSave = 1
let MenuSettingCancel = 2
let MenuPenSize = 3
let MenuPenErase = 4
let MenuPenUndo = 5
let MenuPenRedo = 6
let MenuTextFont = 7
let MenuTextPosition = 8
let MenuTextAdd = 9
let MenuTextDelete = 10
let MenuTextColor = 11
let MenuTextEdit = 12
let MenuColor = 13
let MenuLayer = 14
//
/*enum TextType : Int{
	case FREE = 1
	case GPS
	case CITY
}*/
//
let LayerPen = 2
let LayerText = 3


