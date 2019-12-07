//
//  ViewController.swift
//  MartinTest
//
//  Created by martin on 2019/12/7.
//  Copyright © 2019 martin.nnoffice.com. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView : UITableView?
    var listData : Array<JSON>?
    let identfier = "identifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        requestData()

    }
    
    func setupUI() {
        tableView = UITableView.init(frame: self.view.bounds, style: .grouped)
        tableView?.showsVerticalScrollIndicator = false
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.isPagingEnabled = true
        tableView?.rowHeight = 95
        tableView?.register(TopListTableViewCell.self, forCellReuseIdentifier: self.identfier)
        view.addSubview(self.tableView!)
    }
    
    func requestData() {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        let request = Network();
//        request.requestRecommend { (success,result) in
//            print(result)
//        }
        
        request.requestTopList {[weak self] (success, result) in
            
            hud.hide(animated: true)
            if (success) {
                let entry = result as! JSON
                self!.listData = entry["feed"]["entry"].array
                
                
                self?.tableView?.reloadData()
            } else {
                self?.showErrorAlert(message: "拉取榜单列表失败")
            }
        }
        
//        request.requestLookupApp(appid: "222") { (success, result) in
//            print(result)
//        }
    }
    
    func showErrorAlert(message:String) {
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "确定", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: self.identfier)
        tableViewCell?.selectionStyle = .none
        let cell = tableViewCell as! TopListTableViewCell
        let topListModel = self.listData?[indexPath.row]
        
        let model = TopListModel(index:indexPath.row + 1,originalData: topListModel ?? JSON())
        cell.updateData(model: model)
        
        return cell;
    }

    
}


