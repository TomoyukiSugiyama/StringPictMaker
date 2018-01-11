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

    override func viewDidLoad() {
        super.viewDidLoad()
		super.viewDidLoad()
		self.view.frame = CGRect(x:0,y:UIScreen.main.bounds.height-150-40,width:UIScreen.main.bounds.width,height:150)
		self.view.backgroundColor = UIColor.black

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
