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
of the tab bar. It comes with a default implementation of NMTabBar called NMUITabBar
that provides the iOS default look and feel.

The architectural decision behind NMTabBarController was to free the implementation
from an object like UITabBarItem. Without the contraints of the data that can be
communicated using UITabBarItem, an NMTabBar hosted by NMTabBarController can display
its tabs in whichever way it chooses. Here are some examples of how it can be
implemented:

1. NMUITabBar just reuses UITabBar and UITabBarItems to implement the look and feel
   of the tab bar.
2. SwitchTabBar makes the assumption that exactly two UIViewControllers will be added
   to the NMTabBarController and allows switching between the two.
3. An implementation could make use of a different property defined on your custom
   UIViewControllers and will use that property for configuring the look of the items
   on the tab bar.
4. An implementation could use the data stored in UITabBarItem and display it in a
   completely different fashion.
   
... the sky's the limit!

One feature explicitly not implemented is customization of the NMTabBarController's
tabs. We've never had the necessity to make use of that feature - therefore it's not
available.

NMTabBarController explicitly handles NMTabBars of different heights, correctly
resizing the content area as necessary. When adding your UIViewControllers' views to
its content area, it sets their respective view's autoresizingMask so that it fills
the content area whenever it's resized (eg. during a rotation).

Check out the sample targets NMUITabBar and SwitchTabBar to see two completely
different tab bar implementations in action. Rotate the device to see the hosted
UIViewController's autoresize to the new orientation.


# NMNavigationController

Finally, a re-implementation of UINavigationController is now available, too. Similar
to NMTabBarController, NMNavigationController allows you to use custom navigation
bars with a custom look and feel. Like NMUITabBar, NMUINavigationBar provides an
implementation of NMNavigationBar with the default iOS look and feel.

Most of the methods available on a UINavigationController are available on
NMNavigationController, too. The delegate protocol of NMNavigationController is a
little rough around the edges but provides you with the most fundamental
notifications.


# Future

Re-implementations of UITabBarController and UINavigationController have been the
classes we've used in a couple of projects now. As for other UIViewControllers,
we'll implement them as the need arises.
