//
//  MasterViewController.swift
//  HWSProject7
//
//  Created by Michelangelo on 29/11/15.
//  Copyright (c) 2015 Michelangelo. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    //The Model
    var url: String? {
        didSet {
            fetchJSON(url)
        }
    }
    
    var detailViewController: DetailViewController? = nil
    var objects = [[String: String]]()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.clearsSelectionOnViewWillAppear = false
        self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if navigationController?.tabBarItem.tag == 0 {
            url = Constants.JSONUrl
        }else{
            url = Constants.JSONUrlTopRated
        }
    }
    
    private struct Constants {
        static let JSONUrl = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        static let JSONUrlTopRated = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        static let Metadata = "metadata"
        static let ResponseInfo = "responseInfo"
        static let Status = "status"
        static let OKStatus = 200
        static let Results = "results"
        static let Title = "title"
        static let Body = "body"
        static let SignatureCount = "signatureCount"
    }

    private func fetchJSON(JSONurl: String?) {
        if JSONurl != nil {
            if let url = NSURL(string: JSONurl!) {
                if let data = NSData(contentsOfURL: url) {
                    var parseError: NSError?
                    if let parsedObject = NSJSONSerialization.JSONObjectWithData(data,
                        options: nil,
                        error: &parseError) as? NSDictionary {
                        if let metadata = parsedObject[Constants.Metadata] as? NSDictionary {
                            if let responseInfo = metadata[Constants.ResponseInfo] as? NSDictionary {
                                if let status = responseInfo[Constants.Status] as? NSInteger {
                                    if status == Constants.OKStatus {
                                        parseJSON(parsedObject)
                                    }
                                }
                            }
                        }
                    }
                }else {
                    showError()
                }
            }
        }
    }
    
    private func parseJSON(json: NSDictionary) {
        if let results = json[Constants.Results] as? NSArray {
            for result in results {
                var strTitle = ""
                var strBody = ""
                var strSigs = ""
                if let title = result[Constants.Results] as? NSString {
                    strTitle = String(title)
                }
                if let body = result[Constants.Body] as? NSString {
                    strBody = String(body)
                }
                
                if let sigs = result[Constants.SignatureCount] as? NSInteger {
                    strSigs = String(sigs)
                }
                
                let obj = [Constants.Title: String(strTitle),
                           Constants.Body: String(strBody),
                           Constants.SignatureCount: String(strSigs)]
                
                objects.append(obj)
            }
        }
        tableView.reloadData()
    }
    
    private func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = objects[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        let object = objects[indexPath.row]
        cell.textLabel?.text = object[Constants.Title]
        cell.detailTextLabel?.text = object[Constants.Body]
        return cell
    }

}

