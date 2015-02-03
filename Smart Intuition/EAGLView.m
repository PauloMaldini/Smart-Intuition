#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>


#import "EAGLView.h"
#import "CGameController.h"
#import "CDescrScene.h"
#import "CMenuElement.h"
#import "CGameScene.h"
#import "time.h"
#import "CSpriteStorage.h"
#import "kt_library.h"



@interface EAGLView (EAGLViewPrivate)

- (BOOL)createFramebuffer;
- (void)destroyFramebuffer;

@end

@interface EAGLView (EAGLViewSprite)

- (void)setupView;

@end

@implementation EAGLView

@synthesize animating;
@synthesize gameController;
@dynamic animationFrameInterval;


// You must implement this
+ (Class) layerClass
{
	return [CAEAGLLayer class];
}

//The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithCoder:(NSCoder*)coder
{
    if((self = [super initWithCoder:coder])) 
    {
        int w = 320, h = 480;
        float ver = [[[UIDevice currentDevice] systemVersion] floatValue];
        // You can't detect screen resolutions in pre 3.2 devices, but they are all 320x480
        if (ver >= 3.2f)
        {
            UIScreen* mainscr = [UIScreen mainScreen];
            w = mainscr.currentMode.size.width;
            h = mainscr.currentMode.size.height;
        }
        if (w == 640 && h == 960)
        {
           // self.contentScaleFactor = 2.0;
           // CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
          //  eaglLayer.contentsScale = 2;
            //menuPlistFileName = @"ui@2x";
        }
        
        //Создаем очередь сообщений
        controlMessageStack = [[CControlMessageStack alloc] init];
        
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer*) self.layer;
        
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if(!context || ![EAGLContext setCurrentContext:context] || ![self createFramebuffer]) {
            [self release];
            return nil;
        }
        
        animating = FALSE;
        displayLinkSupported = FALSE;
        animationFrameInterval = 1;
        displayLink = nil;
        animationTimer = nil;
        
        // A system version of 3.1 or greater is required to use CADisplayLink. The NSTimer
        // class is used as fallback when it isn't available.
        NSString *reqSysVer = @"3.1";
        NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
        if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
            displayLinkSupported = TRUE;
        
        self.multipleTouchEnabled = YES;
        
        [self setupView];
        [self drawView];
   }
   
   return self;
}


- (void)layoutSubviews
{
    [EAGLContext setCurrentContext:context];
    [self destroyFramebuffer];
    [self createFramebuffer];
    [self drawView];
}


- (BOOL)createFramebuffer
{
    glGenFramebuffersOES(1, &viewFramebuffer);
    glGenRenderbuffersOES(1, &viewRenderbuffer);
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(id<EAGLDrawable>)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    
    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
    return YES;
}


- (void)destroyFramebuffer
{
    glDeleteFramebuffersOES(1, &viewFramebuffer);
    viewFramebuffer = 0;
    glDeleteRenderbuffersOES(1, &viewRenderbuffer);
    viewRenderbuffer = 0;
    
    if(depthRenderbuffer) {
        glDeleteRenderbuffersOES(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }
}


- (NSInteger) animationFrameInterval
{
    return animationFrameInterval;
}

- (void) setAnimationFrameInterval:(NSInteger)frameInterval
{
    // Frame interval defines how many display frames must pass between each time the
    // display link fires. The display link will only fire 30 times a second when the
    // frame internal is two on a display that refreshes 60 times a second. The default
    // frame interval setting of one will fire 60 times a second when the display refreshes
    // at 60 times a second. A frame interval setting of less than one results in undefined
    // behavior.
    if (frameInterval >= 1)
    {
        animationFrameInterval = frameInterval;
        
        if (animating)
        {
            [self stopAnimation];
            [self startAnimation];
        }
    }
}

- (void) startAnimation
{
    lastTime = 0.0;
    deltaTime = 0.0;

    if (!animating)
    {
        if (displayLinkSupported)
        {
            // CADisplayLink is API new to iPhone SDK 3.1. Compiling against earlier versions will result in a warning, but can be dismissed
            // if the system version runtime check for CADisplayLink exists in -initWithCoder:. The runtime check ensures this code will
            // not be called in system versions earlier than 3.1.
            
            displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(drawView)];
            [displayLink setFrameInterval:animationFrameInterval];
            [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        }
        else
            animationTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)((1.0 / 60.0) * animationFrameInterval) target:self selector:@selector(drawView) userInfo:nil repeats:TRUE];
        
        animating = TRUE;
    }
}

- (void)stopAnimation
{
    if (animating)
    {
        if (displayLinkSupported)
        {
            [displayLink invalidate];
            displayLink = nil;
        }
        else
        {
            [animationTimer invalidate];
            animationTimer = nil;
        }
        
        animating = FALSE;
    }
}

- (void)setupView
{
    
    glViewport(0, 0, backingWidth, backingHeight);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrthof(-160, 160, -240, 240, -1, 1);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    //Смещаемся в левый нижний угол экрана
    glTranslatef(-160, -240, 0.0f);
    //Цвет очистки экрана - черный
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    //Включаем поддержку текстур
    glEnable(GL_TEXTURE_2D);
    //Задаем уравнение смешивания
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    //Включаем смешивание
    glEnable(GL_BLEND);
      
    nextDeltaTimeZero_ = true;
    //Загружаем спрайты для букв FPS
    arialDict = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"arial" ofType:@"plist"]];
    fpsSpriteStorage = [[CSpriteStorage alloc] initWithSpriteCount:100 WithTexture:@"arial.png" WithFillType:ftTexture WithGameScene:nil];
}

- (void)drawView
{
    [self calculateDeltaTime];
    fps = [self calcFPS];
    
    [EAGLContext setCurrentContext:context];
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    
    glClearColor(0.0f, 0.0f, 0.0f, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    
    //Показываем fps в левом верхнем углу
    [fpsSpriteStorage clear];
    NSString *fpsString = [NSString stringWithFormat:@"fps:%d", fps + 1];
    [self drawText:fpsString InPos:CGPointMake(13, 476) InSpriteStorage:fpsSpriteStorage FromDict:arialDict];
    
    //Показываем номер версии в правом верхнем
    fpsString = [NSString stringWithFormat:@VER_NUM];
    [self drawText:fpsString InPos:CGPointMake(180, 476) InSpriteStorage:fpsSpriteStorage FromDict:arialDict];

    //Принимаем данные касаний и данные акселерометра
    //NSLog(@"Message count: %d/n", [controlMessageStack touchMessageCount]);
    
    STouchMessage touchMessage;
    SAccelerometerMessage accelerometerMessage;
    
    do
    {
        //Получаем сообщение от касаний
        [controlMessageStack popTouchMessage:&touchMessage];
        //Получаем сообщение от акселерометра
        [controlMessageStack popAccelerometerMessage:&accelerometerMessage];
        
        //Двигаем текущую сцену
        [gameController moveCurrentScene:/*deltaTime*/dt :touchMessage :accelerometerMessage];
        
    } while ([controlMessageStack touchMessageCount] > 0);
    
    //Рендерим текущую сцену
    [gameController renderCurrentScene];
    //Рендерим FPS
    GLfloat f[16];
    glGetFloatv(GL_MODELVIEW_MATRIX, f);
    for (int i = 0; i < fpsSpriteStorage.count; i++)
    {
        SRect rect = [fpsSpriteStorage getSpriteByIndex:i].rect;
        rect.a.x -= f[12] + 160;
        rect.a.y -= f[13] + 240;
        rect.b.x -= f[12] + 160;
        rect.b.y -= f[13] + 240;
        rect.c.x -= f[12] + 160;
        rect.c.y -= f[13] + 240;
        rect.d.x -= f[12] + 160;
        rect.d.y -= f[13] + 240;
        [fpsSpriteStorage getSpriteByIndex:i].rect = rect;
    }
    [fpsSpriteStorage move:deltaTime :touchMessage :accelerometerMessage];
    [fpsSpriteStorage render];
  
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

- (void)dealloc
{
    //Освобождаем аудио-ресурсы
    alSourceStop(audioSourceCollisId);
    alSourcei(audioSourceCollisId, AL_BUFFER, 0);
    alDeleteBuffers(1, &audioBufferCollisId);
    alDeleteSources(1,&audioSourceCollisId);
    alcDestroyContext(contextAudio);
    alcCloseDevice(deviceAudio);
    
    //Освобождаем OpenGL-контекст
    if([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext:nil];
    } 
    
    [context release];
    context = nil;
    
    //Удаляем игровой контроллер
    [gameController dealloc];
    
    [super dealloc];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch;
    NSEnumerator *enumerator = [touches objectEnumerator];

    while ((touch = (UITouch *)[enumerator nextObject]))
    {
        CGPoint location = [touch locationInView: self];
        CGPoint startLocation = location;
        startLocation.y = backingHeight - startLocation.y;
               
        STouchMessage touchMessage;
        touchMessage.isRight = true;
        touchMessage.newLocation = startLocation;
        touchMessage.type = 1;
        touchMessage.touchId = (int)touch;
        [controlMessageStack pushTouchMessage:touchMessage];
    
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch;
    NSEnumerator *enumerator = [touches objectEnumerator];
    //NSLog(@"%d", [touches count]);
    while ((touch = (UITouch *)[enumerator nextObject]))
    {
        CGPoint oldLocation = [touch previousLocationInView:self];
        CGPoint location    = [touch locationInView:self];
    
        oldLocation.y = backingHeight - oldLocation.y;
        location.y = backingHeight - location.y;
    
        STouchMessage touchMessage;
        touchMessage.isRight = true;
        touchMessage.newLocation = location;
        touchMessage.oldLocation = oldLocation;
        touchMessage.touchId = (int)touch;
        touchMessage.type = 3;
        [controlMessageStack pushTouchMessage:touchMessage];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch;
    NSEnumerator *enumerator = [touches objectEnumerator];
    while ((touch = (UITouch *)[enumerator nextObject]))
    {
        CGPoint location = [touch locationInView: self];
        NSUInteger tapCount = [touch tapCount];
        CGPoint finishLocation = location;
        finishLocation.y = backingHeight - finishLocation.y;
    
        STouchMessage touchMessage;
        touchMessage.isRight = true;
        touchMessage.newLocation = finishLocation;
        touchMessage.touchId = (int)touch;
        touchMessage.type = 2;
        touchMessage.tapCount = tapCount;
        [controlMessageStack pushTouchMessage:touchMessage];
        
        /*if (tapCount == 3)
            [delegate showOptions];*/
    }
}

- (void)clearMemory: (void*)p WithByteCount: (int)count
{
    for (int i = 0; i < count; i++)
        *(Byte *)(p + i) = 0;
}



- (void) drawText:(NSString *)text InPos:(CGPoint)pos InSpriteStorage:(CSpriteStorage *)spriteStorage FromDict:(NSDictionary *)dict
{
    SRect charRect;
    SColor charColor;
    SSpeed charSpeed;
    
    SImageSequence *charImageSequence;
    
    //Проходим в цикле по буквам текста, создавая для каждой буквы свой спрайт
    for (int i = 0; i < text.length; i++)
    {
        charImageSequence = malloc(sizeof(SImageSequence));
        
        getDataFromPlist(dict, [text substringWithRange:NSMakeRange(i, 1)], spriteStorage.textureAtlasWidth, spriteStorage.textureAtlasHeight, &charRect, &charImageSequence[0].images[0], &charColor, &charSpeed);
        
        CGFloat w = charRect.b.x - charRect.a.x;
        CGFloat h = charRect.a.y - charRect.c.y;
        
        charRect.a.x += pos.x + i*w;
        charRect.a.y = pos.y;
        charRect.b.x = charRect.a.x + w;
        charRect.b.y = pos.y;
        charRect.c.x = charRect.a.x;
        charRect.c.y = charRect.a.y - h;
        charRect.d.x = charRect.a.x + w;
        charRect.d.y = charRect.a.y - h;
        
        CSprite *charSprite = [[CSprite alloc] initWithGameController:nil WithRect:charRect WithImageSequences:charImageSequence WithColor:charColor WithSpeed:charSpeed WithRotateSpeed:0 WithRotateBasePoint:CGPointMake(0, 0)];
        
        [fpsSpriteStorage addSprite:charSprite];
    }
}


- (int) calcFPS
{
    static int m_nFps; // current FPS
    static CFTimeInterval lastFrameStartTime; 
    static int m_nAverageFps; // the average FPS over 15 frames
    static int m_nAverageFpsCounter;
    static int m_nAverageFpsSum;
    
    CFTimeInterval thisFrameStartTime = CFAbsoluteTimeGetCurrent();
    float deltaTimeInSeconds = thisFrameStartTime - lastFrameStartTime;
    m_nFps = (deltaTimeInSeconds == 0) ? 0: 1 / (deltaTimeInSeconds);
    
    m_nAverageFpsCounter++;
    m_nAverageFpsSum+=m_nFps;
    if (m_nAverageFpsCounter >= 15) // calculate average FPS over 15 frames
    {
        m_nAverageFps = m_nAverageFpsSum/m_nAverageFpsCounter;
        m_nAverageFpsCounter = 0;
        m_nAverageFpsSum = 0;
    }
   
    lastFrameStartTime = thisFrameStartTime;
    
    return (m_nAverageFps);
}

- (void) drawOptions
{
 
}

-(void) accelerometerProcess:(double)x :(double)y :(double)z
{
    SAccelerometerMessage accelerometerMessage;
    accelerometerMessage.x = x;
    accelerometerMessage.y = y;
    accelerometerMessage.z = z;
    
    [controlMessageStack pushAccelerometerMessage:accelerometerMessage];   
}


- (void) setDelegate:(id)_delegate
{
    delegate = _delegate;
}

-(void) calculateDeltaTime
{
	struct timeval now;
    
	if(gettimeofday(&now, NULL) != 0)
    {
		dt = 0;
		return;
	}
    
	// new delta time
	if( nextDeltaTimeZero_ ) {
		dt = 0;
		nextDeltaTimeZero_ = NO;
	} else {
		dt = (now.tv_sec - lastUpdate_.tv_sec) + (now.tv_usec - lastUpdate_.tv_usec) / 1000000.0f;
		dt = MAX(0,dt);
	}

/*
#ifdef DEBUG
	// If we are debugging our code, prevent big delta time
	if( dt > 0.2f )
		dt = 1/60.0f;
#endif*/
    
	lastUpdate_ = now;
}

- (void) createGameController
{
    gameController = [[CGameController alloc] initWithScreenWidth:backingWidth WithScreenHeight:backingHeight WithDelegate:delegate];
}

- (void) deleteGameController
{
    [gameController dealloc];
    gameController = nil;
}



@end