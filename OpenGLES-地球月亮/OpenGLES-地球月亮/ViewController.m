//
//  ViewController.m
//  OpenGLES-地球月亮
//
//  Created by 熊涛 on 2022/8/9.
//

#import "ViewController.h"
#import "AGLKContext.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "sphere.h"

@interface ViewController ()
@property (nonatomic, strong) GLKBaseEffect *baseEffect;
@property (nonatomic, strong) GLKTextureInfo *earthTextureInfo;
@property (nonatomic, strong) GLKTextureInfo *moonTextureInfo;
@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *vertsBuffer;
@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *normalsBuffer;
@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *textcoordsBuffer;
@property (nonatomic, assign) GLKMatrixStackRef modelviewMatrixStack;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"view is kink of GLKView");
    
    /// 上下文
    AGLKContext *context =  [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [AGLKContext setCurrentContext:context];
    [context setClearColor:GLKVector4Make(0.0, 0.0, 0.0, 1.0)];
    view.context = context;
    
    /// 着色器
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.light0.enabled = GL_TRUE;
    self.baseEffect.light0.diffuseColor = GLKVector4Make(1.0, 1.0, 1.0, 1.0);
    self.baseEffect.light0.position = GLKVector4Make(1.0, 0.5, 0.0, 0.0);
    
    /// 纹理
    CGImageRef earthImageRef = [UIImage imageNamed:@"Earth512x256.jpg"].CGImage;
    self.earthTextureInfo = [GLKTextureLoader textureWithCGImage:earthImageRef options:@{GLKTextureLoaderOriginBottomLeft:@(YES)} error:nil];
    
    CGImageRef moonImageRef = [UIImage imageNamed:@"Moon256x128.png"].CGImage;
    self.moonTextureInfo = [GLKTextureLoader textureWithCGImage:moonImageRef options:@{GLKTextureLoaderOriginBottomLeft:@(YES)} error:nil];
    
    
    /// 顶点数据
    self.vertsBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:sizeof(GLfloat)*3 numberOfVertices:sizeof(sphereVerts)/(sizeof(GLfloat)*3) bytes:sphereVerts usage:GL_STATIC_DRAW];
    /// 法线数据
    self.normalsBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:sizeof(GLfloat)*3 numberOfVertices:sizeof(sphereNormals)/(sizeof(GLfloat)*3) bytes:sphereNormals usage:GL_STATIC_DRAW];
    /// 纹理数据
    self.textcoordsBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:sizeof(GLfloat)*2 numberOfVertices:sizeof(sphereTexCoords)/(sizeof(GLfloat)*2) bytes:sphereTexCoords usage:GL_STATIC_DRAW];
    
    
    /// 开启深度缓冲
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    glEnable(GL_DEPTH_TEST);
}

/// 绘制地球
- (void)drawEarth {
    self.baseEffect.texture2d0.name = self.earthTextureInfo.name;
    self.baseEffect.texture2d0.target = self.earthTextureInfo.target;
    
    [self.vertsBuffer prepareToDrawWithAttrib:AGLKVertexAttribPosition numberOfCoordinates:3 attribOffset:0 shouldEnable:YES];
    [self.normalsBuffer prepareToDrawWithAttrib:AGLKVertexAttribNormal numberOfCoordinates:3 attribOffset:0 shouldEnable:YES];
    [self.textcoordsBuffer prepareToDrawWithAttrib:AGLKVertexAttribTexCoord0 numberOfCoordinates:2 attribOffset:0 shouldEnable:YES];
    
    [self.baseEffect prepareToDraw];
    
    
    /// 变换矩阵
    
}

/// 绘制月亮
- (void)drawMoon {
    
}

/// 绘制回调
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT];
    
    [self drawEarth];
}


@end
