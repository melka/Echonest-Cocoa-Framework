#import "MyView.h"

@implementation MyView

- (id)initWithFrame:(NSRect)rect
{
	self = [super initWithFrame:rect];
	return self;
}

-(void) initSound:(NSString*)file {
	[sound stop];
	[sound release];
	sound = [[QTMovie alloc] initWithURL:[NSURL fileURLWithPath:file] error:nil];
	[sound gotoBeginning];
	[sound play];
}

-(void) awakeFromNib {
	[[self window] setDelegate:self];
}

- (void)mouseUp:(NSEvent *)e {
	NSPoint l = [e locationInWindow];
	NSRect f = [self frame];
	NSSize s = f.size;
	QTTime duration = [sound duration];
	QTTime t = QTMakeTime(duration.timeValue/s.width*l.x,duration.timeScale);
	[sound setCurrentTime:t];
}

-(BOOL) isOpaque {
	return NO;
}

-(void) setXmlData:(NSArray*)input forType:(NSString*)type {
	if (type == @"sections") {
		[sectionsData autorelease];
		sectionsData = [input retain];
	}
	if (type == @"bars") {
		[barsData autorelease];
		barsData = [input retain];
	}
	if (type == @"beats") {
		[beatsData autorelease];
		beatsData = [input retain];
	}
	if (type == @"tatums") {
		[tatumsData autorelease];
		tatumsData = [input retain];
	}
	if (type == @"fadeIn") {
		[fadeInData autorelease];
		fadeInData = [input retain];
	}
	if (type == @"fadeOut") {
		[fadeOutData autorelease];
		fadeOutData = [input retain];
	}
	if (type == @"segments") {
		[segmentsData autorelease];
		segmentsData = [input retain];
		NSLog(@"SEGMENTS LOADED");
	}
	[self drawGraphics];
}

- (void)windowDidResize:(NSNotification *)notification {
	[self drawGraphics];
}

-(IBAction) playSound:(id)sender {
	[sound play];
}

-(IBAction) stopSound:(id)sender {
	[sound stop];
	[sound gotoBeginning];
}

-(IBAction) pauseSound:(id)sender {
	[sound stop];
}

-(void) drawRect:(NSRect)rect {
	if ( !animationTimer)
		animationTimer=[ [ NSTimer scheduledTimerWithTimeInterval:(1.0/60.0) target:self selector:@selector(animationTimerFired:) userInfo:nil repeats:YES ] retain ] ;

	[self drawLayers];
	
	NSRect f = [self frame];
	NSSize s = f.size;
	float width = s.width;
	QTTime duration = [sound duration];
	float d = ((float)duration.timeValue/(float)duration.timeScale);
	float scale = width/d;
	
	// TRACKBAR DRAWING
	QTTime t = [sound currentTime];
	float currentTime = ((float)t.timeValue/(float)t.timeScale);
	
	[[NSColor whiteColor] set];
	NSBezierPath* path = [NSBezierPath bezierPath];
	[path setLineWidth:1];
	[path moveToPoint:NSMakePoint(currentTime*scale, 0)];
	[path lineToPoint:NSMakePoint(currentTime*scale, s.height)];
	[path stroke];
	
	NSBezierPath* triangle = [NSBezierPath bezierPath];
	[triangle setLineWidth:0];
	[triangle moveToPoint:NSMakePoint(currentTime*scale, s.height-7)];
	[triangle lineToPoint:NSMakePoint(currentTime*scale-7, s.height-2)];
	[triangle lineToPoint:NSMakePoint(currentTime*scale-7, s.height-12)];
	[triangle lineToPoint:NSMakePoint(currentTime*scale, s.height-7)];
	[triangle fill];
}

-(void) drawLayers {
	NSRect f = [self frame];
	NSSize s = f.size;
	gc = [[NSGraphicsContext currentContext] graphicsPort];	
	CGContextDrawLayerAtPoint(gc, CGPointZero, sections);
	//CGContextDrawLayerAtPoint(gc, CGPointZero, segments);
	CGContextDrawLayerAtPoint(gc, CGPointZero, bars);
	CGContextDrawLayerAtPoint(gc, CGPointMake(0, s.height/3), beats);
	CGContextDrawLayerAtPoint(gc, CGPointMake(0, 2*s.height/3), tatums);
	CGContextDrawLayerAtPoint(gc, CGPointZero, fadeIn);
	CGContextDrawLayerAtPoint(gc, CGPointZero, fadeOut);
}

-(void) drawGraphics {
	/* 
	 All the XML parsing and drawing are done here.
	 This way, you just have to redraw the view when new XML
	 data arrives or when the view is resized. Much more faster
	 than drawing directly in the drawRect method.	 
	*/
		
	// SCALE OF THE DRAWINGS
	NSRect f = [self frame];
	NSSize s = f.size;
	float width = s.width;
	QTTime duration = [sound duration];
	float d = ((float)duration.timeValue/(float)duration.timeScale);
	float scale = width/d;
	// CURRENT POSITION IN SOUND
	//QTTime t = [sound currentTime];
	//float currentTime = ((float)t.timeValue/(float)t.timeScale);
		
	float dT = 0;
	int i;

	if ([sectionsData count] != 0) {
		sections = CGLayerCreateWithContext(gc, CGSizeMake(s.width,s.height), NULL);
		CGContextRef ref = CGLayerGetContext(sections);
		for (i = 0; i<[sectionsData count];i++) {
			if (i%2 == 0) {
				CGContextSetRGBFillColor(ref,1,1,1,.5);
			} else {
				CGContextSetRGBFillColor(ref,.5,.5,.5,.5);
			}		
			float start = [[[[sectionsData objectAtIndex:i] attributeForName:@"start"] stringValue] floatValue];
			float time = [[[[sectionsData objectAtIndex:i] attributeForName:@"duration"] stringValue] floatValue];
			CGRect r = CGRectMake(start*scale,0,time*scale,s.height);
			CGContextFillRect(ref,r);
		}
	}
	if ([segmentsData count] != 0) {
		sections = CGLayerCreateWithContext(gc, CGSizeMake(s.width,s.height), NULL);
		CGContextRef ref = CGLayerGetContext(sections);
		for (i = 0; i<[segmentsData count];i++) {
			if (i%2 == 0) {
				CGContextSetRGBFillColor(ref,1,1,1,.5);
			} else {
				CGContextSetRGBFillColor(ref,.5,.5,.5,.5);
			}
			float start = [[[[segmentsData objectAtIndex:i] attributeForName:@"start"] stringValue] floatValue];
			float time = [[[[segmentsData objectAtIndex:i] attributeForName:@"duration"] stringValue] floatValue];
			CGRect r = CGRectMake(start*scale,0,time*scale,s.height);
			CGContextFillRect(ref,r);
		}
	}	

	if ([fadeInData count] != 0) {
		fadeIn = CGLayerCreateWithContext(gc, CGSizeMake(s.width,s.height), NULL);
		CGContextRef ref = CGLayerGetContext(fadeIn);
		float time = [[[fadeInData objectAtIndex:0] stringValue] floatValue];
		CGContextSetLineWidth(ref, 1);
		CGContextSetStrokeColorWithColor(ref, CGColorCreateGenericRGB(1, 1, 1, 1));
		CGContextBeginPath(ref);
		CGContextMoveToPoint(ref, 0, 0);
		CGContextAddCurveToPoint(ref, time/2*scale, 0, time/2*scale, s.height/2, time*scale, s.height/2);
		CGContextAddLineToPoint(ref, s.width/2, s.height/2);
		CGContextStrokePath(ref);
	}
	if ([fadeOutData count] != 0) {
		fadeOut = CGLayerCreateWithContext(gc, CGSizeMake(s.width,s.height), NULL);
		CGContextRef ref = CGLayerGetContext(fadeOut);
		float time = [[[fadeOutData objectAtIndex:0] stringValue] floatValue];
		CGContextSetLineWidth(ref, 1);
		CGContextSetStrokeColorWithColor(ref, CGColorCreateGenericRGB(1, 1, 1, 1));
		CGContextBeginPath(ref);
		CGContextMoveToPoint(ref, s.width/2, s.height/2);
		CGContextAddLineToPoint(ref, time*scale, s.height/2);
		CGContextAddCurveToPoint(ref, time*scale+(s.width-time*scale)/2, s.height/2, time*scale+(s.width-time*scale)/2, 0, s.width, 0);
		CGContextStrokePath(ref);
	}
	
	if ([barsData count] != 0) {
		bars = CGLayerCreateWithContext(gc, CGSizeMake(s.width,s.height/3), NULL);
		CGContextRef ref = CGLayerGetContext(bars);
		for (i = 0; i<[barsData count];i++) {
			float confidence = [[[[barsData objectAtIndex:i] attributeForName:@"confidence"] stringValue] floatValue];
			float time = [[[barsData objectAtIndex:i] stringValue] floatValue];
			/*if (currentTime <= time && currentTime > [[[barsData objectAtIndex:i-1] stringValue] floatValue]) {
				CGRect r = CGRectMake(dT*scale,0,(time-dT)*scale,s.height/3);
				CGContextSetRGBFillColor(ref,confidence,confidence,confidence,.4);
				//NSColor* bg = [NSColor colorWithCalibratedHue:confidence saturation:.5 brightness:1 alpha:.4];
				CGContextFillRect(ref, r);
			}*/
			
			CGRect r = CGRectMake(dT*scale,0,(time-dT)*scale,confidence*(s.height/3));
			
			NSColor* hsbStartColor = [NSColor colorWithCalibratedHue:confidence saturation:.8 brightness:.6 alpha:1];
			NSColor* rgbStartColor = [hsbStartColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
			CGFloat red1,green1,blue1,alpha1;
			[rgbStartColor getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
			
			NSColor* hsbEndColor = [NSColor colorWithCalibratedHue:confidence saturation:.8 brightness:1 alpha:1];
			NSColor* rgbEndColor = [hsbEndColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
			CGFloat red2,green2,blue2,alpha2;
			[rgbEndColor getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
			
			CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
			CGFloat colors[] = {
				red1,	green1,	blue1,	alpha1,
				red2,	green2,	blue2,	alpha2,
			};
			CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
			CGColorSpaceRelease(rgb);
			
			CGPoint start, end;

			CGContextSaveGState(ref);
			CGContextClipToRect(ref, r);
			start = CGPointMake(r.origin.x, 0);
			end = CGPointMake(r.origin.x, r.size.height);
			CGContextDrawLinearGradient(ref, gradient, start, end, kCGGradientDrawsBeforeStartLocation);
			CGContextRestoreGState(ref);
			
			dT = time;
		}
	}
	dT = 0;
	if ([beatsData count] != 0) {
		beats = CGLayerCreateWithContext(gc, CGSizeMake(s.width,s.height/3), NULL);
		CGContextRef ref = CGLayerGetContext(beats);
		for (i = 0; i<[beatsData count];i++) {
			float confidence = [[[[beatsData objectAtIndex:i] attributeForName:@"confidence"] stringValue] floatValue];
			float time = [[[beatsData objectAtIndex:i] stringValue] floatValue];			
			/*if (currentTime <= time && currentTime > [[[beatsData objectAtIndex:i-1] stringValue] floatValue]) {
				CGRect r = CGRectMake(dT*scale,0,(time-dT)*scale,(s.height/3));
				CGContextSetRGBFillColor(ref,confidence,confidence,confidence,.4);
				CGContextFillRect(ref,r);
			}*/
			CGRect r = CGRectMake(dT*scale,0,(time-dT)*scale,confidence*(s.height/3));
			NSColor* hsbStartColor = [NSColor colorWithCalibratedHue:confidence saturation:.8 brightness:.6 alpha:1];
			NSColor* rgbStartColor = [hsbStartColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
			CGFloat red1,green1,blue1,alpha1;
			[rgbStartColor getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
			
			NSColor* hsbEndColor = [NSColor colorWithCalibratedHue:confidence saturation:.8 brightness:1 alpha:1];
			NSColor* rgbEndColor = [hsbEndColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
			CGFloat red2,green2,blue2,alpha2;
			[rgbEndColor getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
			
			CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
			CGFloat colors[] = {
				red1,	green1,	blue1,	alpha1,
				red2,	green2,	blue2,	alpha2,
			};
			CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
			CGColorSpaceRelease(rgb);
			
			CGPoint start, end;	
			
			CGContextSaveGState(ref);
			CGContextClipToRect(ref, r);
			start = CGPointMake(r.origin.x, 0);
			end = CGPointMake(r.origin.x, r.size.height);
			CGContextDrawLinearGradient(ref, gradient, start, end, kCGGradientDrawsBeforeStartLocation);
			CGContextRestoreGState(ref);
			dT = time;
		}
	}	
	
	dT = 0;
	if ([tatumsData count] != 0) {
		tatums = CGLayerCreateWithContext(gc, CGSizeMake(s.width,s.height/3), NULL);
		CGContextRef ref = CGLayerGetContext(tatums);
		for (i = 0; i<[tatumsData count];i++) {
			float confidence = [[[[tatumsData objectAtIndex:i] attributeForName:@"confidence"] stringValue] floatValue];
			float time = [[[tatumsData objectAtIndex:i] stringValue] floatValue];
			/*if (currentTime <= time && currentTime > [[[tatumsData objectAtIndex:i-1] stringValue] floatValue]) {
				CGRect r = CGRectMake(dT*scale,0,(time-dT)*scale,(s.height/3));
				CGContextSetRGBFillColor(ref,confidence,confidence,confidence,.4);
				CGContextFillRect(ref,r);
			}*/
			CGRect r = CGRectMake(dT*scale,0,(time-dT)*scale,confidence*(s.height/3));
			NSColor* hsbStartColor = [NSColor colorWithCalibratedHue:confidence saturation:.8 brightness:.6 alpha:1];
			NSColor* rgbStartColor = [hsbStartColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
			CGFloat red1,green1,blue1,alpha1;
			[rgbStartColor getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
			
			NSColor* hsbEndColor = [NSColor colorWithCalibratedHue:confidence saturation:.8 brightness:1 alpha:1];
			NSColor* rgbEndColor = [hsbEndColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
			CGFloat red2,green2,blue2,alpha2;
			[rgbEndColor getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
			
			CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
			CGFloat colors[] = {
				red1,	green1,	blue1,	alpha1,
				red2,	green2,	blue2,	alpha2,
			};
			CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
			CGColorSpaceRelease(rgb);
			
			CGPoint start, end;	
			
			CGContextSaveGState(ref);
			CGContextClipToRect(ref, r);
			start = CGPointMake(r.origin.x, 0);
			end = CGPointMake(r.origin.x, r.size.height);
			CGContextDrawLinearGradient(ref, gradient, start, end, kCGGradientDrawsBeforeStartLocation);
			CGContextRestoreGState(ref);
			dT = time;
		}
	}
}

- (void) animationTimerFired: (NSTimer *)timer {
	[self setNeedsDisplay: YES];
}

@end
