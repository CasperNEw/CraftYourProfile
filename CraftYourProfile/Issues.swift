//
//  Issues.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 26.07.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

struct CodeReview {

    let issues = """

    - Correct the naming of delegate methods, add the transfer of the source object in these methods.
    - Move the setting of the values ​​of the properties of the elements to the initialization.
    - See how to implement hyperlinks inside a UILabel, not inside a UITextView.
    - Add the ability to return to the previous screen using a swipe.
    - Check out PhoneNumberKit.
    - DesignerService, redo, get rid of strong links.
    - Perform general formatting of the text, avoid sliding the code to the right.
    - Redo ResizwScrollViewService, self is captured. Remake methods with keyboard frame size.
    - Redesign the Authorization class.
    - Change extension to UIImage, simplify and make it more readable.
    - Check extension on UIScrollView, remove if unnecessary.
    - Pay attention to naming.

    """
}
