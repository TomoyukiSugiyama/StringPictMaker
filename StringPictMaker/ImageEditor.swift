//
//  imageEditor.swift
//  StringPictMaker
//
//  Created by 杉山智之 on 2017/11/18.
//  Copyright © 2017年 杉山智之. All rights reserved.
//

import Foundation
import UIKit

class ImageEditor: UIViewController, ViewDelegate, UIToolbarDelegate,UIScrollViewDelegate{
//,SampleViewDelegate{
    // delegate
    var delegateParamId: Int = 0
    var imageView : UIView? = nil
    var imageData : DataManager? = nil
    var selectedSubMenuItemState = 0
    var scrollView: UIScrollView!
    // DataManagerのオブジェクトを生成し、CoreDataからデータを読み出す
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        
        
        //スクロールビューを設置
        scrollView = myScrollView()
        let singleTap = UIPanGestureRecognizer(target:self, action:#selector(handlePanGesture))
        singleTap.maximumNumberOfTouches = 1
        scrollView.addGestureRecognizer(singleTap)
        scrollView.frame = CGRect(x:0,y:0,width:self.view.frame.width,height:self.view.frame.height)
        scrollView.center = self.view.center
        print("width:",self.view.frame.width,"height:",self.view.frame.height,"center:",self.view.center)
        //scrollView.frame = CGRect(x:0,y:0,width:(self.imageView?.frame.width)!,height:(self.imageView?.frame.height)!)
        scrollView.frame.size = CGSize(width:(self.view.frame.width),height:(self.view.frame.height))
        //scrollView.contentSize = CGSize(width:self.(view.frame.width), height: (self.view.frame.heigh))
        //scrollView.contentSize = CGSize(width:100,height:100)
        scrollView.isUserInteractionEnabled = true
        //デリゲートを設定
        scrollView.delegate = self
        //最大・最小の大きさを決める
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 0.5
        
        self.view.addSubview(scrollView)
        self.initView()
        
        imageView?.isUserInteractionEnabled = true
        //self.view.addSubview(imageView!)
        //imageView?.addGestureRecognizer(UIPanGestureRecognizer(target:self, action:#selector(handlePanGesture)))
        scrollView.addSubview(imageView!)
        // menuボタンを生成
        // menuボタンにタッチイベントを追加
        let menuButton = MenuButtonActionController(type: .custom)
        menuButton.setImage(UIImage(named: "add-icon"), for: .normal)
        menuButton.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        menuButton.backgroundColor = UIColor.lightGray
        menuButton.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height-70)
        menuButton.layer.cornerRadius = 40.0
        // 影を付ける
        menuButton.layer.shadowOffset = CGSize(width: 1.0, height: 3.0)
        menuButton.layer.shadowOpacity = 5.0
        menuButton.delegate = self
        /// TODO　subボタンの追加
        // MenuButtonViewControllerクラスのインスタンス生成.
        //let subMenuButton: MenuButtonViewController = MenuButtonViewController(frame: self.view.frame)
        
        //let frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        /*let subMenuButton: MenuButtonViewController = MenuButtonViewController(frame: frame)
        subMenuButton.backgroundColor = UIColor.yellow
        //subMenuButton.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        subMenuButton.menuButton = menuButton
        subMenuButton.mainPosition = menuButton.layer.position
        subMenuButton.delegate = self*/
        // mainボタンにイベント追加
        menuButton.addTarget(menuButton, action: #selector(menuButton.onDownMainButton(sender:)), for: UIControlEvents.touchDown)
        //isUserInteractionEnabledをtrueにして、touchesEndedで処理
        menuButton.isUserInteractionEnabled = true
        // subボタンにイベント追加
        menuButton.addTarget(menuButton,action:#selector(menuButton.onUpMainButton(sender:)),for: UIControlEvents.touchUpOutside )
        //| UIControlEvents.touchDragOutside
        // インスタンスをviewに追加.(subボタン)
        //self.view.addSubview(subMenuButton)
        //scrollView.addSubview(subMenuButton)
        // mainボタンをviewに追加.
        self.view.addSubview(menuButton)
        //scrollView.addSubview(menuButton)
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
        //self.imageView?.addSubview(label)
        /************************************/
        //  テストコード↑
        /************************************/
        /************************************/
        //  テストコード↓
        /************************************/

        var myToolbar: UIToolbar!
        // ツールバーのサイズを決定
        myToolbar = UIToolbar(frame: CGRect(x:0, y:self.view.bounds.size.height - 44, width:self.view.bounds.size.width, height:40.0))
        // ツールバーの位置を決定
        myToolbar.layer.position = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height-20.0)
        // ツールバーの色を決定
        myToolbar.barStyle = .blackTranslucent
        myToolbar.tintColor = UIColor.white
        //myToolbar.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        myToolbar.backgroundColor = UIColor.lightGray.withAlphaComponent(0.50)
        // ボタン１を生成
        let myUIBarButtonGreen: UIBarButtonItem = UIBarButtonItem(title: "Green", style:.plain, target: self, action: #selector(onClickBarButton))
        myUIBarButtonGreen.tag = 1
        // ボタン２を生成
        let myUIBarButtonBlue: UIBarButtonItem = UIBarButtonItem(title: "Yellow", style:.plain, target: self, action: #selector(onClickBarButton))
        myUIBarButtonBlue.tag = 2
        // ボタン3を生成
        let myUIBarButtonRed: UIBarButtonItem = UIBarButtonItem(title: "Red", style:.plain, target: self, action: #selector(onClickBarButton))
        myUIBarButtonRed.tag = 3
        // スペースを確保
        let myUIBarItemSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        myUIBarItemSpace.width = 100
        // ボタン4を生成
        let myUIBarButtonCancel: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(onClickBarButton))
        myUIBarButtonCancel.tag = 4
        // スペースを確保
        let myUIBarItemSpace2: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        myUIBarItemSpace2.width = 20
        // ボタン5を生成
        let myUIBarButtonSave: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(onClickBarButton))
        
        myUIBarButtonSave.tag = 5
        // ボタンをツールバーに入れる.
        myToolbar.items = [myUIBarButtonGreen, myUIBarButtonBlue, myUIBarButtonRed,myUIBarItemSpace,myUIBarButtonCancel,myUIBarItemSpace2,myUIBarButtonSave]
        // ツールバーに追加する.
        self.view.addSubview(myToolbar)
        //scrollView.addSubview(myToolbar)
        /************************************/
        //  テストコード↑
        /************************************/

    }
    // ナビゲーションバーを非表示
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
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
                if (view.tag & 0x3FF) == DataManager.TagIDs.typeGPS.rawValue {
                    print("ImageEditor - initView - tagGPS - view.tag:",view.tag)
                    let label = view as! UILabel
                    label.text = "現在位置"
                 }else if view.tag == DataManager.TagIDs.typeDUMMY.rawValue {
                    
                }
            }
        }
    }
    
    /// 選択されたサブメニューを取得
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
    var gpsTag = 1024
    /// GPSをセット
    func setGPSLabel(){
        let GPSlabel = UILabel()
        /*      文字追加        */
        let str2 = "現在位置"
        let pointSize : CGFloat = 120
        let font = UIFont.boldSystemFont(ofSize: pointSize)
        let width = str2.size(withAttributes: [NSAttributedStringKey.font : font])
        //let labelWidth : CGFloat = 375
        let labelWidth : CGFloat = 250
        print("ImageEditor - setGPSLabel");
        GPSlabel.font = UIFont.boldSystemFont(ofSize: pointSize * getScreenRatio() * labelWidth / width.width)
        // label.layer.borderColor = UIColor.black.cgColor
        // label.layer.borderWidth = 2
        GPSlabel.text = str2
        // 文字サイズに合わせてラベルのサイズを調整
        GPSlabel.sizeToFit()
        // ラベルをviewの中心に移動
        GPSlabel.center = self.view.center
        /// TODO
        /// tagの値変更
        GPSlabel.tag = gpsTag + DataManager.TagIDs.typeGPS.rawValue
        gpsTag += 1024
        
        //let singleTap = UIPanGestureRecognizer(target:self, action:#selector(handlePanGesture))
        //singleTap.maximumNumberOfTouches = 1
        //GPSlabel.addGestureRecognizer(UIPanGestureRecognizer(target:self, action:#selector(handlePanGesture)))
        //GPSlabel.addGestureRecognizer(singleTap)
        // touchイベントの有効化
        GPSlabel.isUserInteractionEnabled = true
        self.imageView?.addSubview(GPSlabel)
        
        // imageViewにジェスチャーレコグナイザを設定(ピンチ)
        //let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchAction))
        //self.imageView?.addGestureRecognizer(pinchGesture)
    }
    // Imageをセット
    func setImage(){
        print("ImageEditor - setImage");
        //self.navigationController?.setNavigationBarHidden(false, animated: false)
        //self.navigationController?.popViewController(animated: true)
    }
    // Colorをセット
    func setColor(){
        print("ImageEditor - setColor");
    }
    // Timeをセット
    func setTime(){
        print("ImageEditor - setTime");
    }
    
    // Penをセット
    func setPen(){
        print("ImageEditor - setPen");
    }
    
    /// ツールバーのアクション
    ///
    /// - Parameter sender: ツールバーのボタンを取得
    @objc func onClickBarButton(sender: UIBarButtonItem) {
        switch sender.tag {
        case 1:
            self.imageView?.backgroundColor = UIColor.green
        case 2:
            self.imageView?.backgroundColor = UIColor.yellow
        case 3:
            self.imageView?.backgroundColor = UIColor.red
        case 4:
            print("imageEditor - onClickBarButton - cancel")
            self.dispCancelAlert()
        case 5:
            // CoreDataを更新
            print("imageEditor - onClickBarButton - save:",self.delegateParamId)
            self.dispSaveAlert()
 
        default:
            print("imageEditor - onClickBarButton - error")
        }
    }

    var tagList = [Int]()
    var isSelected:Bool = false
    @objc func handlePanGesture(sender: UIPanGestureRecognizer){
        switch sender.state {
        case UIGestureRecognizerState.began:
            if(!isSelected){
            tagList.removeAll()
            let location:CGPoint=sender.location(in: imageView)
            // タッチされた座標にあるサブビューを取得
            //let hitImageView:UIView? = self.imageView?.hitTest(location, with: UIEvent?)
            print("ImageEditor - Pan began:",sender.view?.tag)
            // タッチされた座標の位置を含むサブビューを取得
            for subview in (self.imageView?.subviews)! {
                if (subview.frame.contains(location)) {
                    tagList.append(subview.tag)
                    print("ImageEditor - Pan - tags:",subview.tag)
                }
            }
                isSelected = true
            }
            break
        case UIGestureRecognizerState.changed:
            if(isSelected){
            //print("ImageEditor - Pan changed")
            var operateView:UIView!
            //移動量を取得する。
            let move:CGPoint = sender.translation(in: self.imageView)
            for tag:Int in tagList {
                operateView = (self.imageView?.viewWithTag(tag))!
                // 画像のフレーム
                //var viewFrame: CGRect = (operateView.frame)
                // 移動分を反映
                //viewFrame.origin.x += move.x
                //viewFrame.origin.y += move.y
                //operateView.frame = viewFrame
                
                let moved = CGPoint(x: operateView.center.x + move.x, y: operateView.center.y + move.y)
                operateView.center = moved
                sender.setTranslation(CGPoint.zero, in:operateView)
            }
            }
            break
        case UIGestureRecognizerState.ended:
            isSelected = false
            break
        default:
            break
            
        }
    }
    //var bezierPath:UIBezierPath!
    
    /// 選択されたサブビューのtagをtagListに追加
    ///
    /// - Parameters:
    ///   - touches: touches description
    ///   - event: event description
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //super.touchesBegan(touches, with: event)
        tagList.removeAll()
        //print("imageEditor - touchesBegan")
        for touch: UITouch in touches {
            // タッチされた位置の座標を取得
            let point:CGPoint = touch.location(in: self.imageView)
            // imageViewにタッチイベントを渡し、
            // タッチされた座標にあるサブビューを取得
            let hitImageView:UIView? = self.imageView?.hitTest(point, with: event)
            if(hitImageView != nil){
                // タッチされた座標の位置を含むサブビューを取得
                for subview in (self.imageView?.subviews)! {
                    if (subview.frame.contains(point)) {
                        tagList.append(subview.tag)
                        print("tags:",subview.tag)
                    }
                }
            }
         }
    }

    /// 移動分をサブビューに反映
    ///
    /// - Parameters:
    ///   - touches: touches description
    ///   - event: event description
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //super.touchesMoved(touches, with: event)
        //print("imageEditor - touchesMoved")
        var operateView:UIView!
        let touchEvent = touches.first!
        // ドラッグ前の座標
        let preDx = touchEvent.previousLocation(in: self.imageView).x
        let preDy = touchEvent.previousLocation(in: self.imageView).y
        // ドラッグ後の座標
        let newDx = touchEvent.location(in: self.imageView).x
        let newDy = touchEvent.location(in: self.imageView).y
        // ドラッグしたx座標の移動距離
        let dx = newDx - preDx
        // ドラッグしたy座標の移動距離
        let dy = newDy - preDy
        for tag:Int in tagList {
            operateView = (self.imageView?.viewWithTag(tag))!
            // 画像のフレーム
            var viewFrame: CGRect = (operateView.frame)
            // 移動分を反映
            viewFrame.origin.x += dx
            viewFrame.origin.y += dy
            operateView.frame = viewFrame
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print("imageEditor - touchesEnded")
        //super.touchesEnded(touches, with: event)
    }
/*    // ピンチ時、ImageListControllerに戻る
    @objc func pinchAction(gesture: UITapGestureRecognizer) -> Void {
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        // ズームのために要指定
        return imageView
    }
*/
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        // 拡大縮小されるたびに呼ばれる
        updateImageCenter()
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
    }
    
    func updateImageCenter(){
        
        let bounds:CGRect = self.scrollView.bounds;
        var point:CGPoint = CGPoint()
        point.x = (self.imageView?.frame.width)! / 2
        if ((self.imageView?.frame.width)! < bounds.size.width) {
            point.x += (bounds.size.width - (self.imageView?.frame.width)!) / 2;
        }
        point.y = (self.imageView?.frame.height)! / 2;
        if ((self.imageView?.frame.height)! < bounds.size.height) {
            point.y += (bounds.size.height - (self.imageView?.frame.height)!) / 2;
        }
        self.imageView?.center = point;
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // スクロール中の処理
        //print("didScroll")
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // ドラッグ開始時の処理
        //print("beginDragging")
    }
    func dispSaveAlert() {
        // UIAlertControllerクラスのインスタンスを生成
        // タイトル, メッセージ, Alertのスタイルを指定する
        // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
        let alert: UIAlertController = UIAlertController(title: "イメージ", message: "保存して終了しますか？", preferredStyle:  UIAlertControllerStyle.alert)
        
        // Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Save - OK")
            self.imageData?.updateImage(id: self.delegateParamId, view: self.imageView!)
            // ImageListControllerを更新
            let prevVC = self.getPreviousViewController() as! ImageListController
            prevVC.updateView()
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.navigationController?.popViewController(animated: true)
            
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Save - Cancel")
        })
        
        // UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        // Alertを表示
        present(alert, animated: true, completion: nil)
    }
    func dispCancelAlert() {
        // UIAlertControllerクラスのインスタンスを生成
        // タイトル, メッセージ, Alertのスタイルを指定する
        // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
        let alert: UIAlertController = UIAlertController(title: "イメージ", message: "保存せず終了してもいいですか？", preferredStyle:  UIAlertControllerStyle.alert)
        
        // Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel - OK")
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.navigationController?.popViewController(animated: true)
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel - Cancel")
        })
        
        // UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        // Alertを表示
        present(alert, animated: true, completion: nil)
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
        // 実装ミス
        return nil
    }
}

class myScrollView: UIScrollView{
    /*override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //self.next?.touchesBegan(touches, with: event)
        superview?.touchesBegan(touches, with: event)
        //print("myScrollView - touchesBegan")
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //self.next?.touchesMoved(touches, with: event)
        superview?.touchesMoved(touches, with: event)
        //print("myScrollView - touchesMoved")
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //self.next?.touchesEnded(touches, with: event)
        superview?.touchesEnded(touches, with: event)
        //print("myScrollView - touchesEnded")
        
    }*/
}
