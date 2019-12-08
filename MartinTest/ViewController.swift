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
    let searchBar = UISearchBar(frame: CGRect(origin: CGPoint.init(x: 0, y: 0), size: CGSize(width: UIScreen.main.bounds.size.width, height: 44)))
    var headerView = HeaderRecommonendView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: UIScreen.main.bounds.size.width, height: HeaderRecommonendView.height)))
    let identfier = "identifier"
    let request = Network()
    var isSearchMode = false
    
    
    
    var searchListData : Array<JSON>? = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        requestTopListData()
        requestRecommendData()
        view.backgroundColor = .white
    }
    
    func setupUI() {
        tableView = UITableView.init(frame: self.view.bounds, style: .grouped)
        tableView?.showsVerticalScrollIndicator = false
        tableView?.backgroundColor = .white
        tableView?.dataSource = self
        tableView?.delegate = self
//        tableView?.isPagingEnabled = true
        tableView?.rowHeight = 95
        tableView?.register(TopListTableViewCell.self, forCellReuseIdentifier: self.identfier)
        view.addSubview(self.tableView!)
        
        searchBar.placeholder = "搜寻"
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.addTarget(self, action: #selector(textFieldChanged(textField:)), for: UIControl.Event.editingChanged)
        tableView?.tableHeaderView = searchBar
        
    }
    
    func requestRecommendData() {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        request.requestRecommend { [weak self] (success,result) in
            hud.hide(animated: true)
            if (success) {
                let json = result as! JSON
                self?.headerView.recommendData = json["feed"]["entry"].array
            } else {
                self?.showErrorAlert(message: "拉取推荐失败")
            }
        }
    }
    
    func requestTopListData() {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        
        request.requestTopList {[weak self] (success, result) in
            
            hud.hide(animated: true)
            if (success) {
                let entry = result as! JSON
                self?.listData = entry["feed"]["entry"].array
                print(entry)
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isSearchMode && headerView.searchData?.count == 0 {
            return 0
        }
        return HeaderRecommonendView.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchMode {
            return searchListData?.count ?? 0
        } else {
            return listData?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: self.identfier)
        tableViewCell?.selectionStyle = .none
        let cell = tableViewCell as! TopListTableViewCell
        var topListModel = listData?[indexPath.row]
        if isSearchMode {
            topListModel = searchListData?[indexPath.row]
        }
        
        let model = TopListModel(index:indexPath.row + 1,originalData: topListModel ?? JSON())
        cell.updateData(model: model)
        
        return cell;
    }
    
    
    func searchKeyword(keyword: String) {
        searchListData?.removeAll()
        headerView.searchData?.removeAll()
        for json in listData ?? [] {
            let nameString = json["im:name"]["label"].string ?? ""
            let typeString = json["category"]["attributes"]["label"].string ?? ""
            let summaryString = json["summary"]["label"].string ?? ""
            if nameString.contains(keyword) || typeString.contains(keyword) || summaryString.contains(keyword) {
                searchListData?.append(json)
            }
        }
        
        tableView?.reloadData()
        
        for json in headerView.recommendData ?? [] {
            let nameString = json["im:name"]["label"].string ?? ""
            let typeString = json["category"]["attributes"]["label"].string ?? ""
            let summaryString = json["summary"]["label"].string ?? ""
            if nameString.contains(keyword) || typeString.contains(keyword) || summaryString.contains(keyword) {
                headerView.searchData?.append(json)
            }
        }
        headerView.reloadData()
    }

    @objc func textFieldChanged(textField: UITextField) {
        
        self.headerView.isSearchMode = (textField.text?.count ?? 0 > 0)
        isSearchMode = (textField.text?.count ?? 0 > 0)
        if textField.text?.count ?? 0 > 0 {
            searchKeyword(keyword: textField.text ?? "")
        } else {
            tableView?.reloadData()
            headerView.reloadData()
            
        }
        
    }
    
}


