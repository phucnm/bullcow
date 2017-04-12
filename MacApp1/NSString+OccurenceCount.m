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

-(BOOL) isEveryCharacterUnique
{
    NSMutableSet *set = [NSMutableSet setWithCapacity:self.length];
    for ( NSUInteger i = 0; i < self.length; ++i )
    {
        unichar c = [self characterAtIndex:i];
        [set addObject:[NSNumber numberWithUnsignedShort:c]];
    }
    
    return (set.count == self.length);
}
@end

