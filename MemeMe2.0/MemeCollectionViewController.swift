//
//  MemeCollectionViewController.swift
//  
//
//  Created by Gil Felot on 27/08/15.
//
//

import UIKit

let reuseIdentifier = "MemeCollectionViewCell"

class MemeCollectionViewController: UICollectionViewController, UICollectionViewDataSource {

    @IBOutlet weak var flowLayout : UICollectionViewFlowLayout!
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        navigationItem.leftBarButtonItem = self.editButtonItem()
//        self.navigationItem.rightBarButtonItem = self.
        
        // Register cell classes
//        collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2*space)) / 3 //3 per line
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        collectionView!.reloadData()
        println(memes[0].topText + " " + memes[0].botText)
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
//    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        
//        return memes.count
//    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MemeCollectionViewCell
    
        // Configure the cell
        let meme = memes[indexPath.item]
        
        cell.backgroundView = UIImageView(image: meme.memedImage)
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //Grab the DetailVC from Storyboard
        let imageVC = self.storyboard!.instantiateViewControllerWithIdentifier("ImageViewController") as! ImageViewController
        imageVC.meme = memes[indexPath.row]
        navigationController!.pushViewController(imageVC, animated: true)
        
    }
    
    @IBAction func addMeme(sender: AnyObject) {
        performSegueWithIdentifier("addMemeFromCollection", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "addMemeFromCollection") {
            let editorVC: MemeEditorViewController = segue.destinationViewController as! MemeEditorViewController
        }
    }
    
    
}

























