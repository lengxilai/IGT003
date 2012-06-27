//
//  AppDelegate.m
//  IGT003
//
//  Created by 鹏 李 on 12-6-20.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "IGGameMenuLayer.h"
#import "IGGamePlayingLayer.h"
#import "ReplaceLayerAction.h"
#import "IGGameOverLayer.h"
#import "IGGameHelpLayer.h"
#import "IGGameOptionsLayer.h"
#import "IGGameScoresLayer.h"
#import "IGGameNewLayer.h" 
#import "IGGamePauseLayer.h"
#import "RootViewController.h"
#import "SimpleAudioEngine.h"

@implementation AppDelegate

@synthesize window;

// 取得游戏代理类
+ (AppDelegate*) instance
{
	UIApplication* app = [UIApplication sharedApplication];
	return (AppDelegate*)(app.delegate);
}

// 这函数什么用啊？不懂
- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController

//	CC_ENABLE_DEFAULT_GL_STATES();
//	CCDirector *director = [CCDirector sharedDirector];
//	CGSize size = [director winSize];
//	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
//	sprite.position = ccp(size.width/2, size.height/2);
//	sprite.rotation = -90;
//	[sprite visit];
//	[[director openGLView] swapBuffers];
//	CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	
}
- (void) applicationDidFinishLaunching:(UIApplication*)application
{
    // Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
    
    viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	CCDirector *director = [CCDirector sharedDirector];
    
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
    // attach the openglView to the director
	[director setOpenGLView:glView];
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
	
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:YES];;
	
    // make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
	// make the View Controller a child of the main window
	[window addSubview: viewController.view];
	
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
    
	// cocos2d will inherit these values
	[window setUserInteractionEnabled:YES];
	
    // 游戏背景音乐和按钮音效
    SimpleAudioEngine* engin = [SimpleAudioEngine sharedEngine];
	[engin preloadBackgroundMusic:@"MenuBkMusic.caf"];
	[engin preloadEffect:@"ButtonClick.wav"];
	engin.backgroundMusicVolume = [m_dataManager realMusicVolume];
	engin.effectsVolume = [m_dataManager realSoundVolume];
    
    // 游戏数据初始化
    m_dataManager = [[IGGameDataManager alloc] init];
	m_dataManager.mainWindow = window;
	[m_dataManager load];
    
    // 菜单页面生成
	m_currentScene = [CCScene node];
	m_currentLayer = [[[IGGameMenuLayer alloc] initWithDataManagerWithAnimate:m_dataManager] autorelease];
	[m_currentLayer enterLayer];
	
    // 背景图片设置
	CCSprite *bg = [CCSprite spriteWithFile:@"bg.png"];
	bg.anchorPoint = ccp(0.0, 0.0);
	[m_currentScene addChild:bg];
	[m_currentScene addChild:m_currentLayer];
	
    [window makeKeyAndVisible];
	[[CCDirector sharedDirector] runWithScene:m_currentScene];

}


- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[m_currentLayer levelLayer:m_dataManager];
	[m_dataManager save];
	
	[[CCDirector sharedDirector] end];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[window release];
	[m_dataManager release];
	[[CCDirector sharedDirector] release];
	[super dealloc];
}


#pragma mark Main menu actions

// 切换游戏页面
- (void) switchStateLayer:(Class) state reverse:(bool)flag
{
	[m_currentLayer levelLayer:m_dataManager];
	IGGameStateLayer* layer = [[[state alloc] initWithDataManager:m_dataManager] autorelease];
	ReplaceLayerAction *replaceScreen = 
	[[[ReplaceLayerAction alloc] initWithScene:m_currentScene layer:layer replaceLayer:m_currentLayer] autorelease];
	replaceScreen.reverse = flag;
	[m_currentScene runAction:replaceScreen];
	
	m_currentLayer = layer;
	
}

// 排行榜
- (void) startGameScores:(bool)flag
{
	[self switchStateLayer:[IGGameScoresLayer class] reverse:flag];
}


// 游戏设置
- (void) startGameOptions:(bool)flag
{
	[self switchStateLayer:[IGGameOptionsLayer class] reverse:flag];
}

// 暂停
- (void) startGamePause:(bool)flag
{
	[self switchStateLayer:[IGGamePauseLayer class] reverse:flag];
}

// 帮助
- (void) startGameHelp:(bool)flag
{
	[self switchStateLayer:[IGGameHelpLayer class] reverse:flag];
}

// 主菜单
- (void) startMainMenu:(bool)flag
{
	[self switchStateLayer:[IGGameMenuLayer class] reverse:flag];
}

// 开始游戏
- (void) startStartNewGame:(bool)flag
{
	[self switchStateLayer:[IGGamePlayingLayer class] reverse:flag];
}

// 启动新游戏页面
- (void) startGameNew:(bool)flag
{
	[self switchStateLayer:[IGGameNewLayer class] reverse:flag];
}

// 游戏结束
- (void) startGameOver:(bool)flag
{
	[self switchStateLayer:[IGGameOverLayer class] reverse:flag];
}

@end
