/*:
 - callout(Other Works): Over the years a University of Calgary I have done many projects, ranging from:
 - A daily UI challenge whre you create new works everyday.
 - Presentations on ARKit, CoreML, Data Stories, and more
 - Being a Technical Mentor for technovation
 - And building my own personal website
 */

/*:
 - Experiment: Tap on the icons to see some of my work!
 */


//#-hidden-code
import UIKit
import PlaygroundSupport

//: ### Main View & Background
let view = FeaturesView(frame: CGRect(x: 0, y: 0, width: 450, height: 600))
let mainVC = UIViewController()
mainVC.view = view

PlaygroundPage.current.liveView = mainVC

//#-end-hidden-code
/// Resize Features icons
view.buttonSize = /*#-editable-code Features icons size*/CGSize(width: 42, height: 42)/*#-end-editable-code*/

/// Wobble angle for icons
view.wiggleAngle = /*#-editable-code Maximum left or right angle*/0.059/*#-end-editable-code*/

/// Icons are randomly placed on the view,
/// defines the maximum number of attempts (watchdog) to find an empty place for an icon
view.maxButtonPlacementAttempt = /*#-editable-code Maximum number of attempts*/142/*#-end-editable-code*/

/// Margin between 2 icons
view.buttonMargins = /*#-editable-code Margin between 2 icons*/UIEdgeInsets(top: -20, left: -20, bottom: -20, right: -20)/*#-end-editable-code*/

/// Features of Students’ Union app to display
let features: [Feature] = [
//#-editable-code
    Feature(title: "ScriptTime: Script journal for feild reporters", icon: #imageLiteral(resourceName: "su-newsIcon.png"), screenshot: #imageLiteral(resourceName: "iPhone 6-7-8 – 1@2x.png")),
    Feature(title: "Daily UI: 100 day UI challenge", icon: #imageLiteral(resourceName: "su-eventsIcon.png"), screenshot: #imageLiteral(resourceName: "DailyUI017.png")),
    Feature(title: "Presentations", icon: #imageLiteral(resourceName: "su-clubsIcon.png"), screenshot: #imageLiteral(resourceName: "DataStoryCaseStudy.jpg")),
    Feature(title: "Technovation: Technical Mentor", icon: #imageLiteral(resourceName: "su-roomsIcon.png"), screenshot: #imageLiteral(resourceName: "technovation.png")),
    Feature(title: "Personal Website", icon: #imageLiteral(resourceName: "su-userIcon.png"), screenshot:#imageLiteral(resourceName: "personalWeb.png") )
//#-end-editable-code
]
view.set(features, in: mainVC)

/// Animate features apparition
//#-editable-code
view.showFeatures()
//#-end-editable-code
