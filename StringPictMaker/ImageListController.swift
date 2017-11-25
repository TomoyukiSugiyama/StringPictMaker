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
    // 表示するセル数を設定
    var cellNum : Int = 0
    var delegateParamIndex : Int = 0
    // DataManagerのオブジェクトを生成し、CoreDataからデータを読み出す
    var data:DataManager? = nil
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
        
        data = DataManager()
        //data?.deleteAllData()
        //data?.saveEmptyImage(id: 0,frame: view.frame)
        data?.loadImage()
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
            secondViewController.imageView = self.data?.imageList[sender as! Int].imageview
         }else if(segue.identifier == "toImageEditor_id"){
            let secondViewController:ImageEditor = segue.destination as! ImageEditor
            secondViewController.delegateParamIndex = sender as! Int
            secondViewController.imageView = self.data?.imageList[sender as! Int].imageview
        }
    }
    /// セルの要素数を設定
    ///
    /// - Parameters:
    ///   - collectionView: myCollectionView
    ///   - section: セクションに含まれる要素数
    /// - Returns: 要素数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.data?.imageList.count)!
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
        
        cell.imageLabel?.image = self.data?.imageList[indexPath.row].imageview.GetImage()
        cell.textLabel?.text = self.data?.imageList[indexPath.row].title
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
        //self.cellNum += 1
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
    func updateView(){
        //self.cellNum += 1
        print("update")
        myCollectionView.reloadData()
        print(self.cellNum)
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
