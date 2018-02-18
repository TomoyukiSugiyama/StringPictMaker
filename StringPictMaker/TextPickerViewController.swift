//
//  TextPickerViewController.swift
//  StringPictMaker
//
//  Created by 杉山智之 on 2018/01/09.
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
protocol TextPickerDelegate {
	// デリゲートメソッド定義
	func selectedText(state:Int)
}
/// テキストの種類を変更するためのピッカービューコントローラ
class TextPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
	// UIToolVarを生成
	var toolbar:UIToolbar!
	// UIPickerViewの生成
	var picker: UIPickerView!
	var delegate : TextPickerDelegate!
	// 表示するデータの配列
	var dataArray = ["フリーテキスト","GPS(都道府県)","GPS(市町村)"]
	var selectedLabelNum:Int!
	func setTextPicker(num: Int){
		selectedLabelNum = num
	}
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.frame = CGRect(x:0,y:UIScreen.main.bounds.height-150-40,width:UIScreen.main.bounds.width,height:150)
		self.view.backgroundColor = UIColor.black
		// toolbarを追加
		toolbar = UIToolbar()
		toolbar.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:35)
		let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
		let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
		toolbar.setItems([cancelItem, doneItem], animated: true)
		self.view.addSubview(toolbar)
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
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return dataArray.count
	}
	func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
		// 表示するラベルを生成する
		let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
		label.textAlignment = .center
		label.text = dataArray[row]
		return label
	}
	// 選択された時
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		// 表示するラベルを生成する
/*		selectedLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
		selectedLabel.textAlignment = .center
		selectedLabel.text = dataArray[row]
		selectedLabel.font = UIFont(name: fontArray[row],size:16)*/
		selectedLabelNum = row
		Log.d("value",dataArray[row])
	}
	// toolbarのキャンセルを選択
	@objc func cancel(){
		Log.d()
		hideContentController(content: self)
	}
	// toolbarの完了を選択
	@objc func done(){
		Log.d()
		/*if(selectedLabel == nil){
			// 表示するラベルを生成する
			selectedLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
			selectedLabel.textAlignment = .center
			selectedLabel.text = dataArray[0]
			selectedLabel.font = UIFont(name: fontArray[0],size:16)
			
		}
		self.delegate?.selectedFont(state: selectedLabel)*/
		self.delegate?.selectedText(state: selectedLabelNum)
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
		self.view.frame = CGRect(x:0,y:UIScreen.main.bounds.height-150-40,width:UIScreen.main.bounds.width,height:150)
		toolbar.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:35)
	}
}
