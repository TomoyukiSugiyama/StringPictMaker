//
//  imageEditor.swift
//  StringPictMaker
//
//  Created by 杉山智之 on 2017/11/18.
//  Copyright © 2017年 杉山智之. All rights reserved.
//

import Foundation
import UIKit

class ImageEditor: UIViewController, ViewDelegate, UIToolbarDelegate{
//,SampleViewDelegate{
    // delegate
    var delegateParamId: Int = 0
    var imageView : UIView? = nil
    var imageData : DataManager? = nil
    var selectedSubMenuItemState = 0
    // DataManagerのオブジェクトを生成し、CoreDataからデータを読み出す
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        self.view.addSubview(imageView!)
        // menuボタンを生成
        // menuボタンにタッチイベントを追加
        let menuButton = MenuButtonActionController(type: .custom)
        menuButton.setImage(UIImage(named: "add-icon"), for: .normal)
        menuButton.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        menuButton.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height-50)
        menuButton.layer.cornerRadius = 40.0
        // 影を付ける
        menuButton.layer.shadowOffset = CGSize(width: 1.0, height: 3.0)
        menuButton.layer.shadowOpacity = 5.0
        /// TODO　subボタンの追加
        // MenuButtonViewControllerクラスのインスタンス生成.
        let subMenuButton: MenuButtonViewController = MenuButtonViewController(frame: self.view.frame)
        subMenuButton.menuButton = menuButton
        subMenuButton.mainPosition = menuButton.layer.position
        subMenuButton.delegate = self
        // mainボタンにイベント追加
        menuButton.addTarget(subMenuButton, action: #selector(subMenuButton.onDownMainButton(sender:)), for: UIControlEvents.touchDown)
        //isUserInteractionEnabledをtrueにして、touchesEndedで処理
        menuButton.isUserInteractionEnabled = true
        // subボタンにイベント追加
        menuButton.addTarget(subMenuButton,action:#selector(subMenuButton.onUpMainButton(sender:)),for: UIControlEvents.touchUpOutside )
        //| UIControlEvents.touchDragOutside
        
        // インスタンスをviewに追加.(subボタン)
        self.view.addSubview(subMenuButton)
        // mainボタンをviewに追加.
        self.view.addSubview(menuButton)
        /************************************/
        //  テストコード↓
        /************************************/
        let label = UILabel()
        /*      文字追加        */
        let str2 = "TEST"
        let pointSize : CGFloat = 120
        
        let font = UIFont.boldSystemFont(ofSize: pointSize)
        let width = str2.size(withAttributes: [NSAttributedStringKey.font : font])
        
        //let labelWidth : CGFloat = 375
        let labelWidth : CGFloat = 50
        label.font = UIFont.boldSystemFont(ofSize: pointSize * getScreenRatio() * labelWidth / width.width)
        label.text = str2
        // 文字サイズに合わせてラベルのサイズを調整する
        label.sizeToFit()
        //ラベルをviewの中心に移動する
        label.center = CGPoint(x: 50, y: 100)
        self.imageView?.addSubview(label)
        /************************************/
        //  テストコード↑
        /************************************/
        /************************************/
        //  テストコード↓
        /************************************/

        var myToolbar: UIToolbar!
        // ツールバーのサイズを決める.
        myToolbar = UIToolbar(frame: CGRect(x:0, y:self.view.bounds.size.height - 44, width:self.view.bounds.size.width, height:40.0))
        // ツールバーの位置を決める.
        myToolbar.layer.position = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height-20.0)
        // ツールバーの色を決める.
        myToolbar.barStyle = .blackTranslucent
        myToolbar.tintColor = UIColor.white
        //myToolbar.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        myToolbar.backgroundColor = UIColor.lightGray.withAlphaComponent(0.50)
        // ボタン１を生成する.
        let myUIBarButtonGreen: UIBarButtonItem = UIBarButtonItem(title: "Green", style:.plain, target: self, action: #selector(onClickBarButton))
        myUIBarButtonGreen.tag = 1
        // ボタン２を生成する.
        let myUIBarButtonBlue: UIBarButtonItem = UIBarButtonItem(title: "Yellow", style:.plain, target: self, action: #selector(onClickBarButton))
        myUIBarButtonBlue.tag = 2
        // ボタン3を生成する.
        let myUIBarButtonRed: UIBarButtonItem = UIBarButtonItem(title: "Red", style:.plain, target: self, action: #selector(onClickBarButton))
        myUIBarButtonRed.tag = 3
        // ボタン3を生成する.
        let myUIBarButtonSave: UIBarButtonItem = UIBarButtonItem(title: "SAVE", style:.plain, target: self, action: #selector(onClickBarButton))
        myUIBarButtonSave.tag = 4
        // ボタンをツールバーに入れる.
        myToolbar.items = [myUIBarButtonGreen, myUIBarButtonBlue, myUIBarButtonRed,myUIBarButtonSave]
        // ツールバーに追加する.
        self.view.addSubview(myToolbar)
        /************************************/
        //  テストコード↑
        /************************************/

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.imageData?.loadImage()
        let prevVC = self.getPreviousViewController() as! ImageListController
        prevVC.updateView()
    }
    /************************************/
    //  テストコード↓
    /************************************/
    private func getScreenRatio() -> CGFloat {
        let baseScreenWidth : CGFloat = 375.0
        return UIScreen.main.bounds.size.width / baseScreenWidth
    }
    /************************************/
    //  テストコード↑
    /************************************/
    func initView(){        
        for view in (imageView?.subviews)!
        {
            // remove image from superview when tag is -1
            // because this image is "noimage"
            if view.tag == -1{
                view.removeFromSuperview()
            }else{
                if view.isKind(of: NSClassFromString("UIImageView")!) {
                    print("ImageView")
                }else if view.isKind(of: NSClassFromString("UISearchBarBackground")!) {
                
                }
            }
        }
    }
    
    // delegate
    func selectedSubMenu(state: Int) {
        if state == 1{
            selectedSubMenuItemState = 1
            setGPSLabel()
        }else if state == 2{
            selectedSubMenuItemState = 2
            setColor()
        }else if state == 3{
            selectedSubMenuItemState = 3
            setImage()
        }else if state == 4{
            selectedSubMenuItemState = 4
            setTime()
        }else if state == 5{
            selectedSubMenuItemState = 5
            setPen()
        }
    }
    // GPSをセット
    func setGPSLabel(){
        let gpsTag = 10
        print("GPS is selected");
        let label = UILabel()
        /*      文字追加        */
        let str2 = "現在位置"
        let pointSize : CGFloat = 120
        
        let font = UIFont.boldSystemFont(ofSize: pointSize)
        let width = str2.size(withAttributes: [NSAttributedStringKey.font : font])
        
        //let labelWidth : CGFloat = 375
        let labelWidth : CGFloat = 250
        label.font = UIFont.boldSystemFont(ofSize: pointSize * getScreenRatio() * labelWidth / width.width)
        
        //label.layer.borderColor = UIColor.black.cgColor
        //label.layer.borderWidth = 2
        label.text = str2
        // 文字サイズに合わせてラベルのサイズを調整する
        label.sizeToFit()
        //ラベルをviewの中心に移動する
        label.center = self.view.center
        label.tag = gpsTag
        label.isUserInteractionEnabled = true
        self.imageView?.addSubview(label)

    }
    // Imageをセット
    func setImage(){
        print("PICT is selected");
        //self.navigationController?.setNavigationBarHidden(false, animated: false)
        //self.navigationController?.popViewController(animated: true)
    }
    // Colorをセット
    func setColor(){
        print("COLOR is selected");
    }
    // Timeをセット
    func setTime(){
        print("TIME is selected");
    }
    
    // Penをセット
    func setPen(){
        print("PEN is selected");
    }
    
    @objc func onClickBarButton(sender: UIBarButtonItem) {
        switch sender.tag {
        case 1:
            self.imageView?.backgroundColor = UIColor.green
        case 2:
            self.imageView?.backgroundColor = UIColor.yellow
        case 3:
            self.imageView?.backgroundColor = UIColor.red
        case 4:
            // CoreDataを更新
            print("imageEditor - save:",self.delegateParamId)
            self.imageData?.updateImage(id: self.delegateParamId, view: self.imageView!)
            // ImageListControllerを更新
            let prevVC = self.getPreviousViewController() as! ImageListController
            prevVC.updateView()
        default:
            print("ERROR!!!")
        }
    }
}

// MARK: - 以前のViewControllerのインスタンスを取得
public extension UIViewController
{
    public func getPreviousViewController() -> UIViewController?
    {
        if let vcList = navigationController?.viewControllers
        {
            var prevVc: UIViewController?;
            for vc in vcList
            {
                if ( vc == self ) { break }
                prevVc = vc
            }
            return prevVc
        }
        // ここに来るのは実装ミスなので assert でもよろし
        return nil
    }
}
