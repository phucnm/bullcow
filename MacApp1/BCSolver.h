//
//  BCSolver.h
//  MacApp1
//
//  Created by MP-Mac on 4/12/17.
//  Copyright © 2017 PhucNguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCSolver : NSObject
- (instancetype)init;
- (NSString*)giveAGuess;
- (NSString*)giveAGuess:(NSString*)prev bulls:(int)bull cows:(int)cow;

@end
