moriarty
========

moriarty is a collection of small classes that are useful for Objective-C and iOS projects. The repository home is at:

https://github.com/tylerneylon/moriarty


NSObject+Be
-----------

This category is designed to help with memory management.  Specifically, this makes it easy to only work with autoreleased objects outside of a small number of ownership-allowed methods.  The rules suggested for use with this category are described [here](http://bynomial.com/blog/?p=65).


UIView+Position
---------------

This category enables you to treat one- or two-dimensional position parameters of a UIView like direct variables.

For example, this code will not compile:

myView.frame.origin.x += 10;

With this category, you can achieve the desired effect with code like this:

myView.frameX += 10;

[Here's the post about this class.](http://bynomial.com/blog/?p=24)


BNColor
-------

UIColor is not mutable; this class is.  This also allows changes in both RGB and HSV color spaces (with conversion between the two).

[Here's the post about this class.](http://bynomial.com/blog/?p=100)

BNPieChart
----------

A UIView subclass for rendering very nice-looking pie charts.

[Here's the post about this class.](http://bynomial.com/blog/?p=104)

WipeView
--------

A UIView subclass for showing a wipe-vanish animation of an image.

This is a wipe animation (you can do them in other directions than this):

    //  1.  /----\
    //      |----|
    //      \----/
    //  2.    ---\
    //        ---|
    //        ---/
    //  3.      -\
    //          -|
    //          -/
    //  4.
    //
    //

[Here's the post about this class.](http://bynomial.com/blog/?p=130)

LineView
--------

A UIView subclass for rending a single line between any two points.
Yes, you can do this with Quartz; this is easier to use if you just want a few
visual lines without diving down into CGContextStuff functions (CG = Core Graphics).

Example:

    LineView *lineView = [LineView lineFromPoint:CGPointZero toPoint:CGPointMake(20, 30)];
    [self.view addSubview:lineView];

[Here's the relevant blog post.](http://bynomial.com/blog/?p=133)

NSString+HMAC
-------------

Adds the method hmacWithKey: to NSString, which uses SHA256 to
produce an authentication code (the HMAC).  Use it like this:

    NSString *key = @"a9bk342nziAFD234";  // Your private key.
    NSString *hmac = [messageStr hmacWithKey:key];
    // Now send the hmac with the message, and the server can authenticate.

CodeTimestamps
--------------

This is a set of macros that can provide line-by-line, nanosecond-resolution
timing information for your app.
[Here's the post about CodeTimestamps.]
(http://eng.pulse.me/line-by-line-speed-analysis-for-ios-apps/)

CArray
------

A struct and collection of C functions to act as a fast, low-level replacement for
NSMutableArray.  Only appropriate in extremely time-sensitive code.  [Here's the post
about CArray.](http://bynomial.com/blog/?p=137)

uncrustify.cfg
--------------

This is a config file for the uncrustify auto-formatting tool that can be used to clean up Objective-C h,m files.

Here is a sample command-line to use this config file:

/Applications/UniversalIndentGUI/indenters/uncrustify -c uncrustify.cfg -lOC -f MyFile.m -o MyFile.m

I suggest installing UniversalIndentGUI, which includes uncrustify as a component.  The uncrustify library on its own appears to be questionably maintained (I could not get it to install correctly).

http://universalindent.sourceforge.net/

[Here's the post about this file.](http://bynomial.com/blog/?p=109)
