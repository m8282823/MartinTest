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
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView : UITableView?
    var rawListData : Array<JSON>?
    var listData : Array<JSON>?
    let searchBar = UISearchBar(frame: CGRect(origin: CGPoint.init(x: 0, y: 0), size: CGSize(width: UIScreen.main.bounds.size.width, height: 44)))
    var headerView = HeaderRecommonendView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: UIScreen.main.bounds.size.width, height: HeaderRecommonendView.height)))
    let identfier = "identifier"
    let request = Network()
    var isSearchMode = false
    var isCheckedNetwork = false
    let footLabel = UILabel(frame: CGRect(origin: CGPoint(x: 20, y: 10), size: CGSize(width: 200, height: 30)))
    
    
    var searchListData : Array<JSON>? = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        requestTopListData()
        requestRecommendData()
        view.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchBar.frame = CGRect(origin: CGPoint.init(x: 0, y: 0), size: CGSize(width: UIScreen.main.bounds.size.width, height: 44))
        headerView.frame = CGRect(origin: CGPoint.init(x: 0, y: 0), size: CGSize(width: UIScreen.main.bounds.size.width, height: 44))
        tableView?.frame = view.bounds
    }
    
    func setupUI() {
        tableView = UITableView.init(frame: view.bounds, style: .grouped)
        tableView?.showsVerticalScrollIndicator = false
        tableView?.backgroundColor = .white
        tableView?.dataSource = self
        tableView?.delegate = self
//        tableView?.isPagingEnabled = true
        tableView?.rowHeight = 95
        tableView?.register(TopListTableViewCell.self, forCellReuseIdentifier: self.identfier)
        view.addSubview(self.tableView!)
        tableView?.keyboardDismissMode = .onDrag
        
        searchBar.placeholder = "搜寻"
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.addTarget(self, action: #selector(textFieldChanged(textField:)), for: UIControl.Event.editingChanged)
        navigationItem.titleView = searchBar
        
        footLabel.font = UIFont.systemFont(ofSize: 16)
        footLabel.textColor = .black
        footLabel.text = "正在加载中..."
        footLabel.isHidden = true
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
                self?.checkNetworkState()
            }
        }
    }
    
    func requestTopListData() {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        
        request.requestTopList {[weak self] (success, result) in
            
            hud.hide(animated: true)
            if (success) {
                let entry = result as! JSON
                self?.rawListData = entry["feed"]["entry"].array
                self?.listData = Array(self?.rawListData?[0..<10] ?? [])
                self?.tableView?.reloadData()
                self?.footLabel.isHidden = false
            } else {
                self?.showErrorAlert(message: "拉取榜单列表失败")
                self?.checkNetworkState()
            }
        }
//        request.requestLookupApp(appid: "222") { (success, result) in
//            print(result)
//        }
    }
    
    func checkNetworkState() {
        let manager = NetworkReachabilityManager()
        manager?.listener = {[weak manager] status in
            manager?.stopListening()
            switch status {
            case .notReachable:
                self.showErrorAlert(message: "请检查网络后重试")
                break
            case .unknown:
                self.showErrorAlert(message: "请检查网络后重试")
                break
            case .reachable(.ethernetOrWiFi):
                break
            case .reachable(.wwan):
                break
            }
        }
        manager?.startListening()
    }
    
    func showErrorAlert(message:String) {
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "确定", style: .default) {[weak self] (action) in
            if !(self?.isCheckedNetwork ?? false) {
                self?.checkNetworkState()
                self?.isCheckedNetwork = true
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 200, height: 500)))
        footView.addSubview(footLabel)
        return footView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isSearchMode && headerView.searchData?.count == 0 {
            return 0
        }
        return HeaderRecommonendView.height
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let indexPath = tableView?.indexPathsForVisibleRows?.last
        if (indexPath?.row ?? 0) + 1 == listData?.count {
            if listData?.count ?? 0 < rawListData?.count ?? 0 {
                let fromIndex = (listData?.count ?? 0)
                let toIndex = (listData?.count ?? 0) + 10
                
                let newListData = Array<JSON>((rawListData?[fromIndex ..< toIndex])!)
                listData?.append(contentsOf: newListData)
                
                if listData?.count == rawListData?.count {
                    footLabel.text = "没有更多数据了"
                }
                tableView?.reloadData()
            } else {
                footLabel.text = "没有更多数据了"
            }
        }
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


