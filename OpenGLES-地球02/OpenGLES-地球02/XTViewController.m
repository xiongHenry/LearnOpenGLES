//
//  XTViewController.m
//  OpenGLES-地球02
//
//  Created by 熊涛 on 2022/8/9.
//

#import "XTViewController.h"

@interface XTViewController ()
@property (nonatomic, strong) CADisplayLink *displayLink;
@end

@implementation XTViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
   bundle:(NSBundle *)nibBundleOrNil;
{
    if(nil != (self = [super initWithNibName:nibNameOrNil
       bundle:nibBundleOrNil]))
    {
      self.displayLink =
         [CADisplayLink displayLinkWithTarget:self
            selector:@selector(drawView:)];

      self.preferredFramesPerSecond = 30;

      [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop]
         forMode:NSDefaultRunLoopMode];
        
        self.paused = NO;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder*)coder
{
   if (nil != (self = [super initWithCoder:coder]))
   {
      self.displayLink =
         [CADisplayLink displayLinkWithTarget:self
            selector:@selector(drawView:)];

      self.preferredFramesPerSecond = 2;

      [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop]
         forMode:NSDefaultRunLoopMode];
         
      self.paused = NO;
   }
   
   return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    XTView *view = (XTView *)self.view;
    NSAssert([view isKindOfClass:[XTView class]],
       @"View controller's view is not a AGLKView");
    
    view.opaque = YES;
    view.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
   [super viewDidAppear:animated];
   self.paused = NO;
}


/////////////////////////////////////////////////////////////////
// This method is called when the receiver's view disappears and
// pauses the receiver.
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   self.paused = YES;
}


#pragma mark - display
- (void)drawView:(id)sender {
    [(XTView *)self.view display];
}

#pragma mark - XTViewDelegate
-(void)glkView:(XTView *)view drawInRect:(CGRect)rect {

}

//-(void)glkView:(AGLKView *)view drawInRect:(CGRect)rect {
//
//}

#pragma mark - setter
-(void)setPreferredFramesPerSecond:(NSInteger)preferredFramesPerSecond {
    _preferredFramesPerSecond = preferredFramesPerSecond;
    self.displayLink.preferredFramesPerSecond = preferredFramesPerSecond;
}

-(void)setPaused:(BOOL)paused {
    _paused = paused;
    self.displayLink.paused = paused;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
   if ([[UIDevice currentDevice] userInterfaceIdiom] ==
      UIUserInterfaceIdiomPhone)
   {
       return (interfaceOrientation !=
          UIInterfaceOrientationPortraitUpsideDown);
   }
   else
   {
       return YES;
   }
}
@end
