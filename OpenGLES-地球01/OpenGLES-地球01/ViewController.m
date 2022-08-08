//
//  ViewController.m
//  OpenGLES-地球01
//
//  Created by 熊涛 on 2022/8/8.
//

#import "ViewController.h"
#import "AGLKContext.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "sphere.h"

@interface ViewController ()
@property (nonatomic, strong) GLKBaseEffect *baseEffect;
@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *vertsBuffer;
@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *normalsBuffer;
@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *textcoordsBuffer;
@property (nonatomic, strong) GLKTextureInfo *earthTextureInfo;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    GLKView *view = (GLKView *)self.view;
    
    // 设置深度缓冲精度
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    
    // context
    AGLKContext *context = [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    view.context = context;
    [AGLKContext setCurrentContext:context];
    [context setClearColor:GLKVector4Make(0.0, 0.0, 0.0, 1.0)]; //black
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.light0.enabled = GL_TRUE;
    /// 漫反射光
    self.baseEffect.light0.diffuseColor = GLKVector4Make(0.7, 0.7, 0.7, 1.0);
    /// 环境光
    self.baseEffect.light0.ambientColor = GLKVector4Make(0.2, 0.2, 0.2, 1.0);
    /// 光源位置
    self.baseEffect.light0.position = GLKVector4Make(1.0, 0.0, -0.8, 0.0);
    
    
    /// 纹理
    CGImageRef earthImage = [UIImage imageNamed:@"Earth512x256.jpg"].CGImage;
    self.earthTextureInfo = [GLKTextureLoader textureWithCGImage:earthImage options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],GLKTextureLoaderOriginBottomLeft,nil] error:nil];
    self.baseEffect.texture2d0.name = self.earthTextureInfo.name;
    self.baseEffect.texture2d0.target = self.earthTextureInfo.target;
    
    /// 数据
    /// 顶点数据
    self.vertsBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:(sizeof(GLfloat)*3) numberOfVertices:(sizeof(sphereVerts)/(sizeof(GLfloat)*3)) bytes:sphereVerts usage:GL_STATIC_DRAW];
    /// 法线数据
    self.normalsBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:(sizeof(GLfloat)*3) numberOfVertices:(sizeof(sphereNormals)/(sizeof(GLfloat)*3)) bytes:sphereNormals usage:GL_STATIC_DRAW];
    /// 纹理数据
    self.textcoordsBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:(sizeof(GLfloat)*2) numberOfVertices:(sizeof(sphereTexCoords)/(sizeof(GLfloat)*2)) bytes:sphereTexCoords usage:GL_STATIC_DRAW];
    
    /// 开启深度缓冲
    glEnable(GL_DEPTH_TEST);
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT];
    
    /// 绑定数据
    [self.vertsBuffer prepareToDrawWithAttrib:AGLKVertexAttribPosition numberOfCoordinates:3 attribOffset:0 shouldEnable:YES];
    [self.normalsBuffer prepareToDrawWithAttrib:AGLKVertexAttribNormal numberOfCoordinates:3 attribOffset:0 shouldEnable:YES];
    [self.textcoordsBuffer prepareToDrawWithAttrib:AGLKVertexAttribTexCoord0 numberOfCoordinates:2 attribOffset:0 shouldEnable:YES];
    
    [self.baseEffect prepareToDraw];
    
    ///缩放比
    const GLfloat aspectRatio = (GLfloat)view.drawableWidth / (GLfloat)view.drawableHeight;
    self.baseEffect.transform.projectionMatrix = GLKMatrix4MakeScale(1.0, aspectRatio, 1.0);
    
    /// 绘制
    [AGLKVertexAttribArrayBuffer drawPreparedArraysWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:sphereNumVerts];
}

@end
