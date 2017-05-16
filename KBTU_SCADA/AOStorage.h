//
//  AOStorage.h
//  KBTU_SCADA
//
//  Created by Altynbek Orumbayev on 30/04/2017.
//  Copyright © 2017 A_Orumbayev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AOStorage : NSObject

+ (instancetype)sharedInstance;
@property (strong, nonatomic) NSMutableArray *sensorsArray;

@end
