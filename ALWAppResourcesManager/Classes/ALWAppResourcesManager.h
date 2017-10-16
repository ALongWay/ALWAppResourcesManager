//
//  ALWAppResourcesManager.h
//  Pods
//
//  Created by lisong on 2017/7/21.
//
//

#import <Foundation/Foundation.h>

#pragma mark - ALWAppResourcesManagerDelegate
@protocol ALWAppResourcesManagerDelegate <NSObject>

///根据名字和尺寸，向代理者（一般为AppDelegate）获取字体对象
- (UIFont *)appResourcesManagerFetchFontWithName:(NSString *)fontName size:(CGFloat)fontSize;

@end

#pragma mark - ALWAppResourcesManager
/**
 该组件可用于统一管理App的字体、图片、音频、视频、bundle等资源文件。
 如字体等部分资源需要在主工程中添加，则需在主工程中注册该组件，并提供相应代理方法。
 其他pod组件可以创建本类的子类并重写currentMainBundle方法，即可复用其他方法用于读取组件内资源。

 提供了可选择集成的Subspec：WebP（读取webp资源图片），MainProject（组件内未获取到资源，则将在主工程中搜索）
 */
@interface ALWAppResourcesManager : NSObject

///注册代理者，多为主工程的AppDelegate
+ (void)registerToDelegate:(id<ALWAppResourcesManagerDelegate>)delegate;

///当前组件加载到应用中后的总资源包；其他组件可以创建本类的子类并重写该方法，即可复用其他方法用于读取组件内资源。
+ (NSBundle *)currentMainBundle;

#pragma mark - 为其他模块提供的字体相关调用方法
///调用此方法，可以获取到主工程中添加的自定义字体
+ (UIFont *)fontWithName:(NSString *)fontName size:(CGFloat)fontSize;

#pragma mark - 为其他模块提供的图片相关调用方法
/**
 通过图片名称获取当前组件内根包目录下图像，同UIimage的imageNamed方法，存在缓存图像的情况，但仅支持iOS8.0以后。
 已经支持webp图片读取：无缓存，需要带扩展名。
 
 @param name 当前组件内图片名称
 @return 当前组件内图像
 */
+ (UIImage *)imageNamed:(NSString *)name;

/**
 通过图片名称获取当前组件内根包目录下图像，同UIimage的imageWithContentsOfFile方法，不存在缓存图像的情况
 
 @param fileName 当前组件内图片文件名称，无扩展名，优先读取png图片
 @return 当前组件内图像
 */
+ (UIImage *)imageWithContentsOfFileName:(NSString *)fileName;

/**
 通过图片名称和当前组件内的子包名称获取当前组件内图像，同上述方法
 
 @param fileName 当前组件内图片文件名称，无扩展名，优先读取png图片
 @param bundleName 当前组件内子包名称
 @return 当前组件内图像
 */
+ (UIImage *)imageWithContentsOfFileName:(NSString *)fileName inBundle:(NSString *)bundleName;

#pragma mark - 为其他模块提供文件数据获取方法
/**
 通过文件完整名称获取当前组件内文件数据
 
 @param fileName 当前组件内文件完整名称
 @return 当前组件内文件数据
 */
+ (NSData *)dataWithContentsOfFileName:(NSString *)fileName;

/**
 通过文件完整名称和当前组件内的子包名称获取当前组件内文件数据
 
 @param fileName 当前组件内文件完整名称
 @param bundleName 当前组件内子包名称
 @return 当前组件内文件数据
 */
+ (NSData *)dataWithContentsOfFileName:(NSString *)fileName inBundle:(NSString *)bundleName;

@end
