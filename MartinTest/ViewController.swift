//
//  ViewController.swift
//  MartinTest
//
//  Created by martin on 2019/12/7.
//  Copyright © 2019 martin.nnoffice.com. All rights reserved.
//

import UIKit
import MBProgressHUD



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView : UITableView?
    let identfier = "identifier"
    var index = 0;

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        //和你Eat
        
        let request = Network();
//        request.requestRecommend { (success,result) in
//            print(result)
//        }
//
        request.requestTopList { (success, result) in
            print(result)
        }
//
//        request.requestLookupApp(appid: "222") { (success, result) in
//            print(result)
//        }
    }
    
    func setupUI() {
        self.tableView = UITableView.init(frame: self.view.bounds, style: .grouped)
        self.tableView?.showsVerticalScrollIndicator = false;
        self.tableView?.dataSource = self;
        self.tableView?.delegate = self;
        self.tableView?.isPagingEnabled = true;
        self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: self.identfier)
        self.view.addSubview(self.tableView!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: self.identfier)
        tableViewCell?.selectionStyle = .none
        index += 1;
        tableViewCell?.textLabel?.text = String.init("\(index)");
        return tableViewCell!;
    }

    
}


