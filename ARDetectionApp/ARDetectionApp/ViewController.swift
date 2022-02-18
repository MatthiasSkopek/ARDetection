

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegateÍÍ
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/GameScene.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Object Detection
        configuration.detectionObjects = ARReferenceObject.referenceObjects(inGroupNamed: "CoffeeObjects", bundle: Bundle.main)!

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        if let objectAnchor = anchor as? ARObjectAnchor {
            print(objectAnchor.name!)
            switch objectAnchor.name{
            case "CoffeeGrinder_v3":
                node.addChildNode(createPlane(_name: "ProductInfo", _anchor: objectAnchor)!)
                break;
            case "Storage":
                node.addChildNode(createPlane(_name: "storage", _anchor: objectAnchor)!)
                break;
            case "Tray":
                node.addChildNode(createPlane(_name: "BottomBay", _anchor: objectAnchor)!)
                break;
            case "Brush":
                node.addChildNode(createPlane(_name: "brush", _anchor: objectAnchor)!)
                break;
            case "SmallInsert":
                node.addChildNode(createPlane(_name: "SmallInsert", _anchor: objectAnchor)!)
                break;
            case "TopCap_v3":
                node.addChildNode(createPlane(_name: "Information_Cap", _anchor: objectAnchor)!)
                break;
            case "BigInsert":
                node.addChildNode(createPlane(_name: "BigInsert", _anchor: objectAnchor)!)
                break;
            default:
                print("nothing found")
            }
        }
        
        return node
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
    func createPlane(_name: String, _anchor: ARObjectAnchor) -> SCNNode?{
        let plane = SCNPlane()
        let spriteKitScene = SKScene(fileNamed: _name)
        plane.firstMaterial?.diffuse.contents = spriteKitScene
        plane.firstMaterial?.isDoubleSided = true
        plane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
        plane.width = plane.width * 0.1
        plane.height = plane.height * 0.1
        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3Make(_anchor.referenceObject.center.x, _anchor.referenceObject.center.y + 0.05, _anchor.referenceObject.center.z)
        planeNode.orientation = SCNQuaternion(0, 1, 0, 1)
        return planeNode
    }
}
