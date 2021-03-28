//
//  XPCMail.h
//  XPCMail
//
//  Created by Vitalii Parovishnyk on 09.01.2021.
//

#import <Foundation/Foundation.h>
#import "XPCMail-Swift.h"

// This object implements the protocol which we have defined. It provides the actual behavior for the service. It is 'exported' by the service to make it available to the process hosting the service over an NSXPCConnection.
@interface XPCMail : NSObject <XPCMailProtocol>
@end
