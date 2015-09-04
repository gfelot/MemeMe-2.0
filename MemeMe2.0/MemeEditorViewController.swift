//
//  MemeEditorViewController.swift
//  
//
//  Created by Gil Felot on 27/08/15.
//
//

import UIKit

class MemeEditorViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /* Outlet */
    //Image-Meme View
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var botText: UITextField!
    //Top Toolbar
    @IBOutlet weak var topBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    //Bottom Toolbar
    @IBOutlet weak var botBar: UIToolbar!
    @IBOutlet weak var folderButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    /* System func */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextAttribut(botText, str : " BOTTOM ")
        setTextAttribut(topText, str: " TOP ")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Check if Camera is available
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        // Disable shareButton if no image is set
        shareButton.enabled = imagePickerView.image != nil
        // Subscribe to KB notification
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // Don't forget to unsubscribe to KB notification
        unsubscribeFromKeyboardNotifications()
    }

    /* KeyBoard method */
    
    //Add an observer for KB notification
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:" , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:" , name: UIKeyboardWillHideNotification, object: nil)
    }
    //Remove thoses observer
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if botText.isFirstResponder() {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    // Get KB height to move the User View
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    /* Action to Album/Photo Button */
    
    //From Album Library
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .PhotoLibrary
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    //From Photo App
    @IBAction func pickAnImageFromPhoto(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .Camera
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    /* Delegate method from imagePickerController */
    
    //Func to pass the selected image to the imageVC
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Func to cancel selection
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    /* Method for textField attributs && control */
    
    //Attributes for styling the text in the text fields
    let memeTextAttribues = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
//        NSBackgroundColorAttributeName : UIColor.clearColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 38)!,
        NSStrokeWidthAttributeName : NSNumber(float: -3.0)
    ]
    
    //General method to set both textField attributs
    func setTextAttribut(textField : UITextField, str : String) {
        textField.delegate = self
        textField.text = str
        textField.defaultTextAttributes = memeTextAttribues
        textField.textAlignment = .Center
    }
    
    //Erase the default text when editing
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField == topText && topText.text == " TOP ") {
            topText.text = ""
        } else if (textField == botText && botText.text == " BOTTOM ") {
            botText.text = ""
        }
    }
    
    //Function that allows the user to use the return key to escape from the text input
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /* Meme method */
    
    func generateMemedImage() -> UIImage
    {
        topBar.hidden = true
        botBar.hidden = true
        
        //Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        topBar.hidden = false
        botBar.hidden = false
        
        return memedImage
    }
    
    func save() {
        //Create the meme
        var meme = Meme(topText: topText.text!, botText: botText.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        //Do Empociello style later ;)
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
    
    @IBAction func shareMeme(sender: AnyObject) {
        let memedImage = generateMemedImage()
        
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = {activity, completed, items, error in
            if completed {
                //Save the image
                self.save()
                //Dismiss the view controller
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}