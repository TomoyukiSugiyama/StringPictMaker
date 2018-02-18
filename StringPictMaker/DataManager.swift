//
//  DataManager.swift
//  StringPictMaker
//
//  Created by 杉山智之 on 2017/11/21.
//  Copyright © 2017年 杉山智之. All rights reserved.
//

import Foundation
import UIKit
import CoreData

///TODO:
/// ＊
/// ＊
/// ＊

/// Future:
/// ＊
/// ＊
/// ＊

/// Data manager
/// 様々なクラスで使用するデータ・メモリに保存するためのデータを管理
class DataManager{
	// Viewにセットするtagの種類を管理
	// |-+-+-+-+-+-+-+-+-+-+-+-+--+-+-|-+-|-+-+-+-+-+-+-+-|
	// |------------SERIAL------------|TAG|-----ITEM------|
	// |------------------------------|-2-|-------8-------|
	// ITEM_MASK:
	// |----------------------------------|1|1|1|1|1|1|1|1|
	// TAG_MASK	:
	// |------------------------------|1|1|1|1|1|1|1|1|1|1|
	// ITEM		:
	//				GPS = 1, CITY = 2, FREE = 3
	// TAG		:
	//				Scale = 1, Rect = 2
	enum TagIDs : Int{
		case GPS = 1
		case CITY = 2
		case FREE = 3
		case ITEM_MASK = 0xFF
		case Scale = 0x100
		case Rect = 0x200
		case TAG_MASK = 0x3FF
	}
	// メニューを管理
	enum MenuTypes : Int{
		case SETTING = 1
		case PEN
		case TEXT
		case COLOR
		case DUMMY
	}
	var selectedSubMenuItem:MenuTypes!
	func setMenuType(menutype:MenuTypes){
		selectedSubMenuItem = menutype
	}
	func getMenuType() -> MenuTypes{
		return selectedSubMenuItem
	}
	var colorArray = [UIColor]()
	func setColor(color:UIColor){
		if let index = colorArray.index(of: color){
			colorArray.remove(at: index)
			colorArray.insert(color, at: 0)
		}else{
			colorArray.insert(color, at: 0)
			if(colorArray.count > 3){
				colorArray.removeLast()
			}
		}
	}
	func getColor(index:Int) -> UIColor{
		if(index < colorArray.count){
			
			return colorArray[index]
		}else{
			fatalError("error")
			//return UIColor.white
		}
	}
	
	var penSize:CGFloat!
	func setPen(size:CGFloat){
		penSize = size
	}
	func getPen() -> CGFloat{
		return penSize
	}
	var textNumber:Int!
	func setTextPicker(num:Int){
		textNumber = num
	}
	func getTextPicker() -> Int{
		return textNumber
	}
	// CoreData : 管理オブジェクトコンテキスト
	var managedContext:NSManagedObjectContext!
	// 検索結果配列
	var searchResult = [Images]()
	// CoreDataを読み出すための構造体
	struct ImageData {
		var id: Int
		var title: String
		var imageview: UIView
	}
	var imageList = [ImageData]()
	let DUMMY:Int
	init() {
		// CoreData : 管理オブジェクトコンテキストを取得
		let applicationDelegate = UIApplication.shared.delegate as! AppDelegate
		managedContext = applicationDelegate.persistentContainer.viewContext
		//コンフリクトが発生した場合にマージ
		managedContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
		/// TODO: 不要な変数のため削除
		/// initを実行する時、１つ以上のクラスインスタンスの初期化が必要であるため
		DUMMY = 0
	}

	/// CoreDataに空のimageを保存
	func saveEmptyImage(id:Int,frame:CGRect){
		do{
			// 空のImageを作成
			let emptyView = UIView(frame: CGRect(x:0, y:0, width:frame.width, height:frame.height))
			emptyView.backgroundColor = UIColor.white
			let imageLabel = UIImageView(frame: CGRect(x:0, y:0, width:frame.width, height:frame.height))
			imageLabel.image = UIImage(named: "noimage")
			imageLabel.tag = -1
			emptyView.addSubview(imageLabel)
			// UIViewをアーカイブし、シリアライズ（バイナリ化）されたNSDataに変換
			let viewArchive = NSKeyedArchiver.archivedData(withRootObject: emptyView)
			let ImagesEntity = NSEntityDescription.insertNewObject(forEntityName: "Images", into: managedContext) as! Images
			ImagesEntity.id = Int16(id)
			ImagesEntity.imageview = viewArchive
			ImagesEntity.title = "none"
			//管理オブジェクトコンテキストの中身を保存する。
			try managedContext.save()
		} catch {
			print(error)
		}
		Log.d("id",id)
		loadImage()
	}
	/// CoreDataからImageを読み出し、ImageListに追加
	func loadImage(){
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Images")
		do {
			//フェッチリクエストを実行
			searchResult = try managedContext.fetch(fetchRequest) as! [Images]
		} catch {
			print(error)
		}
		imageList.removeAll()
		for serchRes in searchResult{
			let archivedData = serchRes.imageview!
			// アーカイブされたデータを元に戻す
			let unarchivedView = (NSKeyedUnarchiver.unarchiveObject(with: archivedData as Data) as? UIView)!
			// imageListに追加
			imageList.append(ImageData(id: Int(serchRes.id),title: serchRes.title!,imageview: unarchivedView))
		}
		//print("type:",imageList[0].typeList[0]);
		Log.d("imageList.count",imageList.count,"searchResult.count",searchResult.count)
	}
	// CoreDataのImageを更新
	func updateImage(id:Int,view:UIView){
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Images")
		//let predict = NSPredicate(format: "%K=%@", "id", id)
		//fetchRequest.predicate = predict
		Log.d("id",id,"count:",imageList.count)
		// 読み込み実行
		do {
			//フェッチリクエストを実行
			searchResult = try managedContext.fetch(fetchRequest) as! [Images]
			// UIViewをアーカイブし、シリアライズされたNSDataに変換
			let viewArchive = NSKeyedArchiver.archivedData(withRootObject: view)
			searchResult[indexOf(id: id)].imageview = viewArchive
			//管理オブジェクトコンテキストの中身を保存する。
			try managedContext.save()
		} catch {
			print(error)
		}
		loadImage()
	}
	/*
	 /// CoreDataからimageを取得
	 func getData(){
	 //フェッチリクエストのインスタンスを生成
	 let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Images")
	 //fetchRequest.predicate = NSPredicate(format: "title = %@", deleteCategory)
	 
	 do {
	 //フェッチリクエストを実行
	 searchResult = try managedContext.fetch(fetchRequest) as! [Images]
	 } catch {
	 print(error)
	 }
	 print(searchResult.count)
	 //for serchRes in searchResult{
	 //	print(serchRes.title! as Any)
	 //}
	 }
	 */
	/// CoreDataに保存したImageを全て削除
	func deleteAllData(){
		//フェッチリクエストのインスタンスを生成
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Images")
		//fetchRequest.predicate = NSPredicate(format: "title = %@", deleteCategory)
		do{
			//フェッチリクエストを実行
			let task = try managedContext.fetch(fetchRequest)
			// Images Entityの全てのデータを削除
			for data in task {
				managedContext.delete(data as! NSManagedObject)
			}
		} catch {
			print(error)
		}
		// 削除したあとのデータを保存する
		(UIApplication.shared.delegate as! AppDelegate).saveContext()
		// 削除後の全データをfetchする
		//getData()
	}
	/// 指定したidを含むimageListのインデックスを返す
	///
	/// - Parameter id: 検索するid
	/// - Returns: 検索したIDを含むimageListのインデックス
	func indexOf(id: Int) -> Int {
		Log.d("id",id,"count",imageList.count)
		return imageList.index(where: { $0.id == id })!
	}
}
