//
//  ALWAppResourcesManager+WebP.h
//  Pods
//
//  Created by lisong on 2017/10/13.
//
//

#import <ALWAppResourcesManager/ALWAppResourcesManager.h>

///获取webP图片资源的分类
@interface ALWAppResourcesManager (WebP)

- (nullable UIImage *)imageWithWebPData:(nullable NSData *)data;

@end
