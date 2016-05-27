//
//  ViewController.swift
//  SearchBarController
//
//  Created by sherry on 16/5/23.
//  Copyright © 2016年 sherry. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    //展示列表
    var tableView: UITableView!
    //搜索控制器
    var countrySearchController: UISearchController!
    
    //原始数据集
    let shoolArray = ["清华大学","北京大学","中国人民大学","北京交通大学","北京工业大学","北京航空航天大学","北京理工大学","北京科技大学","中国政法大学","中央财经大学","华北电力大学","北京体育大学","上海外国语大学","复旦大学","华东师范大学","上海大学","河北工业大学"]
    
    //搜索过滤后的结果集
    var searchArray:[String] = [String]() {
        
        didSet {self.tableView.reloadData()}
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.cyanColor()
        
        //创建表视图
        tableView = UITableView(frame: self.view.bounds, style: .Plain)
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView.backgroundColor = UIColor.whiteColor()
        
        //        let cell: UINib = UINib(nibName: "Cell", bundle: NSBundle.mainBundle())
        //
        //        tableView.registerNib(cell, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView!)
        
        //配置搜索框
        //初始化
        countrySearchController = UISearchController(searchResultsController: nil)
        //设置代理---在UISearchBar文字改变时被通知到
        countrySearchController.searchResultsUpdater = self
        //点击searchBar跳转到另一个页面
        countrySearchController.searchBar.delegate = self
        //隐藏导航栏
        countrySearchController.hidesNavigationBarDuringPresentation = true
        //false不会暗化当前view，若使用另一个viewController来显示当前结果时可以用到
        countrySearchController.dimsBackgroundDuringPresentation = false
        //设置类型
        countrySearchController.searchBar.searchBarStyle = .Minimal
        //设置大小
        countrySearchController.searchBar.sizeToFit()
        //设置提示文字
        countrySearchController.searchBar.placeholder = NSLocalizedString("请输入大学名称", comment: "搜索条的占位符")
        //设置为tableView的头视图
        tableView.tableHeaderView = countrySearchController.searchBar
        //设置为导航栏的标题view
//        self.navigationItem.titleView = countrySearchController.searchBar
        //保证UISearchController在激活状态下用户push到下一个viewController之后searchBar不会仍留在页面
        definesPresentationContext = true

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //判断searchBar的状态---active在点击searchBar时会自动变为true
        return self.countrySearchController.active ? self.searchArray.count : self.shoolArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("cell")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
            //            cell = NSBundle.mainBundle().loadNibNamed("Cell", owner: nil, options: nil).first as? Cell
            
        }
        
        //        cell?.la.text = "aaa"
        
        cell?.backgroundColor = UIColor.clearColor()
        
        if self.countrySearchController.active {
            //            print(self.searchArray.count)
            cell!.textLabel?.text = self.searchArray[indexPath.row]
            return cell!
        }else {
            cell!.textLabel?.text = self.shoolArray[indexPath.row]
            return cell!
        }
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return !self.countrySearchController.active
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        
        if self.countrySearchController.active  {
            
            self.countrySearchController.searchBar.text = cell?.textLabel?.text
            
        }
        
    }
    
//    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
//        let secVC = SecondViewController()
//        secVC.dataList = self.shoolArray
////        secVC.searchController.active = self.countrySearchController.active
//        self.navigationController?.pushViewController(secVC, animated: true)
//        return true
//    }
    
    //更新搜索结果
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        //修改cancel按钮
        self.countrySearchController.searchBar.showsCancelButton = true
        for sousuo in self.countrySearchController.searchBar.subviews {
            for cancel in sousuo.subviews {
                
                if cancel.isKindOfClass(UIButton) {
                    let btn = cancel as! UIButton
                    btn.setTitle("取消", forState: .Normal)
                }
                
            }
        }
        
        //使用谓词
        //        self.searchArray.removeAll(keepCapacity: false)
        //
        //        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        //        let array = (self.shoolArray as NSArray).filteredArrayUsingPredicate(searchPredicate)
        //        self.searchArray = array as! [String]
        
        //判断字符是否包含某一字符
        if var textToSearch = self.countrySearchController.searchBar.text {
            
            self.searchArray = self.shoolArray.filter({ (str) -> Bool in
                //去除字符串中的字符，这里去除空格字符组
                textToSearch = textToSearch.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                return str.containsString(textToSearch)
            })
            
        }
        
        
        self.tableView.reloadData()
        
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
