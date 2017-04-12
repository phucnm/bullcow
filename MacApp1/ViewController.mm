//
//  ViewController.m
//  MacApp1
//
//  Created by Phuc Nguyen on 4/11/17.
//  Copyright © 2017 PhucNguyen. All rights reserved.
//

#import "ViewController.h"
#import <CommonCrypto/CommonCrypto.h>
#import "GCDAsyncSocket.h"
#include "Solver.hpp"
#import "NSString+OccurenceCount.h"
#import "BCSolver.h"

@interface ViewController() <GCDAsyncSocketDelegate>

@property (strong, nonatomic) GCDAsyncSocket *socket;
@property CowsAndBulls_Player cb;
@property (strong, nonatomic) BCSolver *bc;
@property (nonatomic) BOOL isFirst;
@property (nonatomic, strong) NSString *prevGs;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirst = YES;
//    self.bc = [[BCSolver alloc] init];
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self.socket connectToHost:@"bullandcow-challenge.framgia.vn" onPort:2015 error:nil];
    [self.socket readDataWithTimeout:-1 tag:0];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSString *res =  @"753053aeae0d1a3fe33bd2cb31a901069873b8c37127b0d3757dd3a90313b526";
//        NSString *str = @"ICANDO_WHATEVER_UWANT";
//        NSLog(@"Hash %@", [self sha256:str]);
//    });
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"Did connect to %@", sock);
}

int bull = 0, cow = 0;

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"From server: %@", string);
    if ([string containsString:@"Correct"]) {
        self.isFirst = YES;
    }
    NSString *gs;

    if ([string containsString:@"bull"] || [string containsString:@"cow"] || [string containsString:@"nothing"]) {
        bull = (int)[string countOccurencesOfString:@"bull"];
        cow = (int)[string countOccurencesOfString:@"cow"];
        if (![string containsString:@"answer"]) {
            [self.socket readDataWithTimeout:-1 tag:0];
            return;
        }
    } else if (![string containsString:@"answer"]) {
        [self.socket readDataWithTimeout:-1 tag:0];
        return;
    }
    if (self.isFirst) {
        if ([string containsString:@"4-digit"]) {
            self.bc = [[BCSolver alloc] initWithDigits:4];
        } else if ([string containsString:@"5-digit"]) {
            self.bc = [[BCSolver alloc] initWithDigits:5];
        } else if ([string containsString:@"6-digit"]) {
            self.bc = [[BCSolver alloc] initWithDigits:6];
        } else if ([string containsString:@"7-digit"]) {
            self.bc = [[BCSolver alloc] initWithDigits:7];
        } else if ([string containsString:@"8-digit"]) {
            self.bc = [[BCSolver alloc] initWithDigits:8];
        }
        self.prevGs = [self.bc giveAGuess];
        gs = [NSString stringWithString:self.prevGs];
        self.isFirst = NO;
    } else {
        self.prevGs = [self.bc giveAGuess:self.prevGs bulls:bull cows:cow];
        gs = [NSString stringWithString:self.prevGs];
    }
    NSLog(@"Guessed %@", gs);
    gs = [gs stringByAppendingString:@"\n"];
    [self.socket writeData:[gs dataUsingEncoding:NSUTF8StringEncoding]  withTimeout:-1 tag:0];
    [self.socket readDataWithTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
//    NSLog(@" %@Did write with tag %ld", sock, tag);
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"Did disconnect");
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

-(NSString*) sha256:(NSString *)clear{
    const char *s=[clear cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData=[NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
    CC_SHA256(keyData.bytes,(CC_LONG)keyData.length, digest);
    NSData *out=[NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash=[out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    return hash;
}

@end
