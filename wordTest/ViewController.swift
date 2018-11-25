//
//  ViewController.swift
//  wordTest . T
//
//  Created by Habib on 11/11/18.
//  Copyright © 2018 Habib. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import UserNotifications
import GameplayKit

class ViewController: UIViewController, ARSCNViewDelegate, UITextFieldDelegate {
    // MARK: Properties
   
    @IBOutlet weak var ARView: ARSCNView!
//     var currentPositionOfCamera: SCNVector3
//    {
//        get{
//            let pointOfView = ARView.pointOfView!
//            let transform = pointOfView.transform
//            let orientation = SCNVector3(-transform.m31,-transform.m32,-transform.m33)
//            let location = SCNVector3(transform.m41,transform.m42,transform.m43)
//            return orientation + location
//        }
//    }

    var tagArray: [LocationTag] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ARView.debugOptions = [ARSCNDebugOptions.showWorldOrigin]
        self.ARView.delegate = self
        //self.delegate? = self
        menu()
        
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
    
//    
//    @IBAction func handleShowPaths(_ sender: Any) {
//
//        //This block removes previous arrows
//        self.ARView.scene.rootNode.enumerateChildNodes { (node, stop) in
//            if (node.name != nil && (node.name!.elementsEqual("arrow") || node.name!.elementsEqual("cam"))){
//            node.removeFromParentNode()
//
//            }
//        }
//        let tagGraph = GKGraph()
//        //This block adds new arrows
//         if(tagArray.count>0){
//            tagGraph.add(tagArray)
//            tagArray.append(LocationTag(name: "cam", point: SCNVector3Make(currentPositionOfCamera.x, currentPositionOfCamera.y, currentPositionOfCamera.z)))
//
//            let nearest = calculateNearestNode(cam: tagArray[tagArray.count-1].point)
//                tagArray[tagArray.count-1].addConnection(to: nearest, bidirectional: true, weight: distanceBetweenVectors(v1: tagArray[tagArray.count-1].point, v2: nearest.point))
//
//
//            var path = tagGraph.findPath(from: tagArray[tagArray.count-1], to: tagArray[2]) //will crash if the length is less then 3
//           for p in 0 ..< path.count-1 {
//
//            print("\((path[p] as! LocationTag).name) -> \((path[p+1] as! LocationTag).name), Edge Cost: ")
//              drawPath(from: (path[p] as! LocationTag).point , to: (path[p+1] as! LocationTag).point)
//
//            }
//    }
//    }
//    func calculateNearestNode(cam: SCNVector3) -> LocationTag
//    {
//        var nearest = distanceBetweenVectors(v1: tagArray[0].point, v2: cam)
//        var dis: Float
//        var haveIndx = 0
//        for i in 1 ..< tagArray.count-1
//        {
//             dis = distanceBetweenVectors(v1: tagArray[i].point, v2: cam)
//            if(dis < nearest){
//
//                haveIndx = i
//                nearest = dis
//            }
//
//        }
//        return tagArray[haveIndx]
//    }
//    func drawPath(from: SCNVector3, to: SCNVector3)// tag: String)
//    {
//        let distancePieces =  integer_t(((distanceBetweenVectors(v1: from, v2: to))/0.15).rounded(.up))
//        var i = 1
//        var multiple: Float = 0
//        var node: LineNode
//        var lerp = SCNVector3Zero
//        var frm = from
//        while(i <= distancePieces)
//        {
//
//            lerp = frm.lerp(toVector: to, t: 0.15 * multiple)//(float_t(i) * 0.15).rounded(.up))
//
//            if(i % 2 != 0 )
//            {
//               // print(i)
//                node = LineNode(v1: frm, v2: lerp)
//                node.name = "arrow"
//                self.ARView.scene.rootNode.addChildNode(node)
//              //  print("distance is \(frm.distance(toVector: lerp))")
//
//            }
//            frm = lerp
//            i = i+1
//            multiple = multiple + 0.15;
//        }
//
//    }
//
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        ARView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ARView.session.pause()
    }
//
//    func updateAct(showText: String) {
//
//        if(showText.isEmpty)
//        {
//            //show text enter notification
//            let content = UNMutableNotificationContent()
//            content.title = "Metro Station Map"
//            content.body =  " Enter the Stop Name to add"
//            content.sound = UNNotificationSound.default
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.2, repeats: false)
//            let request = UNNotificationRequest(identifier: "TestIdentifier", content: content, trigger: trigger)
//            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//        return
//        }
//        tagArray.append(LocationTag(name: showText, point: SCNVector3Make(currentPositionOfCamera.x, currentPositionOfCamera.y-1, currentPositionOfCamera.z)))
//        for ind in 0 ..< tagArray.count{
//
//            for innerInd in ind ..< tagArray.count-1{
//
//                tagArray[innerInd].addConnection(to: tagArray[innerInd+1], bidirectional: true, weight: distanceBetweenVectors(v1: tagArray[innerInd].point, v2: tagArray[innerInd+1].point))
//            }
//        }
//        let text = SCNText(string: showText, extrusionDepth: 1)
//        print("not returned")
//        let material = SCNMaterial()
//        material.diffuse.contents = UIColor.green
//        text.materials = [material]
//
//        let node = SCNNode()
//        node.position = currentPositionOfCamera
//        node.scale = SCNVector3(x:0.01,y:0.01,z:0.01)
//        node.geometry = text
//        let eulerAngles = self.ARView.session.currentFrame?.camera.eulerAngles
//        node.eulerAngles = SCNVector3(eulerAngles!.x, eulerAngles!.y, eulerAngles!.z + .pi / 2)
//
//
//        //notification
//        let content = UNMutableNotificationContent()
//        content.title = "Metro Station Map"
//        content.body =  " Stop added successfuly!"
//        content.sound = UNNotificationSound.default // These paranthesis are necessary for swift 3, for 4 no parenthesis
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.2, repeats: false)
//        let request = UNNotificationRequest(identifier: "TestIdentifier", content: content, trigger: trigger)
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//
//        self.ARView.scene.rootNode.addChildNode(node)
//
//
//
//        }
//
    
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
        print("TextField should begin editing method called")
        return true
    }
    
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        // became first responder
        print("TextField did begin editing method called")
    }
    
    @objc  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
        print("TextField should snd editing method called")
        return true
    }
    
    @objc  func textFieldDidEndEditing(_ textField: UITextField) {
        // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
        print("TextField did end editing method called")
        
        
    }
    
    @objc  func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        // if implemented, called in place of textFieldDidEndEditing:
        print("TextField did end editing with reason method called")
    }
    
    @objc  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // return NO to not change text
        print("While entering the characters this method gets called")
        return true
    }
    
    @objc  func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // called when clear button pressed. return NO to ignore (no notifications)
        print("TextField should clear method called")
        return true
    }
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // called when 'return' key pressed. return NO to ignore.
        print("TextField should return method called")
        // may be useful: textField.resignFirstResponder()
        let s = Adapter.item!.inputText.text!
        Adapter.item!.updateAct(showText: s)
        
        if let viewWithTag = Adapter.AR!.ARView.viewWithTag(23) {
            viewWithTag.removeFromSuperview()
            
        }else{
            print("No!")
        }
        
        
        return true
    }
    
}

// MARK: UITextFieldDelegate <---
