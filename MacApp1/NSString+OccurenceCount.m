//
//  NSString+OccurenceCount.m
//  MacApp1
//
//  Created by Phuc Nguyen on 4/12/17.
//  Copyright © 2017 PhucNguyen. All rights reserved.
//

#import "NSString+OccurenceCount.h"

@implementation NSString (CountString)
- (NSInteger)countOccurencesOfString:(NSString*)searchString {
    NSInteger strCount = [self length] - [[self stringByReplacingOccurrencesOfString:searchString withString:@""] length];
    return strCount / [searchString length];
}
@end
