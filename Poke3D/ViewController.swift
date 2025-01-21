//
//  ViewController.swift
//  Poke3D
//
//  Created by Isaac Urbina on 1/21/25.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
	
	// MARK: - IBOutlets
	
	@IBOutlet var sceneView: ARSCNView!
	
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Set the view's delegate
		sceneView.delegate = self
		
		// Show statistics such as fps and timing information
		sceneView.showsStatistics = true
		
		sceneView.autoenablesDefaultLighting = true
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// Create a session configuration
		let configuration = ARImageTrackingConfiguration()
		
		// set images to track
		if let imageToTrack = ARReferenceImage.referenceImages(
			inGroupNamed: "Pokemon Cards",
			bundle: Bundle.main
		) {
			configuration.trackingImages = imageToTrack
			configuration.maximumNumberOfTrackedImages = 2
			print("Images Successfully Added")
		}
		
		// Run the view's session
		sceneView.session.run(configuration)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		// Pause the view's session
		sceneView.session.pause()
	}
	
	
	// MARK: - ARSCNViewDelegate
	
	func renderer(_ renderer: any SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
		let node = SCNNode()
		
		if let imageAnchor = anchor as? ARImageAnchor {
			
			let planeNode = createPlaneNode(with: imageAnchor)
			node.addChildNode(planeNode)
			
			switch (imageAnchor.referenceImage.name){
			case "eevee" :
				let pokeNode = getPokeNode(named: "art.scnassets/eevee.scn")
				planeNode.addChildNode(pokeNode!)
				break
			
			case "oddish":
				let pokeNode = getPokeNode(named: "art.scnAssets/oddish.scn")
				planeNode.addChildNode(pokeNode!)
				break
			
			default: break
			}
		}
		
		return node
	}
	
	
	// MARK: - private functions
	
	private func createPlaneNode(with imageAnchor : ARImageAnchor) -> SCNNode {
		let plane = SCNPlane(
			width: imageAnchor.referenceImage.physicalSize.width,
			height: imageAnchor.referenceImage.physicalSize.height
		)
		
		plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
		
		let planeNode = SCNNode(geometry: plane)
		planeNode.eulerAngles.x = -.pi / 2
		
		return planeNode
	}
	
	private func getPokeNode(named asset: String) -> SCNNode? {
		if let pokeScene = SCNScene(named: asset) {
			
			if let pokeNode = pokeScene.rootNode.childNodes.first {
				pokeNode.eulerAngles.x = .pi / 2
				return pokeNode
			}
		}
		return nil
	}
}
