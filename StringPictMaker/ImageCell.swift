//
//  ImageCell.swift
//  StringPictMaker
//
//  Created by 杉山智之 on 2017/11/18.
//  Copyright © 2017年 杉山智之. All rights reserved.
//

import Foundation
import UIKit

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
        imageLabel = UIImageView(frame: CGRect(x:20, y:40, width:frame.width-40, height:frame.height-60))
        self.contentView.addSubview(imageLabel!)
        // UILabelを生成
        textLabel = UILabel(frame: CGRect(x:20, y:20, width:frame.width-40, height:20))
        textLabel?.text = "nil"
        textLabel?.textAlignment = NSTextAlignment.center
        textLabel?.backgroundColor = UIColor.white
        textLabel?.layer.shadowOffset = CGSize(width: 1.0, height: 3.0)
        textLabel?.layer.shadowOpacity = 5.0
        self.contentView.addSubview(textLabel!)
        // UIButtonを生成
        editButton = UIButton()
        editButton?.frame = CGRect(x: 20, y: frame.height-40, width: frame.width-40, height: 20)
        editButton?.setTitle("EDIT", for: .normal)
        editButton?.setTitleColor(UIColor.blue, for: .normal)
        self.contentView.addSubview(editButton!)
        
     }
    
    
}
