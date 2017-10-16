//
//  ALWAppResourcesManager+WebP.m
//  Pods
//
//  Created by lisong on 2017/10/13.
//
//

#import "ALWAppResourcesManager+WebP.h"
#import "ALWWebPDecoder.h"

@implementation ALWAppResourcesManager (WebP)

- (nullable UIImage *)imageWithWebPData:(nullable NSData *)data
{
    return [ALWWebPDecoder imageWithWebPData:data];
}

@end
