#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>


#define myDomain @"com.invokesus.qlvega"

// Status is 0 on success, nonzero on error (like a shell command)
// If thumbnail is 1, only render enough of the file for a thumbnail
NSData *renderSVG(CFBundleRef myBundle, CFURLRef url, int *status);

