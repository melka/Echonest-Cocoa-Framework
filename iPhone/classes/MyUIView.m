#import "MyUIView.h"

@implementation MyUIView

@synthesize duration;
@synthesize fadeInData;
@synthesize fadeOutData;

float contentLength;
float percentage;

#pragma mark AUDIO LOADING & PLAYBACK
-(void)loadDistantMP3:(NSString*)url {
	mp3data = [[NSMutableData alloc] init];
	NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
	[NSURLConnection connectionWithRequest:req delegate:self];
	[progressBar setProgress:0];
}

-(void)loadLocalMP3:(NSString*)filePath {
	player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:nil];
	[player setDelegate:self];
	[progressBar setHidden:YES];
}

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {
	contentLength = (float)[response expectedContentLength];
}
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[mp3data appendData:data];
	percentage = ((float)[mp3data length])/contentLength*100;
	[progressBar setProgress:(percentage/100)];
}
-(void) connectionDidFinishLoading:(NSURLConnection *)connection {
	player = [[AVAudioPlayer alloc] initWithData:mp3data error:nil];
	[player setDelegate:self];
	[progressBar setHidden:YES];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {}
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{}
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player {}

-(void) setXmlData:(NSArray*)input forType:(NSString*)type {
	if ([player currentTime] == 0) {
		[player play];
	}
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
	if (type == @"segments") {
		[segmentsData autorelease];
		segmentsData = [input retain];
	}
	[self drawGraphics];
}

-(void) drawRect:(CGRect)rect {
	if ( !animationTimer)
		animationTimer=[ [ NSTimer scheduledTimerWithTimeInterval:(1.0/60.0) target:self selector:@selector(animationTimerFired:) userInfo:nil repeats:YES ] retain ] ;
	[self drawLayers];
	
	CGRect f = [self frame];
	CGSize s = f.size;
	float width = s.width;
	float scale = 1;
	if (duration) {
		scale = width/duration;
	}	
	// TRACKBAR DRAWING
	float currentTime = [player currentTime];
	CGContextRef ref = UIGraphicsGetCurrentContext();
	
	CGContextSetLineWidth(ref, 1);
	CGContextSetRGBStrokeColor(ref, 0, 0, 0, 1);
	CGContextBeginPath(ref);
	CGContextMoveToPoint(ref, currentTime*scale, 0);
	CGContextAddLineToPoint(ref, currentTime*scale, s.height);
	CGContextStrokePath(ref);
}

-(void) drawLayers {
	CGRect f = [self frame];
	CGSize s = f.size;
	gc = UIGraphicsGetCurrentContext();	
	CGContextDrawLayerAtPoint(gc, CGPointZero, sections);
	CGContextDrawLayerAtPoint(gc, CGPointZero, segments);
	CGContextDrawLayerAtPoint(gc, CGPointZero, tatums);
	CGContextDrawLayerAtPoint(gc, CGPointMake(0, s.height/3), beats);
	CGContextDrawLayerAtPoint(gc, CGPointMake(0, 2*s.height/3), bars);
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
	CGRect f = [self frame];
	CGSize s = f.size;
	float width = s.width;
	float scale = 1;
	if (duration) {
		scale = width/duration;
	}	
	float dT = 0;
	int i;
	
	if ([sectionsData count] != 0) {
		sections = CGLayerCreateWithContext(gc, CGSizeMake(s.width,s.height), NULL);
		CGContextRef ref = CGLayerGetContext(sections);
		for (i = 0; i<[sectionsData count];i++) {
			if (i%2 == 0) {
				CGContextSetRGBFillColor(ref,1,1,1,.5);
			} else {
				CGContextSetRGBFillColor(ref,.8,.8,.8,.5);
			}		
			float start = [[sectionsData objectAtIndex:i] startTime];
			float time = [[sectionsData objectAtIndex:i] time];
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
			float start = [[segmentsData objectAtIndex:i] startTime];
			float time = [[segmentsData objectAtIndex:i] time];
			CGRect r = CGRectMake(start*scale,0,time*scale,s.height);
			CGContextFillRect(ref,r);
		}
	}	
	
	if ([fadeInData time] != -1) {
		fadeIn = CGLayerCreateWithContext(gc, CGSizeMake(s.width,s.height), NULL);
		CGContextRef ref = CGLayerGetContext(fadeIn);
		float time = [fadeInData time];
		CGContextSetLineWidth(ref, 1);
		CGContextSetRGBStrokeColor(ref, 1, 1, 1, 1);
		CGContextBeginPath(ref);
		CGContextMoveToPoint(ref, 0, s.height);
		CGContextAddCurveToPoint(ref, time/2*scale, s.height, time/2*scale, s.height/2, time*scale, s.height/2);
		CGContextAddLineToPoint(ref, s.width/2, s.height/2);
		CGContextStrokePath(ref);
	}
	if ([fadeOutData time] != -1) {
		fadeOut = CGLayerCreateWithContext(gc, CGSizeMake(s.width,s.height), NULL);
		CGContextRef ref = CGLayerGetContext(fadeOut);
		float time = [fadeOutData time];
		CGContextSetLineWidth(ref, 1);
		CGContextSetRGBStrokeColor(ref, 1, 1, 1, 1);
		CGContextBeginPath(ref);
		CGContextMoveToPoint(ref, s.width/2, s.height/2);
		CGContextAddLineToPoint(ref, time*scale, s.height/2);
		CGContextAddCurveToPoint(ref, time*scale+(s.width-time*scale)/2, s.height/2, time*scale+(s.width-time*scale)/2, s.height, s.width, s.height);
		CGContextStrokePath(ref);
	}
	
	if ([barsData count] != 0) {
		bars = CGLayerCreateWithContext(gc, CGSizeMake(s.width,s.height/3), NULL);
		CGContextRef ref = CGLayerGetContext(bars);
		for (i = 0; i<[barsData count];i++) {
			float confidence = [[barsData objectAtIndex:i] confidence];
			float time = [[barsData objectAtIndex:i] time];

			CGRect r = CGRectMake(dT*scale,(s.height/3)-confidence*(s.height/3),(time-dT)*scale,(s.height/3));
			
			UIColor* hsbStartColor = [UIColor colorWithHue:confidence saturation:.8 brightness:.6 alpha:1];
			CGColorRef rgbStartColor = [hsbStartColor CGColor];
			const CGFloat * startColors = CGColorGetComponents(rgbStartColor);
			
			UIColor* hsbEndColor = [UIColor colorWithHue:confidence saturation:.8 brightness:1 alpha:1];
			CGColorRef rgbEndColor = [hsbEndColor CGColor];
			const CGFloat * endColors = CGColorGetComponents(rgbEndColor);

			CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
			CGFloat colors[] = {
				startColors[0],	startColors[1],	startColors[2],	startColors[3],
				endColors[0],	endColors[1],	endColors[2],	endColors[3],
			};
			CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
			CGColorSpaceRelease(rgb);
			
			CGPoint start, end;
			
			CGContextSaveGState(ref);
			CGContextClipToRect(ref, r);
			end = CGPointMake(r.origin.x, 0);
			start = CGPointMake(r.origin.x, r.size.height);
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
			float confidence = [[beatsData objectAtIndex:i] confidence];
			float time = [[beatsData objectAtIndex:i] time];
			
			CGRect r = CGRectMake(dT*scale,(s.height/3)-confidence*(s.height/3),(time-dT)*scale,(s.height/3));
			
			UIColor* hsbStartColor = [UIColor colorWithHue:confidence saturation:.8 brightness:.6 alpha:1];
			CGColorRef rgbStartColor = [hsbStartColor CGColor];
			const CGFloat * startColors = CGColorGetComponents(rgbStartColor);
			
			UIColor* hsbEndColor = [UIColor colorWithHue:confidence saturation:.8 brightness:1 alpha:1];
			CGColorRef rgbEndColor = [hsbEndColor CGColor];
			const CGFloat * endColors = CGColorGetComponents(rgbEndColor);
			
			CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
			CGFloat colors[] = {
				startColors[0],	startColors[1],	startColors[2],	startColors[3],
				endColors[0],	endColors[1],	endColors[2],	endColors[3],
			};
			CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
			CGColorSpaceRelease(rgb);
			
			CGPoint start, end;	
			
			CGContextSaveGState(ref);
			CGContextClipToRect(ref, r);
			end = CGPointMake(r.origin.x, 0);
			start = CGPointMake(r.origin.x, r.size.height);
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
			float confidence = [[tatumsData objectAtIndex:i] confidence];
			float time = [[tatumsData objectAtIndex:i] time];
			
			CGRect r = CGRectMake(dT*scale,(s.height/3)-confidence*(s.height/3),(time-dT)*scale,(s.height/3));
			
			UIColor* hsbStartColor = [UIColor colorWithHue:confidence saturation:.8 brightness:.6 alpha:1];
			CGColorRef rgbStartColor = [hsbStartColor CGColor];
			const CGFloat * startColors = CGColorGetComponents(rgbStartColor);
			
			UIColor* hsbEndColor = [UIColor colorWithHue:confidence saturation:.8 brightness:1 alpha:1];
			CGColorRef rgbEndColor = [hsbEndColor CGColor];
			const CGFloat * endColors = CGColorGetComponents(rgbEndColor);
			
			CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
			CGFloat colors[] = {
				startColors[0],	startColors[1],	startColors[2],	startColors[3],
				endColors[0],	endColors[1],	endColors[2],	endColors[3],
			};
			CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
			CGColorSpaceRelease(rgb);
			
			CGPoint start, end;	
			
			CGContextSaveGState(ref);
			CGContextClipToRect(ref, r);
			end = CGPointMake(r.origin.x, 0);
			start = CGPointMake(r.origin.x, r.size.height);
			CGContextDrawLinearGradient(ref, gradient, start, end, kCGGradientDrawsBeforeStartLocation);
			CGContextRestoreGState(ref);
			dT = time;
		}
	}
}

- (void) animationTimerFired: (NSTimer *)timer {
	[self setNeedsDisplay];
}


@end
