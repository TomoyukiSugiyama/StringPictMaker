//
//  FontPickerViewController.swift
//  StringPictMaker
//
//  Created by 杉山智之 on 2017/12/05.
//  Copyright © 2017年 杉山智之. All rights reserved.
//

import Foundation
import UIKit

class FontPickerViewController: UIView, UIPickerViewDelegate, UIPickerViewDataSource{
    //UIPickerViewの変数の宣言
    private var picker: UIPickerView!
    //表示するデータの配列
    private let data: NSArray = ["White","Yellow","Blue","Green","Red","Orange","Purple","Pink","Cyan"]
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Do any additional setup after loading the view, typically from a nib.
        //UIPickerViewのインスタンスを生成
        picker = UIPickerView()
        //位置とサイズを設定
        picker.frame = CGRect(x: 0, y: frame.height / 2 - 150, width: frame.width, height: 300.0)
        //delegateの設定
        picker.delegate = self
        //dataSourceの設定
        picker.dataSource = self
        //pickerをviewに追加
        self.addSubview(picker)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //PickerViewの個数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //表示する行数。配列の個数を返している
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    //表示する値
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row] as? String
    }
}
