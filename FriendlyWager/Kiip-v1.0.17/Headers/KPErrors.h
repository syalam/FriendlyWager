/*
 *  KPErrors.h
 *  Kiip
 *
 *  Created on 2/21/11.
 *  Copyright 2011 Kiip, Inc. All rights reserved.
 *
 */

/*
* @enum
* @abstract
*/
enum KPError {
    kKPError_UnknownRewardId = 0,
    kKPError_NotificationAlreadyInUse,

    kKPError_Amount
};

typedef NSInteger KPError;