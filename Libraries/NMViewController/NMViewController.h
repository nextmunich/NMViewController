//
//  NMViewController.h
//  NMViewController
//
//  Created by Benjamin Broll on 27.05.11.
//  Copyright 2011 NEXT Munich GmbH. The App Agency. All rights reserved.
//

/*
 * The BSD License
 * http://www.opensource.org/licenses/bsd-license.php
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 * - Neither the name of NEXT Munich GmbH nor the names of its contributors may
 *   be used to endorse or promote products derived from this software without
 *   specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#import <Foundation/Foundation.h>


/**
 * Introduction
 * =============
 *
 * Each UIViewController essentially defines a screen worth of information that
 * can be displayed in your app.
 *
 * Since memory on a mobile device is low (compared to desktop environments) and
 * since the representation of a screen's UI can use big amounts of memory
 * (think of images and videos), UIViewController handles the automatic creation
 * and destruction of the screen's UI representation.
 *
 * This is very handy when you need to manage different screens in your app
 * since it allows you to keep all of the screens objects (the respective
 * UIViewControllers) in memory, while dynamically loading / unloading their
 * views whenever they are required.
 *
 * Dynamically loading / unloading views of UIViewController objects comes at a
 * cost, however: at any point in time when the controller's screen is not
 * visible, the view of the controller can be unloaded. Thus, the controller has
 * to be prepared to restore the view's state. For example, imagine an app where
 * you have a list to choose an item from (screen 1), a detail view for a
 * selected item (screen 2) and a slideshow of images belonging to an item
 * (screen 3). When navigating from screen 2 to screen 3, the slideshow might
 * load a lot of images into memory, causing the view of screen 2 to be
 * unloaded. When the user chooses to navigate back from screen 3 to screen 2,
 * the view of screen 2 is loaded from scratch. The new view of screen 2 no
 * longer presents the information that was previously visible on screen 2
 * (that view had been unloaded) unless you explicitly refresh the view to
 * display the information of the selected item. This case has to manually be
 * taken care of when implementing a UIViewController.
 *
 * This behavior boils down to two different memory lifecycles:
 * 1. State Lifecycle: Memory required from creation of the UIViewController to
 *    its destruction.
 * 2. View Lifecycle: Memory required from loading of the UIViewController's
 *    view to when it's unloaded.
 * 
 * In the example above, information about the selected item would have to be
 * managed in the "State Lifecycle" as the information about the selected item
 * has to be present even after the view has been unloaded so that it can be
 * used to repopulate the view with the item's data.
 *
 * Individual UIView objects required to display the item's data, however, would
 * have to be manged in the "View Lifecycle" as these are only required while
 * the view is loaded.
 *
 *
 * NMViewController's Memory Lifecycles
 * =====================================
 *
 * UIViewController can make it rather hard to see where these separate
 * lifecycles should be managed. We've therefore created a UIViewController
 * subclass - NMViewController - which provides a clearly defined way of
 * managing the separate lifecycles. Your controllers can inherit from
 * NMViewController and benefit from the provided lifecycle methods.
 *
 * 1. State Lifecycle
 *
 * Whenever an NMViewController is created (regardless of the init method used),
 * its -loadState method is called, giving the opportunity to initialize any
 * state information required.
 *
 * Whenever an NMViewController is destroyed, its -unloadState method is called
 * so that any state memory can be reclaimed. This typically includes any memory
 * prepared in -loadState and state data that has been provided externally using
 * properties.
 *
 * 2. View Lifecycle
 *
 * NMViewController relies on the fact that you either implement -loadView in
 * your subclass to programmatically create the UI of your screen or that you
 * override -viewDidLoad to do any post-initialization after your view has been
 * loaded from a nib file.
 *
 * Whenever an NMViewController's view is unloaded (either when the controller
 * is destroyed or when its -viewDidUnload method was called), the
 * -unloadViewReferences method is called, giving you the opportunity to
 * release any memory that you have explicitly (eg. by creating and retaining
 * UIView objects in -loadView or -viewDidLoad) or implicitly (eg. by assigning
 * objects to IBOutlets during nib loading) retained.
 *
 * As another example of what has to be unloaded in -unloadViewReferences,
 * suppose in the example above your slideshow screen contains a scroll view
 * into which you dynamically add UIImageView objects in your -viewDidLoad
 * method. Now you need to keep track of those UIImageView objects in an NSArray
 * for easy manipulation of their images. In that case, the UIImageView objects
 * have to be removed from the array in your -unloadViewReferences method.
 *
 *
 * Cached Data
 * ============
 *
 * As a bonus, NMViewController calls the -unloadCachedData method whenever a
 * memory warning is received. You can implement this method to release any data
 * that you have cached during the lifetime of the controller but which you do
 * not need to bring the controller back into the state that the user expects.
 *
 * In the example above, assume that the slideshow (screen 3) displays a lot of
 * large images. Whenever the user scrolls to the next image in the slideshow,
 * it is loaded into memory and displayed but the images that the user has
 * already seen are kept in memory so that no loading time occurs whenever the
 * user decides to swipe back to a previously visited image.
 *
 * In that case, a memory warning can easily occur while the user keeps viewing
 * more images. In that case, NMViewController calls -unloadCachedData, giving
 * your subclass the chance of cleaning up any image that is not currently
 * displayed on screen. Those images can easily be reloaded in case the user
 * goes back to a previous image, therefore they can safely be released when
 * memory is low.
 *
 * This can also apply to data that you would consider to belong to the "State
 * Lifecyle": imagine that you load the images into NSData objects before you
 * create UIImages. In that case, you should let go of both objects when
 * -unloadCachedData is called, not only the UIImage objects.
 *
 *
 * Remarks
 * ========
 *
 * 1. Make sure that you call the super implementation of any NMViewController
 *    method that you implement in your custom subclass.
 */
@interface NMViewController : UIViewController {

}


// Memory Lifecycles

// 1. State Lifecycle

// Initialize / Release any state your controller is using that must be present
// from creation to destruction of the controller
- (void)loadState;
- (void)unloadState;


// 2. View Lifecycle

// Release any view references you retained during loadView / viewDidLoad.
// You need to release *any* objects that pertain
- (void)unloadViewReferences;


// Cached Data

// Optional: If your controller uses a cache for some of the data it needs to
// display / work with, you must release any of the cached data that is not
// needed at the moment and which can be recreated in this method.
- (void)unloadCachedData;

@end
