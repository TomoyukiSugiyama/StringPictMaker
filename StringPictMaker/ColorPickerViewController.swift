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
	var firstColor:UIColor!
	var secondColor:UIColor!
	var thirdColor:UIColor!
	var firstColorButton:UIButton!
	var secondColorButton:UIButton!
	var thirdColorButton:UIButton!
	
	var buttonSize:CGFloat!
	var firstPosX:CGFloat!
	var firstPosY:CGFloat!
	var secondPosX:CGFloat!
	var secondPosY:CGFloat!
	var thirdPosX:CGFloat!
	var thirdPosY:CGFloat!
	var frame:CGRect!

	func setColor(color:UIColor,first:UIColor,second:UIColor,third:UIColor){
		defaultColor = color
		firstColor = first
		secondColor = second
		thirdColor = third
	}
	/// ピッカービューを生成
	override func viewDidLoad() {
		super.viewDidLoad()
		Log.d("self.view.frame",self.view.frame)
		margine = 20
		toolBarHeight = 35
		if(UIScreen.main.bounds.height > UIScreen.main.bounds.width){
			pickerViewSize = UIScreen.main.bounds.width - margine*2 - toolBarHeight
			frame = CGRect(x:UIScreen.main.bounds.width/2 - pickerViewSize/2,y:UIScreen.main.bounds.height/2 + toolBarHeight/2 - pickerViewSize/2,width:pickerViewSize,height:pickerViewSize)
			buttonSize = 60
			firstPosX = UIScreen.main.bounds.width/4 - buttonSize/2
			firstPosY = UIScreen.main.bounds.height/2 + pickerViewSize/2 + 50
			secondPosX = UIScreen.main.bounds.width / 2 - buttonSize/2
			secondPosY = firstPosY
			thirdPosX = UIScreen.main.bounds.width * 3 / 4 - buttonSize/2
			thirdPosY = firstPosY
		}else{
			pickerViewSize = UIScreen.main.bounds.height - margine*2 - toolBarHeight
			frame = CGRect(x:UIScreen.main.bounds.width/4 - pickerViewSize/2,y:UIScreen.main.bounds.height/2 + toolBarHeight/2 - pickerViewSize/2,width:pickerViewSize,height:pickerViewSize)
			buttonSize = 60
			let width = UIScreen.main.bounds.width - frame.center.x - pickerViewSize/2
			firstPosX = width + width / 4 - buttonSize/2
			firstPosY = UIScreen.main.bounds.height/2 - buttonSize/2
			secondPosX = width + width / 2 - buttonSize/2
			secondPosY = firstPosY
			thirdPosX = width + width * 3 / 4 - buttonSize/2
			thirdPosY = firstPosY
		}
		self.view.frame = CGRect(x:0,y:0,width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height)
		self.view.backgroundColor = UIColor.black
		Log.d("self.view.frame",self.view.frame)
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
		selectButton.tag = 0
		selectButton.addTarget(self, action: #selector(changeColor), for: UIControlEvents.touchUpInside)
		self.view.addSubview(selectButton)
		pickerView.selectedColor = defaultColor
		Log.d()
		// 1番目に選択した色
		firstColorButton = UIButton()
		firstColorButton.frame = CGRect(x:firstPosX, y:firstPosY, width:buttonSize, height:buttonSize)
		firstColorButton.backgroundColor = firstColor
		firstColorButton.layer.cornerRadius = buttonSize/2
		firstColorButton.tag = 1
		firstColorButton.addTarget(self, action: #selector(changeColor), for: UIControlEvents.touchUpInside)
		self.view.addSubview(firstColorButton)
		// 2番目に選択した色
		secondColorButton = UIButton()
		secondColorButton.frame = CGRect(x:secondPosX, y:secondPosY, width:buttonSize, height:buttonSize)
		secondColorButton.layer.cornerRadius = buttonSize/2
		secondColorButton.backgroundColor = secondColor
		secondColorButton.tag = 2
		secondColorButton.addTarget(self, action: #selector(changeColor), for: UIControlEvents.touchUpInside)
		self.view.addSubview(secondColorButton)
		// 3番目に選択した色
		thirdColorButton = UIButton()
		thirdColorButton.frame = CGRect(x:thirdPosX, y:thirdPosY, width:buttonSize, height:buttonSize)
		thirdColorButton.backgroundColor = thirdColor
		thirdColorButton.layer.cornerRadius = buttonSize/2
		thirdColorButton.tag = 3
		thirdColorButton.addTarget(self, action: #selector(changeColor), for: UIControlEvents.touchUpInside)
		self.view.addSubview(thirdColorButton)
	}
	// 色変更ボタンが押された時、ImageEditorにUIColorを送付
	@objc func changeColor(_ sender: ColorPickerView)
	{
		Log.d("sender.selectedColor:",pickerView.selectedColor)
		switch sender.tag{
		case 0:
			delegate?.selectedColor(state: pickerView.selectedColor)
		case 1:
			delegate?.selectedColor(state: firstColor)
		case 2:
			delegate?.selectedColor(state: secondColor)
		case 3:
			delegate?.selectedColor(state: thirdColor)
		default:
			fatalError("ColorPickerView - changeColor - error: \(sender.tag)")
			break
		}
		done()
	}
	// toolbarのキャンセルを選択
	@objc func cancel(){
		Log.d()
		hideContentController(content: self)
	}
	// toolbarの完了を選択
	@objc func done(){
		Log.d()
		hideContentController(content: self)
	}
	/// コンテナをスーパービューに追加
	func displayContentController(content:UIViewController, container:UIView){
		Log.d()
		addChildViewController(content)
		content.view.frame = container.bounds
		container.addSubview(content.view)
		content.didMove(toParentViewController: self)
	}
	/// コンテナをスーパービューから削除
	func hideContentController(content:UIViewController){
		Log.d()
		content.willMove(toParentViewController: self)
		content.view.removeFromSuperview()
		content.removeFromParentViewController()
	}
	// 画面回転時に呼び出される
	override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval){
		self.view.frame = CGRect(x:0,y:0,width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height)
		self.toolbar.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:35)
		/*pickerView.frame = CGRect(x:UIScreen.main.bounds.width/2 - pickerViewSize/2,y:UIScreen.main.bounds.height/2 + toolBarHeight/2 - pickerViewSize/2,width:pickerViewSize,height:pickerViewSize)*/
		if(UIScreen.main.bounds.height > UIScreen.main.bounds.width){
			pickerViewSize = UIScreen.main.bounds.width - margine*2 - toolBarHeight
			frame = CGRect(x:UIScreen.main.bounds.width/2 - pickerViewSize/2,y:UIScreen.main.bounds.height/2 + toolBarHeight/2 - pickerViewSize/2,width:pickerViewSize,height:pickerViewSize)
			buttonSize = 60
			firstPosX = UIScreen.main.bounds.width/4 - buttonSize/2
			firstPosY = UIScreen.main.bounds.height/2 + pickerViewSize/2 + 50
			secondPosX = UIScreen.main.bounds.width / 2 - buttonSize/2
			secondPosY = firstPosY
			thirdPosX = UIScreen.main.bounds.width * 3 / 4 - buttonSize/2
			thirdPosY = firstPosY
		}else{
			pickerViewSize = UIScreen.main.bounds.height - margine*2 - toolBarHeight
			frame = CGRect(x:UIScreen.main.bounds.width/4 - pickerViewSize/2,y:UIScreen.main.bounds.height/2 + toolBarHeight/2 - pickerViewSize/2,width:pickerViewSize,height:pickerViewSize)
			buttonSize = 60
			let width = UIScreen.main.bounds.width - frame.center.x - pickerViewSize/2
			firstPosX = width + width / 4 - buttonSize/2
			firstPosY = UIScreen.main.bounds.height/2 - buttonSize/2
			secondPosX = width + width / 2 - buttonSize/2
			secondPosY = firstPosY
			thirdPosX = width + width * 3 / 4 - buttonSize/2
			thirdPosY = firstPosY
		}
		pickerView.frame = frame
		firstColorButton.frame = CGRect(x:firstPosX, y:firstPosY, width:buttonSize, height:buttonSize)
		secondColorButton.frame = CGRect(x:secondPosX, y:secondPosY, width:buttonSize, height:buttonSize)
		thirdColorButton.frame = CGRect(x:thirdPosX, y:thirdPosY, width:buttonSize, height:buttonSize)
		selectButton.center = pickerView.center
//		self.picker.frame = CGRect(x: 0, y: 35, width: self.view.frame.width, height: self.view.frame.height - 35)
	}
}
