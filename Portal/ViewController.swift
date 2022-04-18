//
//  ViewController.swift
//  Portal
//
//  Created by Saransh Duggal on 2022-04-17.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    
// MARK: - Horizontal Plane Creation (ARSCNViewDelegate Methods)
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let portalNode = SCNNode() //Parent Node to hold Horizontal Plane
        
        //Detecting Plane
        guard let planeAnchor = anchor as? ARPlaneAnchor
        else {
            fatalError("Unable to Detect Horizontal Plane")
        }
        
        //Creating Horizontal Plane
        let planeHeight = CGFloat(planeAnchor.extent.z)
        let planeWidth = CGFloat(planeAnchor.extent.x)
        let horizontalPlane = SCNPlane(width: planeWidth, height: planeHeight)
        horizontalPlane.firstMaterial?.diffuse.contents = UIColor.blue.withAlphaComponent(0.8)
        
        //Creating Plane Node
        let horizontalPlaneNode = SCNNode(geometry: horizontalPlane)
        
        //Transforming Plane from Vertical to Horizontal
        horizontalPlaneNode.transform = SCNMatrix4MakeRotation(-(Float.pi)/2, 1, 0, 0)
        
        //Adding Plane Node to Parent Node
        portalNode.addChildNode(horizontalPlaneNode)
        
        return portalNode
    }
    

}
