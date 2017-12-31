//
//  LayerCell.swift
//  StringPictMaker
//
//  Created by 杉山智之 on 2017/12/11.
//  Copyright © 2017年 杉山智之. All rights reserved.
//

import Foundation
import UIKit

///TODO:
/// ＊セルに表示するビューの変更
/// ＊レイアウト
/// ＊
/// ＊
/// ＊

/// Future:
/// ＊
/// ＊
/// ＊
/// LayerPickerControllerに追加するセルのデザインを作成
class LayerCell: UITableViewCell {
	var imageLabel: UIImageView?
	var layerLabel : UILabel?
	var editButton: UIButton?
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
	}	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.contentView.backgroundColor = UIColor.gray
		// Initialization code
		imageLabel = UIImageView()
		imageLabel?.backgroundColor = UIColor.white
		self.contentView.addSubview(imageLabel!)
		// UILabelを生成
		layerLabel = UILabel()
		layerLabel?.text = "Layer"
		layerLabel?.textAlignment = NSTextAlignment.center
		//layerLabel?.backgroundColor = UIColor.gray
		self.contentView.addSubview(layerLabel!)
		print("LayerCell - init - ImageLabel:",imageLabel as Any)
		// UIButtonを生成
		editButton = UIButton()
		editButton?.setImage(UIImage(named: "layeron_icon"), for: .normal)
		editButton?.setTitleColor(UIColor.blue, for: .normal)
		self.contentView.addSubview(editButton!)
	}
	override func prepareForReuse() {
		super.prepareForReuse()
	}
	override func layoutSubviews() {
		let margine:CGFloat = 5
		let labelWidth:CGFloat = 80
		let labelHeight:CGFloat = 20
		var imageWidth:CGFloat!
		var imageHeight:CGFloat!
		let buttonWidth:CGFloat = 30
		let buttonHeight:CGFloat = 20
		imageWidth = self.contentView.frame.width - margine*2
		if(UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height){
			imageHeight = imageWidth * UIScreen.main.bounds.size.height / UIScreen.main.bounds.size.width
		}else{
			imageHeight = imageWidth * UIScreen.main.bounds.size.width / UIScreen.main.bounds.size.height
		}
		super.layoutSubviews()
		layerLabel?.frame = CGRect(x: 10, y  : 0, width: labelWidth, height: labelHeight)
		imageLabel?.frame = CGRect(x: margine, y: labelHeight, width: imageWidth, height: imageHeight)
		print("LayerCell - layoutSubviews - ImageLabel:",imageLabel as Any)
		editButton?.frame = CGRect(x: 10, y: labelHeight + imageHeight, width: buttonWidth, height: buttonHeight)
	}
}
