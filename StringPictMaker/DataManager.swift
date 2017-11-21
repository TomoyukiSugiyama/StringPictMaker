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
/// Data manager
class DataManager{
    // CoreData : 管理オブジェクトコンテキスト
    var managedContext:NSManagedObjectContext!
    // 検索結果配列
    var searchResult = [Images]()
    struct ImageData {
        var title: String
        var imageview: UIView
    }
    var imageList = [ImageData]()
    var imageSize:UIView
    init(param: UIView) {
        // CoreData : 管理オブジェクトコンテキストを取得
        let applicationDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = applicationDelegate.persistentContainer.viewContext
        //コンフリクトが発生した場合にマージ
        managedContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        imageSize = param
    }
    /// CoreDataに空のimageを保存
    func saveEmptyImage(){
        do{
            let emptyView = UIView(frame: CGRect(x:0, y:0, width:imageSize.frame.width, height:imageSize.frame.height))
            let  imageLabel = UIImageView(frame: CGRect(x:0, y:0, width:imageSize.frame.width, height:imageSize.frame.height))
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
