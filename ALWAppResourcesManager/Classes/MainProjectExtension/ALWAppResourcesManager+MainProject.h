//
//  ALWAppResourcesManager+MainProject.h
//  Pods
//
//  Created by lisong on 2017/10/13.
//
//

#import <ALWAppResourcesManager/ALWAppResourcesManager.h>

///如果pod组件中无目标资源，继续前往主工程中查找资源
@interface ALWAppResourcesManager (MainProject)

- (NSBundle *)mainProjectBundle;

@end
