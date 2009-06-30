#import <Cocoa/Cocoa.h>
#import <QTKit/QTKit.h>

@interface MyView : NSView {
	NSArray* sectionsData;
	NSArray* barsData;
	NSArray* beatsData;
	NSArray* tatumsData;
	NSArray* fadeInData;
	NSArray* fadeOutData;
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

-(void) setXmlData:(NSArray*)input forType:(NSString*)type;
-(void) drawGraphics;
-(void) drawLayers;
-(void) initSound:(NSString*)file;
-(IBAction) playSound:(id)sender;
-(IBAction) stopSound:(id)sender;
-(IBAction) pauseSound:(id)sender;
@end
