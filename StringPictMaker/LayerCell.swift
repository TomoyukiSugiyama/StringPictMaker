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
        // Initialization code
//        imageLabel = UIImageView(frame: CGRect(x:5, y:30, width:frame.width-20, height:frame.width-20))
        imageLabel = UIImageView()
        self.contentView.addSubview(imageLabel!)
        // UILabelを生成
        layerLabel = UILabel()
//        textLabel_ = UILabel(frame: CGRect(x:0, y:0, width:frame.width-20, height:20))
        layerLabel?.text = "Layer"
        layerLabel?.textAlignment = NSTextAlignment.center
        layerLabel?.backgroundColor = UIColor.white
//        textLabel_?.layer.shadowOffset = CGSize(width: 1.0, height: 3.0)
//        textLabel_?.layer.shadowOpacity = 5.0
        self.contentView.addSubview(layerLabel!)
        // UIButtonを生成
        editButton = UIButton()
        //editButton?.frame = CGRect(x: frame.width-10, y: frame.width, width: 20, height: 20)
        editButton?.setTitle("EYE", for: .normal)
        editButton?.setTitleColor(UIColor.blue, for: .normal)
        self.contentView.addSubview(editButton!)
    }
    
  
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layerLabel?.frame = CGRect(x: 0, y  : 0, width: 100, height: 20)
        imageLabel?.frame = CGRect(x: 0, y: 20, width: 150, height: 150)
        editButton?.frame = CGRect(x: 100, y: 0, width: 100, height: 20)
 //       print("LayerCell - init - frame:",frame,"tableView.frame:",imageLabel?.frame,"editButton.frame:",editButton?.frame);
    }
    /*override func layoutSubviews() {
        super.layoutSubviews()
    }*/
    /// LayerPickerControllerのセルをカスタマイズ
    ///
    /// - Parameter frame: セルのフレーム
//    override init(frame: CGRect) {
//        super.init(frame: frame)
  
//    }
}
