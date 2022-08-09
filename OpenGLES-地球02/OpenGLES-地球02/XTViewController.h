//
//  XTViewController.h
//  OpenGLES-地球02
//
//  Created by 熊涛 on 2022/8/9.
//

#import <UIKit/UIKit.h>
#import "XTView.h"
#import "AGLKView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XTViewController : UIViewController<XTViewDelegate>
@property (nonatomic, assign) NSInteger preferredFramesPerSecond;
@property (nonatomic, assign) BOOL paused;
@end

NS_ASSUME_NONNULL_END
