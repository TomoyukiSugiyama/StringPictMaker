//
//  ColorPickerViewController.swift
//  StringPictMaker
//
//  Created by 杉山智之 on 2017/12/10.
//  Copyright © 2017年 杉山智之. All rights reserved.
//

import Foundation
import UIKit
/// 選択された色をImageEditorに送付するデリゲートメソッド
protocol ColorPickerDelegate {
	// デリゲートメソッド定義
	func selectedColor(state:UIColor)
}
/// 文字列の色を変更するためのピッカービューコントローラ
class ColorPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
	var delegate : ColorPickerDelegate!
	// UIPickerViewの変数の宣言
	var picker: UIPickerView!
   // 表示するデータの配列
	var dataArray = ["Black","White","Blue","Yellow","Red",
					 "Green","Gray","Orange","Purple","Brown"]
	var colorArray = [UIColor.black,UIColor.white,UIColor.blue,UIColor.yellow,UIColor.red,
					  UIColor.green,UIColor.gray,UIColor.orange,UIColor.purple,UIColor.brown]
	/// ピッカービューを生成
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.frame = CGRect(x:0,y:self.view.frame.height - 150 - 40,width:self.view.frame.width,height:150)
		print("ColorPickerViewController - viewDidLoad - frame:",self.view.frame)
		self.view.backgroundColor = UIColor.black
		// toolbarを追加
		let toolbar = UIToolbar(frame: CGRect(x:0, y:0, width:self.view.frame.width, height:35))
		let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
		let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
		toolbar.setItems([cancelItem, doneItem], animated: true)
		self.view.addSubview(toolbar)
		// PickerViewを追加
		// UIPickerViewのインスタンスを生成
		picker = UIPickerView()
		//位置とサイズを設定
		// picker.frame = CGRect(x: 0, y: self.view.frame.height - 100 - 40, width: self.view.frame.width, height: 100.0)
		picker.frame = CGRect(x: 0, y: 35, width: self.view.frame.width, height: self.view.frame.height - 35)
		picker.backgroundColor = UIColor.lightGray
		// delegateの設定
		picker.delegate = self
		// dataSourceの設定
		picker.dataSource = self
		self.view.addSubview(picker)
		print("ColorPickerViewController")
	}
	// PickerViewの個数
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	// 表示する行数。配列の個数を返している
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return dataArray.count
	}
	// 表示する値
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return dataArray[row]
	}
	// 選択された時
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		delegate?.selectedColor(state: colorArray[row])
		print("value : \(dataArray[row])")
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
}
