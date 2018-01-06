//
//  PenPickerViewController.swift
//  StringPictMaker
//
//  Created by 杉山智之 on 2018/01/06.
//  Copyright © 2018年 杉山智之. All rights reserved.
//

import UIKit
/// TODO:
/// ＊
/// ＊
/// ＊

/// Future:
/// ＊レイヤー毎の透過度変更バー追加
/// ＊
/// ＊
/// ＊

/// ペンのサイズを変更するためのピッカービューコントローラ
class PenPickerViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
		print("PenPickerViewController - viewDidLoad")
		self.view.frame = CGRect(x:0,y:self.view.frame.height - 150 - 40,width:self.view.frame.width,height:150)
		self.view.backgroundColor = UIColor.black
		// スライダーの作成
		let slider = UISlider()
		slider.sizeToFit()
		slider.center = self.view.center
		
		// スライダーの値が変更された時に呼び出されるメソッドを設定
		slider.addTarget(self, action: #selector(onChange), for: .valueChanged)
		
		// スライダーを画面に追加
		self.view.addSubview(slider)
    }
	@objc func onChange(_ sender: UISlider) {
		// スライダーの値が変更された時の処理
		print(sender.value)
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
