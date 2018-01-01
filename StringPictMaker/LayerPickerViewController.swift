//
//  LayerPickerViewController.swift
//  StringPictMaker
//
//  Created by 杉山智之 on 2017/12/10.
//  Copyright © 2017年 杉山智之. All rights reserved.
//

import Foundation
import UIKit

/// TODO:
/// ＊コレクションビューのレイアウト
/// ＊レイヤービューのリロードが正しく行われていない
/// ＊
/// ＊
/// ＊

/// Future:
/// ＊レイヤー毎の透過度変更バー追加
/// ＊
/// ＊
/// ＊

/// 選択されたレイヤーの番号をImageEditorに送付するデリゲートメソッド
protocol LayerPickerDelegate {
	// デリゲートメソッド定義
	// 選択されたレイヤーの番号をImageEditorに送る
	func selectedLayer(num:Int)
	// 表示・非表示を切り替えるレイヤーの番号をImageEditorに送る
	func changeVisibleLayer(num:Int)
}
/// レイヤーを選択するためのピッカービューコントローラ
class LayerPickerViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
	var delegate : LayerPickerDelegate!
	var imageView:UIView!
	var imageViewInEditor:UIView!
	/// ImageEditorからImageViewを取得
	func setImageView( view: UIView) {
		// ImageEditorから受け取ったImageViewをアーカイブ
		// 参照渡ししないようにするため
		let viewArchive = NSKeyedArchiver.archivedData(withRootObject: view)
		// アーカイブされたデータを元に戻す
		let unarchivedView = (NSKeyedUnarchiver.unarchiveObject(with: viewArchive as Data) as? UIView)!
		imageView = unarchivedView
		for layer in imageView.subviews{
			layer.isHidden = false
			for item in layer.subviews{
				clearEmphasisSelectedItem(selectedView: item)
			}
		}
		self.imageViewInEditor = view
		//self.imageView = view
	}
	// コレクションビューを生成
	var tableView : UITableView!
	var indexpath: IndexPath!
	var layerViewWidth:CGFloat!
	var layerViewHight:CGFloat!
	let margine:CGFloat = 5
	var tableViewWidth:CGFloat!
	var tableViewHight:CGFloat!
	let toolBarHight:CGFloat = 40
	let labelHeight:CGFloat = 20
	var imageWidth:CGFloat!
	var imageHeight:CGFloat!
	var closeButton:UIButton!
	let closeButtonSize:CGFloat = 30
	var selectAllLayerButton:UIButton!
	let selectAllButtonSize:CGFloat = 20
	override func viewDidLoad() {
		super.viewDidLoad()
		layerViewWidth = UIScreen.main.bounds.size.width * 0.3
		layerViewHight = UIScreen.main.bounds.height - toolBarHight
		tableViewWidth = layerViewWidth - margine*2
		tableViewHight = layerViewHight - margine*6 - closeButtonSize - selectAllButtonSize
		imageWidth = layerViewWidth - margine*2
		if(UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height){
			imageHeight = imageWidth * UIScreen.main.bounds.size.height / UIScreen.main.bounds.size.width
		}else{
			imageHeight = imageWidth * UIScreen.main.bounds.size.width / UIScreen.main.bounds.size.height
		}
		self.view.frame = CGRect(x:UIScreen.main.bounds.width - layerViewWidth,y:0,width:layerViewWidth,height:layerViewHight)
		self.view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
		indexpath = nil
		let frame = CGRect(x:margine,y:margine*3 + closeButtonSize,width:tableViewWidth,height:tableViewHight)
		print("LayerPickerViewController - viewDidLoad - frame:",frame)
		tableView = UITableView(frame:frame, style: .plain)
		tableView.register(LayerCell.self, forCellReuseIdentifier: "LayerCell_id")
		tableView.delegate = self
		tableView.dataSource = self
		tableView.backgroundColor = UIColor.gray
		tableView.rowHeight = labelHeight*2 + imageHeight
		tableView.isHidden = false
		self.view.addSubview(tableView)
		closeButton = UIButton()
		closeButton.frame = CGRect(x:margine,y:margine,width:closeButtonSize,height:closeButtonSize)
		closeButton.setImage(UIImage(named: "close_icon"), for: .normal)
		closeButton.addTarget(self, action: #selector(onClickEditButtons), for: UIControlEvents.touchUpInside)
		closeButton.tag = -2
		self.view.addSubview(closeButton)		
		selectAllLayerButton = UIButton(frame: CGRect(x:margine,y:layerViewHight - selectAllButtonSize - margine,width:tableViewWidth,height:selectAllButtonSize))
		selectAllLayerButton.setTitle("Select All", for: .normal)
		selectAllLayerButton.setTitleColor(UIColor.blue, for: .normal)
		selectAllLayerButton.tag = -1
		selectAllLayerButton.addTarget(self, action: #selector(onClickEditButtons), for: UIControlEvents.touchUpInside)
		self.view.addSubview(selectAllLayerButton)
		print("LayerPickerViewController - viewDidLoad")
	}
	/// セクション数
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	/// セクションの行数
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return imageView.subviews.count
	}
	/// カスタマイズされたLayerCellを追加
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "LayerCell_id", for: indexPath) as! LayerCell
		cell.layerLabel?.text = "Layer" + String(indexPath.row)
		cell.imageLabel?.image = imageView.subviews[indexPath.row].GetImage()
		if(imageViewInEditor.subviews.count > indexPath.row){
			if(imageViewInEditor.subviews[indexPath.row].isHidden){
				cell.editButton?.setImage(UIImage(named: "layeroff_icon"), for: .normal)
			}else{
				cell.editButton?.setImage(UIImage(named: "layeron_icon"), for: .normal)
			}
		}
		print(imageViewInEditor.subviews.count,"row:",indexPath.row)
		cell.editButton?.tag = indexPath.row
		cell.editButton?.addTarget(self, action: #selector(onClickEditButtons), for: UIControlEvents.touchUpInside)
		return cell
	}
	/// データ選択後に呼び出されるメソッド
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
		print("LayerPickerViewController - indexPath:",indexPath.row)
		for layer in self.imageViewInEditor.subviews{
			for item in layer.subviews{
				clearEmphasisSelectedItem(selectedView: item)
			}
		}
		self.indexpath = indexPath
		delegate?.selectedLayer(num: indexPath.row)
	}
	/// - Parameter sender: 編集ボタン
	@objc func onClickEditButtons(sender: UIButton) {
		if(sender.tag == -2){
			hideContentController(content: self)
		}else if(sender.tag == -1){
			indexpath = tableView.indexPathForSelectedRow
			if(indexpath != nil){
				tableView.deselectRow(at: indexpath, animated: false)
			}
			delegate?.selectedLayer(num: sender.tag)
		}else{
			changeVisibleIcon(layer: imageViewInEditor, num:sender.tag)
			self.delegate?.changeVisibleLayer(num: sender.tag)
		}
	}
	/// コンテナをスーパービューに追加
	func displayContentController(content:UIViewController, container:UIView){
		print("LayerPickerViewController - displayContentController")
		addChildViewController(content)
		content.view.frame = container.bounds
		container.addSubview(content.view)
		content.didMove(toParentViewController: self)
	}
	/// コンテナをスーパービューから削除
	func hideContentController(content:UIViewController){
		print("LayerPickerViewController - hideContentController")
		tableView.isHidden = true
		content.willMove(toParentViewController: self)
		content.view.removeFromSuperview()
		content.removeFromParentViewController()
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
	///
	func changeVisibleIcon(layer: UIView,num:Int) {
		//var constraint: NSLayoutConstraint!
		let indexpath: IndexPath = IndexPath(row: num, section: 0)
		let cell = tableView.cellForRow(at: indexpath) as! LayerCell
		if(layer.subviews[num].isHidden){
			cell.editButton?.setImage(UIImage(named: "layeron_icon"), for: .normal)
			print("LayerPickerViewController - changeVisibleIcon - layeron")
		}else{
			cell.editButton?.setImage(UIImage(named: "layeroff_icon"), for: .normal)
			print("LayerPickerViewController - changeVisibleIcon:")
		}
	}
	func updateTableView(){
		if(!tableView.isHidden){
		//self.tableView.reloadData()
		print("LayerPickerViewController - updateTableView1")
		indexpath = tableView.indexPathForSelectedRow
		print("LayerPickerViewController - updateTableView2:",indexpath)
		if(indexpath != nil){
			self.tableView.reloadRows(at: [indexpath], with: .none)
			print("LayerPickerViewController - updateTableView3")
			tableView.selectRow(at: indexpath, animated: false, scrollPosition: .none)
		}else{
			self.tableView.reloadData()
		}
		print("LayerPickerViewController - updateTableView4")
		}
	}
	// 画面回転時に呼び出される
	override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval){
		layerViewWidth = UIScreen.main.bounds.size.width * 0.3
		layerViewHight = UIScreen.main.bounds.height - toolBarHight
		tableViewWidth = layerViewWidth - margine*2
		tableViewHight = layerViewHight - margine*6 - closeButtonSize - selectAllButtonSize
		imageWidth = layerViewWidth - margine*2
		if(UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height){
			imageHeight = imageWidth * UIScreen.main.bounds.size.height / UIScreen.main.bounds.size.width
		}else{
			imageHeight = imageWidth * UIScreen.main.bounds.size.width / UIScreen.main.bounds.size.height
		}
		self.view.frame = CGRect(x:UIScreen.main.bounds.width - layerViewWidth,y:0,width:layerViewWidth,height:layerViewHight)
		let frame = CGRect(x:margine,y:margine*3 + closeButtonSize,width:tableViewWidth,height:tableViewHight)
		tableView.frame = frame
		closeButton.frame = CGRect(x:margine,y:margine,width:closeButtonSize,height:closeButtonSize)
		selectAllLayerButton.frame = CGRect(x:margine,y:layerViewHight - selectAllButtonSize - margine,width:tableViewWidth,height:selectAllButtonSize)
		tableView.rowHeight = labelHeight*2 + imageHeight
		indexpath = tableView.indexPathForSelectedRow
		if(indexpath != nil){
			self.tableView.reloadRows(at: [indexpath], with: .none)
		}
		tableView.selectRow(at: indexpath, animated: false, scrollPosition: .none)
	}
}
