//
//  TextEditorViewController.swift
//  StringPictMaker
//
//  Created by 杉山智之 on 2018/01/11.
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

class TextEditorViewController: UIViewController {
	// UIToolVarを生成
	var toolbar:UIToolbar!
	
    override func viewDidLoad() {
        super.viewDidLoad()
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

        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	// toolbarのキャンセルを選択
	@objc func cancel(){
		print("TextPickerViewController - cancel")
		hideContentController(content: self)
	}
	// toolbarの完了を選択
	@objc func done(){
		print("TextPickerViewController - done")
		/*if(selectedLabel == nil){
		// 表示するラベルを生成する
		selectedLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
		selectedLabel.textAlignment = .center
		selectedLabel.text = dataArray[0]
		selectedLabel.font = UIFont(name: fontArray[0],size:16)
		
		}
		self.delegate?.selectedFont(state: selectedLabel)*/
		hideContentController(content: self)
	}

	/// コンテナをスーパービューに追加
	func displayContentController(content:UIViewController, container:UIView){
		print("TextPickerViewController - displayContentController")
		addChildViewController(content)
		content.view.frame = container.bounds
		container.addSubview(content.view)
		content.didMove(toParentViewController: self)
	}
	/// コンテナをスーパービューから削除
	func hideContentController(content:UIViewController){
		print("TextPickerViewController - hideContentController")
		content.willMove(toParentViewController: self)
		content.view.removeFromSuperview()
		content.removeFromParentViewController()
	}
	// 画面回転時に呼び出される
	override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval){
	}
}
