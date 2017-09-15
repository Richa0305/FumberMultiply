//
//  ChallangesTableView.swift
//  fumber
//
//  Created by Srivastava, Richa on 14/07/17.
//  Copyright © 2017 ShivHari Apps. All rights reserved.
//

import UIKit

class ChallangesTableView: UITableView,UITableViewDelegate,UITableViewDataSource {
    var items: [String] = ["Challange 1 - Small Targets in 20sec", "Challange 2 - More in 20sec", "Challange 3 - Big Targets in 30sec", "Challange 4 - Bigger n Better", "Challange 5 - Huge Numbers", "Challange 6 - Think Fast", "Challange 7 - Think Faster", "Challange 8 - The Final Challange"]
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
        self.allowsSelection = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                return UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
            }
            return cell
        }()
        
        cell.textLabel?.text = self.items[indexPath.row]
        cell.detailTextLabel?.textColor = UIColor.white
        let highScore = UserDefaults.standard.integer(forKey: "HighScore")
        if cell.textLabel?.text == "Challange 1 - Small Targets in 20sec"{
            cell.imageView?.image =  UIImage(named: "unlocked")
            cell.contentView.alpha = 1
            cell.detailTextLabel?.text = "Collect 30 points to unlock next challange!"
        }else{
            if cell.textLabel?.text == "Challange 2 - More in 20sec"{
                if highScore >= 30 {
                    cell.imageView?.image =  UIImage(named: "unlocked")
                    cell.contentView.alpha = 1
                }else{
                    cell.imageView?.image =  UIImage(named: "locked")
                    cell.contentView.alpha = 0.4
                }
                cell.detailTextLabel?.text = "Collect 60 points to unlock next challange!"
            }
            else if cell.textLabel?.text == "Challange 3 - Big Targets in 30sec"{
                if highScore >= 60  {
                    cell.imageView?.image =  UIImage(named: "unlocked")
                    cell.contentView.alpha = 1
                }else{
                    cell.imageView?.image =  UIImage(named: "locked")
                    cell.contentView.alpha = 0.4
                    
                }
                cell.detailTextLabel?.text = "Collect 100 points to unlock next challange!"
            }
            else if cell.textLabel?.text == "Challange 4 - Bigger n Better"{
                if highScore >= 100 {
                    cell.imageView?.image =  UIImage(named: "unlocked")
                    cell.contentView.alpha = 1
                }else{
                    cell.imageView?.image =  UIImage(named: "locked")
                    cell.contentView.alpha = 0.4
                }
                cell.detailTextLabel?.text = "Collect 150 points to unlock next challange!"
            }
            else if cell.textLabel?.text == "Challange 5 - Huge Numbers"{
                if highScore >= 150  {
                    cell.imageView?.image =  UIImage(named: "locked")
                    cell.contentView.alpha = 1
                }else{
                    cell.imageView?.image =  UIImage(named: "locked")
                    cell.contentView.alpha = 0.4
                }
                cell.detailTextLabel?.text = "Collect 300 points to unlock next challange!"
            }
            else if cell.textLabel?.text == "Challange 6 - Think Fast"{
                if highScore >= 300 {
                    cell.imageView?.image =  UIImage(named: "locked")
                    cell.contentView.alpha = 1
                }else{
                    cell.imageView?.image =  UIImage(named: "locked")
                    cell.contentView.alpha = 0.4
                }
                cell.detailTextLabel?.text = "Collect 500 points to unlock next challange!"
            }
            else if cell.textLabel?.text == "Challange 7 - Think Faster"{
                if highScore >= 300 {
                    cell.imageView?.image =  UIImage(named: "locked")
                    cell.contentView.alpha = 1
                }else{
                    cell.imageView?.image =  UIImage(named: "locked")
                    cell.contentView.alpha = 0.4
                }
                cell.detailTextLabel?.text = "Collect 700 points to unlock next challange!"
            }
            else if cell.textLabel?.text == "Challange 8 - The Final Challange"{
                if highScore >= 300 {
                    cell.imageView?.image =  UIImage(named: "locked")
                    cell.contentView.alpha = 1
                }else{
                    cell.imageView?.image =  UIImage(named: "locked")
                    cell.contentView.alpha = 0.4
                }
                cell.detailTextLabel?.text = "Collect 1000 points to complete the challange!"
            }else{
                cell.imageView?.image =  UIImage(named: "locked")
                cell.contentView.alpha = 1
                
            }
        }
        if UIDevice.current.model == "iPad" {
            cell.textLabel?.font = UIFont(name: "Avenir-Black", size: 20)
            cell.detailTextLabel?.font = UIFont(name: "Avenir-Black", size: 15)
            
        }else{
            cell.textLabel?.font = UIFont(name: "Avenir-Black", size: 11)
            cell.detailTextLabel?.font = UIFont(name: "Avenir-Black", size: 7)
            
        }
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.clear
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.model == "iPad" {
            return 200
        }
        return 110
    }
    //    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return "Section \(section)"
    //    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
}
