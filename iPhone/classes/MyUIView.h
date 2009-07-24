#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "EchoNest.h"

@interface MyUIView : UIView <AVAudioPlayerDelegate> {
	NSArray* sectionsData;
	NSArray* barsData;
	NSArray* beatsData;
	NSArray* tatumsData;
	ENEndOfFadeIn* fadeInData;
	ENStartOfFadeOut* fadeOutData;
	NSArray* segmentsData;
	NSString* attribute;
	NSTimer* animationTimer;
	
	float duration;
	
	CGContextRef gc;
	
	CGLayerRef sections;
	CGLayerRef bars;
	CGLayerRef beats;
	CGLayerRef tatums;
	CGLayerRef fadeIn;	
	CGLayerRef fadeOut;
	CGLayerRef segments;
	
	AVAudioPlayer* player;
	NSMutableData* mp3data;
	
	IBOutlet id progressBar;
}

@property float duration;
@property (nonatomic,retain) ENEndOfFadeIn*		fadeInData;
@property (nonatomic,retain) ENStartOfFadeOut*	fadeOutData;
-(void)loadDistantMP3:(NSString*)url;
-(void)loadLocalMP3:(NSString*)filePath;
-(void) setXmlData:(NSArray*)input forType:(NSString*)type;
-(void) drawGraphics;
-(void) drawLayers;

@end
