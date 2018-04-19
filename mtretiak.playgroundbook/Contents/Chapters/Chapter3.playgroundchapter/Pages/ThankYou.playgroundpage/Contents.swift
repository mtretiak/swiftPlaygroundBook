/*:
 - callout(Thanks for your time!): I hope you enjoyed my **Swift Resume Book**!
 */

/*:
 - Note: I had a blast making this book, I hope you enjoyed it too! Let me know what you guys think.
 */

/*:
 - Experiment: Touch the scene 😉
 */

//#-hidden-code
import SpriteKit
import PlaygroundSupport

let mainView = SKView(frame: CGRect(x: 0, y: 0, width: 430, height: 600))
let scene = KitScene(size: mainView.frame.size)

//#-end-hidden-code
// Change how many iOSKits show up.
scene.kits = /*#-editable-code Change how many people participate in WWDC*/10/*#-end-editable-code*/

// Change background text lines
scene.textLine1 = /*#-editable-code Write some text for the 1st line*/"Michael Tretiak"/*#-end-editable-code*/
scene.textLine2 = /*#-editable-code Write some text for the 2nd line*/"mtretiak@me.com"/*#-end-editable-code*/

// Change the font size of the text lines
scene.fontSize = /*#-editable-code Change the font size of the text lines*/60/*#-end-editable-code*/
//#-hidden-code

mainView.presentScene(scene)

PlaygroundPage.current.liveView = mainView
//#-end-hidden-code
