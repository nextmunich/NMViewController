# Introduction

iOS provides a lot of convenience classes to integrate common UI metaphors into
your Apps: UITabBarController, UINavigationController and UIPopoverController
amongst others.

Most of these classes lack the skinnability that many people require when
creating branded apps. The NMViewController repository gathers custom
implementations of common UIViewController subclasses which allow for a custom
look and feel. And, since they are open source, if their implementation does
not meet your requirements, you can change their implementation and work them
your own way.


# NMViewController

Even though this class has a very simple (some might call it empty) implementation
it can serve as a great help to people new to iOS development. UIViewController
is rather complex to understand since it allows for the existance of the controller
without a loaded view. Even more so, the view may be unloaded if necessary, a case
that's often neglected by newbies.

NMViewController documents the memory lifecycles involved in dealing with
UIViewController and provides simple convenience methods that can be overriden and
which will provide a clear way of managing controller state vs. view state.

Even if you don't want to use the class, pass the documentation to somebody new to
iOS - it's going to help.


# NMTabBarController

A re-implementation of a UITabBarController which allows for a custom look and feel
of the tab bar. It comes with a default implementation of NMTabBar that provides the
iOS default look and feel. Take a look at the implementation of NMUITabBar to see
how you can implement your own NMTabBar subclass.


# Future

NMNavigationController will be next, it just needs some additional developer love.