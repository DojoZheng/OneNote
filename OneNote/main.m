//
//  main.m
//  OneNote
//
//  Created by Dongjia Zheng on 15/11/24.
//  Copyright © 2015年 Dongjia Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}

// From here to end of file added by Injection Plugin //

#ifdef DEBUG
static char _inMainFilePath[] = __FILE__;
static const char *_inIPAddresses[] = {"192.168.1.100", "127.0.0.1", 0};

#define INJECTION_ENABLED
//#import "/tmp/injectionforxcode/BundleInjection.h"
#endif
