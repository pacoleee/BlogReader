//
//  MasterViewController.swift
//  Blog Reader
//
//  Created by Paco Lee on 2016-05-31.
//  Copyright © 2016 Paco Lee. All rights reserved.
//

import UIKit
import CoreData

var blogPostTitles = [String]()
var blogPostContents = [String]()
var activeBlog = 0

class MasterViewController: UITableViewController {
    
    @IBOutlet var blogTable: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let urlPath = "https://www.googleapis.com/blogger/v3/blogs/10861780/posts?key=AIzaSyBOlDkfiwUJkdRwlewcOchtqZcKWSpAJb8"
        
        let url = NSURL(string: urlPath)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            
            if (error != nil) {
                print(error)
                
            } else {
                
                do {
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    for item in jsonResult["items"] as! [AnyObject] {
                        blogPostTitles.append(item["title"] as! String)
                        blogPostContents.append(item["content"] as! String)
                    }
                    self.blogTable.reloadData()
                    
                } catch {
                    
                    print("error")

                }
                
            }
        })
        
        task.resume()
        
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let row: Int = indexPath.row
                activeBlog = row
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blogPostTitles.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = blogPostTitles[indexPath.row]
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
}

