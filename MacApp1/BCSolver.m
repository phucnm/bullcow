//
//  BCSolver.m
//  MacApp1
//
//  Created by MP-Mac on 4/12/17.
//  Copyright © 2017 PhucNguyen. All rights reserved.
//

#import "BCSolver.h"
#import "NSString+OccurenceCount.h"

@interface BCSolver()

@property (strong, nonatomic) NSMutableArray *pool;
@property (nonatomic) int digits;

@end

@implementation BCSolver

-(instancetype)initWithDigits:(int)digits {
    if (self = [super init]) {
        self.digits = digits;
        [self fillPool];
    }
    return self;
}

- (int)minWithDigit:(int)digit {
    int n = 1, s = 1;
    for (int i = 1; i < digit; i++) {
        n = n * 10 + (s + 1);
        s++;
    }
    return n;
}

- (int)maxWithDigit:(int)digit {
    int n = 9, s = 9;
    for (int i = 1; i < digit; i++) {
        n = n * 10 + (s - 1);
        s--;
    }
    return n;
}

- (void)fillPool {
    self.pool = [NSMutableArray array];
    int min = [self minWithDigit:self.digits];
    int max = [self maxWithDigit:self.digits];

    for (int i = min; i <= max; i++) {
        NSString *string = [NSString stringWithFormat:@"%d", i];
        if ([string isEveryCharacterUnique]) {
            [self.pool addObject:string];
        }
    }
}

- (void)clearPool:(NSString *)prev bulls:(int)bull cows:(int)cow   {
//    NSLog(@"Before clear Pool size %d", self.pool.count);
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    for (int i = 0; i < self.pool.count; i++) {
        if ([self removeIt:prev secret:self.pool[i] bull:bull cow:cow]) {
            [set addIndex:i];
        }
    }
    [self.pool removeObjectsAtIndexes:set];
//    NSLog(@"After clear Pool size %d", self.pool.count);
}

- (BOOL)removeIt:(NSString*)guess secret:(NSString*)secret bull:(int)bull cow:(int)cow {
    int lbull = 0, lcow = 0;
    [self getScore:guess secret:secret bull:&lbull cow:&lcow];
    return (lbull != bull || lcow != cow);
}

- (void)getScore:(NSString*)guess secret:(NSString*)secret bull:(int*)bull cow:(int*)cow {
    int cbull = 0, ccow = 0;
    for (int i = 0; i < self.digits; i++) {
        if ([guess characterAtIndex:i] == [secret characterAtIndex:i]) {
            cbull++;
        } else {
            for (int j = 0; j < self.digits; j++) {
                if ([guess characterAtIndex:i] == [secret characterAtIndex:j]) {
                    ccow++;
                }
            }
        }
    }
    *bull = cbull;
    *cow = ccow;
}

- (NSString *)giveAGuess {
    if (self.pool.count == 0)
        return @"";
//    NSLog(@"Pool size when random %d", self.pool.count);
    int random = arc4random() % self.pool.count;
    return self.pool[random];
}

- (NSString *)giveAGuess:(NSString *)prev bulls:(int)bull cows:(int)cow {
    [self clearPool:prev bulls:bull cows:cow];
    return [self giveAGuess];
}

@end
