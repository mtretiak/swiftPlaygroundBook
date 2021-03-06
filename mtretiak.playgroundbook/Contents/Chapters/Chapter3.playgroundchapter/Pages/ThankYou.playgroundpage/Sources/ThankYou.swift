import SpriteKit
import PlaygroundSupport


/// kit floating
public class Thing: SKSpriteNode {
    
    /// Types of available kits
    static let nbrAppearances: UInt32 = 7

    
    public convenience init() {
        
        /* Choose a random appearance */
        let randomIndex = 1 + Int(arc4random_uniform(Thing.nbrAppearances))
        
        self.init(imageNamed: "thing\(randomIndex)")
        
        /* Basic setup */
        name = "thing"
        setScale(0.3)
        
        /* Physics setup
           constant body moving which can collide */
        let body = SKPhysicsBody(circleOfRadius: 70 * xScale)
        body.allowsRotation = false
        body.affectedByGravity = false
        body.linearDamping = 0   // friction
        body.restitution   = 1   // don't lose velocity when colliding
        body.contactTestBitMask = 1  // contacts handled
        
        body.velocity = Thing.findRandomVelocity()
        
        self.physicsBody = body
        
        // float orientation
        zRotation = atan2(body.velocity.dy, body.velocity.dx)
    }
    
    class func findRandomVelocity() -> CGVector {
        
        let randomDest = Int(arc4random_uniform(50))
        let signX: CGFloat =  randomDest & 1       == 0 ? -1 : 1
        let signY: CGFloat = (randomDest & 2) >> 1 == 0 ? -1 : 1
        
        let velocityX = CGFloat(randomDest) // Initial speed of the thing
        let velocityY = CGFloat(arc4random_uniform(50))
        return CGVector(dx: signX * velocityX,
                        dy: signY * velocityY)
    }
    
    
    func reorient() {
        
        let velocity = physicsBody?.velocity ?? .zero
        let angle = atan2(velocity.dy, velocity.dx)
        
        run(.rotate(toAngle: angle, duration: 0.42))
    }
    
}


// MARK: -
/// Floating Kit Scene
public class KitScene: SKScene {
    
    /// Number of kits
    public var kits = 42
    
    /// Kits displayed on the screen
    var things = [Thing]()
    
    /// 1st line of text
    public var textLine1 = "Thank you"
    /// 2nd line of text
    public var textLine2 = "Michal Tretiak"
    
    /// Background text node, centered on the scene (1st line)
    var titleL1: SKLabelNode?
    /// Background text node, centered on the scene (2nd line underneath)
    var titleL2: SKLabelNode?
    
    /// Font size of the background text
    public var fontSize: CGFloat = 60
    
    /// Stores on-going contacts among nodes
    var contactQueue = Array<SKPhysicsContact>()
    
    
    /// Called when the scene is presented in a certain view
    ///
    /// - Parameter view: The view presenting this scene
    public override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        /* Basic scene setup */
        name = "scene"
        backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        scaleMode = .resizeFill
        
        /* Physics scene setup */
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        /* Backgound text setup */
        titleL1 = SKLabelNode(text: textLine1)
        titleL2 = SKLabelNode(text: textLine2)
        titleL1?.position  = self.view?.center ?? .zero
        titleL2?.position  = titleL1?.position ?? .zero
        titleL2?.position.y -= fontSize
        titleL1?.fontName  = UIFont.boldSystemFont(ofSize: 22).fontName
        titleL2?.fontName  = titleL1?.fontName
        titleL1?.fontSize  = fontSize
        titleL2?.fontSize  = fontSize
        titleL1?.fontColor = #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.2352941176, alpha: 1)
        titleL2?.fontColor = titleL1?.fontColor
//        titleL1?.zPosition = 10
//        titleL2?.zPosition = titleL1?.zPosition ?? 10
        addChild(titleL1!)
        addChild(titleL2!)
        
        /* Things placement */
        for _ in 0..<kits {
            /* Finds a random position on the scene, overlapping not handled */
            let posX = Int(arc4random_uniform(UInt32(size.width)))
            let posY = Int(arc4random_uniform(UInt32(size.height)))
            
            let thing = Thing()
            thing.position = CGPoint(x: posX, y: posY)
            addChild(thing)
            things.append(thing)
        }
    }
    
    /// Replaces objects when the scene is resized
    ///
    /// - Parameter oldSize: Old size of the scene
    public override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        
        /* Scene outside boundary */
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        /* Center text */
        if let titleL1 = titleL1,
           let titleL2 = titleL2 {
            titleL1.position = self.view?.center ?? .zero
            titleL2.position = titleL1.position
            titleL2.position.y -= fontSize
        }
    }
    
    /// Called when the user begins to touch the view
    ///
    /// - Parameters:
    ///   - touches: Touches in the Began phase
    ///   - event: Event to which touches belong
    public override func touchesBegan(_ touches: Set<UITouch>,
                                      with event: UIEvent?) {
        
        guard let touch = touches.first else {
            return
        }
        
        let touchPoint = touch.location(in: self)
        attractThings(to: touchPoint)
    }
    
    /// Called when the user moves their finger on the view
    ///
    /// - Parameters:
    ///   - touches: Touches in the Moved phase
    ///   - event: Event to which touches belong
    public override func touchesMoved(_ touches: Set<UITouch>,
                                      with event: UIEvent?) {
        
        guard let touch = touches.first else {
            return
        }
        
        let touchPoint = touch.location(in: self)
        attractThings(to: touchPoint)
    }
    
    /// Called when the user moves their finger on the view
    ///
    /// - Parameters:
    ///   - touches: Touches in the Ended phase
    ///   - event: Event to which touches belong
    public override func touchesEnded(_ touches: Set<UITouch>,
                                      with event: UIEvent?) {
        
        for thing in things {
            
            thing.physicsBody?.velocity = Thing.findRandomVelocity()
            thing.reorient()
        }
    }
    
    /// Move all things nodes to a specific point
    ///
    /// - Parameter point: Destination of all the things
    func attractThings(to point: CGPoint) {
        
        for thing in things {
            
            thing.physicsBody?.velocity = CGVector(dx: point.x - thing.position.x,
                                                    dy: point.y - thing.position.y)
            thing.reorient()
        }
    }
    
}

// MARK: - Contact handling for the scene
extension KitScene: SKPhysicsContactDelegate {
    
    /// Called at each frame
    ///
    /// - Parameter currentTime: Current time of the frame
    public override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        processContactForUpdate(currentTime)
    }
    
    /// Called when a contact among 2 objects arises
    ///
    /// - Parameter contact: Contact occurring and its data
    public func didBegin(_ contact: SKPhysicsContact) {
        contactQueue.append(contact)
    }
    
    /// Processes contacts at a current time frame
    ///
    /// - Parameter currentTime: Current time of the frame
    func processContactForUpdate(_ currentTime: TimeInterval) {
        
        let contacts = contactQueue
        
        /* Manage contacts one by one, then delete them from the stack */
        for contact in contacts {
            handleContact(contact)
            if let index = contactQueue.index(where: { $0 == contact }) {
                contactQueue.remove(at: index)
            }
        }
    }
    
    /// Handles some contact between 2 objects
    ///
    /// - Parameter contact: Contact occurring and its data
    func handleContact(_ contact: SKPhysicsContact) {
        
        /* If we really have 2 objects */
        if let bodyA = contact.bodyA.node,
           let bodyB = contact.bodyB.node {
            
            /* Store them and their name for easy access */
            let nodes = [bodyA, bodyB]
            let nodeNames = [bodyA.name, bodyB.name]
            
            /* We only manage contacts with a thing */
            if let thingIndex = nodeNames.index(where: { $0 == "thing" }) {
                
                /* If this thing hit a scene boundary */
                if nodeNames.contains(where: { $0 == "scene" })/* || nodeNames.contains(where: { $0 == "text" })*/ {
                    
                    /* Rotate the thing to follow the new path */
                    if let thing = (thingIndex > 0 ? bodyB : bodyA) as? Thing {
                        thing.reorient()
                    }
                    
                } else {
                    /* If the thing hit another */
                    for thing in nodes where thing is Thing {
                        /* Rotate each thing to follow their new path */
                        (thing as! Thing).reorient()
                    }
                }
            }
        }
    }
    
}
