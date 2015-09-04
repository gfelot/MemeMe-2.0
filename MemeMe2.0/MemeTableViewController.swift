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
        navigationItem.leftBarButtonItem = editButtonItem()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        tableView!.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Jump to editorView if there is no Meme already.
        if memes == nil {
            performSegueWithIdentifier("isEmpty", sender: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "isEmpty") {
            let editorVC = segue.destinationViewController as! MemeEditorViewController
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewCell") as! UITableViewCell
        let data = memes[indexPath.row]
        
        cell.imageView?.image = data.memedImage
        cell.textLabel?.text = data.topText
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let editorVC = storyboard?.instantiateViewControllerWithIdentifier("ImageViewController") as! ImageViewController
        println(memes[indexPath.row].topText)
        editorVC.meme = memes[indexPath.row]
        
        navigationController!.pushViewController(editorVC, animated: true)
    }
   
    @IBAction func addMeme(sender: AnyObject) {
        performSegueWithIdentifier("isEmpty", sender: nil)
    }
}