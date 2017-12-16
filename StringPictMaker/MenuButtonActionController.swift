//
//  MenuButtonActionController.swift
//  StringPictMaker
//
//  Created by 杉山智之 on 2017/11/21.
//  Copyright © 2017年 杉山智之. All rights reserved.
//

import Foundation
import UIKit

/// 選択されたサブメニューの番号をImageEditorに送付するデリゲートメソッド
protocol SubMenuDelegate {
	// デリゲートメソッド定義
	func selectedSubMenu(state:DataManager.MenuTypes)
}
/// TODO:
/// メインメニューボタンを移動した時、サブメニューを閉じる
/// サブメニューが画面外に出る

/// CustomButton Class (Menu/Sub Menu Button)
/// ImageEditorでメイン/サブメニューボタンが押された時の、アクションを定義
class MenuButtonActionController: UIButton {
	var isMoveing: Bool = false
	var position: CGPoint!
	let buttonSize:CGFloat = 80
	let toolBarSize:CGFloat = 40
	/// began to touch menu butoon
	///
	/// - Parameters:
	///   - touches: touches
	///   - event: event
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		position = self.frame.origin
	}
	/// touches moved
	///
	/// - Parameters:
	///   - touches: touches
	///   - event: event
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesMoved(touches, with: event)
		isMoveing = true
		let touchEvent = touches.first!
		// ドラッグ前の座標
		let preDx = touchEvent.previousLocation(in: superview).x
		let preDy = touchEvent.previousLocation(in: superview).y
		// ドラッグ後の座標
		let newDx = touchEvent.location(in: superview).x
		let newDy = touchEvent.location(in: superview).y
		
		// ドラッグしたx座標の移動距離
		let dx = newDx - preDx
		// ドラッグしたy座標の移動距離
		let dy = newDy - preDy
		// 画像のフレーム
		var viewFrame: CGRect = self.frame
		// 移動分を反映させる
		/// TODO フレームの外に出ないように設定
		//print("MenuButtonActionController - bounds",self.window?.screen.bounds)
		if(dx > 0){
			if(viewFrame.origin.x + dx >= (self.window?.screen.bounds.width)! - buttonSize){
				
			}else{
				viewFrame.origin.x += dx
			}
		}else{
			if(viewFrame.origin.x + dx <= (self.window?.screen.bounds.origin.x)!){
				
			}else{
				viewFrame.origin.x += dx
			}
		}
		if(dy > 0){
			if(viewFrame.origin.y + dy >= (self.window?.screen.bounds.height)! - buttonSize - toolBarSize){
				
			}else{
				viewFrame.origin.y += dy
			}
		}else{
			if(viewFrame.origin.y + dy <= (self.window?.screen.bounds.origin.y)!){
				
			}else{
				viewFrame.origin.y += dy
			}
		}
		self.frame = viewFrame
	}
	/// touches ended
	///
	/// - Parameters:
	///   - touches: touches
	///   - event: event
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
		isMoveing = false
		if position == self.frame.origin {
			 self.sendActions(for: .touchUpOutside)
		}
	}
	/// メインメニューボタンイベント(Down)
	///
	/// - Parameter sender: 選択されたメインメニューボタン
	@objc  func onDownMainButton(sender: UIButton) {
		// 背景を黒色に設定
		//self.backgroundColor = UIColor.white
		UIView.animate(withDuration: 0.06,
			// アニメーション中の処理
			animations: { () -> Void in
						// 縮小用アフィン行列を生成する
						sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
		}){ (Bool) -> Void in
		}
	}
	var delegate: SubMenuDelegate?
	// subボタン(飛び出すボタン)を生成
	var subButton_1: UIButton = UIButton()
	var subButton_2: UIButton = UIButton()
	var subButton_3: UIButton = UIButton()
	var subButton_4: UIButton = UIButton()
	var subButton_5: UIButton = UIButton()
	var colors: NSMutableArray!
	/// サブメニューボタンの座標を返すメソッド
	///
	/// - Parameters:
	///   - angle: 度
	///   - radius: ラジアン
	/// - Returns: サブメニューボタンの座標
	func getPosition(angle: CGFloat, radius: CGFloat) -> CGPoint {
		// 度からラジアンに変換.
		let radian = angle * CGFloat(Double.pi) / 180.0
		// x座標を計算.
		let x_position:CGFloat = self.layer.position.x + radius * cos(radian)
		// y座標を計算.
		//let y_position = mainPosition.y + radius * sin(radian)
		let y_position = self.layer.position.y + radius * sin(radian)
		
		let position = CGPoint(x: x_position, y: y_position)
		
		return position
	}
	/// メインメニューボタンイベント(Up)
	///
	/// - Parameter sender: 選択されたメインメニューボタン
	@objc  func onUpMainButton(sender: UIButton) {
		// subボタンを配列に格納
		let buttons = [subButton_1, subButton_2, subButton_3, subButton_4, subButton_5]
		// subボタン用の　UIColorを配列に格納
		colors = [UIColor.green, UIColor.yellow, UIColor.cyan, UIColor.magenta, UIColor.purple] as NSMutableArray
		// mainボタンからの距離(半径)
		//let radius: CGFloat = 150
		let radius: CGFloat = 140
		buttons[0].setTitle("GPS", for: .normal)
		buttons[0].setImage(UIImage(named: "gps_icon"), for: .normal)
		buttons[0].setTitleColor(UIColor.black, for: .normal)
		buttons[1].setTitle("COLOR", for: .normal)
		buttons[1].setImage(UIImage(named: "palet_icon"), for: .normal)
		buttons[1].setTitleColor(UIColor.black, for: .normal)
		buttons[2].setTitle("PICT", for: .normal)
		buttons[2].setImage(UIImage(named: "save_icon"), for: .normal)
		buttons[2].setTitleColor(UIColor.black, for: .normal)
		buttons[3].setTitle("TIME", for: .normal)
		buttons[3].setImage(UIImage(named: "time_icon"), for: .normal)
		buttons[3].setTitleColor(UIColor.black, for: .normal)
		buttons[4].setTitle("PEN", for: .normal)
		buttons[4].setImage(UIImage(named: "pen_icon"), for: .normal)
		buttons[4].setTitleColor(UIColor.black, for: .normal)
		// subボタンに各種設定
		//		for var i = 0; i < buttons.count; i++ {
		for i in 0 ..< buttons.count {
			//buttons[i].frame = CGRect(x: 0, y: 0, width: 60, height: 60)
			buttons[i].frame = CGRect(x: 0, y: 0, width: 60, height: 60)
			//buttons[i].layer.cornerRadius = 30.0
			buttons[i].layer.cornerRadius = 30.0
			//buttons[i].backgroundColor = colors[i] as? UIColor
			//buttons[i].center = self.center
			buttons[i].center = CGPoint(x: self.layer.position.x, y: self.layer.position.y)
			buttons[i].addTarget(self, action: #selector(onClickSubButtons), for: UIControlEvents.touchUpInside)
			buttons[i].backgroundColor = UIColor.blue
			buttons[i].layer.shadowOffset = CGSize(width: 1.0, height: 3.0)
			buttons[i].layer.shadowOpacity = 5.0
			buttons[i].tag = i+1
			// subボタンをviewに追加
			self.superview?.addSubview(buttons[i])
		}
		// メインメニューボタンのサイズを0.4倍にした後、元のサイズに戻す
		UIView.animate(withDuration: 0.06,
			// アニメーション中の処理
			animations: { () -> Void in
						// 縮小用アフィン行列を作成
						sender.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
						// 拡大用アフィン行列を作成
						sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
		}){ (Bool) -> Void in
		}
		// サブメニューボタンを設定した位置に移動
		UIView.animate(withDuration: 0.7,
					   delay: 0.0,
					   // バネを設定
						usingSpringWithDamping: 0.5,
						// バネの弾性力
						initialSpringVelocity: 1.5,
						options: UIViewAnimationOptions.curveEaseIn,
			// アニメーション中の処理
			animations: { () -> Void in
						// サブメニューボタンに座標を設定
						self.subButton_1.layer.position = self.getPosition(angle: -90, radius: radius)
						self.subButton_2.layer.position = self.getPosition(angle: -30, radius: radius)
						self.subButton_3.layer.position = self.getPosition(angle: -60, radius: radius)
						self.subButton_4.layer.position = self.getPosition(angle: -120, radius: radius)
						self.subButton_5.layer.position = self.getPosition(angle: -150, radius: radius)
		}) { (Bool) -> Void in
		}		
	}
	/// サブメニューボタンイベント　選択されたサブメニューの番号を送信
	///
	/// - Parameter sender: 選択されたボタン
	@objc func onClickSubButtons(sender: UIButton) {
		// 背景色をsubボタンの色に設定
		switch(sender.tag) {
		case 1:
			// デリゲートメソッドを呼出
			self.delegate?.selectedSubMenu(state: DataManager.MenuTypes.typeGPS)
			fadeAnimation()
		case 2:
			// デリゲートメソッドを呼出(処理をデリゲートインスタンスに委譲)
			self.delegate?.selectedSubMenu(state: DataManager.MenuTypes.typeColor)
			fadeAnimation()
		case 3:
			// デリゲートメソッドを呼出(処理をデリゲートインスタンスに委譲)
			self.delegate?.selectedSubMenu(state: DataManager.MenuTypes.typeImage)
			fadeAnimation()
		case 4:
			// デリゲートメソッドを呼出(処理をデリゲートインスタンスに委譲)
			self.delegate?.selectedSubMenu(state: DataManager.MenuTypes.typePen)
			fadeAnimation()
		case 5:
			// デリゲートメソッドを呼出(処理をデリゲートインスタンスに委譲)
			self.delegate?.selectedSubMenu(state: DataManager.MenuTypes.typeTime)
			fadeAnimation()
		default: break
		}
	}
	/// サブメニューボタンをフェードアウト
	func fadeAnimation(){
		UIView.animate(withDuration: 0.1,
					   // アニメーション中の処理.
			animations: { () -> Void in
						// subボタンに座標を設定.
						self.subButton_1.layer.position = CGPoint(x: self.layer.position.x, y: self.layer.position.y)
						// subボタンに座標を設定.
						self.subButton_2.layer.position = CGPoint(x: self.layer.position.x, y: self.layer.position.y)
						// subボタンに座標を設定.
						self.subButton_3.layer.position = CGPoint(x: self.layer.position.x, y: self.layer.position.y)
						// subボタンに座標を設定.
						self.subButton_4.layer.position = CGPoint(x: self.layer.position.x, y: self.layer.position.y)
						// subボタンに座標を設定.
						self.subButton_5.layer.position = CGPoint(x: self.layer.position.x, y: self.layer.position.y)
		}
			, completion: { (Bool) -> Void in
						self.subButton_1.removeFromSuperview()
						self.subButton_2.removeFromSuperview()
						self.subButton_3.removeFromSuperview()
						self.subButton_4.removeFromSuperview()
						self.subButton_5.removeFromSuperview()
		}
		)
	}
}
