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

@interface ViewController() <GCDAsyncSocketDelegate>

@property (strong, nonatomic) GCDAsyncSocket *socket;
@property CowsAndBulls_Player cb;
@property (nonatomic) BOOL isFirst;
@property std::string prevGs;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirst = YES;
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

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"From server: %@", string);
    if ([string containsString:@"Correct"]) {
        return;
    }
    NSString *gs;
    if (self.isFirst) {
        self.prevGs = self.cb.gimmeANumber();
        gs = [NSString stringWithCString:self.prevGs.c_str() encoding:NSASCIIStringEncoding];
        self.isFirst = NO;
    } else {
        pair<int, int> res;
        res.first = (int)[string countOccurencesOfString:@"bull"];
        res.second = (int)[string countOccurencesOfString:@"cow"];
        self.prevGs = self.cb.guessANum(self.prevGs, res);
        gs = [NSString stringWithCString:self.prevGs.c_str() encoding:NSASCIIStringEncoding];
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
