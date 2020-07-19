# CraftYourProfile

Test task from my friend) Creating a welcome screen and authorization screens. I received five screenshots and a brief description ) Below you can see the source data, and my project in the code )

- Emojis should fly up from the bottom of the screen and disappear at the top, random emojis. The Terms and Privacy Policy links should lead to some pages on the Internet. All buttons must be pressed when pressed.
- Entering a phone number with a check that it is correct. Allow to go further only with the correct number. By clicking on the code, select a country.
- Entering a PIN code (any one is possible) and a timer for 20 seconds to re-send the code.
- Enter a name and date field. Skip on only if a date is selected and a non-empty name.
- Selection of pictures from a camera or gallery.

<img src="/source/firstScreen.png" alt="first screen"/> <img src="/source/secondScreen.png" alt="second screen"/> <img src="/source/thirdScreen.png" alt="third screen"/>
<img src="/source/fourthScreen.png" alt="fourth screen"/> <img src="/source/fifthScreen.png" alt="fifth screen"/>

# CodeReview

I am very grateful to my friend for taking the time to review this code) A little later I will post a link to the video of the review process (in Russian). Below are the points of the issues that need to be fixed ...

## Issues

- Make a normal VC Fabric, add a constructor, remember about encapsulation. The VC doesn't need to know about the factory and other VCs.
- Remove "crutches" from main.async from the main thread and methods .afterDelay 'Oops' %)
- Make a convenient folder hierarchy and application structure, split into modules.
- Remove view from initialization, there is a .loadView method for this. There is no point in doing such a DI.
- Take a close look at saving links inside VC. The factory must be weak.
- Correct the naming of delegate methods, add the transfer of the source object in these methods.
- Completely overhaul the logic of the animation of pressing the button. Use UIButton state properties.
- Change the location of the activation of the constraints, add minimal logic.
- Move .translatesautoresizingmaskintoconstraints to extension.
- Move the setting of the values ​​of the properties of the elements to the initialization.
- Redesign the start screen animation, make it less resource intensive.
- See how to implement hyperlinks inside a UILabel, not inside a UITextView.
- Redesign animation, logic, screen appearances. The first transition must be done modally.
- Remove delays in reverse navigation.
- Add the ability to return to the previous screen using a swipe.
- Substitute the default phone number code, use Locale. Add placeholder "Phone" to PhoneView.
- Redesign the screen for selecting the phone number code, make it look like the native elements of the system.
- Make buttons inactive until full data entry.
- Get rid of alerts, do not interfere with the user interacting with the application.
- Redo the "shake error" animation.
- Redesign the logic of appearing and hiding the keyboard. Especially in PinCodeView and CountryCodeVC
- ModelController, redo the logic of methods and their naming. Rename the class itself.
- From outside inform about the need to download data from the network. Load data exactly when needed.
- Redesign the logic of requesting data codes of telephone numbers. Check out PhoneNumberKit.
- DesignerService, redo, get rid of strong links.
- Perform general formatting of the text, avoid sliding the code to the right.
- Correct the start point of the timer on VerifyPhoneCodeVC, the timer must exist separately from the VC. Use the closure method to create a timer.
- Make text alignment to the left on IntroduceVC.
- Hide the display of the cursor on elements where user input from the keyboard is blocked.
- Add logic for trimming spaces at the beginning and end of lines.
- Move to a separate class TextField with DatePicker.
- Redo Image Picker.
- Redo ResizwScrollViewService, self is captured. Remake methods with keyboard frame size.
- Redesign the Authorization class.
- Change extension to UIImage, simplify and make it more readable.
- Check extension on UIScrollView, remove if unnecessary.
- Check extension on Array, it is possible to rewrite logic without using these methods.
- Pay attention to naming.

---------------------------------------

In the near future, I will fix these issued and a link to the video of the review itself, wish me luck ))