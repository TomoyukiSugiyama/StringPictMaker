//
//  FontPickerViewController.swift
//  StringPictMaker
//
//  Created by 杉山智之 on 2017/12/05.
//  Copyright © 2017年 杉山智之. All rights reserved.
//

import Foundation
import UIKit

/// TODO:
/// ＊レイアウト
/// ＊cansel,doneボタンの中身を実装
/// ＊横画面にした時のレイアウト
/// ＊
/// ＊
/// ＊

/// Future:
/// ＊文字の影を調整する機能の追加
/// ＊
/// ＊
/// ＊

/// 選択されたフォントをImageEditorに送付するデリゲートメソッド
protocol FontPickerDelegate {
	// デリゲートメソッド定義
	func selectedFont(state:UILabel)
}
/// 文字列のフォントを変更するためのピッカービューコントローラ
class FontPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
	// UIPickerViewの変数の宣言
	var picker: UIPickerView!
	// delegate
	//var testLabel: UILabel!
	var delegate : FontPickerDelegate!
	// 表示するデータの配列
	var dataArray = ["Font 1","Font 2","Font 3","Font 4","Font 5",
					 "Font 6","Font 7","Font 8","Font 9","Font 10"]
	var fontArray = ["Zapfino","DBLCDTempBlack","MarkerFelt-Thin","Academy Engraved LET","Al Nile",
					 "American Typewriter","Apple Color Emoji","Apple SD Gothic Neo","Arial","Arial Hebrew"]
	/// ピッカービューを生成
	override func viewDidLoad() {
		super.viewDidLoad()
		print("FontPickerViewController - viewDidLoad - frame:",self.view.frame)
		self.view.frame = CGRect(x:0,y:self.view.frame.height - 150 - 40,width:self.view.frame.width,height:150)
		print("FontPickerViewController - viewDidLoad - frame:",self.view.frame)
		self.view.backgroundColor = UIColor.black
		//self.view.frame = CGRect(x:0,y:self.view.frame.height - 100 - 4,width:self.view.frame.width,height:100.0)
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
		print("FontPickerViewController")
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
//	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
	func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
		// 表示するラベルを生成する
		let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
		label.textAlignment = .center
		label.text = dataArray[row]
		label.font = UIFont(name: fontArray[row],size:16)
		return label
	}
	// 選択された時
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		// 表示するラベルを生成する
		let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
		label.textAlignment = .center
		label.text = dataArray[row]
		label.font = UIFont(name: fontArray[row],size:16)
		self.delegate?.selectedFont(state: label)
		print("value : \(dataArray[row])")
	}
	// toolbarのキャンセルを選択
	@objc func cancel(){
		print("FontPickerViewController - cancel")
		hideContentController(content: self)
	}
	// toolbarの完了を選択
	@objc func done(){
		print("FontPickerViewController - done")
		hideContentController(content: self)
	}
	/// コンテナをスーパービューに追加
	func displayContentController(content:UIViewController, container:UIView){
		print("FontPickerViewController - displayContentController")
		addChildViewController(content)
		content.view.frame = container.bounds
		container.addSubview(content.view)
		content.didMove(toParentViewController: self)
	}
	/// コンテナをスーパービューから削除
	func hideContentController(content:UIViewController){
		print("FontPickerViewController - hideContentController")
		content.willMove(toParentViewController: self)
		content.view.removeFromSuperview()
		content.removeFromParentViewController()
	}
}
