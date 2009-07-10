#import <Cocoa/Cocoa.h>
#import <QTKit/QTKit.h>
#import "EchoNest/EchoNest.h"

@interface MyView : NSView {
	NSArray* sectionsData;
	NSArray* barsData;
	NSArray* beatsData;
	NSArray* tatumsData;
	ENEndOfFadeIn* fadeInData;
	ENStartOfFadeOut* fadeOutData;
	NSArray* segmentsData;
	NSString* attribute;
	QTMovie* sound;
	NSTimer* animationTimer;
	
	CGContextRef gc;
	
	CGLayerRef sections;
	CGLayerRef bars;
	CGLayerRef beats;
	CGLayerRef tatums;
	CGLayerRef fadeIn;	
	CGLayerRef fadeOut;
	CGLayerRef segments;
}

@property (nonatomic,retain) ENEndOfFadeIn*		fadeInData;
@property (nonatomic,retain) ENStartOfFadeOut*	fadeOutData;

-(void) setXmlData:(NSArray*)input forType:(NSString*)type;
-(void) drawGraphics;
-(void) drawLayers;
-(void) initSound:(NSString*)file;
-(IBAction) playSound:(id)sender;
-(IBAction) stopSound:(id)sender;
-(IBAction) pauseSound:(id)sender;
@end
