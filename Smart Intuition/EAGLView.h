/*

File: EAGLView.h
Abstract: This class wraps the CAEAGLLayer from CoreAnimation into a convenient
UIView subclass. The view content is basically an EAGL surface you render your
OpenGL scene into.  Note that setting the view non-opaque will only work if the
EAGL surface has an alpha channel.

Version: 1.8

Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple Inc.
("Apple") in consideration of your agreement to the following terms, and your
use, installation, modification or redistribution of this Apple software
constitutes acceptance of these terms.  If you do not agree with these terms,
please do not use, install, modify or redistribute this Apple software.

In consideration of your agreement to abide by the following terms, and subject
to these terms, Apple grants you a personal, non-exclusive license, under
Apple's copyrights in this original Apple software (the "Apple Software"), to
use, reproduce, modify and redistribute the Apple Software, with or without
modifications, in source and/or binary forms; provided that if you redistribute
the Apple Software in its entirety and without modifications, you must retain
this notice and the following text and disclaimers in all such redistributions
of the Apple Software.
Neither the name, trademarks, service marks or logos of Apple Inc. may be used
to endorse or promote products derived from the Apple Software without specific
prior written permission from Apple.  Except as expressly stated in this notice,
no other rights or licenses, express or implied, are granted by Apple herein,
including but not limited to any patent rights that may be infringed by your
derivative works or by other works in which the Apple Software may be
incorporated.

The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO
WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
COMBINATION WITH YOUR PRODUCTS.

IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR
DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF
CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF
APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Copyright (C) 2009 Apple Inc. All Rights Reserved.

*/

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>
#import <AudioToolbox/AudioToolbox.h>



/*
#import "CSprite.h"
#import "CSpriteStorage.h"
#import "CWorldGameProtocol.h"
#import "CFon.h"
#import "CTransfer.h"
#import "CMenuElement.h"
#import "CControlMessageStack.h"
#import "CPlayer.h"
#import "CSlider.h"
#import "CTurnControl.h"*/


#define VER_NUM "20121125"

@class CControlMessageStack;
@class CGameController;
@class CSpriteStorage;

@interface EAGLView : UIView
{
@private
	
    /* The pixel dimensions of the backbuffer */
	GLint backingWidth;
	GLint backingHeight;
	
	EAGLContext *context;
    
    ALCcontext *contextAudio;
    ALCdevice *deviceAudio;
    ALuint audioSourceCollisId;
    ALuint audioBufferCollisId;
	
	/* OpenGL names for the renderbuffer and framebuffers used to render to this view */
	GLuint viewRenderbuffer, viewFramebuffer;
	
	/* OpenGL name for the depth buffer that is attached to viewFramebuffer, if it exists (0 if it does not exist) */
	GLuint depthRenderbuffer;
	
	/* OpenGL name for the sprite texture */
	GLuint fonTexture;
    GLuint atlasOne;
    GLuint atlasTwo;
    GLuint atlasThree;
	
	BOOL animating;
	BOOL displayLinkSupported;
	NSInteger animationFrameInterval;
	// Use of the CADisplayLink class is the preferred method for controlling your animation timing.
	// CADisplayLink will link to the main display and fire every vsync when added to a given run-loop.
	// The NSTimer class is used only as fallback when running on a pre 3.1 device where CADisplayLink
	// isn't available.
	id displayLink;
    NSTimer *animationTimer;	
    
    //GLfloat *vertCoords; //Массив вершинных, текстурных и цветовых координат
    //unsigned short *vertIndexes; //Массив индексов вершин
   
    //CGPoint startLocation; //Первые экранные координаты касания
    //CGPoint finishLocation; //Последние экранные координаты
    
    NSDictionary *arialDict;
    CSpriteStorage *fpsSpriteStorage;
    
    int fps; //FPS
    int polygonCount; //Кол-во полигонов
    
    CControlMessageStack *controlMessageStack; //Очередь сообщений
    
    CFAbsoluteTime lastTime; //Время последнего вызова drawView
    GLfloat deltaTime; //Текущее время выполнения функции drawView
    
    id delegate;
    
    CGameController *gameController;
    
    BOOL nextDeltaTimeZero_;
    struct timeval lastUpdate_;
    float dt;
}

@property (readonly, nonatomic, getter=isAnimating) BOOL animating;
@property (nonatomic) NSInteger animationFrameInterval;
@property (nonatomic, retain) CGameController *gameController;

- (void) startAnimation;
- (void) stopAnimation;
- (void) drawView;
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void) setDelegate:(id)_delegate;
- (void) calculateDeltaTime;

//Очищает указанную область памяти
- (void) clearMemory: (void*)p WithByteCount: (int)count;

//Создает спрайты, реализующие текст и помещает их в хранилище
- (void) drawText:(NSString *)text InPos:(CGPoint)pos InSpriteStorage:(CSpriteStorage *)spriteStorage FromDict:(NSDictionary *)dict;

//Подсчет кол-ва кадров в секунду
- (int) calcFPS;

//Создание игрового контроллера
- (void) createGameController;

//Удаление игрового контроллера
- (void) deleteGameController;


@end
