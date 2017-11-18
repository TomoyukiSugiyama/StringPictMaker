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
    //管理オブジェクトコンテキスト
    var managedContext:NSManagedObjectContext!
    //検証用データ
    let dataList = [["月刊コロコロコミック", "小学館",390,20.2,"2016/5/16 10:30:00"],
                    ["コロコロイチバン！","小学館",540,25.3,"2016/4/23 09:00:00"],
                    ["最強ジャンプ","集英社",420,13.2,"2016/6/9 7:00:00"],
                    ["Vジャンプ","集英社",300,13.4,"2016/1/3 12:00:00"],
                    ["週刊少年サンデー","小学館",280,16.7,"2016/8/23 11:00:00"],
                    ["週刊少年マガジン","講談社",250,40.5,"2016/10/10 7:30:00"],
                    ["週刊少年ジャンプ","集英社",300,60.3,"2016/9/9 10:00:00"],
                    ["週刊少年チャンピオン","秋田書店",280,23.5,"2015/5/1 11:30:00"],
                    ["月刊少年マガジン","講談社",320,45.1,"2016/7/2 13:30:00"],
                    ["月刊少年チャンピオン","秋田書店",220,12.6,"2015/11/10 7:30:00"],
                    ["月刊少年ガンガン","スクウェア",240,33.5,"2016/2/2 7:30:00"],
                    ["月刊少年エース","KADOKAWA", 330,9.8,"2016/7/1 8:30:00"],
                    ["月刊少年シリウス","講談社",350,20.2,"2016/11/26 15:00:00"],
                    ["週刊ヤングジャンプ","集英社",300,33.3,"2014/3/16 8:30:00"],
                    ["ビッグコミックスピリッツ","小学館",240,11.2,"2014/9/29 11:30:00"],
                    ["週刊ヤングマガジン","講談社",310,26.7,"2016/8/8 10:00:00"]]
    //検索結果配列
    var searchResult = [Images]()
    
    /// コレクションビューを生成
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        myCollectionView = UICollectionView(frame:view.frame, collectionViewLayout: layout)
        myCollectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell_id")        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.backgroundColor = UIColor.black
        self.view.addSubview(myCollectionView)
        
        //管理オブジェクトコンテキストを取得する。
        let applicationDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = applicationDelegate.persistentContainer.viewContext
        //コンフリクトが発生した場合はマージする。
        managedContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        getData()
    }
    
    /// CoreDataにimageを保存
    func setData(){
        do{
            //オブジェクトを管理オブジェクトコンテキストに格納する。
            for data in dataList {
                let book = NSEntityDescription.insertNewObject(forEntityName: "Images", into: managedContext) as! Images
                book.title = data[0] as? String        //雑誌名
            }
            //管理オブジェクトコンテキストの中身を保存する。
            try managedContext.save()
         } catch {
            print(error)
         }
    }
    
    /// CoreDataからimageを取得
    func getData(){
        //フェッチリクエストのインスタンスを生成する。
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Images")
        do {
            //フェッチリクエストを実行する。
            searchResult = try managedContext.fetch(fetchRequest) as! [Images]
        } catch {
            print(error)
        }
        for serchRes in searchResult{
            print(serchRes.title! as Any)
        }
        //print(searchResult[2].title! as Any)
    }
    /// セルの要素数を設定
    ///
    /// - Parameters:
    ///   - collectionView: myCollectionView
    ///   - section: セクションに含まれる要素数
    /// - Returns: 要素数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
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
        cell.imageLabel?.image = UIImage(named: "jv_logo")
        cell.textLabel?.text = "Title" + indexPath.row.description
        cell.editButton?.setTitle("EDIT", for: .normal)
        cell.editButton?.setTitleColor(UIColor.blue, for: .normal)
        cell.backgroundColor = UIColor.lightGray
        //cell.editButton?.addTarget(self, action: #selector(onClickSubButtons), for: UIControlEvents.touchUpInside)
        return cell
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
}
