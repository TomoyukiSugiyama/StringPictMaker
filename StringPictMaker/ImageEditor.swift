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
/// ＊(レイヤーピッカービューを表示した時のImageView,Buttonの位置を調整する)
/// ＊(アイテムを下に移動した時に、ツールバーとメニューボタンを透過)
/// ＊(レイヤービューに３枚以上のレイヤーを追加した状態で、レイヤービューを上にスクロール)
/// ＊( - ImageView上のアイテムを動かすとレイヤービューの挙動がおかしくなる)
/// ＊(レイヤーの番号を画面上部に表示)
/// ＊フリーテキスト
/// ＊GPS　都道府県、市町村　選択
/// ＊ペンツール使用ー＞保存ー＞EDITー＞redoー＞落ちる
/// ＊ペンツールのundo redoアイコンを画像に置き換え
/// ＊3115
/// ＊
/// ＊
/// ＊

/// Future:
/// ＊グリッド表示
/// ＊アイテムを移動した時、グリッドに合わせて位置調整
/// ＊複数アイテムの整列
/// ＊消しゴム
/// ＊色吸い取り
/// ＊範囲選択
/// ＊画像追加
/// ＊時間追加
/// ＊テキスト追加
/// ＊フレーム画像追加
/// ＊スタンプ追加
/// ＊
/// ＊
/// ＊

/// Imageを編集するためのコントローラー
class ImageEditor: UIViewController, SubMenuDelegate, FontPickerDelegate,ColorPickerDelegate,LayerPickerDelegate,PenPickerDelegate,TextPickerDelegate,UIToolbarDelegate,UIScrollViewDelegate{
	// delegate
	// ImageListControllerから選択されたセルのid、imageView/Dataを取得
	var delegateParamId: Int = 0
	var imageView : UIView? = nil
	var imageData : DataManager? = nil
	// MenuButtonActionControllerで選択されたサブメニューアイテムの番号を取得
	//var selectedSubMenuItemState = 0
	// スクロールビューを生成
	var scrollView: UIScrollView! = nil
	// メニューボタンを生成
	var menuButton:MenuButtonActionController! = nil
	// ツールバーを生成
	var myToolbar: UIToolbar! = nil
	// ツールバーのアイテム
	struct ToolBarItem {
		var title: [String]
		//var item: [UIBarButtonItem]
	}
	// サブメニュー毎のツールバーのアイテム一覧を生成
	var toolBar: [[UIBarButtonItem]]! = nil
	// フォントのピッカービューを生成
	var fontPickerView: FontPickerViewController!
	// カラーのピッカービューを生成
	var colorPickerView: ColorPickerViewController!
	// レイヤーのピッカービューを生成
	var layerPickerView: LayerPickerViewController!
	// ペンのピッカービューを生成
	var penPickerView: PenPickerViewController!
	// テキストのピッカービューを生成
	var textPickerView: TextPickerViewController!
	var selectedLayerNumber: Int = -1
	var imageViewRatio: CGFloat!
	/// DataManagerのオブジェクトを生成し、CoreDataからデータを読み出す
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor.gray
		// スクロールビューを設置
		scrollView = UIScrollView()
		let singlePan = UIPanGestureRecognizer(target:self, action:#selector(handlePanGesture))
		singlePan.maximumNumberOfTouches = 1
		let tap = UITapGestureRecognizer(target:self, action:#selector(handleTapGesture))
		scrollView.addGestureRecognizer(singlePan)
		scrollView.addGestureRecognizer(tap)
		scrollView.frame = CGRect(x:0,y:0,width:self.view.frame.width,height:self.view.frame.height)
		scrollView.center = self.view.center
		print("ImageEditor - viewDidLoad - self.imageView.frame:",self.imageView?.frame as Any)
		scrollView.frame.size = CGSize(width:(self.view.frame.width),height:(self.view.frame.height))
		scrollView.isUserInteractionEnabled = true
		// スクロールビューのデリゲートを設定
		scrollView.delegate = self
		//最大・最小の大きさを決定
		scrollView.maximumZoomScale = 2.0
		scrollView.minimumZoomScale = 0.5
		self.view.addSubview(scrollView)
		self.initView(imageView:self.imageView!)
		imageView?.isUserInteractionEnabled = true
		scrollView.addSubview(imageView!)
		// menuボタンを生成
		// menuボタンにタッチイベントを追加
		menuButton = MenuButtonActionController(type: .custom)
		menuButton.setImage(UIImage(named: "add-icon"), for: .normal)
		menuButton.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
		menuButton.backgroundColor = UIColor.lightGray
		menuButton.center = CGPoint(x: self.view.frame.width - 40, y: self.view.frame.height-80)
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
		// mainボタンをviewに追加
		self.view.addSubview(menuButton)
		// ツールバーを設置
		self.initToolBarItem()
		// ツールバーのサイズを決定
		myToolbar = UIToolbar(frame: CGRect(x:0, y:self.view.bounds.size.height - 40, width:self.view.bounds.size.width, height:40.0))
		// ツールバーの位置を決定
		myToolbar.layer.position = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height-20.0)
		// ツールバーの色を決定
		myToolbar.barStyle = .blackTranslucent
		myToolbar.backgroundColor = UIColor.white
		// ボタンをツールバーに追加
		myToolbar.items = toolBar[0]
		// ツールバーに追加
		self.view.addSubview(myToolbar)
		imageData?.setMenuType(menutype: DataManager.MenuTypes.SETTING)
		imageData?.setColor(color: UIColor.yellow)
		imageData?.setColor(color: UIColor.red)
		imageData?.setColor(color: UIColor.blue)
		imageData?.setPen(size: 10.0)
	}
	/// ナビゲーションバーを非表示
	override func viewWillAppear(_ animated: Bool) {
		navigationController?.setNavigationBarHidden(true, animated: false)
	}
	/// ImageEditorを離れる時に、ImageListControllerを更新
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.imageData?.loadImage()
		let prevVC = self.getPreviousViewController() as! ImageListController
		prevVC.updateView()
	}
	/// 画面回転時に呼び出される
	override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval){
		// スクロールビューのサイズを決定
		scrollView.frame = CGRect(x:0,y:0,width:self.view.frame.width,height:self.view.frame.height)
		// ツールバーのサイズを決定
		myToolbar.frame = CGRect(x:0, y:self.view.bounds.size.height - 40, width:self.view.bounds.size.width, height:40.0)
		// ツールバーの位置を決定
		myToolbar.layer.position = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height-20.0)
		// メニューボタンの位置を決定
		menuButton.center = CGPoint(x: self.view.frame.width - 40, y: self.view.frame.height-80)
		// imageViewのサイズを調整
		adjustSize(imageView:self.imageView!)
		// レイヤーピッカービューを更新
		updateLayerPickerView()
	}
	/// imageViewのサイズを回転後の画面サイズに合わせて調整
	func adjustSize(imageView:UIView){
		// imageViewのサイズを調整
		imageViewRatio = self.view.frame.width / imageView.bounds.width
		let fWidth = imageView.frame.width * imageViewRatio
		let fHeight = imageView.frame.height * imageViewRatio
		imageView.frame = CGRect(x:0,y:0,width:fWidth,height:fHeight)
		imageView.center = self.view.center
		// レイヤーのサイズ、レイヤー上のアイテムのサイズを調整
		for layer in imageView.subviews{
			adjustItemSize(layer: layer,imageViewSize:imageView.bounds)
		}
	}
	/// imageViewのサイズを回転後の画面サイズに合わせて調整
	func adjustItemSize(layer:UIView,imageViewSize:CGRect){
		let layerCenter:CGPoint = layer.center
		layer.frame = imageViewSize
		// レイヤー上のアイテムのサイズを調整
		for item in layer.subviews{
			let vectorX:CGFloat = (layerCenter.x - item.center.x) * imageViewRatio
			let vectorY:CGFloat = (layerCenter.y - item.center.y) * imageViewRatio
			adjustItemToScreenSize(item:item,latio: imageViewRatio)
			item.center = CGPoint(x:layer.center.x - vectorX,y:layer.center.y - vectorY)
			for resizeIcon in item.subviews{
				if((resizeIcon.tag & DataManager.TagIDs.Rect.rawValue) == DataManager.TagIDs.Rect.rawValue){
					let selectAreaView = resizeIcon as! SelectAreaView
					selectAreaView.changeFrame(frame: item.bounds)
				}else{
					let iconSize:CGFloat = 40.0
					let posX = item.frame.width + iconSize / 2
					let posY = item.frame.height / 2 - iconSize / 2
					resizeIcon.frame = CGRect(x:posX,y:posY,width:iconSize,height:iconSize)
				}
			}
		}
	}
	/// スクリーンサイズを変更するための変更率を決定
	/// Iphone7のスクリーンサイズをベースにする
	private func getScreenRatio() -> CGFloat {
		let baseScreenWidth : CGFloat = 375.0
		print("ImageEditor - getScreenRatio - UIScreen.main.bounds.size.width:",UIScreen.main.bounds.size.width)
		return UIScreen.main.bounds.size.width / baseScreenWidth
	}
	/// imageViewを初期化
	func initView(imageView:UIView){
		imageViewRatio = self.view.frame.width / imageView.frame.width
		print("ImageEditor - initView - imageView.frame",imageView.frame as Any)
		let fwidth:CGFloat = imageView.frame.width * imageViewRatio
		let fheight:CGFloat = imageView.frame.height * imageViewRatio
		imageView.frame = CGRect(x:0,y:0,width:fwidth,height:fheight)
		imageView.center = self.view.center
		print("ImageEditor - initView - imageView.frame",imageView.frame as Any)
		for layer in imageView.subviews {
			if layer.tag == -1{
				layer.removeFromSuperview()
			}
			for item in layer.subviews{
				// removed image from superview when tag is -1
				// because this image is dummy. ("noimage")
				if item.tag == -1{
					item.removeFromSuperview()
				}else if (item.tag & DataManager.TagIDs.TAG_MASK.rawValue) == DataManager.TagIDs.GPS.rawValue {
					print("ImageEditor - initView - tagGPS - view.tag:",item.tag)
					let label = item as! UILabel
					label.text = "現在地"
					if(gpsTag <= (item.tag & ~DataManager.TagIDs.TAG_MASK.rawValue)){
						gpsTag = (item.tag & ~DataManager.TagIDs.TAG_MASK.rawValue) + 1024
						print("ImageEditor - initVies - gpsTag:",gpsTag)
					}
				}else if(item.tag & DataManager.TagIDs.TAG_MASK.rawValue) == DataManager.TagIDs.CITY.rawValue {
					print("ImageEditor - initView - tagCity - view.tag:",item.tag)
					let label = item as! UILabel
					label.text = "CITY"
					if(cityTag <= (item.tag & ~DataManager.TagIDs.TAG_MASK.rawValue)){
						cityTag = (item.tag & ~DataManager.TagIDs.TAG_MASK.rawValue) + 1024
						print("ImageEditor - initVies - cityTag:",cityTag)
					}
				}else if(item.tag & DataManager.TagIDs.TAG_MASK.rawValue) == DataManager.TagIDs.FREE.rawValue {
					print("ImageEditor - initView - tagCity - view.tag:",item.tag)
					let label = item as! UILabel
					label.text = "テキスト"
					if(freeTag <= (item.tag & ~DataManager.TagIDs.TAG_MASK.rawValue)){
						freeTag = (item.tag & ~DataManager.TagIDs.TAG_MASK.rawValue) + 1024
						print("ImageEditor - initVies - cityTag:",freeTag)
					}
				}
			}
		}
	}
	var TextFont:UIBarButtonItem!
	var TextPosition:UIBarButtonItem!
	var TextColor:UIBarButtonItem!
	var TextEdit:UIBarButtonItem!
	var PenSize:UIBarButtonItem!
	var PenErase:UIBarButtonItem!
	var PenUndo:UIBarButtonItem!
	var PenRedo:UIBarButtonItem!
	var Color:UIBarButtonItem!
	var SelectedColor:UIBarButtonItem!
	var SelectedColorView:UIButton!
	/// ツールバーのアイテムを初期化
	func initToolBarItem(){
		let buttonSize: CGFloat = 25
		var SettingSave:UIBarButtonItem!
		var SettingCancel:UIBarButtonItem!
		var TextAdd:UIBarButtonItem!
		var TextDelete:UIBarButtonItem!
		var Layer:UIBarButtonItem!
		var Space:UIBarButtonItem!
		toolBar = [[UIBarButtonItem]]()
		let SettingSaveView = UIButton()
		SettingSaveView.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
		SettingSaveView.setImage(UIImage(named: "save_icon"), for: .normal)
		SettingSaveView.addTarget(self, action: #selector(onClickBarButton), for:.touchUpInside)
		SettingSaveView.tag = 1
		SettingSaveView.tintColor = UIColor.brown
		SettingSave = UIBarButtonItem(customView: SettingSaveView)
		let SettingCancelView = UIButton()
		SettingCancelView.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
		SettingCancelView.setImage(UIImage(named: "cancel_icon"), for: .normal)
		SettingCancelView.addTarget(self, action: #selector(onClickBarButton), for:.touchUpInside)
		SettingCancelView.tag = 2
		SettingCancel = UIBarButtonItem(customView: SettingCancelView)
		let PenSizeView = UIButton()
		PenSizeView.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
		PenSizeView.setImage(UIImage(named: "size_icon"), for: .normal)
		PenSizeView.addTarget(self, action: #selector(onClickBarButton), for:.touchUpInside)
		PenSizeView.tag = 3
		PenSize = UIBarButtonItem(customView: PenSizeView)
		let PenEraseView = UIButton()
		PenEraseView.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
		PenEraseView.setImage(UIImage(named: "erase_icon"), for: .normal)
		PenEraseView.addTarget(self, action: #selector(onClickBarButton), for:.touchUpInside)
		PenEraseView.tag = 4
		PenErase = UIBarButtonItem(customView: PenEraseView)
		let PenUndoView = UIButton()
		PenUndoView.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
		PenUndoView.setTitle("Undo", for: .normal)
		PenUndoView.addTarget(self, action: #selector(onClickBarButton), for:.touchUpInside)
		PenUndoView.tag = 5
		PenUndo = UIBarButtonItem(customView: PenUndoView)
		let PenRedoView = UIButton()
		PenRedoView.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
		PenRedoView.setTitle("Redo", for: .normal)
		PenRedoView.addTarget(self, action: #selector(onClickBarButton), for:.touchUpInside)
		PenRedoView.tag = 6
		PenRedo = UIBarButtonItem(customView: PenRedoView)
		let TextFontView = UIButton()
		TextFontView.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
		TextFontView.setImage(UIImage(named: "font_icon"), for: .normal)
		TextFontView.addTarget(self, action: #selector(onClickBarButton), for:.touchUpInside)
		TextFontView.tag = 7
		TextFont = UIBarButtonItem(customView: TextFontView)
		let TextPositionView = UIButton()
		TextPositionView.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
		TextPositionView.setImage(UIImage(named: "position_icon"), for: .normal)
		TextPositionView.addTarget(self, action: #selector(onClickBarButton), for:.touchUpInside)
		TextPositionView.tag = 8
		TextPosition = UIBarButtonItem(customView: TextPositionView)
		let TextAddView = UIButton()
		TextAddView.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
		TextAddView.setImage(UIImage(named: "text_icon"), for: .normal)
		TextAddView.addTarget(self, action: #selector(onClickBarButton), for:.touchUpInside)
		TextAddView.tag = 9
		TextAdd = UIBarButtonItem(customView: TextAddView)
		let TextDeleteView = UIButton()
		TextDeleteView.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
		TextDeleteView.setImage(UIImage(named: "delete_icon"), for: .normal)
		TextDeleteView.addTarget(self, action: #selector(onClickBarButton), for:.touchUpInside)
		TextDeleteView.tag = 10
		TextDelete = UIBarButtonItem(customView: TextDeleteView)
		let TextColorView = UIButton()
		TextColorView.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
		TextColorView.setImage(UIImage(named: "color_icon"), for: .normal)
		TextColorView.addTarget(self, action: #selector(onClickBarButton), for:.touchUpInside)
		TextColorView.tag = 11
		TextColor = UIBarButtonItem(customView: TextColorView)
		let TextEditView = UIButton()
		TextEditView.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
		TextEditView.setTitle("Edit", for: .normal)
		TextEditView.addTarget(self, action: #selector(onClickBarButton), for:.touchUpInside)
		TextEditView.tag = 12
		let ColorView = UIButton()
		ColorView.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
		ColorView.setImage(UIImage(named: "color_icon"), for: .normal)
		ColorView.addTarget(self, action: #selector(onClickBarButton), for:.touchUpInside)
		ColorView.tag = 13
		Color = UIBarButtonItem(customView: ColorView)
		SelectedColorView = UIButton()
		SelectedColorView.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
		SelectedColorView.backgroundColor = UIColor.green
		SelectedColorView.layer.cornerRadius = buttonSize/2
		SelectedColor = UIBarButtonItem(customView: SelectedColorView)
		let LayerView = UIButton()
		LayerView.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
		LayerView.setImage(UIImage(named: "layer_icon"), for: .normal)
		LayerView.addTarget(self, action: #selector(onClickBarButton), for:.touchUpInside)
		LayerView.tag = 14
		Layer = UIBarButtonItem(customView: LayerView)
		Space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
		self.toolBar.append([SettingSave,Space,SettingCancel])
		self.toolBar.append([SettingSave,Space,SettingCancel])
		self.toolBar.append([PenSize,PenErase,Color,PenUndo,PenRedo,Space,Layer])
		self.toolBar.append([TextAdd,Space,TextFont,Space,TextPosition,Space,TextColor,Space,TextDelete,Space,Layer])
		self.toolBar.append([Color,SelectedColor,Space,Layer])
		self.toolBar.append([Space])
		print("ImageEditor - initToolBarItem")
	}

	func enableToolBarItem(enable:Bool){
		TextFont.isEnabled = enable
		TextPosition.isEnabled = enable
		TextColor.isEnabled = enable
	}
	/// 以下、デリゲート
	/// 選択されたサブメニューを取得
	func selectedSubMenu(state: DataManager.MenuTypes) {
		if state == DataManager.MenuTypes.SETTING{
			setSetting()
		}else if state == DataManager.MenuTypes.PEN{
			setPen()
		}else if state == DataManager.MenuTypes.TEXT{
			setText()
		}else if state == DataManager.MenuTypes.COLOR{
			setColor()
		}else if state == DataManager.MenuTypes.DUMMY{
			setDUMMY()
		}
	}
	/// 以下、デリゲートによって選択されたメニュー毎の処理
	/// FontPickerViewControllerで選択されたフォントをラベルに設定
	func selectedFont(state: UILabel){
		for layer in (self.imageView?.subviews)! {
			for item in layer.subviews {
				// subview has a resize icon.
				if(item.subviews.count != 0){
					let center:CGPoint = item.center
					/// TODO:
					/// サイズ調整
					print("ImageEditor - selectedFont - 1subview.frame:",item.frame,"subview.center",item.center)
					adjustTextWithFont(textLabel: item as! UILabel, font: state)
					//(subview as! UILabel).font  = UIFont(name: state.font.fontName,size:(subview as! UILabel).font.pointSize)
						print("ImageEditor - selectedFont - 2subview.frame:",item.frame,"subview.center",item.center)
					item.center = center
					print("ImageEditor - selectedFont - 3subview.frame:",item.frame,"subview.center",item.center)
					//(subview as! UILabel).sizeToFit()
				}
			}
		}
		// レイヤーピッカービューを更新
		updateLayerPickerView()
		print("ImageEditor - selectedFont - fontName:",state.font.fontName)
	}
	/// ColorPickerViewControllerで選択されたカラーをラベルに設定
	func selectedColor(state: UIColor) {
		for layer in (self.imageView?.subviews)! {
			for subview in layer.subviews {
				// subview has a resize icon.
				if(subview.subviews.count != 0){
						(subview as! UILabel).textColor = state
				}
			}
		}
		imageData?.setColor(color: state)
		//print(imageData?.getColor(index: 0), imageData?.getColor(index: 1),imageData?.getColor(index: 2))
		SelectedColorView.backgroundColor = state
		// レイヤーピッカービューを更新
		updateLayerPickerView()
		print("ImageEditor - selectedColor - UIColor:",state)
	}
	func selectedPen(size: CGFloat) {
		imageData?.setPen(size: size)
		print("ImageEditor - selectedPen - size:",size)
	}
	func selectedText(state: Int) {
		switch state {
		case 0:
			setFREE(imageView: self.imageView!)
			print("ImageEditor - selectedText - Free Text")
		case 1:
			setGPS(imageView: self.imageView!)
			print("ImageEditor - selectedText - GPS")
		case 2:
			setCITY(imageView: self.imageView!)
			print("ImageEditor - selectedText - GPS(city)")
		default:
			print("ImageEditor - selectedText - default")
		}
		print("ImageEditor - selectedText - state:",state)
	}
	/// LayerPickerViewControllerで選択されたレイヤーをラベルに設定
	func selectedLayer(num: Int) {
		print("ImageEditor - selectedLayer - num:",num)
		selectedLayerNumber = num
	}
	/// 表示・非表示を切り替えるレイヤーの番号を取得
	func changeVisibleLayer(num: Int) {
		print("ImageEditor - switchLayer - num:",num)
		changeVisible(layer: (imageView?.subviews[num])!)
	}
	/// レイヤーの表示・非表示、切り替え
	func changeVisible(layer: UIView) {
		if(layer.isHidden){
			layer.isHidden = false
		}else{
			layer.isHidden = true
		}
	}
	/// Settingをセット
	func setSetting(){
		imageData?.setMenuType(menutype: DataManager.MenuTypes.SETTING)
		myToolbar.items = toolBar[1]
		print("ImageEditor - setSetting");
	}
	/// Penをセット
	func setPen(){
		var isSelected:Bool = false
		imageData?.setMenuType(menutype: DataManager.MenuTypes.PEN)
		myToolbar.items = toolBar[2]
		for layer in (imageView?.subviews)!{
			if(layer.tag == DataManager.MenuTypes.PEN.rawValue){
				print("ImageEditor - setPen - layer is selected")
				isSelected = true
				break
			}
		}
		if(!isSelected){
			let canvas = UIImageView(frame:(imageView?.bounds)!)
			canvas.backgroundColor = UIColor.clear
			canvas.tag = DataManager.MenuTypes.PEN.rawValue
			canvas.image = UIImage()
			imageView?.addSubview(canvas)
			
			saveImageArray = [UIImage]()
			saveImageArray.append(canvas.image!)
			print("ImageEditor - setPen - make new canvas")
		}
		print("ImageEditor - setPen");
	}
	/// Textをセット
	func setText(){
		imageData?.setMenuType(menutype: DataManager.MenuTypes.TEXT)
		myToolbar.items = toolBar[3]
		enableToolBarItem(enable: false)
		print("ImageEditor - setText");
	}
	/// Colorをセット
	func setColor(){
		for layer in (self.imageView?.subviews)!{
			for item in layer.subviews{
				self.clearEmphasisSelectedItem(selectedView: item)
			}
		}
		imageData?.setMenuType(menutype: DataManager.MenuTypes.COLOR)
		myToolbar.items = toolBar[4]
		print("ImageEditor - setColor");
	}
	/// ダミーをセット
	func setDUMMY(){
		imageData?.setMenuType(menutype: DataManager.MenuTypes.DUMMY)
		myToolbar.items = toolBar[5]
		print("ImageEditor - setDummy");
	}
	var freeTag = 1024
	func setFREE(imageView:UIView){
		print("ImageEditor - setFREE");
		let layer = UIView(frame:imageView.bounds)
		layer.tag = DataManager.MenuTypes.TEXT.rawValue
		let GPSlabel = UILabel()
		// 文字追加
		let str2 = "テキスト"
		let pointSize : CGFloat = 120
		let font = UIFont.boldSystemFont(ofSize: pointSize)
		let width = str2.size(withAttributes: [NSAttributedStringKey.font : font])
		let labelWidth : CGFloat = 250
		GPSlabel.font = UIFont.boldSystemFont(ofSize: pointSize * getScreenRatio() * labelWidth / width.width)
		GPSlabel.text = str2
		// 文字サイズに合わせてラベルのサイズを調整
		GPSlabel.sizeToFit()
		// ラベルをviewの中心に移動
		GPSlabel.center = layer.center
		GPSlabel.tag = freeTag + DataManager.TagIDs.FREE.rawValue
		print("ImageEditor - setGPSLabel - tag",GPSlabel.tag);
		freeTag += 1024
		layer.addSubview(GPSlabel)
		imageView.addSubview(layer)
		if(selectedLayerNumber == -1){
			for layer in imageView.subviews{
				for item in layer.subviews{
					self.clearEmphasisSelectedItem(selectedView: item)
				}
			}
			self.emphasisSelectedItem(selectedView: GPSlabel)
		}
		// ツールバーのアイテムを有効化
		enableToolBarItem(enable: true)
		// レイヤーピッカービューを更新
		updateLayerPickerView()
	}
	/// ImageViewに追加するアイテムがGPSの場合、
	/// GPSタグ = 1024の整数倍 ＋ 0x001 (typeGPS:　アイテムの種類がGPSであることを示す値)
	var gpsTag = 1024
	/// GPSをセット
	func setGPS(imageView:UIView){
		print("ImageEditor - setGPS");
		let layer = UIView(frame:imageView.bounds)
		layer.tag = DataManager.MenuTypes.TEXT.rawValue
		let GPSlabel = UILabel()
		// 文字追加
		let str2 = "現在地"
		let pointSize : CGFloat = 120
		let font = UIFont.boldSystemFont(ofSize: pointSize)
		let width = str2.size(withAttributes: [NSAttributedStringKey.font : font])
		let labelWidth : CGFloat = 250
		GPSlabel.font = UIFont.boldSystemFont(ofSize: pointSize * getScreenRatio() * labelWidth / width.width)
		GPSlabel.text = str2
		// 文字サイズに合わせてラベルのサイズを調整
		GPSlabel.sizeToFit()
		// ラベルをviewの中心に移動
		GPSlabel.center = layer.center
		GPSlabel.tag = gpsTag + DataManager.TagIDs.GPS.rawValue
		print("ImageEditor - setGPSLabel - tag",GPSlabel.tag);
		gpsTag += 1024
		layer.addSubview(GPSlabel)
		imageView.addSubview(layer)
		if(selectedLayerNumber == -1){
			for layer in imageView.subviews{
				for item in layer.subviews{
					self.clearEmphasisSelectedItem(selectedView: item)
				}
			}
			self.emphasisSelectedItem(selectedView: GPSlabel)
		}
		// ツールバーのアイテムを有効化
		enableToolBarItem(enable: true)
		// レイヤーピッカービューを更新
		updateLayerPickerView()
	}
	var cityTag = 1024
	/// GPSをセット
	func setCITY(imageView:UIView){
		print("ImageEditor - setGPS");
		let layer = UIView(frame:imageView.bounds)
		layer.tag = DataManager.MenuTypes.TEXT.rawValue
		let GPSlabel = UILabel()
		// 文字追加
		let str2 = "CITY"
		let pointSize : CGFloat = 120
		let font = UIFont.boldSystemFont(ofSize: pointSize)
		let width = str2.size(withAttributes: [NSAttributedStringKey.font : font])
		let labelWidth : CGFloat = 250
		GPSlabel.font = UIFont.boldSystemFont(ofSize: pointSize * getScreenRatio() * labelWidth / width.width)
		GPSlabel.text = str2
		// 文字サイズに合わせてラベルのサイズを調整
		GPSlabel.sizeToFit()
		// ラベルをviewの中心に移動
		GPSlabel.center = layer.center
		GPSlabel.tag = gpsTag + DataManager.TagIDs.CITY.rawValue
		print("ImageEditor - setGPSLabel - tag",GPSlabel.tag);
		cityTag += 1024
		layer.addSubview(GPSlabel)
		imageView.addSubview(layer)
		if(selectedLayerNumber == -1){
			for layer in imageView.subviews{
				for item in layer.subviews{
					self.clearEmphasisSelectedItem(selectedView: item)
				}
			}
			self.emphasisSelectedItem(selectedView: GPSlabel)
		}
		// ツールバーのアイテムを有効化
		enableToolBarItem(enable: true)
		// レイヤーピッカービューを更新
		updateLayerPickerView()
	}
	/// Future functions
	/// Imageをセット
	func setPicture(){
		print("ImageEditor - setPicture");
		//self.navigationController?.setNavigationBarHidden(false, animated: false)
		//self.navigationController?.popViewController(animated: true)
	}
	/// Stampをセット
	func setStamp(){
		print("ImageEditor - setStamp");
	}
	/// Timeをセット
	func setTime(){
		print("ImageEditor - setTime");
	}
	/// Dateをセット
	func setDate(){
		print("ImageEditor - setDate");
	}
	/// 以下、ツールバーのアクション
	///
	/// - Parameter sender: ツールバーのボタンを取得
	@objc func onClickBarButton(sender: UIBarButtonItem) {
		switch sender.tag {
		case 1:
			print("ImageEditor - onClickBarButton - SettingSave")
			displaySaveAlert(imageView:self.imageView!)
		case 2:
			print("ImageEditor - onClickBarButton - SettingCancel")
			displayCancelAlert()
		case 3:
			print("ImageEditor - onClickBarButton - PenSize")
			displayPenPicker()
		case 4:
			print("ImageEditor - onClickBarButton - PenErase:")
		case 5:
			print("ImageEditor - onClickBarButton - PenUndo")
			undoImage()
		case 6:
			print("ImageEditor - onClickBarButton - PenRedo")
			redoImage()
		case 7:
			print("ImageEditor - onClickBarButton - TextFont")
			displayFontSelector()
		case 8:
			print("ImageEditor - onClickBarButton - TextPosition")
			adjustItemPositionCenter(imageView:self.imageView!)
		case 9:
			print("ImageEditor - onClickBarButton - TextAdd")
			//setGPS(imageView:self.imageView!)
			displayTextSelector()
		case 10:
			print("ImageEditor - onClickBarButton - TextDelete")
			removeItemFromLayer(imageView:self.imageView!)
		case 11:
			print("ImageEditor - onClickBarButton - TextColor")
			displayColorPalet()
		case 12:
			print("ImageEditor - onClickBarButton - TextEdit")
			displayTextEditor()
		case 13:
			print("ImageEditor - onClickBarButton - Color")
			displayColorPalet()
		case 14:
			print("ImageEditor - onClickBarButton - Layer")
			displayLayerSelector()
		default:
			print("ImageEditor - onClickBarButton - DUMMY")
		}
	}
	/// 以下、ツールバーで選択されたボタン毎の処理
	/// 作成したImageを保存して終了するためのアラートを表示
	func displaySaveAlert(imageView:UIView) {
		// UIAlertControllerクラスのインスタンスを生成
		// タイトル, メッセージ, Alertのスタイルを指定
		// 第3引数のpreferredStyleでアラートの表示スタイルを指定
		let alert: UIAlertController = UIAlertController(
			title: "イメージ",
			message: "保存して終了しますか？",
			preferredStyle:  UIAlertControllerStyle.alert)
		// Actionの設定
		// Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定
		// 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
		// OKボタン
		let defaultAction: UIAlertAction = UIAlertAction(
			title: "OK",
			style: UIAlertActionStyle.default,
			handler:{
			// ボタンが押された時（クロージャ実装）
			(action: UIAlertAction!) -> Void in
			print("ImageEditor - dispCancelAlert - SaveAlert: OK")
			// 拡大、縮小されたimageViewを元のサイズに変更
			self.imageView?.transform = CGAffineTransform.identity
			for layer in imageView.subviews{
				layer.isHidden = false
				for item in layer.subviews{
					self.clearEmphasisSelectedItem(selectedView: item)
				}
			}
			self.imageData?.updateImage(id: self.delegateParamId, view: imageView)
			// ImageListControllerを更新
			let prevVC = self.getPreviousViewController() as! ImageListController
			prevVC.updateView()
			self.navigationController?.setNavigationBarHidden(false, animated: false)
			self.navigationController?.popViewController(animated: true)
		})
		// キャンセルボタン
		let cancelAction: UIAlertAction = UIAlertAction(
			title: "キャンセル",
			style: UIAlertActionStyle.cancel,
			handler:{
			// ボタンが押された時（クロージャ実装）
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
	func displayCancelAlert() {
		// UIAlertControllerクラスのインスタンスを生成
		// タイトル, メッセージ, Alertのスタイルを指定
		// 第3引数のpreferredStyleでアラートの表示スタイルを指定
		let alert: UIAlertController = UIAlertController(
			title: "イメージ",
			message: "保存せず終了してもいいですか？",
			preferredStyle:  UIAlertControllerStyle.alert)
		// Actionの設定
		// Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定
		// 第3引数のUIAlertActionStyleでボタンのスタイルを指定
		// OKボタン
		let defaultAction: UIAlertAction = UIAlertAction(
			title: "OK",
			style: UIAlertActionStyle.default,
			handler:{
			// ボタンが押された時の処理（クロージャ実装）
			(action: UIAlertAction!) -> Void in
			print("ImageEditor - dispCancelAlert - CancelAlert: OK")
			self.navigationController?.setNavigationBarHidden(false, animated: false)
			self.navigationController?.popViewController(animated: true)
			})
		// キャンセルボタン
		let cancelAction: UIAlertAction = UIAlertAction(
			title: "キャンセル",
			style: UIAlertActionStyle.cancel,
			handler:{
			// ボタンが押された時の処理（クロージャ実装）
			(action: UIAlertAction!) -> Void in
			print("ImageEditor - dispCancelAlert - CancelAlert: Cancel")
			})
		// UIAlertControllerにActionを追加
		alert.addAction(cancelAction)
		alert.addAction(defaultAction)
		// Alertを表示
		present(alert, animated: true, completion: nil)
	}
	/// ペンピッカーを表示
	func displayPenPicker() {
		print("ImageEditor - displayPenPicker")		
		penPickerView = PenPickerViewController()
		penPickerView.delegate = self
		penPickerView.setPen(size: (imageData?.getPen())!)
		self.view.addSubview(penPickerView.view)
		self.addChildViewController(penPickerView)
		penPickerView.didMove(toParentViewController: self)
	}
	/// 画像をアンドゥー
	func undoImage(){
		if(currentDrawNumber-1 >= 0){
		var canvas:UIImageView!
		canvas = UIImageView()
		print("ImageEditor - undoImage")
		for layer in (imageView?.subviews)!{
			if(layer.tag == DataManager.MenuTypes.PEN.rawValue){
				canvas = layer as! UIImageView
				break
			}
		}
		
		canvas.image = saveImageArray[currentDrawNumber-1]
		currentDrawNumber -= 1
		lastDrawImage = saveImageArray[currentDrawNumber]
			print("ImageEditor - undoImage - currentDrawNumber",currentDrawNumber)
		}
	}
	/// 画像をリドゥー
	func redoImage(){
		if(currentDrawNumber+1 < saveImageArray.count){
		var canvas:UIImageView!
		canvas = UIImageView()
		print("ImageEditor - redoImage")
		for layer in (imageView?.subviews)!{
			if(layer.tag == DataManager.MenuTypes.PEN.rawValue){
				canvas = layer as! UIImageView
				break
			}
		}
		
		canvas.image = saveImageArray[currentDrawNumber+1]
		currentDrawNumber += 1
		lastDrawImage = saveImageArray[currentDrawNumber]
		print("ImageEditor - redoImage - currentDrawNumber",currentDrawNumber)
		}
	}
	/// カラーパレットを表示
	func displayColorPalet(){
		print("ImageEditor - displayColorPalet")
		if(fontPickerView != nil){
			hideContentController(content:fontPickerView)
		}
		if(colorPickerView != nil){
			hideContentController(content:colorPickerView)
		}
		colorPickerView = ColorPickerViewController()
		colorPickerView.delegate = self
//		colorPickerView.setColor(color: SelectedColorView.backgroundColor!)
		let first:UIColor = (imageData?.getColor(index: 0))!
		let second:UIColor = (imageData?.getColor(index: 1))!
		let third:UIColor = (imageData?.getColor(index: 2))!
		colorPickerView.setColor(color: first, first: first, second: second, third: third)
		self.view.addSubview(colorPickerView.view)
		self.addChildViewController(colorPickerView)
		colorPickerView.didMove(toParentViewController: self)
	}
	/// 文字フォントを選択するピッカーを表示
	func displayFontSelector(){
		print("ImageEditor - displayFontSelector")
		if(fontPickerView != nil){
			hideContentController(content:fontPickerView)
		}
		if(colorPickerView != nil){
			hideContentController(content:colorPickerView)
		}
		fontPickerView = FontPickerViewController()
		fontPickerView.delegate = self
		self.view.addSubview(fontPickerView.view)
		self.addChildViewController(fontPickerView)
		fontPickerView.didMove(toParentViewController: self)
	}
	func displayTextSelector(){
		print("ImageEditor - onClickBarButton - displayTextSelector")
		textPickerView = TextPickerViewController()
		textPickerView.delegate = self
		self.view.addSubview(textPickerView.view)
		self.addChildViewController(textPickerView)
		textPickerView.didMove(toParentViewController: self)
	}
	func displayTextEditor(){
		print("ImageEditor - onClickBarButton - displayTextEditor")
	}
	/// レイヤー選択画面を表示
	func displayLayerSelector(){
		print("ImageEditor - onClickBarButton - Color")
		if(layerPickerView != nil){
			hideContentController(content:layerPickerView)
		}
		layerPickerView = LayerPickerViewController()
		layerPickerView.delegate = self
		layerPickerView.setImageView(view: imageView!)
		//self.view.addSubview(layerPickerView.view)
		//self.addChildViewController(layerPickerView)
		displayContentController(content: layerPickerView, container: self.view)
		//layerPickerView.didMove(toParentViewController: self)
		if(selectedLayerNumber != -1){
			let indexpath: IndexPath = IndexPath(row: selectedLayerNumber, section: 0)
			layerPickerView.tableView.selectRow(at: indexpath, animated: false, scrollPosition: .none)
			layerPickerView.indexpath = indexpath
		}
	}
	// 選択されたアイテムをレイヤーから削除
	func removeItemFromLayer(imageView:UIView){
		print("ImageEditor - removeItemFromLayer");
		for (index,layer) in imageView.subviews.enumerated(){
			for item in layer.subviews{
				print("ImageEditor - remoceItemFromLayer - index:",index)
				let indexpath: IndexPath = IndexPath(row: selectedLayerNumber, section: 0)
				if((index == indexpath.row) || (indexpath.row == -1)){
					if(!layer.isHidden){
						print("ImageEditor - remoceItemFromLayer - indexpath:",indexpath)
						if(item.subviews.count != 0){
							item.removeFromSuperview()
							if(layer.subviews.count == 0){
								layer.removeFromSuperview()
								if(selectedLayerNumber != -1){
									layerPickerView.tableView.deselectRow(at: indexpath, animated: false)
									layerPickerView.indexpath = nil
									selectedLayerNumber = -1
								}
							}
						}
					}
				}
			}
		}
		// ツールバーのアイテムを無効化
		enableToolBarItem(enable: false)
		// レイヤーピッカービューを更新
		updateLayerPickerView()
	}
	/// アイテムの位置をviewの中心に移動
	func adjustItemPositionCenter(imageView:UIView){
		print("ImageEditor - adjustPositionCenter");
		for layer in imageView.subviews{
			for item in layer.subviews{
				if(item.subviews.count != 0){
					print("ImageEditor - item.center",item.center);
					item.center = (self.imageView?.bounds.center)!
					print("ImageEditor - item.center",item.center);
					// レイヤーピッカービューを更新
					updateLayerPickerView()
				}
			}
		}
	}
	/// TODO:
	/// Imageを編集し保存後、再編集するとTagの番号が誤って追加される
	/// タッチした座標にあるimageView上のアイテムを管理
	var tagList = [Int]()
	/// PENツール用パス
	var bezierPath:UIBezierPath!
	var lastDrawImage:UIImage!
	var saveImageArray:[UIImage]!
	var currentDrawNumber = 0
	@objc func handleTapGesture(sender: UITapGestureRecognizer){
		print("ImageEditor - handleTapGesture")
		let location:CGPoint = sender.location(in: self.imageView)
		if(imageData?.getMenuType() == DataManager.MenuTypes.COLOR){
			tagList.removeAll()
			var isSelected = false
			var imageView:[UIView]!
			// 全てのレイヤーが選択状態の場合　-1
			if(selectedLayerNumber == -1){
				imageView = self.imageView?.subviews
			}else{
				imageView = [(self.imageView?.subviews[selectedLayerNumber])!]
			}
			for layer in imageView {
				if(!layer.isHidden){
					for item in layer.subviews {
						// imageView上のアイテムが選択された時の処理
						if (item.frame.contains(location)) {
							if(item.tag & DataManager.TagIDs.ITEM_MASK.rawValue == DataManager.TagIDs.GPS.rawValue ||
								item.tag & DataManager.TagIDs.ITEM_MASK.rawValue == DataManager.TagIDs.CITY.rawValue ||
								item.tag & DataManager.TagIDs.ITEM_MASK.rawValue == DataManager.TagIDs.FREE.rawValue){
								let label:UILabel = item as! UILabel
								label.textColor = SelectedColorView.backgroundColor!
								isSelected = true
							}
						}
					}
				}
			}
			if(!isSelected){
				if(self.imageView?.bounds.contains(location))!{
					self.imageView?.backgroundColor = SelectedColorView.backgroundColor!
				}
			}
		}else if(imageData?.getMenuType() == DataManager.MenuTypes.TEXT){
			tagList.removeAll()
			// タッチされた座標の位置を含むサブビューを取得
			var imageView:[UIView]!
			var isSelected: Bool = false
			// 選択されたレイヤーをviewに設定
			// 全てのレイヤーが選択状態の場合　-1
			if(selectedLayerNumber == -1){
				imageView = self.imageView?.subviews
			}else{
				imageView = [(self.imageView?.subviews[selectedLayerNumber])!]
			}
			for layer in imageView {
				if(!layer.isHidden){
					if(selectedItem(layer: layer, location: location)){
						isSelected = true
					}
				}
			}
			enableToolBarItem(enable: isSelected)
		}else if(imageData?.getMenuType() == DataManager.MenuTypes.PEN){
			bezierPath = UIBezierPath()
			let pointSize:CGFloat = (imageData?.getPen())!
			bezierPath.addArc(withCenter: location, radius: pointSize/2, startAngle: 0.0, endAngle: CGFloat(Double.pi)*2, clockwise: true)
			drawPoint(path: bezierPath)
			var canvas:UIImageView!
			canvas = UIImageView()
			for layer in (imageView?.subviews)!{
				if(layer.tag == DataManager.MenuTypes.PEN.rawValue){
					canvas = layer as! UIImageView
					break
				}
			}
			currentDrawNumber += 1
			saveImageArray.append(canvas.image!)
			//lastDrawImage = canvas.image
			lastDrawImage = saveImageArray[currentDrawNumber]
		}
	}
	/// imageView上のアイテムをタッチ、パンした時のアクションを定義
	///
	/// - Parameter sender: sender
	@objc func handlePanGesture(sender: UIPanGestureRecognizer){
		switch sender.state {
		case UIGestureRecognizerState.began:
			if(imageData?.getMenuType() == DataManager.MenuTypes.COLOR){
				tagList.removeAll()
			}else if(imageData?.getMenuType() == DataManager.MenuTypes.TEXT){
				tagList.removeAll()
				let location:CGPoint = sender.location(in: self.imageView)
				var imageView:[UIView]!
				var isSelected: Bool = false
				// 選択されたレイヤーをviewに設定
				// 全てのレイヤーが選択状態の場合　-1
				if(selectedLayerNumber == -1){
					imageView = self.imageView?.subviews
				}else{
					imageView = [(self.imageView?.subviews[selectedLayerNumber])!]
				}
				for layer in imageView {
					if(!layer.isHidden){
						if(selectedItem(layer: layer, location: location)){
							isSelected = true
						}
					}
				}
				enableToolBarItem(enable: isSelected)
			}else if(imageData?.getMenuType() == DataManager.MenuTypes.PEN){
				let location:CGPoint = sender.location(in: self.imageView)
				bezierPath = UIBezierPath()
				bezierPath.lineWidth = (imageData?.getPen())!
				bezierPath.move(to: location)
			}
			break
		case UIGestureRecognizerState.changed:
			if(imageData?.getMenuType() == DataManager.MenuTypes.TEXT){
				//移動量を取得
				let move:CGPoint = sender.translation(in: self.imageView)
				var imageView:[UIView]!
				// 選択されたレイヤーをviewに設定
				// 全てのレイヤーが選択状態の場合　-1
				if(selectedLayerNumber == -1){
					imageView = self.imageView?.subviews
					updatePosition(imageView:self.imageView!,tagList:tagList,move:move,sender: sender)
				}else{
					imageView = [(self.imageView?.subviews[selectedLayerNumber])!]
					for image in imageView{
						updatePosition(imageView:image,tagList:tagList,move:move,sender: sender)
					}
				}
				/// TODO:
				/// isHiddenを設定しなくても、判定できるようにする
				// レイヤーピッカービューを更新
				if(layerPickerView != nil){
					if(!layerPickerView.tableView.isHidden){
						updateLayerPickerView()
					}
				}
			}else if(imageData?.getMenuType() == DataManager.MenuTypes.PEN){
				if bezierPath != nil {
					let location:CGPoint = sender.location(in: self.imageView)
					bezierPath.addLine(to: location)
					drawLine(path: bezierPath)
				}
			}
			break
		case UIGestureRecognizerState.ended:
			if(imageData?.getMenuType() == DataManager.MenuTypes.PEN){
				let location:CGPoint = sender.location(in: self.imageView)
				bezierPath.addLine(to: location)
				drawLine(path: bezierPath)
				var canvas:UIImageView!
				canvas = UIImageView()
				for layer in (imageView?.subviews)!{
					if(layer.tag == DataManager.MenuTypes.PEN.rawValue){
						canvas = layer as! UIImageView
						break
					}
				}
				currentDrawNumber += 1
				saveImageArray.append(canvas.image!)
				//lastDrawImage = canvas.image
				lastDrawImage = saveImageArray[currentDrawNumber]
				print("ImageEditor - handlePanGesture - currentDrawNumber",currentDrawNumber)
			}
			break
		case UIGestureRecognizerState.cancelled:
			break
		default:
			break
		}
	}
	//　線を引く
	func drawLine(path:UIBezierPath){
		var canvas:UIImageView!
		canvas = UIImageView()
		for layer in (imageView?.subviews)!{
			if(layer.tag == DataManager.MenuTypes.PEN.rawValue){
				canvas = layer as! UIImageView
				break
			}
		}
		while currentDrawNumber != saveImageArray.count - 1 {
			saveImageArray.removeLast()
		}
		canvas.image = saveImageArray[currentDrawNumber]
		print("ImageEditor - drawLine - saveImageArray",currentDrawNumber)
		UIGraphicsBeginImageContext(canvas.frame.size)
		if lastDrawImage != nil {
			lastDrawImage.draw(at: CGPoint.zero)
		}
		let lineColor:UIColor = (imageData?.getColor(index: 0))!
		lineColor.setStroke()
		path.stroke()
		canvas.image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
	}
	func drawPoint(path:UIBezierPath){
		var canvas:UIImageView!
		canvas = UIImageView()
		for layer in (imageView?.subviews)!{
			if(layer.tag == DataManager.MenuTypes.PEN.rawValue){
				canvas = layer as! UIImageView
				break
			}
		}
		UIGraphicsBeginImageContext(canvas.frame.size)
		if lastDrawImage != nil {
			lastDrawImage.draw(at: CGPoint.zero)
		}
		let lineColor:UIColor = (imageData?.getColor(index: 0))!
		lineColor.setStroke()
		path.stroke()
		lineColor.setFill()
		path.fill()
		canvas.image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

	}
	/// 選択されたアイテムをジェスチャーに合わせて移動・サイズ変更
	func updatePosition(imageView:UIView,tagList:[Int],move:CGPoint,sender: UIPanGestureRecognizer){
		for tag:Int in tagList {
			let item:UIView = (self.imageView?.viewWithTag(tag))!
			if(tag & DataManager.TagIDs.Scale.rawValue == DataManager.TagIDs.Scale.rawValue){
				let textLavel = (self.imageView?.viewWithTag(tag & ~DataManager.TagIDs.Scale.rawValue))!
				self.resizeText(textLabel: textLavel as! UILabel, posX: item.frame)
				let moved = CGPoint(x: item.center.x + move.x, y: textLavel.frame.height / 2)
				item.center = moved
				sender.setTranslation(CGPoint.zero, in: item)
			}else if(tag & DataManager.TagIDs.ITEM_MASK.rawValue == DataManager.TagIDs.GPS.rawValue ||
				tag & DataManager.TagIDs.ITEM_MASK.rawValue == DataManager.TagIDs.CITY.rawValue ||
				tag & DataManager.TagIDs.ITEM_MASK.rawValue == DataManager.TagIDs.FREE.rawValue){
				let moved = CGPoint(x: item.center.x + move.x, y: item.center.y + move.y)
				item.center = moved
				sender.setTranslation(CGPoint.zero, in:item)
			}
		}
	}
	func selectedItem(layer:UIView,location:CGPoint) -> Bool{
		var isSelected:Bool = false
		for item in layer.subviews {
			// imageView上のアイテムが選択された時の処理
			if (item.frame.contains(location)) {
				// 選択されたアイテムのタグをタグリストに追加
				tagList.append(item.tag)
				print("ImageEditor - selectedItem - item.tag:",String(item.tag,radix:16))
				if(item.tag & DataManager.TagIDs.ITEM_MASK.rawValue == DataManager.TagIDs.GPS.rawValue ||
					item.tag & DataManager.TagIDs.ITEM_MASK.rawValue == DataManager.TagIDs.CITY.rawValue ||
					item.tag & DataManager.TagIDs.ITEM_MASK.rawValue == DataManager.TagIDs.FREE.rawValue){
					// 選択されたアイテムを強調
					var operateView:UIView!
					operateView = layer.viewWithTag(item.tag)
					self.emphasisSelectedItem(selectedView: operateView)
					isSelected = true
					myToolbar.items = toolBar[3]
				}else{
					/// TODO:
					/// 必要な処理を書く　なければ消す
				}
			}else{
				// リサイズアイコンが選択された時の処理
				var iconIsSelected:Bool = false
				for icon in item.subviews{
					var iconframe = icon.frame
					iconframe.origin.x += item.frame.origin.x
					iconframe.origin.y += item.frame.origin.y
					if(iconframe.contains(location)){
						tagList.append(icon.tag)
						print("ImageEditor - selectedItem - icon.tag:",String(icon.tag,radix:16))
						iconIsSelected = true
						isSelected = true
					}
				}
				if(iconIsSelected == false){
					// 選択されたアイテムの強調を削除
					var operateView:UIView!
					operateView = layer.viewWithTag(item.tag)
					self.clearEmphasisSelectedItem(selectedView: operateView)
				}
			}
		}
		return isSelected
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
		let bounds:CGRect = self.scrollView.bounds
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
	/// 以下、追加したラベルに関する処理
	/// 選択されたアイテムを強調
	/// 拡大・縮小アイコンを追加
	///
	/// - Parameter selectedView: 選択されたアイテム
	func emphasisSelectedItem(selectedView:UIView){
		if(selectedView.subviews.count == 0){
			let iconSize:CGFloat = 50.0
			let margine:CGFloat = 10.0
			let posX = selectedView.frame.width + margine
			let posY = selectedView.frame.height / 2 - iconSize / 2			
			let scaleButton = UIButton(frame:CGRect(x:posX,y:posY,width:iconSize,height:iconSize))
			scaleButton.setImage(UIImage(named: "resize_icon"), for: .normal)
			scaleButton.tag = selectedView.tag | DataManager.TagIDs.Scale.rawValue
			selectedView.addSubview(scaleButton)
			let frame = CGRect(x: 0,y: 0,width: selectedView.frame.width, height: selectedView.frame.height)
			let selectAreaView = SelectAreaView(frame: frame)
			selectAreaView.tag = selectedView.tag | DataManager.TagIDs.Rect.rawValue
			selectedView.addSubview(selectAreaView)
		}
	}
	/// 選択されたアイテムの強調を削除
	/// 拡大・縮小アイコンを削除
	///
	/// - Parameter selectedView: 選択されたアイテム
	func clearEmphasisSelectedItem(selectedView:UIView){
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
		let margine:CGFloat = 10.0
		let width = posX.origin.x - margine
		let refPointSize: CGFloat = 100.0
		let refFont = UIFont(name: textLabel.font.fontName,size:refPointSize)
		let refWidth = textLabel.text?.size(withAttributes: [NSAttributedStringKey.font : refFont!])
		textLabel.font = UIFont(name: textLabel.font.fontName,size: refPointSize * width / (refWidth?.width)!)
		// 文字サイズに合わせてラベルのサイズを調整
		textLabel.sizeToFit()
		for icon in textLabel.subviews{
			if((icon.tag & DataManager.TagIDs.Rect.rawValue) == DataManager.TagIDs.Rect.rawValue){
				let selectAreaView = icon as! SelectAreaView
				selectAreaView.changeFrame(frame: textLabel.bounds)
			}
		}
	}
	// フォントに合わせてテキストの幅を調整
	func adjustTextWithFont(textLabel:UILabel,font:UILabel){
		let refPointSize: CGFloat = 100.0
		let refFont = UIFont(name: font.font.fontName,size:refPointSize)
		let refWidth = textLabel.text?.size(withAttributes: [NSAttributedStringKey.font : refFont!])
		let width:CGFloat = textLabel.frame.width
		textLabel.font = UIFont(name: font.font.fontName,size: refPointSize * width / (refWidth?.width)!)
		// 文字サイズに合わせてラベルのサイズを調整
		textLabel.sizeToFit()
		for icon in textLabel.subviews{
			if((icon.tag & DataManager.TagIDs.Rect.rawValue) == DataManager.TagIDs.Rect.rawValue){
				let selectAreaView = icon as! SelectAreaView
				selectAreaView.changeFrame(frame: textLabel.bounds)
			}
		}
	}
	/// スクリーンサイズにアイテムのサイズを合わせて調整
	func adjustItemToScreenSize(item:UIView,latio:CGFloat){
		let refPointSize: CGFloat = 100.0
		let textLabel = item as! UILabel
		let refFont = UIFont(name: textLabel.font.fontName,size:refPointSize)
		let refWidth = textLabel.text?.size(withAttributes: [NSAttributedStringKey.font : refFont!])
		let itemWidth = textLabel.frame.width
		print("ImageEditor - adjustItemToScreenSize - refWidth:",
			  refWidth?.width as Any,
			  "itemWidth:",
			  itemWidth as Any,
			  "ratio:",
			  latio)
		textLabel.font = UIFont(name: textLabel.font.fontName,size:  refPointSize * itemWidth * latio / (refWidth?.width)!)
		textLabel.sizeToFit()
		for icon in textLabel.subviews{
			if((icon.tag & DataManager.TagIDs.Rect.rawValue) == DataManager.TagIDs.Rect.rawValue){
				let selectAreaView = icon as! SelectAreaView
				selectAreaView.changeFrame(frame: textLabel.bounds)
			}
		}
	}
	/// 以下、レイヤーピッカービューのコンテナに関する処理
	/// コンテナをスーパービューに追加
	func displayContentController(content:UIViewController, container:UIView){
		print("ImageEditor - displayContentController")
		//content.view.frame = container.bounds
		container.addSubview(content.view)
		addChildViewController(content)
		print("ImageEditor - displayContentController - didMove1:",content.isMovingToParentViewController)
		content.didMove(toParentViewController: self)
		print("ImageEditor - displayContentController - didMove2:",content.isMovingToParentViewController)
	}
	/// コンテナをスーパービューから削除
	func hideContentController(content:UIViewController){
		print("ImageEditor - hideContentController")
		content.willMove(toParentViewController: self)
		content.view.removeFromSuperview()
		content.removeFromParentViewController()
	}
	/// レイヤーピッカービューを更新
	func updateLayerPickerView(){
		// レイヤーピッカービューが表示されていれば更新
		if(layerPickerView != nil){
			layerPickerView.setImageView(view: imageView!)
			layerPickerView.updateTableView()
		}else{
			// layerPickerView is not displayed.
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
		// 実装ミスの場合、nilを返す
		return nil
	}
}

class SelectAreaView: UIView {
	let segmentSize: CGFloat = 4.0     // 点線の線のサイズ
	let gapSize: CGFloat = 4.0    // 点線の間のサイズ
	var myTimer: Timer! = nil
	var phaseCount: CGFloat = 0.0
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
	}
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = UIColor.clear
		myTimer = Timer.scheduledTimer(
			timeInterval: 0.1,
			target: self,
			selector: #selector(phaseChange),
			userInfo: nil,
			repeats: true)
	}
	deinit {
		if myTimer != nil {
			myTimer.invalidate()
			myTimer = nil
		}
	}
	@objc func phaseChange(timer: Timer) {
		phaseCount += 1.0
		if phaseCount >= segmentSize + gapSize {
			phaseCount = 0
		}
		self.setNeedsDisplay()
	}
	override func draw(_ rect: CGRect) {
		let path = UIBezierPath()
		UIColor.black.set()
		path.lineWidth = 1
		let dashPattern = [segmentSize, gapSize]
		path.setLineDash(dashPattern, count:2, phase:phaseCount)
		path.move(to: CGPoint.zero)
		path.addLine(to: CGPoint.init(x:self.frame.size.width,y: 0))
		path.addLine(to: CGPoint.init(x:self.frame.size.width,y: self.frame.size.height))
		path.addLine(to: CGPoint.init(x:0,y: self.frame.size.height))
		path.addLine(to: CGPoint.init(x:0,y: 0))
		path.stroke()
	}
	func changeFrame(frame: CGRect) {
		self.frame = frame
		self.setNeedsDisplay()
	}
}
