#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "EchoNest.h"

@interface MyUIView : UIView {
	NSArray* sectionsData;
	NSArray* barsData;
	NSArray* beatsData;
	NSArray* tatumsData;
	ENEndOfFadeIn* fadeInData;
	ENStartOfFadeOut* fadeOutData;
	NSArray* segmentsData;
	NSString* attribute;
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

@end
