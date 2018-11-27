//
//  ExpandingMenuButtonItem.swift
//
//  Created by monoqlo on 2015/07/17.
//  Copyright (c) 2015年 monoqlo All rights reserved
//
import ARKit
import UserNotifications
import GameKit
import UIKit

open class ExpandingMenuItem: UIView {
    
    
   
    var inputText =  UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
    let navigationField = SearchTextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
    var currentPositionOfCamera: SCNVector3
    {
        get{
            let pointOfView = Adapter.AR!.ARView.pointOfView!
            let transform = pointOfView.transform
            let orientation = SCNVector3(-transform.m31,-transform.m32,-transform.m33)
            let location = SCNVector3(transform.m41,transform.m42,transform.m43)
            return orientation + location
        }
    }
    
   
    
    
    
    
    @objc open var title: String? {
        get { return self.titleButton?.titleLabel?.text }
        set {
            if let title = newValue {
                if let titleButton = self.titleButton {
                    #if swift(>=4.2)
                    titleButton.setTitle(title, for: UIControl.State())
                    #else
                    titleButton.setTitle(title, for: UIControlState())
                    #endif
                } else {
                    self.titleButton = self.createTitleButton(title, titleColor: self.titleColor)
                }
                self.titleButton?.sizeToFit()
            } else {
                self.titleButton = nil
            }
        }
    }
    
    @objc open var titleMargin: CGFloat = 5.0
    
    #if swift(>=4.2)
    @objc open var titleColor: UIColor? {
        get { return self.titleButton?.titleColor(for: UIControl.State()) }
        set { self.titleButton?.setTitleColor(newValue, for: UIControl.State()) }
    }
    #else
    @objc open var titleColor: UIColor? {
        get { return self.titleButton?.titleColor(for: UIControlState()) }
        set { self.titleButton?.setTitleColor(newValue, for: UIControlState()) }
    }
    #endif
    
    @objc var titleTappedActionEnabled: Bool = true {
        didSet {
            self.titleButton?.isUserInteractionEnabled = titleTappedActionEnabled
        }
    }
    
    var index: Int = 0
    weak var delegate: ExpandingMenuButton?
    fileprivate(set) var titleButton: UIButton?
    fileprivate var frontImageView: UIImageView
    fileprivate var tappedAction: (() -> Void)?
    
    // MARK: - Initializer
    public init(size: CGSize?, title: String? = nil, titleColor: UIColor? = nil, image: UIImage, highlightedImage: UIImage?, backgroundImage: UIImage?, backgroundHighlightedImage: UIImage?, itemTapped: (() -> Void)?) {
        
        // Initialize properties
        //
        self.frontImageView = UIImageView(image: image, highlightedImage: highlightedImage)
        self.tappedAction = itemTapped
        
        // Configure frame
        //
        let itemFrame: CGRect
        if let itemSize = size , itemSize != CGSize.zero {
            itemFrame = CGRect(x: 0.0, y: 0.0, width: itemSize.width, height: itemSize.height)
        } else {
            if let bgImage = backgroundImage , backgroundHighlightedImage != nil {
                itemFrame = CGRect(x: 0.0, y: 0.0, width: bgImage.size.width, height: bgImage.size.height)
            } else {
                itemFrame = CGRect(x: 0.0, y: 0.0, width: image.size.width, height: image.size.height)
            }
        }
        
        super.init(frame: itemFrame)
        
        // Configure base button
        //
        let baseButton = UIButton()
        #if swift(>=4.2)
        baseButton.setImage(backgroundImage, for: UIControl.State())
        #else
        baseButton.setImage(backgroundImage, for: UIControlState())
        #endif
        baseButton.setImage(backgroundHighlightedImage, for: .highlighted)
        baseButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(baseButton)
        
        self.addConstraint(NSLayoutConstraint(item: baseButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: baseButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: baseButton, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: baseButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
        
        
        // Add an action for the item
        //
        baseButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        
        // Configure front images
        //
        self.frontImageView.contentMode = .center
        self.frontImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.frontImageView)
        
        self.addConstraint(NSLayoutConstraint(item: self.frontImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.frontImageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.frontImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.frontImageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
        
        // Configure title button
        //
        if let title = title {
            self.titleButton = self.createTitleButton(title, titleColor: titleColor)
        }
    }
    
    @objc public convenience init(image: UIImage, highlightedImage: UIImage, backgroundImage: UIImage?, backgroundHighlightedImage: UIImage?, itemTapped: (() -> Void)?) {
        self.init(size: nil, title: nil, image: image, highlightedImage: highlightedImage, backgroundImage: backgroundImage, backgroundHighlightedImage: backgroundHighlightedImage, itemTapped: itemTapped)
    }
    
    @objc public convenience init(title: String, titleColor: UIColor? = nil, image: UIImage, highlightedImage: UIImage, backgroundImage: UIImage?, backgroundHighlightedImage: UIImage?, itemTapped: (() -> Void)?) {
        self.init(size: nil, title: title, titleColor: titleColor, image: image, highlightedImage: highlightedImage, backgroundImage: backgroundImage, backgroundHighlightedImage: backgroundHighlightedImage, itemTapped: itemTapped)
    }
    
    @objc public convenience init(size: CGSize, image: UIImage, highlightedImage: UIImage, backgroundImage: UIImage?, backgroundHighlightedImage: UIImage?, itemTapped: (() -> Void)?) {
        self.init(size: size, title: nil, image: image, highlightedImage: highlightedImage, backgroundImage: backgroundImage, backgroundHighlightedImage: backgroundHighlightedImage, itemTapped: itemTapped)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.frontImageView = UIImageView()
        
        super.init(coder: aDecoder)
    }
    
    // MARK: - Title Button
    fileprivate func createTitleButton(_ title: String, titleColor: UIColor? = nil) -> UIButton {
        let button = UIButton()
        #if swift(>=4.2)
        button.setTitle(title, for: UIControl.State())
        button.setTitleColor(titleColor, for: UIControl.State())
        #else
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(titleColor, for: UIControlState())
        #endif
        button.sizeToFit()
        
        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        
        return button
    }
    
    // MARK: - Tapped Action
    @objc func tapped() {
        self.delegate?.menuItemTapped(self)
        
        if(self.index==0){
            inputText.placeholder = "Enter text here"
            inputText.font = UIFont.systemFont(ofSize: 15)
            inputText.borderStyle = UITextField.BorderStyle.roundedRect
            inputText.autocorrectionType = UITextAutocorrectionType.no
            inputText.keyboardType = UIKeyboardType.default
            inputText.returnKeyType = UIReturnKeyType.done
            inputText.clearButtonMode = UITextField.ViewMode.whileEditing;
            inputText.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
            inputText.clearsOnBeginEditing = true
            inputText.becomeFirstResponder()
            inputText.tag = 23
            inputText.delegate = Adapter.AR! //as? UITextFieldDelegate
            Adapter.AR!.ARView.addSubview(inputText)
            Adapter.item = self
        }else if(self.index==1){
          
            navigationField.backgroundColor = UIColor.white
            navigationField.borderStyle = UITextField.BorderStyle.roundedRect
            navigationField.placeholder = "Where to?"
            navigationField.keyboardType = UIKeyboardType.default
            navigationField.returnKeyType = UIReturnKeyType.done
            navigationField.clearsOnBeginEditing = true
            navigationField.becomeFirstResponder()
            navigationField.tag = 24
            navigationField.highlightAttributes = [NSAttributedString.Key.backgroundColor: UIColor.red, NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 12)]

            let header = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
            header.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
            header.textAlignment = .center
            header.font = UIFont.boldSystemFont(ofSize: 14)//.systemFont(ofSize: 15)
            header.textColor = UIColor.red
            header.text = "Pick A Stop"
            navigationField.resultsListHeader = header
            
            
            navigationField.itemSelectionHandler = {tem, itemPosition in
                self.navigationField.text = tem[itemPosition].title
            }
            
            
            
            //navigationField.startVisible = true
            navigationField.forceNoFiltering = false
            navigationField.delegate = Adapter.AR! //as? UITextFieldDelegate
            Adapter.AR!.ARView.addSubview(navigationField)
            Adapter.item = self
            navigationField.filterStrings(Adapter.stopsArray)
            //handleShowPaths()
        }else{
            print("Index Not Found")
        }
        
        
        self.tappedAction?()
    }
    
    // MARK: UpdateAct
    func updateAct(showText: String) {
        
        if(showText.isEmpty)
        {
            //show text enter notification
            let content = UNMutableNotificationContent()
            content.title = "Metro Station Map"
            content.body =  " Enter the Stop Name to add"
            content.sound = UNNotificationSound.default
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.2, repeats: false)
            let request = UNNotificationRequest(identifier: "TestIdentifier", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            return
        }
        Adapter.tagArray.append(LocationTag(name: showText, point: SCNVector3Make(currentPositionOfCamera.x, currentPositionOfCamera.y-1, currentPositionOfCamera.z)))
        Adapter.stopsArray.append(Adapter.tagArray.last!.name)
        for ind in 0 ..< Adapter.tagArray.count-1{
                
                Adapter.tagArray.last!.addConnection(to: Adapter.tagArray[ind], bidirectional: true, weight: distanceBetweenVectors(v1: Adapter.tagArray[ind].point, v2: Adapter.tagArray[ind+1].point))
              print("\nAdding connection from '\(Adapter.tagArray.last!.name)' to '\(Adapter.tagArray[ind].name)'\n")
            
        }
        let text = SCNText(string: showText, extrusionDepth: 1)
        print("not returned")
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.green
        text.materials = [material]
        
        let node = SCNNode()
        node.position = currentPositionOfCamera
        node.scale = SCNVector3(x:0.01,y:0.01,z:0.01)
        node.geometry = text
        let eulerAngles = Adapter.AR!.ARView.session.currentFrame?.camera.eulerAngles
        node.eulerAngles = SCNVector3(eulerAngles!.x, eulerAngles!.y, eulerAngles!.z + .pi / 2)
        
        
        //notification
        let content = UNMutableNotificationContent()
        content.title = "Metro Station Map"
        content.body =  " Stop added successfuly!"
        content.sound = UNNotificationSound.default // These paranthesis are necessary for swift 3, for 4 no parenthesis
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.2, repeats: false)
        let request = UNNotificationRequest(identifier: "TestIdentifier", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        Adapter.AR!.ARView.scene.rootNode.addChildNode(node)
        
        
        
    }
    
    
    // MARK: handleShowPath
    func handleShowPaths(drawTo: Int) {
        
        //This block removes previous arrows
        Adapter.AR!.ARView.scene.rootNode.enumerateChildNodes { (node, stop) in
            if (node.name != nil && (node.name!.elementsEqual("arrow"))){
                node.removeFromParentNode()
            }
        }
        let tagGraph = GKGraph()
        //This block adds new arrows
        if(Adapter.tagArray.count>0){
            
            tagGraph.add(Adapter.tagArray)
//          Adapter.tagArray.append(LocationTag(name: "cam", point: SCNVector3Make(currentPositionOfCamera.x, currentPositionOfCamera.y, currentPositionOfCamera.z)))
            let camTag = LocationTag(name: "cam", point: SCNVector3Make(currentPositionOfCamera.x, currentPositionOfCamera.y, currentPositionOfCamera.z))
            let nearest = calculateNearestNode(cam: camTag.point)
           camTag.addConnection(to: nearest, bidirectional: true, weight: distanceBetweenVectors(v1: Adapter.tagArray[Adapter.tagArray.count-1].point, v2: nearest.point))
            
            drawPath(from: camTag.point , to: nearest.point)

            
             var path = tagGraph.findPath(from: nearest, to: Adapter.tagArray[drawTo])
            for p in 0 ..< path.count-1 {
                
                print("\((path[p] as! LocationTag).name) -> \((path[p+1] as! LocationTag).name), Edge Cost: ")
                drawPath(from: (path[p] as! LocationTag).point , to: (path[p+1] as! LocationTag).point)
                
            }
        }
    }
    // MARK: DrawPath()
    func drawPath(from: SCNVector3, to: SCNVector3)// tag: String)
    {
        let distancePieces =  integer_t(((distanceBetweenVectors(v1: from, v2: to))/0.15).rounded(.up))
        var i = 1
        var multiple: Float = 0
        var node: LineNode
        var lerp = SCNVector3Zero
        var frm = from
        while(i <= distancePieces)
        {
            
            lerp = frm.lerp(toVector: to, t: 0.15 * multiple)//(float_t(i) * 0.15).rounded(.up))
            
            if(i % 2 != 0 )
            {
                // print(i)
                node = LineNode(v1: frm, v2: lerp)
                node.name = "arrow"
                Adapter.AR!.ARView.scene.rootNode.addChildNode(node)
                //  print("distance is \(frm.distance(toVector: lerp))")
                
            }
            frm = lerp
            i = i+1
            multiple = multiple + 0.15;
        }
        
    }
    
    
    
    
    //MARK: Calculate Nearest Node
    
    func calculateNearestNode(cam: SCNVector3) -> LocationTag
    {
        var nearest = distanceBetweenVectors(v1: Adapter.tagArray[0].point, v2: cam)
        var dis: Float
        var haveIndx = 0
        for i in 1 ..< Adapter.tagArray.count
        {
            dis = distanceBetweenVectors(v1: Adapter.tagArray[i].point, v2: cam)
            if(dis < nearest){
                
                haveIndx = i
                nearest = dis
            }
            
        }
        return Adapter.tagArray[haveIndx]
    }
    
    
}

