//
//  ColorPickerViewController.swift
//  StringPictMaker
//
//  Created by 杉山智之 on 2017/12/10.
//  Copyright © 2017年 杉山智之. All rights reserved.
//

import Foundation
import UIKit

/// TODO:
/// ＊
/// ＊
/// ＊

/// Future:
/// ＊
/// ＊
/// ＊

/// 選択された色をImageEditorに送付するデリゲートメソッド
protocol ColorPickerDelegate {
	// デリゲートメソッド定義
	func selectedColor(state:UIColor)
}
/// 文字列の色を変更するためのピッカービューコントローラ
class ColorPickerViewController: UIViewController{
	// UIToolVarを生成
	var toolbar:UIToolbar!
	// UIPickerViewの変数の宣言
	var picker: UIPickerView!
	// delegate
	var delegate : ColorPickerDelegate!
	// カラーピッカービューを生成
	var pickerView:ColorPickerView!
	var selectButton:UIButton!
	var margine:CGFloat!
	var toolBarHeight:CGFloat!
	var pickerViewSize:CGFloat!
	var defaultColor:UIColor!
	func setColor(color:UIColor){
		defaultColor = color
	}
	/// ピッカービューを生成
	override func viewDidLoad() {
		super.viewDidLoad()
		print("ImageEditor - ColorPickerViewController - viewDidLoad - self.view.frame1:",self.view.frame)
		margine = 20
		toolBarHeight = 35
		if(UIScreen.main.bounds.height > UIScreen.main.bounds.width){
			pickerViewSize = UIScreen.main.bounds.width - margine*2 - toolBarHeight
		}else{
			pickerViewSize = UIScreen.main.bounds.height - margine*2 - toolBarHeight
		}
		self.view.frame = CGRect(x:0,y:0,width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height)
		self.view.backgroundColor = UIColor.black
		print("ImageEditor - ColorPickerViewController - viewDidLoad - self.view.frame2:",self.view.frame)
		let frame = CGRect(x:UIScreen.main.bounds.width/2 - pickerViewSize/2,y:UIScreen.main.bounds.height/2 + toolBarHeight/2 - pickerViewSize/2,width:pickerViewSize,height:pickerViewSize)
		pickerView = ColorPickerView(frame:frame)
		pickerView.setNeedsDisplay()
		self.view.addSubview(pickerView)
		// toolbarを追加
		toolbar = UIToolbar(frame: CGRect(x:0, y:0, width:self.view.frame.width, height:35))
		//let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
		let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
		//toolbar.setItems([cancelItem, doneItem], animated: true)
		toolbar.setItems([cancelItem], animated: true)
		self.view.addSubview(toolbar)
		selectButton = UIButton()
		selectButton.frame = CGRect(x:0, y:0, width:40, height:40)
		selectButton.center = pickerView.center
		selectButton.backgroundColor = UIColor.clear
		selectButton.addTarget(self, action: #selector(changeColor), for: UIControlEvents.touchUpInside)
		self.view.addSubview(selectButton)
		pickerView.selectedColor = defaultColor
		print("ColorPickerViewController")
	}
	// 色変更ボタンが押された時、ImageEditorにUIColorを送付
	@objc func changeColor(_ sender: ColorPickerView)
	{
		print("test")
		print("ColorPickerViewController - changeColor - sender.selectedColor:",pickerView.selectedColor)
		delegate?.selectedColor(state: pickerView.selectedColor)
		done()
	}
	// toolbarのキャンセルを選択
	@objc func cancel(){
		print("ColorPickerViewController - cancel")
		hideContentController(content: self)
	}
	// toolbarの完了を選択
	@objc func done(){
		print("ColorPickerViewController - done")
		hideContentController(content: self)
	}
	/// コンテナをスーパービューに追加
	func displayContentController(content:UIViewController, container:UIView){
		print("ColorPickerViewController - displayContentController")
		addChildViewController(content)
		content.view.frame = container.bounds
		container.addSubview(content.view)
		content.didMove(toParentViewController: self)
	}
	/// コンテナをスーパービューから削除
	func hideContentController(content:UIViewController){
		print("ColorPickerViewController - hideContentController")
		content.willMove(toParentViewController: self)
		content.view.removeFromSuperview()
		content.removeFromParentViewController()
	}
	// 画面回転時に呼び出される
	override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval){
		self.view.frame = CGRect(x:0,y:0,width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height)
		self.toolbar.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:35)
		pickerView.frame = CGRect(x:UIScreen.main.bounds.width/2 - pickerViewSize/2,y:UIScreen.main.bounds.height/2 + toolBarHeight/2 - pickerViewSize/2,width:pickerViewSize,height:pickerViewSize)
		selectButton.center = pickerView.center
//		self.picker.frame = CGRect(x: 0, y: 35, width: self.view.frame.width, height: self.view.frame.height - 35)
	}
}
