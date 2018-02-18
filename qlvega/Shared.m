#import <CoreFoundation/CoreFoundation.h>
#import <CoreServices/CoreServices.h>
#import <Foundation/Foundation.h>

#import "Shared.h"


NSData *runTask(NSString *script, NSDictionary *env, int *exitCode) {
    NSTask *task = [[NSTask alloc] init];
    [task setCurrentDirectoryPath:@"/tmp"];     /* XXX: Fix this */
    [task setEnvironment:env];
    [task setLaunchPath:@"/bin/sh"];
    [task setArguments:[NSArray arrayWithObjects:@"-c", script, nil]];
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    // Let stderr go to the usual place
    //[task setStandardError: pipe];
    
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data;
    data = [file readDataToEndOfFile];
    [task waitUntilExit];
    
    *exitCode = [task terminationStatus];
    [task release];
    /* The docs claim this isn't needed, but we leak descriptors otherwise */
    [file closeFile];
    /*[pipe release];*/
    
    return data;
}

NSString *pathOfURL(CFURLRef url)
{
    NSString *targetCFS = [[(NSURL *)url absoluteURL] path];
    return targetCFS;
}

int isVegaLite(CFURLRef url){
    NSString *searchQuery = [NSString stringWithFormat:
                             @"grep -q schema/vega-lite %@",pathOfURL(url)];
    const char *qString = [searchQuery cStringUsingEncoding:NSASCIIStringEncoding];
    int match = system(qString);
    return match;
}

NSData *renderSVG(CFBundleRef bundle, CFURLRef url, int *status)
{
    NSData *output = NULL;
    CFURLRef rsrcDirURL = CFBundleCopyResourcesDirectoryURL(bundle);
    
    CFRelease(rsrcDirURL);
    NSString *targetEsc = pathOfURL(url);
    
    NSString *parentDirectory = [targetEsc stringByDeletingLastPathComponent];
    NSMutableDictionary *env = [NSMutableDictionary dictionaryWithDictionary:
                                [[NSProcessInfo processInfo] environment]];
    
    NSString *path = [env objectForKey: @"PATH"];
    NSString *newPath = [path stringByAppendingString: @":/usr/local/bin:/usr/local/sbin"];
    [env setObject: newPath forKey: @"PATH"];
    NSString *cmd = @"";
    if (isVegaLite(url) == 0){
        cmd = [NSString stringWithFormat:@"vl2svg '%@' -b '%@'",
               targetEsc, parentDirectory];
    }else{
        cmd = [NSString stringWithFormat:@"vg2svg '%@' -b '%@'",
               targetEsc, parentDirectory];
    }
    
    output = runTask(cmd, env, status);
    if (*status != 0) {
        NSLog(@"QLColorCode: vl2svg failed with exit code %d.  Command was (%@).",
              *status, cmd);
    }
    return output;
}

