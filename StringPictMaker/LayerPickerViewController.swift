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
/// ＊レイヤーオンオフ時、サイズ０にしないと選択できてしまう
/// ＊全レイヤーセレクトメニュー追加
/// ＊横画面にした時のレイアウト
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
			for item in layer.subviews{
				clearEmphasisSelectedItem(selectedView: item)
			}
		}
		self.imageViewInEditor = view
		//self.imageView = view
	}
	// コレクションビューを生成
	var tableView : UITableView!
//	var layerCell: UICollectionViewCell!
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.frame = CGRect(x:self.view.frame.width/2,y:0,width:self.view.frame.width/2,height:self.view.frame.height - 100)
		self.view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
		// コレクションビューを生成
//		let layout = UITableViewFlowLayout()
		let frame = CGRect(x:20,y:20,width:self.view.frame.width - 30,height:self.view.frame.height - 30)
		print("LayerPickerViewController - viewDidLoad - frame:",frame)
		tableView = UITableView(frame:frame, style: .plain)
		tableView.register(LayerCell.self, forCellReuseIdentifier: "LayerCell_id")
		//tableView.register(LayerCell.self, forCellWithReuseIdentifier: "LayerCell_id")
		tableView.delegate = self
		tableView.dataSource = self
		tableView.backgroundColor = UIColor.white
		tableView.rowHeight = 200.0
		self.view.addSubview(tableView)
		let closeButton = UIButton(frame: CGRect(x:0,y:0,width:20,height:20))
		closeButton.backgroundColor = UIColor.white
		closeButton.setTitle(">", for: .normal)
		closeButton.tag = -1
		closeButton.addTarget(self, action: #selector(onClickEditButtons), for: UIControlEvents.touchUpInside)
		self.view.addSubview(closeButton)
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
		//cell.textLabel?.text = indexPath.row.description
		cell.layerLabel?.text = "Layer" + String(indexPath.row)
		cell.imageLabel?.image = imageView.subviews[indexPath.row].GetImage()
		//print("indexPath:",indexPath.row,imageView.subviews[indexPath.row].GetImage())
		cell.editButton?.setTitle("EYE", for: .normal)
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
		delegate?.selectedLayer(num: indexPath.row)
	}
	/// - Parameter sender: 編集ボタン
	@objc func onClickEditButtons(sender: UIButton) {
		if(sender.tag == -1){
			hideContentController(content: self)
		}else{
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
}
