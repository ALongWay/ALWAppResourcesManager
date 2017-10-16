//
//  ALWAppResourcesManager.m
//  Pods
//
//  Created by lisong on 2017/7/21.
//
//

#import "ALWAppResourcesManager.h"

@interface ALWAppResourcesManager ()

@property (nonatomic, weak) id<ALWAppResourcesManagerDelegate> delegate;

@end

@implementation ALWAppResourcesManager

+ (instancetype)sharedManager
{
    static ALWAppResourcesManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ALWAppResourcesManager alloc] init];
    });
    
    return instance;
}

+ (void)registerToDelegate:(id<ALWAppResourcesManagerDelegate>)delegate
{
    [ALWAppResourcesManager sharedManager].delegate = delegate;
}

///当前组件加载到应用中后的总资源包。实现方法中需要注意包名ALWAppResourcesManagerComponent是根据ALWAppResourcesManager.podspec中resource_bundles字段设置的。
+ (NSBundle *)currentMainBundle
{
    static NSBundle *currentMainBundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *path = [bundle pathForResource:@"ALWAppResourcesManagerComponent" ofType:@"bundle"];
        currentMainBundle = [NSBundle bundleWithPath:path];
    });
    
    return currentMainBundle;
}

#pragma mark - 为其他模块提供的字体相关调用方法
+ (UIFont *)fontWithName:(NSString *)fontName size:(CGFloat)fontSize
{
    UIFont *font;
    
    if ([[ALWAppResourcesManager sharedManager].delegate respondsToSelector:@selector(appResourcesManagerFetchFontWithName:size:)]) {
        font = [[ALWAppResourcesManager sharedManager].delegate appResourcesManagerFetchFontWithName:fontName size:fontSize];
    }
    
    if (!font) {
        font = [UIFont fontWithName:fontName size:fontSize];
    }
    
    if (!font) {
        font = [UIFont systemFontOfSize:fontSize];
    }
    
    return font;
}

#pragma mark - 为其他模块提供的图片相关调用方法
+ (UIImage *)imageNamed:(NSString *)name
{
    if (name && [name.pathExtension isEqualToString:@"webp"]) {
        return [self imageWithContentsOfFileName:name];
    }
    
    UIImage *image;
    
    NSArray *mainBundleArray = [self getMainBundleArray];
    for (NSBundle *mainBundle in mainBundleArray) {
        image = [UIImage imageNamed:name inBundle:mainBundle compatibleWithTraitCollection:nil];
        
        if (image) {
            break;
        }
    }
    
    return image;
}

+ (UIImage *)imageWithContentsOfFileName:(NSString *)fileName
{
    return [self imageWithContentsOfFileName:fileName inBundle:nil];
}

+ (UIImage *)imageWithContentsOfFileName:(NSString *)fileName inBundle:(NSString *)bundleName
{
    NSString *filePath = [self getImagePathWithFileName:fileName inBundle:bundleName];
    
    //增加webp图片的读取逻辑
    if (filePath && [filePath.pathExtension isEqualToString:@"webp"]) {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wundeclared-selector"
        if (![[self sharedManager] respondsToSelector:@selector(imageWithWebPData:)]) {
            
#ifdef DEBUG
            NSLog(@"ALWAppResourcesManager' subspec named WebP not be installed.");
#endif
            
            return nil;
        }
        
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        UIImage *webpImage = [[self sharedManager] performSelector:@selector(imageWithWebPData:) withObject:data];
#pragma clang diagnostic pop
        
        return webpImage;
    }
    
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    
    return image;
}

#pragma mark - 为其他模块提供文件数据获取方法
+ (NSData *)dataWithContentsOfFileName:(NSString *)fileName
{
    return [self dataWithContentsOfFileName:fileName inBundle:nil];
}

+ (NSData *)dataWithContentsOfFileName:(NSString *)fileName inBundle:(NSString *)bundleName
{
    NSString *filePath;
    NSArray *mainBundleArray = [self getMainBundleArray];
    
    for (NSBundle *mainBundle in mainBundleArray) {
        NSBundle *currentBundle;
        
        if (bundleName) {
            NSString *bundlePath = [mainBundle pathForResource:bundleName.stringByDeletingPathExtension ofType:@"bundle"];
            currentBundle = [NSBundle bundleWithPath:bundlePath];
        }else{
            currentBundle = mainBundle;
        }
        
        filePath = [currentBundle pathForResource:fileName.stringByDeletingPathExtension ofType:fileName.pathExtension];
        
        if (filePath) {
            break;
        }
    }
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    return data;
}

#pragma mark - Private
+ (NSString *)getImagePathWithFileName:(NSString *)fileName inBundle:(NSString *)bundleName
{
    NSString *ext = fileName.pathExtension;
    NSArray *extArray;
    
    NSString *fullName = fileName;
    NSString *fileNameWithoutExt = fileName;
    
    if (ext && ![ext isEqualToString:@""]) {
        fileNameWithoutExt = fileName.stringByDeletingPathExtension;
        extArray = @[ext];
    }else{
        //优先读取png格式的图片
        extArray = @[@"png", @"jpg", @"webp", @"jpeg", @"bmp"];
    }
    
    NSInteger scale = [UIScreen mainScreen].scale;
    if (scale > 1) {
        fullName = [fileNameWithoutExt stringByAppendingString:[NSString stringWithFormat:@"@%dx", (int)scale]];
    }
    
    NSString *filePath;
    
    NSArray *mainBundleArray = [self getMainBundleArray];
    
    for (NSBundle *mainBundle in mainBundleArray) {
        BOOL isExist = NO;
        
        NSBundle *currentBundle;
        
        if (bundleName) {
            NSString *bundlePath = [mainBundle pathForResource:bundleName.stringByDeletingPathExtension ofType:@"bundle"];
            currentBundle = [NSBundle bundleWithPath:bundlePath];
        }else{
            currentBundle = mainBundle;
        }
        
        for (NSString *tempExt in extArray) {
            filePath = [currentBundle pathForResource:fullName ofType:tempExt];
            
            if (filePath) {
                isExist = YES;
                break;
            }else{
                if (![fileNameWithoutExt isEqualToString:fullName]) {
                    filePath = [currentBundle pathForResource:fileNameWithoutExt ofType:tempExt];
                    
                    if (filePath) {
                        isExist = YES;
                        break;
                    }
                }
            }
        }
        
        if (isExist) {
            break;
        }
    }
    
    return filePath;
}

+ (NSArray *)getMainBundleArray
{
    NSMutableArray *mainBundleArray = [NSMutableArray array];
    
    if ([self currentMainBundle]) {
        [mainBundleArray addObject:[self currentMainBundle]];
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wundeclared-selector"
    if ([[self sharedManager] respondsToSelector:@selector(mainProjectBundle)]) {
        NSBundle *mainProjectBundle = [[self sharedManager] performSelector:@selector(mainProjectBundle) withObject:nil];
        
        if (mainProjectBundle) {
            [mainBundleArray addObject:mainProjectBundle];
        }
    }
#pragma clang diagnostic pop
    
    return mainBundleArray;
}

@end
