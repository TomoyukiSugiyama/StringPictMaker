//
//  ImageCell.swift
//  StringPictMaker
//
//  Created by 杉山智之 on 2017/11/18.
//  Copyright © 2017年 杉山智之. All rights reserved.
//

import Foundation
import UIKit

/// TODO:
/// ＊レイアウト
/// ＊バックグラウンドを画像に変更
/// ＊
/// ＊
/// ＊

/// Future:
/// ＊
/// ＊
/// ＊

/// ImageListControllerに追加するセルのデザインを作成
class ImageCell: UICollectionViewCell {
	var imageLabel: UIImageView?
	var textLabel : UILabel?
	var editButton: UIButton?	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
	}
	/// ImageListControllerのセルをカスタマイズ
	///
	/// - Parameter frame: セルのフレーム
	override init(frame: CGRect) {
		super.init(frame: frame)
		let margine:CGFloat = 5
		let labelHeight:CGFloat = 20
		let buttonHeight:CGFloat = 30
		let imageWidth:CGFloat = frame.width - margine*2
		let imageHeight:CGFloat!
		if(UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height){
			imageHeight = imageWidth * UIScreen.main.bounds.size.height / UIScreen.main.bounds.size.width
		}else{
			imageHeight = imageWidth * UIScreen.main.bounds.size.width / UIScreen.main.bounds.size.height
		}
		//imageLabel = UIImageView(frame: CGRect(x:20, y:40, width:frame.width-40, height:frame.height-60))
		imageLabel = UIImageView(frame: CGRect(x:margine, y:margine+labelHeight, width:frame.width-margine*2, height:imageHeight))
		self.contentView.addSubview(imageLabel!)
		// UILabelを生成
		textLabel = UILabel(frame: CGRect(x:margine, y:margine, width:frame.width-margine*2, height:labelHeight))
		textLabel?.text = "nil"
		textLabel?.textAlignment = NSTextAlignment.center
		textLabel?.backgroundColor = UIColor.lightGray
		self.contentView.addSubview(textLabel!)
		// UIButtonを生成
		editButton = UIButton()
		editButton?.frame = CGRect(x: margine, y: margine + labelHeight + imageHeight + margine, width: frame.width-margine*2, height: buttonHeight)
		editButton?.setTitle("EDIT", for: .highlighted)
		editButton?.setTitleColor(UIColor.white, for: .normal)
		editButton?.backgroundColor = UIColor.gray
		editButton?.layer.cornerRadius = buttonHeight / 2
		editButton?.layer.borderColor = UIColor.gray.cgColor
		editButton?.layer.borderWidth = 2
		self.contentView.addSubview(editButton!)		
	 }
}
