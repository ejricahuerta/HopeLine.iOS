//
//  CommonResourcesView.swift
//  HopeLine.iOS
//
//  Created by Edmel John Ricahuerta on 2018-11-07.
//  Copyright © 2018 prj. All rights reserved.
//

import UIKit

class CommonResourcesController: UITableViewController {
    
    var comonItems =  NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 200.0;
        tableView.rowHeight = UITableViewAutomaticDimension;
        
        
        let stringUrl = "\(APIConstants.url)\(String(describing: title!))"
        print(stringUrl)
        let url = URL(string: stringUrl )
        
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data!) as! [NSDictionary]
                    print(parsedData)
                    DispatchQueue.main.async {
                        for item in parsedData
                        {
                            if self.title!.contains("resources") {
                                let newres = Resource(id: item.value(forKey: "id") as! Int, name: item.value(forKey: "name") as! String,desc: item.value(forKey: "description") as! String, url: item.value(forKey: "url") as! String, img: item.value(forKey: "imageurl") as! String)
                                print("\(newres.name!)")
                                self.comonItems.add(newres)
                            }
                            else {
                                let newCom = Community(id: item.value(forKey: "id") as? Int, name: item.value(forKey: "name") as! String,desc: item.value(forKey: "description") as! String, url: item.value(forKey: "url") as! String, img: item.value(forKey: "imageurl") as! String)
                                print("\(newCom.name!)")
                                self.comonItems.add(newCom)
                            }
                        }
                    self.tableView.reloadData()
                    }
        

                } catch let error as NSError {
                    DispatchQueue.main.async {
                        self.navigationController?.popToRootViewController(animated: false)
                    }

                    print(error.localizedDescription)
                }
            }
            

        }.resume()
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comonItems.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "commonCell", for: indexPath) as! CommonCell
        
        if title == "resources"{
            var obj: Resource?
            obj = comonItems.object(at: indexPath.row) as? Resource
            print(obj!)
            cell.commonTitle.text = obj?.name
            cell.commonImage.image = #imageLiteral(resourceName: "commonimg")
            cell.commonDescription.text = obj?.desc
            cell.commonLink.text = obj?.url
            cell.backgroundColor = UIColor(red: 111, green: 331, blue: 20, alpha: 1)
        }
        else {
            var obj: Community?
            obj = comonItems.object(at: indexPath.row) as? Community
            print(obj!)
            cell.commonTitle.text = obj?.name
            cell.commonImage.image = #imageLiteral(resourceName: "commonimg")
            cell.commonDescription.text = obj?.desc
            cell.commonLink.text = obj?.url
            cell.backgroundColor = UIColor(red: 111, green: 331, blue: 20, alpha: 1)
        }
        return cell
    }
    
    override  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = (comonItems.object(at: indexPath.row) as! Resource).url
        
        UIApplication.shared.open(URL(string: url!)!, options: [:], completionHandler: nil)
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
