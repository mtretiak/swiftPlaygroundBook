import SpriteKit

/// Defines a skill
public struct Skill {
    
    /// Radius of the skill
    public enum SkillSize: CGFloat {
        case small  = 25
        case medium = 30
        case big    = 42
    }
    
    public var name = ""
    public var size: SkillSize = .medium
    public var fontSize: CGFloat = 30
    
    public init(name: String, size: SkillSize = .medium, fontSize: CGFloat = 30) {
        self.name = name
        self.size = size
        self.fontSize = fontSize
    }
}

/// Node associated to a skill and displayed
class SkillNode: SKNode {
    
    let skill: Skill
    
    init(with skill: Skill, velocityFact: CGFloat = 1) {
        
        // Set up the skill before setting self
        self.skill = skill
        
        super.init()
        
        /// Circle representing the skill in its size
        let skillNode = SKShapeNode(circleOfRadius: skill.size.rawValue)
        skillNode.fillColor = #colorLiteral(red: 0.5294117647, green: 0.7176470588, blue: 0.8235294118, alpha: 1)
        skillNode.position = self.position
        addChild(skillNode)
        
        /// Name of the skill displayed in the center of the circle
        let skillText = SKLabelNode(text: skill.name)
        skillText.fontSize = skill.fontSize
        skillText.fontName = UIFont.systemFont(ofSize: skill.fontSize).fontName
        skillText.fontColor = #colorLiteral(red: 0.07450980392, green: 0.1490196078, blue: 0.2039215686, alpha: 1)
        skillText.horizontalAlignmentMode = .center
        skillText.verticalAlignmentMode = .center
        skillText.position = self.position
        addChild(skillText)
        
        /// Defines physics of the skill node
        let body = SKPhysicsBody(circleOfRadius: skill.size.rawValue)
        body.allowsRotation = false
        body.affectedByGravity = false
        body.linearDamping = skill.size == .big ? 0.5 : 0   // friction
        body.restitution = 1      // don't lose velocity when colliding
        let signX: CGFloat = Int(skill.fontSize) & 1 == 0 ? -velocityFact : velocityFact
        let signY: CGFloat = Int(skill.fontSize) & 2 == 0 ? -velocityFact : velocityFact
        /// Initial speed of the skill, depending on its size
        let velocity = Skill.SkillSize.big.rawValue + Skill.SkillSize.small.rawValue - skill.size.rawValue
        body.velocity = CGVector(dx: signX * velocity,
                                 dy: signY * velocity)
        physicsBody = body
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

/// Scene displaying skills bubbles
public class SkillScene: SKScene {
    
    /// Skills displayed in the scene
    public var skills = [Skill]()
    
    public var velocityFact: CGFloat = 1
    
    
    /// Initial configuration of the scene
    ///
    /// - Parameter view: View in which the scene is displayed
    public override func didMove(to view: SKView) {
        
        /* Basic configuration */
        size = view.frame.size
        scaleMode = .resizeFill
        backgroundColor = #colorLiteral(red: 0.07450980392, green: 0.1490196078, blue: 0.2039215686, alpha: 1)
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        addSkills()
    }
    
    /// Update view children when its size changes
    ///
    /// - Parameter oldSize: Old view size
    public override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        addSkills()
    }
    
    /// Add skills to view
    func addSkills() {
        
        removeAllChildren()
        
        /* Add every skill */
        for skill in skills {
            let node = SkillNode(with: skill, velocityFact: velocityFact)
            var suggestedPos = CGPoint.zero
            
            repeat {    // avoid overlapping skills
                suggestedPos = CGPoint(x: CGFloat(arc4random_uniform(UInt32(frame.width - skill.size.rawValue))),
                                       y: CGFloat(arc4random_uniform(UInt32(frame.height - skill.size.rawValue))))
            } while !nodes(at: suggestedPos).isEmpty
            
            node.position = suggestedPos
            addChild(node)
        }
    }
    
    /// Responds to user interaction: moving finger
    ///
    /// - Parameters:
    ///   - touches: Received moving inputs
    ///   - event: Event corresponding to the touches
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let touchLoc = touch.location(in: self)
            let allNodes = nodes(at: touchLoc)
            let velocity = Skill.SkillSize.big.rawValue + Skill.SkillSize.small.rawValue
            
            /* Apply to velocity to all nodes around */
            for node in allNodes {
                if let skillNode = node as? SkillNode {
                    
                    /* Direction depending on the distance with the finger */
                    let signX: CGFloat = skillNode.position.x - touchLoc.x > 0 ? velocityFact : -velocityFact
                    let signY: CGFloat = skillNode.position.y - touchLoc.y > 0 ? velocityFact : -velocityFact
                    let skillSize = skillNode.skill.size.rawValue
                    skillNode.physicsBody?.velocity = CGVector(dx: 3 * signX * (velocity - skillSize),
                                                               dy: 3 * signY * (velocity - skillSize))
                }
            }
        }
    }
    
}
