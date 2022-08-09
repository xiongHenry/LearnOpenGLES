//
//  XTView.h
//  OpenGLES-地球02
//
//  Created by 熊涛 on 2022/8/9.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

NS_ASSUME_NONNULL_BEGIN
@protocol XTViewDelegate;
typedef enum
{
    XTViewDrawableDepthFormatNone = 0,
    XTViewDrawableDepthFormat16,
} XTViewDrawableDepthFormat;

@interface XTView : UIView
{
    GLuint frameBuffer;
    GLuint renderBuffer;
    GLuint depthBuffer;
}
@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, assign, readonly) NSInteger drawableWidth;
@property (nonatomic, assign, readonly) NSInteger drawableHeight;
@property (nonatomic, assign) XTViewDrawableDepthFormat drawableDepthFormat;
@property (nonatomic, weak) id<XTViewDelegate> delegate;

- (void)display;
@end

@protocol XTViewDelegate <NSObject>
@required
- (void)glkView:(XTView *)view drawInRect:(CGRect)rect;
@end

NS_ASSUME_NONNULL_END
