//
//  Extentions.swift
//  wordTest
//
//  Created by Habib on 11/12/18.
//  Copyright © 2018 Habib. All rights reserved.
//


import Foundation
import CoreGraphics
import SceneKit

extension SCNVector3 {
    
    // Vector Length is Zero
    func isZero() -> Bool {
        if self.x == 0 && self.y == 0 && self.z == 0 {
            return true
        }
        
        return false
    }
    
    /**
     Inverts vector
     */
    mutating func invert() -> SCNVector3 {
        self * -1
        return self
    }
    
    /**
     Calculates vector length based on Pythagoras theorem
     */
    var length:Float {
        get {
            return sqrtf(x*x + y*y + z*z)
        }
        set {
            self = self.unit * newValue
        }
    }
    
    /**
     Calculate Length Squared of Vector
     - Used to determine Longest/Shortest Vector. Faster than using v.length
     */
    var lengthSquared:Float {
        get {
            return self.x * self.x + self.y * self.y + self.z * self.z;
        }
    }
    
    /**
     Returns unit vector (aka Normalized Vector)
     - v.length = 1.0
     */
    var unit:SCNVector3 {
        get {
            return self / self.length
        }
    }
    
    /**
     Normalizes vector
     - v.Length = 1.0
     */
    mutating func normalize() {
        self = self.unit
    }
    
    /**
     Calculates distance to vector
     */
    func distance(toVector: SCNVector3) -> Float {
        return (self - toVector).length
    }
    
    
    /**
     Calculates dot product to vector
     */
    func dot(toVector: SCNVector3) -> Float {
        return x * toVector.x + y * toVector.y + z * toVector.z
    }
    
    /**
     Calculates cross product to vector
     */
    func cross(toVector: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(y * toVector.z - z * toVector.y, z * toVector.x - x * toVector.z, x * toVector.y - y * toVector.x)
    }
    
    /**
     Returns lerp from Vector to Vector
     */
    func lerp(toVector: SCNVector3, t: Float) -> SCNVector3 {
        return SCNVector3Make(
            self.x + ((toVector.x - self.x) * t),
            self.y + ((toVector.y - self.y) * t),
            self.z + ((toVector.z - self.z) * t))
    }
    
    /**
     Project onto Vector
     */
    func project(ontoVector: SCNVector3) -> SCNVector3 {
        let scale: Float = dotBetweenVectors(v1: ontoVector, v2: self) / dotBetweenVectors(v1: ontoVector, v2: ontoVector)
        let v: SCNVector3 = ontoVector * scale
        return v
    }
    
    /// Get/Set Angle of Vector
    mutating func rotate(angle:Float) {
        let length = self.length
        self.x = cos(angle) * length
        self.y = sin(angle) * length
    }
    
    
    func toCGVector() -> CGVector {
        return CGVector(dx: CGFloat(self.x), dy: CGFloat(self.y))
    }
    
    static func lineEulerAngles(vector: SCNVector3) -> SCNVector3 {
        let height = vector.length
        let lxz = sqrtf(vector.x * vector.x + vector.z * vector.z)
        let pitchB = vector.y < 0 ? Float.pi - asinf(lxz/height) : asinf(lxz/height)
        let pitch = vector.z == 0 ? pitchB : sign(vector.z) * pitchB
        
        var yaw: Float = 0
        if vector.x != 0 || vector.z != 0 {
            let inner = vector.x / (height * sinf(pitch))
            if inner > 1 || inner < -1 {
                yaw = Float.pi / 2
            } else {
                yaw = asinf(inner)
            }
        }
        return SCNVector3(CGFloat(pitch), CGFloat(yaw), 0)
    }
}

/**
 v1 = v2 + v3
 */
func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

/**
 v1 += v2
 */
func +=( left: inout SCNVector3, right: SCNVector3) {
    left = left + right
}

/**
 v1 = v2 - v3
 */
func -(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x - right.x, left.y - right.y, left.z - right.z)
}

/**
 v1 -= v2
 */
func -=( left: inout SCNVector3, right: SCNVector3) {
    left = left - right
}

/**
 v1 = v2 * v3
 */
func *(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x * right.x, left.y * right.y, left.z * right.z)
}

/**
 v1 *= v2
 */
func *=( left: inout SCNVector3, right: SCNVector3) {
    left = left * right
}

/**
 v1 = v2 * x
 */
func *(left: SCNVector3, right: Float) -> SCNVector3 {
    return SCNVector3Make(left.x * right, left.y * right, left.z * right)
}

/**
 v *= x
 */
func *=( left: inout SCNVector3, right: Float) {
    left = SCNVector3Make(left.x * right, left.y * right, left.z * right)
}

/**
 v1 = v2 / v3
 */
func /(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x / right.x, left.y / right.y, left.z / right.z)
}

/**
 v1 /= v2
 */
func /=( left: inout SCNVector3, right: SCNVector3) {
    left = SCNVector3Make(left.x / right.x, left.y / right.y, left.z / right.z)
}

/**
 v1 = v2 / x
 */
func /(left: SCNVector3, right: Float) -> SCNVector3 {
    return SCNVector3Make(left.x / right, left.y / right, left.z / right)
}

/**
 v /= x
 */
func /=( left: inout SCNVector3, right: Float) {
    left = SCNVector3Make(left.x / right, left.y / right, left.z / right)
}

/**
 v = -v
 */
prefix func -(v: SCNVector3) -> SCNVector3 {
    return v * -1
}

/**
 Returns distance between two vectors
 */
func distanceBetweenVectors(v1: SCNVector3, v2: SCNVector3) -> Float {
    return (v2 - v1).length
}

/**
 Returns dot product between two vectors
 */
func dotBetweenVectors(v1: SCNVector3, v2: SCNVector3) -> Float {
    return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z
}

/**
 Returns cross product between two vectors
 */
func crossBetweenVectors(v1: SCNVector3, v2: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(v1.y * v2.z - v1.z * v2.y, v1.z * v2.x - v1.x * v2.z, v1.x * v2.y - v1.y * v2.x)
}

/**
 Generate a Random Vector
 */
func randomSCNVector3(rangeX:Float, rangeY:Float, rangeZ:Float) -> SCNVector3 {
    
    return SCNVector3(
        x: Float(arc4random()%UInt32(rangeX)),
        y: Float(arc4random()%UInt32(rangeY)),
        z: Float(arc4random()%UInt32(rangeZ)))
}

func SCNVector3DotProduct(_ left: SCNVector3, right: SCNVector3) -> Float {
    return left.x * right.x + left.y * right.y + left.z * right.z
}

func SCNVector3Project(vectorToProject: SCNVector3, projectionVector: SCNVector3) -> SCNVector3 {
    let scale: Float = SCNVector3DotProduct(projectionVector, right: vectorToProject) / SCNVector3DotProduct(projectionVector, right: projectionVector)
    let v: SCNVector3 = projectionVector * scale
    return v
}

func SCNVector3ProjectPlane(vector: SCNVector3, planeNormal: SCNVector3 ) -> SCNVector3 {
    
    let projection = SCNVector3Project(vectorToProject: vector, projectionVector: planeNormal)
    
    return ( vector - projection )
}


