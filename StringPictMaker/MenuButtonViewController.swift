//
//  MenuButtonViewController.swift
//  StringPictMaker
//
//  Created by 杉山智之 on 2017/11/21.
//  Copyright © 2017年 杉山智之. All rights reserved.
//

import Foundation
import UIKit
@objc protocol ViewDelegate {
    // デリゲートメソッド定義
    func selectedSubMenu(state:Int)
}

class MenuButtonViewController : UIView {
    //SampleViewDelegateのインスタンスを宣言
    weak var delegate: ViewDelegate?
    // subボタン(飛び出すボタン)を生成
    var subButton_1: UIButton = UIButton()
    var subButton_2: UIButton = UIButton()
    var subButton_3: UIButton = UIButton()
    var subButton_4: UIButton = UIButton()
    var subButton_5: UIButton = UIButton()
    
    var menuButton: UIButton!
    var colors: NSMutableArray!
    var mainPosition: CGPoint!
    
    //var viewControll: UIViewController = ViewController()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    /// メインメニューボタンイベント(Down)
    ///
    /// - Parameter sender: 選択されたメインメニューボタン
    @objc  func onDownMainButton(sender: UIButton) {
        // 背景を黒色に設定.
        //self.backgroundColor = UIColor.white
        UIView.animate(withDuration: 0.06,
                       // アニメーション中の処理.
                        animations: { () -> Void in
                            // 縮小用アフィン行列を生成する.
                            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                        }){ (Bool) -> Void in
                        }
    }
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
        let x_position:CGFloat = menuButton.layer.position.x + radius * cos(radian)
        // y座標を計算.
        //let y_position = mainPosition.y + radius * sin(radian)
        let y_position = menuButton.layer.position.y + radius * sin(radian)
        
        let position = CGPoint(x: x_position, y: y_position)
        
        return position
    }
    /// メインメニューボタンイベント(Up)
    ///
    /// - Parameter sender: 選択されたメインメニューボタン
    @objc  func onUpMainButton(sender: UIButton) {
        // subボタンを配列に格納.
        let buttons = [subButton_1, subButton_2, subButton_3, subButton_4, subButton_5]
        // subボタン用の　UIColorを配列に格納.
        colors = [UIColor.green, UIColor.yellow, UIColor.cyan, UIColor.magenta, UIColor.purple] as NSMutableArray
        // mainボタンからの距離(半径).
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
        //        for var i = 0; i < buttons.count; i++ {
        for i in 0 ..< buttons.count {
            //buttons[i].frame = CGRect(x: 0, y: 0, width: 60, height: 60)
            buttons[i].frame = CGRect(x: 0, y: 0, width: 60, height: 60)
            //buttons[i].layer.cornerRadius = 30.0
            buttons[i].layer.cornerRadius = 30.0
            //buttons[i].backgroundColor = colors[i] as? UIColor
            //buttons[i].center = self.center
            buttons[i].center = CGPoint(x: menuButton.layer.position.x, y: menuButton.layer.position.y)
            buttons[i].addTarget(self, action: #selector(onClickSubButtons), for: UIControlEvents.touchUpInside)
            buttons[i].layer.shadowOffset = CGSize(width: 1.0, height: 3.0)
            buttons[i].layer.shadowOpacity = 5.0
            buttons[i].tag = i+1
            // subボタンをviewに追加
            self.addSubview(buttons[i])
        }
        
        UIView.animate(withDuration: 0.06,
                       // アニメーション中の処理
                        animations: { () -> Void in
                            // 拡大用アフィン行列を作成
                            sender.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                            // 縮小用アフィン行列を作成
                            sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        }){ (Bool) -> Void in
                        }
        
        UIView.animate(withDuration: 0.7,
                        delay: 0.0,
                        // バネを設定
                        usingSpringWithDamping: 0.5,
                        // バネの弾性力
                        initialSpringVelocity: 1.5,
                        options: UIViewAnimationOptions.curveEaseIn,
                        // アニメーション中の処理
                        animations: { () -> Void in
                            // subボタンに座標を設定.
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
            // デリゲートメソッドを呼ぶ
            self.delegate?.selectedSubMenu(state: 1)
            fadeAnimation()
        case 2:
            // デリゲートメソッドを呼ぶ(処理をデリゲートインスタンスに委譲する)
            self.delegate?.selectedSubMenu(state: 2)
             fadeAnimation()
        case 3:
            // デリゲートメソッドを呼ぶ(処理をデリゲートインスタンスに委譲する)
            self.delegate?.selectedSubMenu(state: 3)
             fadeAnimation()
        case 4:
            // デリゲートメソッドを呼ぶ(処理をデリゲートインスタンスに委譲する)
            self.delegate?.selectedSubMenu(state: 4)
            fadeAnimation()
        case 5:
            // デリゲートメソッドを呼ぶ(処理をデリゲートインスタンスに委譲する)
            self.delegate?.selectedSubMenu(state: 5)
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
                self.subButton_1.layer.position = CGPoint(x: self.menuButton.layer.position.x, y: self.menuButton.layer.position.y)
                // subボタンに座標を設定.
                self.subButton_2.layer.position = CGPoint(x: self.menuButton.layer.position.x, y: self.menuButton.layer.position.y)
                // subボタンに座標を設定.
                self.subButton_3.layer.position = CGPoint(x: self.menuButton.layer.position.x, y: self.menuButton.layer.position.y)
                // subボタンに座標を設定.
                self.subButton_4.layer.position = CGPoint(x: self.menuButton.layer.position.x, y: self.menuButton.layer.position.y)
                // subボタンに座標を設定.
                self.subButton_5.layer.position = CGPoint(x: self.menuButton.layer.position.x, y: self.menuButton.layer.position.y)
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
