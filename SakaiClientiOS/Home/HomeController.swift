//
//  HomeController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/23/18.

import Foundation
import UIKit

class HomeController: UITableViewController {
    
    var sites:[[Site]] = [[Site]]()
    var terms:[Term] = [Term]()
    
    var numRows:[Int] = [Int]()
    var numSections = 0
    
    var isLoading:Bool = true
    
    override func viewDidLoad() {
        title = "Home"
        RequestManager.getSites(completion: { siteList in
            
            guard let list = siteList else {
                return
            }
            
            self.numSections = list.count
            
            for index in 0..<list.count {
                self.numRows.append(list[index].count)
                self.terms.append(list[index][0].getTerm())
                self.sites.append(list[index])
            }
            
            self.isLoading = false
            self.tableView.reloadData()
        })
        tableView.register(SiteTableViewCell.self, forCellReuseIdentifier: "siteTableViewCell")
        tableView.register(TableHeaderView.self, forHeaderFooterViewReuseIdentifier: "tableHeaderView")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return numSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.numRows[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "siteTableViewCell", for: indexPath) as? SiteTableViewCell else {
            fatalError("Not a Site Table View Cell")
        }
        let site:Site = self.sites[indexPath.section][indexPath.row]
            
        cell.titleLabel.text = site.getTitle()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UITableViewHeaderFooterView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "tableHeaderView") as? TableHeaderView else {
            fatalError("Not a Table Header View")
        }

        view.label.text = "\(getSectionTitle(section: section))"

        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func getSectionTitle(section:Int) -> String {
        if let string = terms[section].getTermString(), let year = terms[section].getYear() {
            return "\(string) \(year)"
        } else {
            return "General"
        }
    }
}