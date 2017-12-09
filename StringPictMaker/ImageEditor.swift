//
//  imageEditor.swift
//  StringPictMaker
//
//  Created by 杉山智之 on 2017/11/18.
//  Copyright © 2017年 杉山智之. All rights reserved.
//

import Foundation
import UIKit

/// TODO:
/// ＊再編集すると、スクロールが効かなくなる
/// ＊編集し保存すると文字サイズ変更アイコンが残る
/// ＊Image上のアイテムを選択したタイミングに、強調枠が表示されない
/// ＊ディスプレイを反転した時の処理がない

/// Imageを編集するためのコントローラー
class ImageEditor: UIViewController, SubMenuDelegate, FontPickerDelegate,UIToolbarDelegate,UIScrollViewDelegate{
    // delegate
    // ImageListControllerから選択されたセルのid、imageView/Dataを取得
    var delegateParamId: Int = 0
    var imageView : UIView? = nil
    var imageData : DataManager? = nil
    // MenuButtonActionControllerで選択されたサブメニューアイテムの番号を取得
    var selectedSubMenuItemState = 0
    // スクロールビューを生成
    var scrollView: UIScrollView! = nil
    // ツールバーを生成
    var myToolbar: UIToolbar! = nil
    // ツールバーのアイテム
    struct ToolBarItem {
        var title: [String]
        //var item: [UIBarButtonItem]
    }
    var toolBar: [[UIBarButtonItem]]! = nil
    var myUIBarButtonGreen: UIBarButtonItem? = nil
    var myUIBarButtonBlue: UIBarButtonItem? = nil
    var myUIBarButtonRed: UIBarButtonItem? = nil
    var myUIBarItemSpace100: UIBarButtonItem? = nil
    var myUIBarButtonCancel: UIBarButtonItem? = nil
    var myUIBarItemSpace20: UIBarButtonItem? = nil
    var myUIBarButtonSave: UIBarButtonItem? = nil
    var myUIBarButtonColorPalet: UIBarButtonItem? = nil
    var myUIBarButtonFontSeloctor: UIBarButtonItem? = nil
    // ピッカービューを生成
    var fontPickerView: FontPickerViewController!
    /// DataManagerのオブジェクトを生成し、CoreDataからデータを読み出す
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        //スクロールビューを設置
        scrollView = UIScrollView()
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
        //最大・最小の大きさを決定
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
        // mainボタンにイベント追加
        menuButton.addTarget(menuButton, action: #selector(menuButton.onDownMainButton(sender:)), for: UIControlEvents.touchDown)
        //isUserInteractionEnabledをtrueにして、touchesEndedで処理
        menuButton.isUserInteractionEnabled = true
        // subボタンにイベント追加
        menuButton.addTarget(menuButton,action:#selector(menuButton.onUpMainButton(sender:)),for: UIControlEvents.touchUpOutside )
        //| UIControlEvents.touchDragOutside
        // mainボタンをviewに追加.
        self.view.addSubview(menuButton)
        //scrollView.addSubview(menuButton)
        /************************************/
        //  テストコード↓
        /************************************/
        self.initToolBarItem()
        // ツールバーのサイズを決定
        myToolbar = UIToolbar(frame: CGRect(x:0, y:self.view.bounds.size.height - 44, width:self.view.bounds.size.width, height:40.0))
        // ツールバーの位置を決定
        myToolbar.layer.position = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height-20.0)
        // ツールバーの色を決定
        myToolbar.barStyle = .blackTranslucent
        myToolbar.tintColor = UIColor.white
        //myToolbar.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        myToolbar.backgroundColor = UIColor.lightGray.withAlphaComponent(0.50)
        // ボタンをツールバーに入れる.
        myToolbar.items = toolBar[0]
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
    // ImageEditorを離れる時に、ImageListControllerを更新
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
                    if(gpsTag <= (view.tag & ~0x3FF)){
                        gpsTag += 1024
                        print("ImageEditor - initVies - tag:",gpsTag)
                    }
                 }else if view.tag == DataManager.TagIDs.typeDUMMY.rawValue {
                    
                }
            }
        }
    }
    /// ツールバーのアイテムを初期化
    func initToolBarItem(){
        self.toolBar = [[UIBarButtonItem]]()
        myUIBarButtonGreen = UIBarButtonItem(title: "Green", style:.plain, target: self, action: #selector(onClickBarButton))
        myUIBarButtonGreen?.tag = 1
        myUIBarButtonBlue = UIBarButtonItem(title: "Yellow", style:.plain, target: self, action: #selector(onClickBarButton))
        myUIBarButtonBlue?.tag = 2
        myUIBarButtonRed = UIBarButtonItem(title: "Red", style:.plain, target: self, action: #selector(onClickBarButton))
        myUIBarButtonRed?.tag = 3
        myUIBarItemSpace100 = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        myUIBarItemSpace100?.width = 100
        myUIBarButtonCancel = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(onClickBarButton))
        myUIBarButtonCancel?.tag = 4
        myUIBarItemSpace20 = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        myUIBarItemSpace20?.width = 20
        myUIBarButtonSave = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(onClickBarButton))
        myUIBarButtonSave?.tag = 5
        myUIBarButtonColorPalet = UIBarButtonItem(title: "Color", style:.plain, target: self,action:#selector(onClickBarButton))
        myUIBarButtonColorPalet?.tag = 6
        myUIBarButtonFontSeloctor = UIBarButtonItem(title: "Font", style:.plain, target: self,action:#selector(onClickBarButton))
        myUIBarButtonFontSeloctor?.tag = 7
        // 選択されたサブメニュー毎のアイテムを設定
        self.toolBar.append([myUIBarButtonGreen!,myUIBarButtonBlue!,myUIBarButtonRed!,myUIBarItemSpace100!,myUIBarButtonCancel!,myUIBarItemSpace20!,myUIBarButtonSave!])
        self.toolBar.append([myUIBarButtonGreen!,myUIBarButtonBlue!,myUIBarButtonRed!,myUIBarItemSpace100!,myUIBarButtonCancel!,myUIBarItemSpace20!,myUIBarButtonSave!])
        self.toolBar.append([myUIBarButtonColorPalet!,myUIBarButtonFontSeloctor!,myUIBarItemSpace100!,myUIBarItemSpace100!,myUIBarButtonCancel!,myUIBarItemSpace20!,myUIBarButtonSave!])
        print("ImageEditor - initToolBarItem")
    }
    /// 選択されたサブメニューを取得
    func selectedSubMenu(state: DataManager.MenuTypes) {
        if state == DataManager.MenuTypes.typeGPS{
            selectedSubMenuItemState = 1
            setGPSLabel()
            myToolbar.items = toolBar[2]
        }else if state == DataManager.MenuTypes.typeColor{
            selectedSubMenuItemState = 2
            setColor()
        }else if state == DataManager.MenuTypes.typeImage{
            selectedSubMenuItemState = 3
            setImage()
        }else if state == DataManager.MenuTypes.typeTime{
            selectedSubMenuItemState = 4
            setTime()
        }else if state == DataManager.MenuTypes.typePen{
            selectedSubMenuItemState = 5
            setPen()
        }
    }
    
    func selectedFont(state: UILabel){
        print("ImageEditor - selectedFont - font:",state.font)
    }
    /// TODO:
    /// Imageを編集し保存後、再編集するとTagの番号が誤って追加される
    /// ImageViewに追加するアイテムがGPSの場合、
    /// タグ = 1024の整数倍 ＋ 0x001 (typeGPS:　アイテムの種類がGPSであることを示す値)
    var gpsTag = 1024
    /// GPSをセット
    func setGPSLabel(){
        let GPSlabel = UILabel()
        // 文字追加
        let str2 = "現在位置"
        let pointSize : CGFloat = 120
        let font = UIFont.boldSystemFont(ofSize: pointSize)
        let width = str2.size(withAttributes: [NSAttributedStringKey.font : font])
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
        /// TODO:
        /// tagの値変更
        GPSlabel.tag = gpsTag + DataManager.TagIDs.typeGPS.rawValue
        gpsTag += 1024
        // touchイベントの有効化
        GPSlabel.isUserInteractionEnabled = true
        self.imageView?.addSubview(GPSlabel)
    }
    /// Imageをセット
    func setImage(){
        print("ImageEditor - setImage");
        //self.navigationController?.setNavigationBarHidden(false, animated: false)
        //self.navigationController?.popViewController(animated: true)
    }
    /// Colorをセット
    func setColor(){
        print("ImageEditor - setColor");
    }
    /// Timeをセット
    func setTime(){
        print("ImageEditor - setTime");
    }
    /// Penをセット
    func setPen(){
        print("ImageEditor - setPen");
    }
    /// ツールバーのアクション
    ///
    /// - Parameter sender: ツールバーのボタンを取得
    @objc func onClickBarButton(sender: UIBarButtonItem) {
        switch sender.tag {
        case 1:
            //myToolbar.items = [myUIBarButtonGreen, myUIBarButtonBlue, myUIBarButtonRed,myUIBarItemSpace,myUIBarButtonCancel,myUIBarItemSpace2,myUIBarButtonSave]
            self.imageView?.backgroundColor = UIColor.green
        case 2:
            self.imageView?.backgroundColor = UIColor.yellow
        case 3:
            self.imageView?.backgroundColor = UIColor.red
        case 4:
            print("ImageEditor - onClickBarButton - cancel")
            self.dispCancelAlert()
        case 5:
            // CoreDataを更新
            print("ImageEditor - onClickBarButton - save:",self.delegateParamId)
            self.dispSaveAlert()
        case 6:
            displayColorPalet()
        case 7:
            displayFontSelector()
        default:
            print("ImageEditor - onClickBarButton - error")
        }
    }
    /// カラーパレットを表示
    func displayColorPalet(){
        print("ImageEditor - displayColorPalet")
    }
    /// 文字フォントを選択するピッカーを表示
    func displayFontSelector(){
        fontPickerView = FontPickerViewController()
        fontPickerView.delegate = self
        self.view.addSubview(fontPickerView.view)
        self.addChildViewController(fontPickerView)
        fontPickerView.didMove(toParentViewController: self)
        print("ImageEditor - displayFontSelector")
    }
    /// TODO:
    /// Imageを編集し保存後、再編集するとTagの番号が誤って追加される
    /// タッチした座標にあるimageView上のアイテムを管理
    var tagList = [Int]()
    /// imageView上のアイテムをタッチ、パンした時のアクションを定義
    ///
    /// - Parameter sender: sender
    @objc func handlePanGesture(sender: UIPanGestureRecognizer){
        switch sender.state {
        case UIGestureRecognizerState.began:
            tagList.removeAll()
            let location:CGPoint = sender.location(in: imageView)
            // タッチされた座標にあるサブビューを取得
            //let hitImageView:UIView? = self.imageView?.hitTest(location, with: UIEvent?)
            print("ImageEditor - handlePanGesture - view.tag:",sender.view?.tag as Any)
            // タッチされた座標の位置を含むサブビューを取得
            for subview in (self.imageView?.subviews)! {
                if (subview.frame.contains(location)) {
                    tagList.append(subview.tag)
                    print("ImageEditor - handlePanGesture - subview.tag:",subview.tag)
                    /// TODO:
                    /// タグの種類確認
                    if(subview.tag != 0){
                        // 選択されたアイテムを強調
                        var operateView:UIView!
                        operateView = (self.imageView?.viewWithTag(subview.tag))!
                        self.emphasisSelectedItem(selectedView: operateView)
                    }else{
                        /// TODO:
                    }
                }else{
                    var iconIsSelected:Bool = false
                        for icon in subview.subviews{
                            print("subview:",subview.frame,"icon:",icon.frame,"location:",location)
                            var iconframe = icon.frame
                            iconframe.origin.x += subview.frame.origin.x
                            iconframe.origin.y += subview.frame.origin.y
                            print("subview:",subview.frame,"iconframe:",iconframe,"location:",location)
                            if(iconframe.contains(location)){
                                tagList.append(icon.tag)
                                print("ImageEditor - handlePanGesture - icon.tag:",icon.tag)
                                iconIsSelected = true
                            }
                        }
                        if(iconIsSelected == false){
                            // 選択されたアイテムの強調を削除
                            var operateView:UIView!
                            operateView = (self.imageView?.viewWithTag(subview.tag))!
                            self.clearEmphasisSelectedItem(selectedView: operateView)
                        }
                }
            }
            break
        case UIGestureRecognizerState.changed:
            var operateView:UIView!
            //移動量を取得する。
            let move:CGPoint = sender.translation(in: self.imageView)
            var iconIsSelected:Bool = false
            for tag:Int in tagList {
                for subview in (self.imageView?.subviews)! {
                    for icon in subview.subviews{
                        //print("tag:",tag,icon.tag)
                        if(tag  == icon.tag){
                            //print("ImageEditor - handlePanGesture - subview.frame:",subview.frame)
                            let moved = CGPoint(x: icon.center.x + move.x, y: icon.center.y)
                            //print("ImageEditor - handlePanGesture - moved:",moved,"move:",move)
                            self.resizeText(textLabel: subview as! UILabel, posX: icon.frame)
                            icon.center = moved
                            sender.setTranslation(CGPoint.zero, in: icon)
                            iconIsSelected = true
                        }
                    }
                }
                if(iconIsSelected == false){
                operateView = (self.imageView?.viewWithTag(tag))!
                // 移動分を反映
                let moved = CGPoint(x: operateView.center.x + move.x, y: operateView.center.y + move.y)
                operateView.center = moved
                sender.setTranslation(CGPoint.zero, in:operateView)
                }
            }
            break
        case UIGestureRecognizerState.ended:
            break
        case UIGestureRecognizerState.cancelled:
            break
        default:
            break
        }
    }
    /// ズーム機能を追加するviewをimageViewに設定
    ///
    /// - Parameter scrollView: scrollView
    /// - Returns: imageView
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    /// スクロールビュー上のviewが拡大縮小した時に、viewがディスプレイの中心に来るよう更新
    ///
    /// - Parameter scrollView: scrollView
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        // 拡大縮小されるたびに呼ばれる
        updateImageCenter()
    }
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
    }
    // スクロールビュー上のviewサイズを変更した時、
    // viewがディスプレイの中心に来るように更新
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
    /// スクロール中の処理
    ///
    /// - Parameter scrollView: scrollView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // スクロール中の処理
        //print("didScroll")
    }
    /// スクロールビュー上でドラッグした時の処理
    ///
    /// - Parameter scrollView: scrollView
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // ドラッグ開始時の処理
        //print("beginDragging")
    }
    /// 作成したImageを保存して終了するためのアラートを表示
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
            print("ImageEditor - dispCancelAlert - SaveAlert: OK")
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
            print("ImageEditor - dispCancelAlert - SaveAlert: Cancel")
        })
        // UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        // Alertを表示
        present(alert, animated: true, completion: nil)
    }
    /// 作成したImageを保存せず終了するためのアラートを表示
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
            print("ImageEditor - dispCancelAlert - CancelAlert: OK")
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.navigationController?.popViewController(animated: true)
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("ImageEditor - dispCancelAlert - CancelAlert: Cancel")
        })
        // UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        // Alertを表示
        present(alert, animated: true, completion: nil)
    }
    /// 選択されたアイテムを強調
    /// 拡大・縮小アイコンを追加
    ///
    /// - Parameter selectedView: 選択されたアイテム
    func emphasisSelectedItem(selectedView:UIView){
        if(selectedView.subviews.count == 0){
            selectedView.layer.borderColor = UIColor.red.cgColor
            selectedView.layer.borderWidth = 4
            //print("ImageEditor - emphasisSelectedItem - selectedView.frame:",selectedView.frame)
            //print("ImageEditor - emphasisSelectedItem - selectedView.frame.origin:",selectedView.frame.origin)
            //print("ImageEditor - emphasisSelectedItem - selectedView.center:",selectedView.center)
            let iconSize:CGFloat = 40.0
            let posX = selectedView.frame.width + iconSize / 2
            let posY = selectedView.frame.height / 2 - iconSize / 2
            let scaleButton = UIButton(frame:CGRect(x:posX,y:posY,width:iconSize,height:iconSize))
            //print("ImageEditor - emphasisSelectedItem - scaleButton.frame:",scaleButton.frame)
            scaleButton.backgroundColor = UIColor.blue
            scaleButton.setTitle("↔︎", for: .normal)
            scaleButton.tag = selectedView.tag & ~0x3FF + DataManager.TagIDs.typeScale.rawValue
            print("ImageEditor - emphasisSelectedItem - tag:",scaleButton.tag)
            selectedView.addSubview(scaleButton)
        }
    }
    /// 選択されたアイテムの強調を削除
    /// 拡大・縮小アイコンを削除
    ///
    /// - Parameter selectedView: 選択されたアイテム
    func clearEmphasisSelectedItem(selectedView:UIView){
        selectedView.layer.borderColor = UIColor.clear.cgColor
        selectedView.layer.borderWidth = 4
        for v in selectedView.subviews {
            // オブジェクトの型がUIImageView型で、タグ番号が1〜5番のオブジェクトを取得する
            //if let v = v as? UIImageView, v.tag >= 1 && v.tag <= 5  {
                // そのオブジェクトを親のviewから取り除く
                v.removeFromSuperview()
            //}
        }
        
    }
    /// テキストの幅を調整
    ///
    /// - Parameters:
    ///   - textLabel: 調整したいテキスト
    ///   - posX: テキストの左上の座標を(0,0)とした時の、調整後の右上のx座標
    func resizeText(textLabel:UILabel,posX:CGRect){
        let margine:CGFloat = 20.0
        let width = posX.origin.x - margine
        let refPointSize: CGFloat = 100.0
        let refFont = UIFont.boldSystemFont(ofSize: refPointSize)
        let refWidth = textLabel.text?.size(withAttributes: [NSAttributedStringKey.font : refFont])
        textLabel.font = UIFont.boldSystemFont(ofSize: refPointSize * width / (refWidth?.width)! )
        // 文字サイズに合わせてラベルのサイズを調整する
        textLabel.sizeToFit()
     }
    /// コンテナをスーパービューに追加
    func displayContentController(content:UIViewController, container:UIView){
        print("ImageEditor - displayContentController")
        addChildViewController(content)
        content.view.frame = container.bounds
        container.addSubview(content.view)
        content.didMove(toParentViewController: self)
    }
    /// コンテナをスーパービューから削除
    func hideContentController(content:UIViewController){
        print("ImageEditor - hideContentController")
        content.willMove(toParentViewController: self)
        content.view.removeFromSuperview()
        content.removeFromParentViewController()
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
        // 実装ミスの場合、nilを返す
        return nil
    }
}
