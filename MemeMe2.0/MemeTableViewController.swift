//
//  MemeTableViewController.swift
//  
//
//  Created by Gil Felot on 27/08/15.
//
//

import UIKit

class MemeTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {

    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Jump to editorView if there is no Meme already.
        if memes == nil {
            let editorVC = storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
            navigationController!.pushViewController(editorVC, animated: true)
        }
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewCell") as! UITableViewCell
        let data = self.memes[indexPath.row]
        
        cell.imageView?.image = data.memedImage
        cell.textLabel?.text = data.topText
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let editorVC = storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        
        editorVC.imagePickerView.image = memes[indexPath.row].originalImage
        editorVC.topText.text = memes[indexPath.row].topText
        editorVC.botText.text = memes[indexPath.row].botText
        
        navigationController!.pushViewController(editorVC, animated: true)
    }
   
}