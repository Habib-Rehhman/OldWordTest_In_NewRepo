//
//  LocationTag.swift
//  wordTest
//
//  Created by Habib on 11/23/18.
//  Copyright © 2018 Habib. All rights reserved
//

import GameplayKit
import ARKit



class LocationTag: GKGraphNode {
    let name: String
    let point: SCNVector3
    var travelCost: [GKGraphNode: Float] = [:]
    
    init(name: String, point: SCNVector3) {
        self.name = name
        self.point = point
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = ""
        self.point = SCNVector3Zero
        super.init()
    }
    
//    override func cost(to node: GKGraphNode) -> Float {
//        return travelCost[node] ?? 0
//    }
    
    func addConnection(to node: GKGraphNode, bidirectional: Bool = true, weight: Float) {
        self.addConnections(to: [node], bidirectional: bidirectional)
//        travelCost[node] = weight
//        guard bidirectional else { return }
//        (node as? LocationTag)?.travelCost[self] = weight
    }
}



//func printCost(for path: [GKGraphNode]) {
//    var total: Float = 0
//    for i in 0..<(path.count-1) {
//        total += path[i].cost(to: path[i+1])
//    }
//    print(total)
//}
