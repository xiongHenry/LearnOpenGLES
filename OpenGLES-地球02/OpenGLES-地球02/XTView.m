//
//  XTView.m
//  OpenGLES-地球02
//
//  Created by 熊涛 on 2022/8/9.
//

#import "XTView.h"

@implementation XTView

+(Class)layerClass {
    return [CAEAGLLayer class];
}

-(instancetype)initWithFrame:(CGRect)frame context:(EAGLContext *)context {
    if (self = [super initWithFrame:frame]) {
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        eaglLayer.drawableProperties =
           [NSDictionary dictionaryWithObjectsAndKeys:
               [NSNumber numberWithBool:NO],
               kEAGLDrawablePropertyRetainedBacking,
               kEAGLColorFormatRGBA8,
               kEAGLDrawablePropertyColorFormat,
               nil];
        self.context = context;
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)coder
{
   if ((self = [super initWithCoder:coder]))
   {
      CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
      
      eaglLayer.drawableProperties =
         [NSDictionary dictionaryWithObjectsAndKeys:
             [NSNumber numberWithBool:NO],
             kEAGLDrawablePropertyRetainedBacking,
             kEAGLColorFormatRGBA8,
             kEAGLDrawablePropertyColorFormat,
             nil];
   }
   
   return self;
}

#pragma mark - display
- (void)display{
    [EAGLContext setCurrentContext:self.context];
    glViewport(0, 0, self.drawableWidth, self.drawableHeight);
    [self drawRect:[self bounds]];
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
}

#pragma mark - laysubviews
// 视图附属的帧缓存，渲染缓存取决于视图的大小，视图会自动调整相关层的尺寸。
-(void)layoutSubviews {
//    [super layoutSubviews];

    CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
    [EAGLContext setCurrentContext:self.context];
    /// 调整视图的缓存的尺寸以匹配层的新尺寸
    [self.context renderbufferStorage:GL_RENDERBUFFER fromDrawable:eaglLayer];

    if (depthBuffer != 0) {
        glDeleteRenderbuffers(1, &depthBuffer); //注：我使用deletebuffer删除，则出现出错。
        depthBuffer = 0;
    }

    GLsizei width = self.drawableWidth;
    GLsizei height = self.drawableHeight;
    /**
        注意：与core animation层分享内存的`像素颜色缓存`在层调整大小时会自动调整大小
        但是！，深度缓存不会自动调整大小。
        所以当视图大小改变时，在layoutSubviews删除现存的深度缓存，并创建一个新的与像素颜色缓存的新尺寸相匹配的深度缓存
     */
    if (self.drawableDepthFormat != XTViewDrawableDepthFormatNone && width > 0 && height
        > 0) {
        //1.生成
        glGenRenderbuffers(1, &depthBuffer);
        //2.绑定
        glBindRenderbuffer(GL_RENDERBUFFER, depthBuffer);
        //3.配置存储---指定深度缓存大小
        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, width, height);
        //4.附加---附加深度缓存到一个帧缓存
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthBuffer);
    }

    /// 使渲染缓冲区成为当前要显示的缓冲区
    glBindRenderbuffer(GL_RENDERBUFFER, renderBuffer);
}

-(void)drawRect:(CGRect)rect {
    if (self.delegate) {
        [self.delegate glkView:self drawInRect:[self bounds]];
    }
}

#pragma mark - setter
-(void)setContext:(EAGLContext *)context {
    if (context != _context) {
        [EAGLContext setCurrentContext:_context];
        if (frameBuffer != 0) {
            glDeleteFramebuffers(1, &frameBuffer);
            frameBuffer = 0;
        }
        
        if (renderBuffer != 0) {
            glDeleteRenderbuffers(1, &renderBuffer);
            renderBuffer = 0;
        }
        
        if (depthBuffer != 0) {
            glDeleteRenderbuffers(1, &depthBuffer);
            depthBuffer = 0;
        }
    }
    
    _context = context;
    
    if (context != nil) {
        [EAGLContext setCurrentContext:_context];
        glGenFramebuffers(1, &frameBuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
        
        glGenRenderbuffers(1, &renderBuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, renderBuffer);
        
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderBuffer);
        
        [self layoutSubviews];
    }
}

#pragma mark - getter
-(NSInteger)drawableWidth {
    GLint backingWidth;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    return (NSInteger)backingWidth;
}

-(NSInteger)drawableHeight {
    GLint backingHeight;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
    return (NSInteger)backingHeight;
}

#pragma mark - dealloc
-(void)dealloc {
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    self.context = nil;
}

@end
