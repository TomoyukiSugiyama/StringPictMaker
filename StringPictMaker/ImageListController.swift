//
//  ImageListController.swift
//  StringPictMaker
//
//  Created by 杉山智之 on 2017/11/17.
//  Copyright © 2017年 杉山智之. All rights reserved.
//

import Foundation
import UIKit
import CoreData

/// 作成したイメージのリストを表示
class ImageListController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    var myCollectionView : UICollectionView!
    // ビューのマージンを設定
    let cellMargin:CGFloat = 10.0
    // CoreData : 管理オブジェクトコンテキスト
    var managedContext:NSManagedObjectContext!
    // 検索結果配列
    var searchResult = [Images]()
    // 表示するセル数を設定
    var cellNum : Int = 0
    var delegateParamIndex : Int = 0
    
    struct ImageData {
        var title: String
        var imageview: UIView
    }
    var imageList = [ImageData]()
    /// コレクションビューを生成
    override func viewDidLoad() {
        super.viewDidLoad()
         // ナビゲーションバーにアイテム追加
        // ナビゲーションバーのボタン
        var rightBarButton: UIBarButtonItem!
        rightBarButton = UIBarButtonItem(barButtonSystemItem:  .add,target: self, action: #selector(tappedRightBarButton))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        // コレクションビューを生成
        let layout = UICollectionViewFlowLayout()
        myCollectionView = UICollectionView(frame:view.frame, collectionViewLayout: layout)
        myCollectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell_id")        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.backgroundColor = UIColor.black
        self.view.addSubview(myCollectionView)
        
        // CoreData : 管理オブジェクトコンテキストを取得
        let applicationDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = applicationDelegate.persistentContainer.viewContext
        //コンフリクトが発生した場合にマージ
        managedContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        //saveEmptyImage()
        //loadImage()

        //getData()
        deleteData()
        saveEmptyImage()
        loadImage()
        //setView()
    }
    
    /// 画面遷移時に渡すデータを設定
    ///
    /// - Parameters:
    ///   - segue: セグエ
    ///   - sender: 渡すデータ
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toImageBoard_id") {
            let secondViewController:ImageBoard = segue.destination as! ImageBoard
            secondViewController.delegateParamIndex = sender as! Int
         }else if(segue.identifier == "toImageEditor_id"){
            let secondViewController:ImageEditor = segue.destination as! ImageEditor
            secondViewController.delegateParamIndex = sender as! Int
            secondViewController.imageView = imageList[sender as! Int].imageview
        }
    }
    /// セルの要素数を設定
    ///
    /// - Parameters:
    ///   - collectionView: myCollectionView
    ///   - section: セクションに含まれる要素数
    /// - Returns: 要素数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    /// セルの情報を設定
    ///
    /// - Parameters:
    ///   - collectionView: myCollectionView
    ///   - indexPath: セルのインデックス
    /// - Returns: セル
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell_id", for: indexPath) as! ImageCell
        //logo設定
        //let img = self.imageList[indexPath.row].imageview.GetImage()
        //cell.imageLabel?.image = UIImage(named: "noimage")
        //cell.textLabel?.text = "Title" + indexPath.row.description
        
        cell.imageLabel?.image = self.imageList[indexPath.row].imageview.GetImage() as UIImage
        cell.textLabel?.text = self.imageList[indexPath.row].title
        cell.editButton?.setTitle("EDIT", for: .normal)
        cell.editButton?.setTitleColor(UIColor.blue, for: .normal)
        cell.editButton?.tag = indexPath.row
        cell.backgroundColor = UIColor.lightGray
        cell.editButton?.addTarget(self, action: #selector(onClickEditButtons), for: UIControlEvents.touchUpInside)
        return cell
    }
    /// セルが選択された時のイベント
    ///
    /// - Parameters:
    ///   - collectionView: myCollectionView
    ///   - indexPath: セルのインデックス
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegateParamIndex = (indexPath as NSIndexPath).row
        self.performSegue(withIdentifier: "toImageBoard_id", sender: self.delegateParamIndex)
    }
    /// 行間の余白を設定
    ///
    /// - Parameters:
    ///   - collectionView: myCollectionView
    ///   - collectionViewLayout: layout
    ///   - section: 最小の行間余白
    /// - Returns: 行間の余白
    func collectionView(_ collectionView:UICollectionView,layout collectionViewLayout:UICollectionViewLayout,minimumLineSpacingForSectionAt section:Int) -> CGFloat{
        return cellMargin
    }
    /// 列間の余白を設定
    ///
    /// - Parameters:
    ///   - collectionView: myCollectionView
    ///   - collectionViewLayout: layout
    ///   - section: 最小の列間余白
    /// - Returns: 列間の余白
    func collectionView(_ collectionView:UICollectionView,layout collectionViewLayout:UICollectionViewLayout,minimumInteritemSpacingForSectionAt section:Int) -> CGFloat{
        return cellMargin
    }
    /// セルサイズ設定
    ///
    /// - Parameters:
    ///   - collectionView: myCollectionView
    ///   - collectionViewLayout: layout
    ///   - indexPath: セルのインデックス
    /// - Returns: セルサイズ
    func collectionView(_ collectionView:UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAt indexPath:IndexPath) -> CGSize{
        let numberOfMargin:CGFloat = 1.0
        let width:CGFloat = (collectionView.frame.size.width - cellMargin * numberOfMargin) / 2
        let height:CGFloat = width * 4.0 / 3.0
        return CGSize(width:width,height:height)
    }
    /// セクション数を設定
    ///
    /// - Parameter collectionView: myCollectionView
    /// - Returns: セクション数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    /// ナビゲーションバーの追加ボタンをタップしたときのアクション
    @objc func tappedRightBarButton() {
        self.cellNum += 1
        myCollectionView.reloadData()
        
        self.delegateParamIndex = self.cellNum
        self.performSegue(withIdentifier: "toImageEditor_id", sender: self.delegateParamIndex)
    }
    /// セルの編集ボタンをタップしたときのアクション
    ///
    /// - Parameter sender: 編集ボタン
    @objc func onClickEditButtons(sender: UIButton) {
        self.delegateParamIndex = sender.tag
        self.performSegue(withIdentifier: "toImageEditor_id", sender: self.delegateParamIndex)
    }
    
    /// CoreDataに空のimageを保存
    func saveEmptyImage(){
        do{
            let emptyView = UIView(frame: CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height))
            let  imageLabel = UIImageView(frame: CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height))
            imageLabel.image = UIImage(named: "noimage")
            imageLabel.tag = -1
            emptyView.addSubview(imageLabel)
            // UIViewをアーカイブし、シリアライズされたNSDataに変換
            let viewArchive = NSKeyedArchiver.archivedData(withRootObject: emptyView)
            let ImagesEntity = NSEntityDescription.insertNewObject(forEntityName: "Images", into: managedContext) as! Images
            ImagesEntity.imageview = viewArchive
            ImagesEntity.title = "none"
            //管理オブジェクトコンテキストの中身を保存する。
            try managedContext.save()
         } catch {
            print(error)
         }
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
        print(searchResult.count)
        for serchRes in searchResult{
            let archivedData = serchRes.imageview!
            // アーカイブされたデータを元に戻す
            let unarchivedView = (NSKeyedUnarchiver.unarchiveObject(with: archivedData as Data) as? UIView)!
            // imageListに追加
            imageList.append(ImageData(title: serchRes.title!,imageview: unarchivedView))
            //self.view.addSubview(unarchivedView)
         }
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
        //    print(serchRes.title! as Any)
        //}
    }*/
    func deleteData(){
        //フェッチリクエストのインスタンスを生成
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Images")
        //fetchRequest.predicate = NSPredicate(format: "title = %@", deleteCategory)
        do{
            //フェッチリクエストを実行
            let task = try managedContext.fetch(fetchRequest)
            print("delete")
            print(task.count)
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

    
    
}

extension UIView {
    
    func GetImage() -> UIImage{
        
        // キャプチャする範囲を取得.
        let rect = self.bounds
        
        // ビットマップ画像のcontextを作成.
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        
        // 対象のview内の描画をcontextに複写する.
        self.layer.render(in: context)
        
        // 現在のcontextのビットマップをUIImageとして取得.
        let capturedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        // contextを閉じる.
        UIGraphicsEndImageContext()
        
        return capturedImage
    }
}
