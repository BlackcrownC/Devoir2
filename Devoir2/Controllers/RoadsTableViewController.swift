//
//  RoadsTableViewController.swift
//  Devoir2
//
//  Created by Mac11 on 2021-05-06.
//

import UIKit

class RoadTableViewCell: UITableViewCell {
    var road: Road?
    var isFavorite: Bool?
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBAction func addToFavorite(_ sender: Any) {
        let dao = FavoriteDAO()
        if isFavorite! {
            isFavorite = false
            button.setImage(UIImage(systemName: "star"), for: UIControl.State.normal)
            dao.remove(email: connectedUser, road: road!)
        } else {
            isFavorite = true
            button.setImage(UIImage(systemName: "star.fill"), for: UIControl.State.normal)
            dao.add(email: connectedUser, road: road!)
        }
        print(dao.getRoadsByEmail(email: connectedUser)!)
    }
    
}

class RoadsTableViewController: UITableViewController {

    var favoriteRoads:[Road]?
    
    var sector:Sector?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dao = FavoriteDAO()
        favoriteRoads = dao.getRoadsByEmail(email: connectedUser)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (sector?.roads!.count)!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "roadCell", for: indexPath) as! RoadTableViewCell
        
        let roads = sector?.roads?.allObjects as! [Road]
        let road = roads[indexPath.row]
        
        cell.label.text = road.title
        cell.road = road
        cell.isFavorite = false
        if favoriteRoads != nil {
            for r in favoriteRoads! {
                if r == road {
                    cell.button.setImage(UIImage(systemName: "star.fill"), for: UIControl.State.normal)
                    cell.isFavorite = true
                    break
                }
            }
        }

        return cell
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
