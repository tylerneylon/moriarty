moriarty
========

moriarty is a collection of small classes that are useful for Objective-C and iOS projects. The repository home is at:

https://github.com/tylerneylon/moriarty


NSObject+Be
-----------

This category is designed to help with memory management.  Specifically, this makes it easy to only work with autoreleased objects outside of a small number of ownership-allowed methods.  The rules suggested for use with this category are described (here)[http://bynomial.com/blog/?p=65].


UIView+Position
---------------

This category enables you to treat one- or two-dimensional position parameters of a UIView like direct variables.

For example, this code will not compile:

myView.frame.origin.x += 10;

With this category, you can achieve the desired effect with code like this:

myView.frameX += 10;

(Here's the post about this class.)[http://bynomial.com/blog/?p=24]


BNColor
-------

UIColor is not mutable; this class is.  This also allows changes in both RGB and HSV color spaces (with conversion between the two).

(Here's the post about this class.)[http://bynomial.com/blog/?p=100]

BNPieChart
----------

A UIView subclass for rendering very nice-looking pie charts.

(Here's the post about this class.)[http://bynomial.com/blog/?p=104]

uncrustify.cfg
--------------

This is a config file for the uncrustify auto-formatting tool that can be used to clean up Objective-C h,m files.

Here is a sample command-line to use this config file:

/Applications/UniversalIndentGUI/indenters/uncrustify -c uncrustify.cfg -lOC -f MyFile.m -o MyFile.m

I suggest installing UniversalIndentGUI, which includes uncrustify as a component.  The uncrustify library on its own appears to be questionably maintained (I could not get it to install correctly).

http://universalindent.sourceforge.net/

(Here's the post about this file.)[http://bynomial.com/blog/?p=109]
