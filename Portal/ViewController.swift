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
    
    
//MARK: - Placing Objects when User Taps Screen
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Identifying if User Touch was Detected
        guard let userTouch = touches.first
        else {
            fatalError("No Touch Detected by the User.")
        }
        
        //Getting the Location of Where the User Tapped
        let userTouchLocation = userTouch.location(in: sceneView)
        
        //Converting 2D Touch Location Coordinates to 3D Augemented Reality Ray
        guard let locationRayQuery = sceneView.raycastQuery(from: userTouchLocation, allowing: .existingPlaneInfinite, alignment: .any)
        else {
            fatalError("Unable to convert 2D Touch Coordinates to 3D Ray.")
        }
        
        let locationResults = sceneView.session.raycast(locationRayQuery)
        
    
        //Placing Object at Location of Touch
        if let safeResults = locationResults.first?.worldTransform {
            //worldTransform -> Converts AR coordinate to a REAL WORLD POSITION.
            
            let object = SCNBox(width: 0.08, height: 0.08, length: 0.08, chamferRadius: 0)
            
            object.firstMaterial?.diffuse.contents = UIColor.red
            
            let objectNode = SCNNode(geometry: object)
            
            //Getting 3D coordinates from 3D Ray
            let positionX = safeResults.columns.3.x
            let positionY = safeResults.columns.3.y
            let positionZ = safeResults.columns.3.z
            objectNode.position = SCNVector3(positionX, positionY + 0.04, positionZ)
            
            sceneView.scene.rootNode.addChildNode(objectNode)
            
            sceneView.automaticallyUpdatesLighting = true
        }
        
    }
    

}
