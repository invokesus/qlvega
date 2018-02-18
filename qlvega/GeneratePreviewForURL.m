#import <CoreFoundation/CoreFoundation.h>
#import <CoreServices/CoreServices.h>
#import <Foundation/Foundation.h>
#import <QuickLook/QuickLook.h>
#import "Shared.h"


/* -----------------------------------------------------------------------------
 Generate a preview for file
 
 This function's job is to create preview for designated file
 ----------------------------------------------------------------------------- */

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview,
                               CFURLRef url, CFStringRef contentTypeUTI,
                               CFDictionaryRef options)
{
    
    if (QLPreviewRequestIsCancelled(preview))
        return noErr;
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // Invoke vega or vega-lite executables
    CFBundleRef bundle = QLPreviewRequestGetGeneratorBundle(preview);
    int status;
    NSData *output = renderSVG(bundle, url, &status);
    
    
    if (status != 0 || QLPreviewRequestIsCancelled(preview)) {
#ifndef DEBUG
        goto done;
#endif
    }
    // Invoke Webkit to Render the svg
    NSString *textEncoding = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"webkitTextEncoding"];
    if (!textEncoding || [textEncoding length] == 0)
        textEncoding = @"UTF-8";
    CFDictionaryRef properties =
    (CFDictionaryRef)[NSDictionary dictionaryWithObject:textEncoding
                                                 forKey:(NSString *)kQLPreviewPropertyTextEncodingNameKey];
    QLPreviewRequestSetDataRepresentation(preview, (CFDataRef)output,
                                          //kUTTypePlainText,
                                          kUTTypeHTML,
                                          properties);
    
#ifndef DEBUG
done:
#endif
    [pool release];
    return noErr;
}

void CancelPreviewGeneration(void* thisInterface, QLPreviewRequestRef preview)
{
    // implement only if supported
}

