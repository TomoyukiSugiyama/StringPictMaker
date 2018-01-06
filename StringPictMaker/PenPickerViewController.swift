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
/// ＊
/// ＊
/// ＊

/// 選択されたフォントをImageEditorに送付するデリゲートメソッド
protocol PenPickerDelegate {
	// デリゲートメソッド定義
	func selectedPen(size:CGFloat)
}
/// ペンのサイズを変更するためのピッカービューコントローラ
class PenPickerViewController: UIViewController{
	// UIToolVarを生成
	var toolbar:UIToolbar!
	var penSize:CGFloat!
	var refButton:UIButton!
	var delegate : PenPickerDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
		print("PenPickerViewController - viewDidLoad")
		penSize = 10.0
		self.view.frame = CGRect(x:0,y:self.view.frame.height - 150 - 40,width:self.view.frame.width,height:150)
		//self.view.backgroundColor = UIColor.white
		refButton = UIButton()
		//refButton.frame = CGRect(x:self.view.frame.width/4,y:50,width:penSize,height:penSize)
		refButton.frame = CGRect(x:0,y:0,width:penSize,height:penSize)
		refButton.center = CGPoint(x:self.view.frame.width/4,y:self.view.frame.height / 2)
		refButton.backgroundColor = UIColor.black
		refButton.layer.cornerRadius = penSize/2
		self.view.addSubview(refButton)
		// スライダーの作成
		let slider = UISlider()
		slider.frame = CGRect(x:self.view.frame.width/4,y:self.view.frame.height * 3/4,width:self.view.frame.width/2,height:10)
		//slider.frame.size.width = self.view.frame.width/2
		slider.sizeToFit()
		//slider.backgroundColor = UIColor.blue
		//slider.center = self.view.center
		// 最小値・最大値の設定
		slider.minimumValue = 2.0
		slider.maximumValue = 50.0
		// デフォルト値の設定
		slider.setValue(Float(penSize), animated: true)
		// 色の変更
		slider.tintColor = UIColor.red
		// スライダーの値が変更された時に呼び出されるメソッドを設定
		slider.addTarget(self, action: #selector(onChange), for: .valueChanged)
		// スライダーを画面に追加
		self.view.addSubview(slider)
		//self.view.addSubview(button)
		// toolbarを追加
		toolbar = UIToolbar()
		toolbar.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:35)
		let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
		let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
		toolbar.setItems([cancelItem, doneItem], animated: true)
		self.view.addSubview(toolbar)

    }
	@objc func onChange(_ sender: UISlider) {
		// スライダーの値が変更された時の処理
		print(sender.value)
		penSize = CGFloat(sender.value)
		refButton.frame = CGRect(x:0,y:0,width:penSize,height:penSize)
		refButton.center = CGPoint(x:self.view.frame.width/4,y:self.view.frame.height / 2)
		refButton.layer.cornerRadius = penSize/2
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	// toolbarのキャンセルを選択
	@objc func cancel(){
		print("PenPickerViewController - cancel")
		hideContentController(content: self)
	}
	// toolbarの完了を選択
	@objc func done(){
		print("FontPickerViewController - done")
//		if(selectedLabel == nil){
			// 表示するラベルを生成する
//			selectedLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
//			selectedLabel.textAlignment = .center
//			selectedLabel.text = dataArray[0]
//			selectedLabel.font = UIFont(name: fontArray[0],size:16)
			
//		}
		self.delegate?.selectedPen(size: penSize)
		hideContentController(content: self)
	}
	/// コンテナをスーパービューから削除
	func hideContentController(content:UIViewController){
		print("FontPickerViewController - hideContentController")
		content.willMove(toParentViewController: self)
		content.view.removeFromSuperview()
		content.removeFromParentViewController()
	}

}
