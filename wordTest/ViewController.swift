//
//  ViewController.swift
//  wordTest . T
//
//  Created by Habib on 11/11/18.
//  Copyright © 2018 Habib. All rights reserved
//

import UIKit
import ARKit
import SceneKit
import UserNotifications
import GameplayKit

class ViewController: UIViewController, ARSCNViewDelegate, UITextFieldDelegate {
    // MARK: Properties
   
    @IBOutlet weak var ARView: ARSCNView!

    var tagArray: [LocationTag] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ARView.debugOptions = [ARSCNDebugOptions.showWorldOrigin]
        self.ARView.delegate = self
        //self.delegate? = self
        menu()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        if let viewWithTag = Adapter.AR!.ARView.viewWithTag(23) {
            viewWithTag.removeFromSuperview()
            
        }
    }
        func menu()
        {
            let menuButtonSize: CGSize = CGSize(width: 64.0, height: 64.0)
            let menuButton = ExpandingMenuButton(frame: CGRect(origin: CGPoint.zero, size: menuButtonSize), image: UIImage(named: "chooser-button-tab")!, rotatedImage: UIImage(named: "chooser-button-tab-highlighted")!)
            menuButton.center = CGPoint(x: self.view.bounds.width - 32.0, y: self.view.bounds.height - 72.0)
            view.addSubview(menuButton)
    
            let dropPin = ExpandingMenuItem(size: menuButtonSize, title: "Drop Pin", image: UIImage(named: "chooser-moment-icon-music")!, highlightedImage: UIImage(named: "chooser-moment-icon-music-highlighted")!, backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted")) { () -> Void in
                // Do some action
            }
    
    
            let navigation = ExpandingMenuItem(size: menuButtonSize, title: "Navigate", image: UIImage(named: "chooser-moment-icon-sleep")!, highlightedImage: UIImage(named: "chooser-moment-icon-sleep-highlighted")!, backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted")) { () -> Void in
                // Do some action
            }
    
            Adapter.AR = self
            menuButton.addMenuItems([dropPin,navigation])
        }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        ARView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ARView.session.pause()
    }
    
    }


    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user

    }

    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay

    }

    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required

    }

    
// OUT
class LineNode: SCNNode
{
    init(
        v1: SCNVector3,  // where line starts
        v2: SCNVector3
                      // where line ends
         )  // any material.
    {
        super.init()
        let  height1 = self.distanceBetweenPoints2(A: v1, B: v2) as CGFloat //v1.distance(v2)
        
        position = v1
        
        let ndV2 = SCNNode()
        
        ndV2.position = v2
        
        let ndZAlign = SCNNode()
        ndZAlign.eulerAngles.x = Float.pi/2
        
        let cylgeo = SCNBox(width: 0.2, height: height1, length: 0.001, chamferRadius: 0)
        cylgeo.firstMaterial?.diffuse.contents = UIImage(named: "Arrow")
        
        let ndCylinder = SCNNode(geometry: cylgeo )
        ndCylinder.position.y = Float(-height1/2) + 0.001
        ndZAlign.addChildNode(ndCylinder)
        
        addChildNode(ndZAlign)
        
        
        constraints = [SCNLookAtConstraint(target: ndV2)]
}

    override init() {
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func distanceBetweenPoints2(A: SCNVector3, B: SCNVector3) -> CGFloat {
        let l = sqrt(
            (A.x - B.x) * (A.x - B.x)
                +   (A.y - B.y) * (A.y - B.y)
                +   (A.z - B.z) * (A.z - B.z)
        )
        return CGFloat(l)
    }
}


// MARK:- ---> UITextFieldDelegate

extension ViewController {
    
    @objc func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // return NO to disallow editing.
       // print("TextField should begin editing method called")
        return true
    }
    
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        // became first responder
       // print("TextField did begin editing method called")
    }
    
    @objc  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
      //  print("TextField should snd editing method called")
        return true
    }
    
    @objc  func textFieldDidEndEditing(_ textField: UITextField) {
        // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
        //print("TextField did end editing method called")
        
        
    }
    
    @objc  func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        // if implemented, called in place of textFieldDidEndEditing:
        //print("TextField did end editing with reason method called")
    }
    
    @objc  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // return NO to not change text
       // print("While entering the characters this method gets called")
        return true
    }
    
    @objc  func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // called when clear button pressed. return NO to ignore (no notifications)
       // print("TextField should clear method called")
        return true
    }
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // called when 'return' key pressed. return NO to ignore.
        //print("TextField should return method called")
        
        if(Adapter.item?.index == 0){
        let s = Adapter.item!.inputText.text!
        Adapter.item!.updateAct(showText: s)
        
        if let viewWithTag = Adapter.AR!.ARView.viewWithTag(23) {
            viewWithTag.removeFromSuperview()
            
        }
        }else{
            let s = Adapter.item!.navigationField.text!
            if(Adapter.stopsArray.firstIndex(of: s) == nil){
                return false
            }
            Adapter.item!.handleShowPaths(drawTo: Adapter.stopsArray.firstIndex(of: s)!)//updateAct(showText: s)
            
            if let viewWithTag = Adapter.AR!.ARView.viewWithTag(24) {
                viewWithTag.removeFromSuperview()
                
            }
        }
        
        
        return true
    }
    
}

 //MARK: UITextFieldDelegate <---
