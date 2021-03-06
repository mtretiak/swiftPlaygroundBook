/*:
 - callout(A Look at Current Projects): This app is currently in development. It is a year end project for my iOS Developement course at the University of Calgary.
 */

/*:
 - Note: Compared to other pages, I've let this one completely visible & editable
 */

import UIKit
import PlaygroundSupport

//: ### Main View & Background
/// Main View
let view = UIView(frame: CGRect(x: 0, y: 0, width: 430, height: 600))
PlaygroundPage.current.liveView = view

/// Background image
let backImage = UIImageView(image: #imageLiteral(resourceName: "breather-187923-unsplash.jpg"))
backImage.frame = view.frame
backImage.autoresizingMask = [.flexibleWidth, .flexibleHeight]
backImage.contentMode = .scaleAspectFill
view.addSubview(backImage)

//: ### Title
let title = UILabel()
title.textColor = .white
title.numberOfLines = 0
title.textAlignment = .center
title.layer.shadowColor   = UIColor.black.cgColor
title.layer.shadowRadius  = 10
title.layer.shadowOffset  = CGSize(width: 0, height: 0)
title.layer.shadowOpacity = 1

let attrStr = NSMutableAttributedString(string: "Shelf\n A digital personal inventory system using ARKit to help you find your stuff.")
attrStr.addAttributes([NSFontAttributeName : UIFont.boldSystemFont(ofSize: 42)], range: NSRange(0..<7))
attrStr.addAttributes([NSFontAttributeName : UIFont.systemFont(ofSize: 26)], range: NSRange(7..<attrStr.string.characters.count))
title.attributedText = attrStr

//: ### Content
/// Mockup of the app
let hand = UIImageView(image: #imageLiteral(resourceName: "iphone.png"))
hand.contentMode = .scaleAspectFit
hand.addConstraint(NSLayoutConstraint(item: hand, attribute: .width, relatedBy: .equal, toItem: hand, attribute: .height, multiplier: 2579 / 3487, constant: 0))

/// Side Text of Features
let description = UILabel()
description.textColor = .white
description.numberOfLines = 0
description.font = UIFont.systemFont(ofSize: 21)
description.layer.shadowColor   = UIColor.black.cgColor
description.layer.shadowRadius  = 5
description.layer.shadowOffset  = CGSize(width: 0, height: 0)
description.layer.shadowOpacity = 1
description.text = "• Digital personal database!\n• Location Tags\n• Picture to text\n• ARKit Billboards to help find your stuff"

//: ### Layout
/// Content Layout, Picture & Side Text
let hStack = UIStackView(arrangedSubviews: [hand, description])
hStack.spacing = 18

/// Main Layout
let mainStack = UIStackView(arrangedSubviews: [title, hStack])
mainStack.frame = view.frame
mainStack.autoresizingMask = [.flexibleWidth, .flexibleHeight]
mainStack.axis = .vertical
mainStack.spacing = 30
mainStack.distribution = .fillEqually
view.addSubview(mainStack)

//: ### Build-In Animations
/* Title */
title.alpha = 0
UIView.animate(withDuration: 1.5, delay: 0.25, options: [], animations: {
    title.alpha = 1
    title.frame.origin.y += 10
})

/* Content */
hand.alpha = 0
description.alpha = 0
description.frame.origin.y -= 10
UIView.animate(withDuration: 1.5, delay: 0.75, options: [], animations: {
    hand.alpha = 1
    description.alpha = 1
    description.frame.origin.y += 10
})

