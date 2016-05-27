//
//  SecondViewController.swift
//  SearchBarController
//
//  Created by sherry on 16/5/23.
//  Copyright © 2016年 sherry. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {

    var tableView: UITableView!
    var searchController: UISearchController!
    var dataList: [String]!
    var searchDataList: [String] = [String]() {
    
        didSet {self.tableView.reloadData()}
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.title = "results list"
        self.view.backgroundColor = UIColor.whiteColor()
        
        tableView = UITableView(frame: self.view.bounds, style: .Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(tableView)
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.searchBarStyle = .Minimal
        searchController.searchBar.sizeToFit()
//        searchController.active = true

        searchController.searchBar.placeholder = "请输入大学名称"
//        searchController.searchBar.showsSearchResultsButton = true
        tableView.tableHeaderView = searchController.searchBar

        definesPresentationContext = true
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return self.searchController.active ? 0 : self.searchDataList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("cell")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        }
        cell?.backgroundColor = UIColor.clearColor()
        if self.searchController.active {
            cell?.textLabel?.text = self.searchDataList[indexPath.row]

        }
        return cell!
    }
    
//    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
//        return true
//    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.searchController.searchBar.showsCancelButton = true
        for item in self.searchController.searchBar.subviews {
            for cancel in item.subviews {
                if cancel.isKindOfClass(UIButton) {
                    let btn = cancel as! UIButton
                    btn.setTitle("搜索", forState: .Normal)
                    btn.addTarget(self, action: #selector(btnAct), forControlEvents: .TouchUpInside)
                }
            }
        }
        
        if var textToSearch = self.searchController.searchBar.text {
            self.searchDataList = self.dataList.filter({ (str) -> Bool in
                textToSearch = textToSearch.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                return str.containsString(textToSearch)
            })
        }
        
        self.tableView.reloadData()
        
    }
    
    func btnAct(btn: UIButton) {
    
//        self.navigationController?.popViewControllerAnimated(true)
    
    }
    
    override func viewWillAppear(animated: Bool) {
        self.searchController.active = true
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
