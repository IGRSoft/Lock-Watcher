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

typedef void (^FoudChangesInPowerBlock)(NSInteger);

@interface XPCPower () {
    CFRunLoopRef _runLoop;
    CFRunLoopSourceRef _runLoopSource;
}

@property (nonatomic, copy  ) FoudChangesInPowerBlock foudChangesInPowerBlock;
@property (nonatomic, assign) IGRPowerMode powerMode;
@end

@implementation XPCPower

- (void)startCheckPower:(void (^)(NSInteger))replyBlock {
    self.foudChangesInPowerBlock = [replyBlock copy];
    _powerMode = IGRPowerModeUnknown;
    
    
    [self runCustomLoop];
}

- (void)stopCheckPower{
    self.foudChangesInPowerBlock = nil;
    
    if (_runLoopSource && _runLoop){
        CFRunLoopRemoveSource(_runLoop,_runLoopSource,kCFRunLoopDefaultMode);
    }
    if (_runLoopSource){
        CFRelease(_runLoopSource);
    }
}

- (void)updateReplay:(void (^)(NSInteger))replyBlock {
    self.foudChangesInPowerBlock = [replyBlock copy];
}

void IGRPowerMonitorCallback(void *context) {
    XPCPower *xpcPower = (__bridge XPCPower *)(context);
    
    CFTypeRef powerSource = IOPSCopyPowerSourcesInfo();
    CFStringRef source = IOPSGetProvidingPowerSourceType(powerSource);
    if (source) {
        NSString *sSource = (__bridge NSString *)(source);
        
        BOOL isBatteryPower = [@"Battery Power" isEqualToString:sSource];
        BOOL isACPower = [@"AC Power" isEqualToString:sSource];
        
        if (xpcPower.powerMode == IGRPowerModeUnknown){
            xpcPower.powerMode = isBatteryPower ? IGRPowerModeBattery : IGRPowerModeACPower;
        }
        else if (isBatteryPower && xpcPower.powerMode == IGRPowerModeACPower) {
            xpcPower.powerMode = IGRPowerModeBattery;
            void(^foudChangesInPowerBlock)(NSInteger) = [xpcPower.foudChangesInPowerBlock copy];
            foudChangesInPowerBlock(xpcPower.powerMode);
        }
        else if (isACPower && xpcPower.powerMode == IGRPowerModeBattery) {
            xpcPower.powerMode = IGRPowerModeACPower;
            void(^foudChangesInPowerBlock)(NSInteger) = [xpcPower.foudChangesInPowerBlock copy];
            foudChangesInPowerBlock(xpcPower.powerMode);
        }
    }
}

- (void)runCustomLoop {
    _runLoop = CFRunLoopGetCurrent();
    _runLoopSource = IOPSCreateLimitedPowerNotification(IGRPowerMonitorCallback, (__bridge void *)(self));
    
    if (_runLoop && _runLoopSource){
        CFRunLoopAddSource(_runLoop, _runLoopSource, kCFRunLoopDefaultMode);
    }
    
    IGRPowerMonitorCallback((__bridge void *)(self)); // get current power state
    
    CFRunLoopRun();
}

@end
