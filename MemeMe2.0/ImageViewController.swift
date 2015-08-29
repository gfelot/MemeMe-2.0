//
//  ImageViewController.swift
//  
//
//  Created by Gil Felot on 29/08/15.
//
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var imageVC: UIImageView!
    var meme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        imageVC.image = meme.memedImage
    }
}
