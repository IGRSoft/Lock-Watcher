//
//  XPCPower.m
//  XPCPower
//
//  Created by Vitalii Parovishnyk on 06.01.2021.
//

#import "XPCPower.h"
#import "IGRPowerModel.h"

#import <IOKit/IOKitLib.h>
#import <IOKit/ps/IOPSKeys.h>
#import <IOKit/ps/IOPowerSources.h>
#import <IOKit/pwr_mgt/IOPMLib.h>

// Block that gets executed when changes in power source are detected.
typedef void (^FoundChangesInPowerBlock)(NSInteger);

@interface XPCPower () {
    CFRunLoopRef _runLoop;         // Reference to the current run loop.
    CFRunLoopSourceRef _runLoopSource; // Source that is associated with power notifications.
}

// Callback block which will be invoked upon detection of changes in power source.
@property (nonatomic, strong) FoundChangesInPowerBlock foundChangesInPowerBlock;

// Property to track the current power mode (battery or AC power).
@property (nonatomic, assign) IGRPowerMode powerMode;

@end

@implementation XPCPower

// Begins the monitoring process for power source changes.
- (void)startCheckPower:(void (^)(NSInteger))replyBlock {
    self.foundChangesInPowerBlock = replyBlock;
    _powerMode = IGRPowerModeUnknown;
    
    [self startCustomLoop];
}

// Stops the monitoring process for power source changes.
- (void)stopCheckPower {
    self.foundChangesInPowerBlock = nil;
    
    [self stopCustomLoop];
}

// Callback function to handle power source changes. It checks the current power source type
// and invokes the callback block if there's a change in the power source.
void IGRPowerMonitorCallback(void *context) {
    XPCPower *xpcPower = (__bridge XPCPower *)(context);
    
    CFTypeRef powerSource = IOPSCopyPowerSourcesInfo();
    CFStringRef source = IOPSGetProvidingPowerSourceType(powerSource);
    if (source) {
        NSString *sSource = (__bridge NSString *)(source);
        
        BOOL isBatteryPower = [@kIOPMBatteryPowerKey isEqualToString:sSource];
        BOOL isACPower = [@kIOPMACPowerKey isEqualToString:sSource];
        
        if (xpcPower.powerMode == IGRPowerModeUnknown) {
            xpcPower.powerMode = isBatteryPower ? IGRPowerModeBattery : IGRPowerModeACPower;
        }
        else if (isBatteryPower && xpcPower.powerMode == IGRPowerModeACPower) {
            xpcPower.powerMode = IGRPowerModeBattery;
            void(^foundChangesInPowerBlock)(NSInteger) = [xpcPower.foundChangesInPowerBlock copy];
            foundChangesInPowerBlock(xpcPower.powerMode);
        }
        else if (isACPower && xpcPower.powerMode == IGRPowerModeBattery) {
            xpcPower.powerMode = IGRPowerModeACPower;
            void(^foundChangesInPowerBlock)(NSInteger) = [xpcPower.foundChangesInPowerBlock copy];
            foundChangesInPowerBlock(xpcPower.powerMode);
        }
    }
}

// Initializes and starts a custom run loop to monitor power source changes.
- (void)startCustomLoop {
    _runLoop = CFRunLoopGetCurrent();
    _runLoopSource = IOPSCreateLimitedPowerNotification(IGRPowerMonitorCallback, (__bridge void *)(self));
    
    if (_runLoop && _runLoopSource) {
        CFRunLoopAddSource(_runLoop, _runLoopSource, kCFRunLoopDefaultMode);
    }
    
    IGRPowerMonitorCallback((__bridge void *)(self)); // Get the current power state
    
    CFRunLoopRun();
}

// Stops the custom run loop and performs cleanup.
- (void)stopCustomLoop {
    if (_runLoopSource && _runLoop) {
        CFRunLoopRemoveSource(_runLoop, _runLoopSource, kCFRunLoopDefaultMode);
    }
    if (_runLoopSource) {
        CFRelease(_runLoopSource);
    }
}

@end
