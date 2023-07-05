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

typedef void (^FoundChangesInPowerBlock)(NSInteger);

@interface XPCPower () {
    CFRunLoopRef _runLoop;
    CFRunLoopSourceRef _runLoopSource;
}

@property (nonatomic, strong) FoundChangesInPowerBlock foudChangesInPowerBlock;
@property (nonatomic, assign) IGRPowerMode powerMode;

@end

@implementation XPCPower

- (void)startCheckPower:(void (^)(NSInteger))replyBlock {
    self.foudChangesInPowerBlock = replyBlock;
    _powerMode = IGRPowerModeUnknown;
    
    [self startCustomLoop];
}

- (void)stopCheckPower {
    self.foudChangesInPowerBlock = nil;
    
    [self stopCustomLoop];
}

void IGRPowerMonitorCallback(void *context) {
    XPCPower *xpcPower = (__bridge XPCPower *)(context);
    
    CFTypeRef powerSource = IOPSCopyPowerSourcesInfo();
    CFStringRef source = IOPSGetProvidingPowerSourceType(powerSource);
    if (source) {
        NSString *sSource = (__bridge NSString *)(source);
        
        BOOL isBatteryPower = [@kIOPMBatteryPowerKey isEqualToString:sSource];
        BOOL isACPower = [@kIOPMACPowerKey isEqualToString:sSource];
        
        if (xpcPower.powerMode == IGRPowerModeUnknown){
            xpcPower.powerMode = isBatteryPower ? IGRPowerModeBattery : IGRPowerModeACPower;
        }
        else if (isBatteryPower && xpcPower.powerMode == IGRPowerModeACPower) {
            xpcPower.powerMode = IGRPowerModeBattery;
            void(^foundChangesInPowerBlock)(NSInteger) = [xpcPower.foudChangesInPowerBlock copy];
            foundChangesInPowerBlock(xpcPower.powerMode);
        }
        else if (isACPower && xpcPower.powerMode == IGRPowerModeBattery) {
            xpcPower.powerMode = IGRPowerModeACPower;
            void(^foundChangesInPowerBlock)(NSInteger) = [xpcPower.foudChangesInPowerBlock copy];
            foundChangesInPowerBlock(xpcPower.powerMode);
        }
    }
}

- (void)startCustomLoop {
    _runLoop = CFRunLoopGetCurrent();
    _runLoopSource = IOPSCreateLimitedPowerNotification(IGRPowerMonitorCallback, (__bridge void *)(self));
    
    if (_runLoop && _runLoopSource){
        CFRunLoopAddSource(_runLoop, _runLoopSource, kCFRunLoopDefaultMode);
    }
    
    IGRPowerMonitorCallback((__bridge void *)(self)); // get current power state
    
    CFRunLoopRun();
}

- (void)stopCustomLoop {
    if (_runLoopSource && _runLoop) {
        CFRunLoopRemoveSource(_runLoop,_runLoopSource, kCFRunLoopDefaultMode);
    }
    if (_runLoopSource){
        CFRelease(_runLoopSource);
    }
}

@end
