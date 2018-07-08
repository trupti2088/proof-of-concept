//
//  CanadaTableViewController.swift
//  Proof Of Concept
//
//  Created by Trupti Gavhane on 07/07/18.
//  Copyright © 2018 Telstra. All rights reserved.
//

import UIKit

class CanadaTableViewController: UITableViewController,DatModelProtocol  {
    func didFetchData(data: NSDictionary) {
        print("Reloading ...")
        self.canadaDataSource = data[Constants.rowsKey] as! NSArray
        self.navigationItem.title = data[Constants.titleKey] as? String
        self.tableView.reloadData()
    }
    
    var canadaDataSource: NSArray = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Self-sizing table view cells in iOS 8 require that the rowHeight property of the table view be set to the constant UITableViewAutomaticDimension
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Self-sizing table view cells in iOS 8 are enabled when the estimatedRowHeight property of the table view is set to a non-zero value.
        // Setting the estimated row height prevents the table view from calling tableView:heightForRowAtIndexPath: for every row in the table on first load;
        // it will only be called as cells are about to scroll onscreen. This is a major performance optimization.
        tableView.estimatedRowHeight = 80.0 // set this to whatever your "average" cell height is; it doesn't need to be very accurate
        
        // fetch data except for real images.
        self.downloaData()

    }

    func downloaData(){
        DataModel.sharedInstance().datModelProtocol = self
        self.canadaDataSource = DataModel.sharedInstance().fetchData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return canadaDataSource.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let canadaTableViewCell = CanadaTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cellIdentifier")
        
        let currentItem = canadaDataSource[indexPath.row] as! NSDictionary
        if ((currentItem[Constants.labelTitle] as? String) != nil){
            canadaTableViewCell.labelTitle.text = (currentItem[Constants.labelTitle] as! String)
        }else {
            canadaTableViewCell.labelTitle.text = "No title"
        }
        
        if ((currentItem[Constants.labelDescription] as? String) != nil){
            canadaTableViewCell.labelDescription.text = currentItem[Constants.labelDescription] as? String
        }else {
            canadaTableViewCell.labelDescription.text = "No description"
        }

        canadaTableViewCell.setNeedsUpdateConstraints()
        canadaTableViewCell.updateConstraintsIfNeeded()
        
        // check if image string is present in the current item dictionary
        if let imageString = currentItem["imageHref"] as? String {
            // URL is present
            guard let url = URL(string: (currentItem["imageHref"] as? String)!)
                else {
                    return canadaTableViewCell
            }
            
            // fetch image in the background
            DispatchQueue.global(qos: .background).async {
                guard let data = try? Data(contentsOf: url)else {
                    return
                }
                
                // set image if it is converted from data
                guard let image : UIImage = UIImage(data: data) else {
                    return
                }
                DispatchQueue.main.async {
                    // assign image to the image view on the main thread
                    canadaTableViewCell.imageViewItem.image = image
                }
            }
        }else {
            print("NULL")
            // URL is nil
        }
        return canadaTableViewCell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
