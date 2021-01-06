//
//  IGRPowerModel.h
//  XPCPower
//
//  Created by Vitalii Parovishnyk on 06.01.2021.
//

#ifndef IGRPowerModel_h
#define IGRPowerModel_h

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, IGRPowerMode) {
    IGRPowerModeUnknown = NSIntegerMax,
    IGRPowerModeBattery = 0,
    IGRPowerModeACPower = 1,
};

#endif /* IGRPowerModel_h */
