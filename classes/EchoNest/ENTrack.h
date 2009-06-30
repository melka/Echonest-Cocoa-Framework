//
//  ENTrack.h
//  EchoNest
//
//  Created by Kamel Makhloufi on 17/06/09.
//  Copyright 2009 melka. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ENTrack : NSObject {
	// URL LOADING
	NSURLConnection*	trackBarsConnection;
	NSMutableData*		trackBarsData;
	NSXMLDocument*		trackBars;
	NSURLConnection*	trackBeatsConnection;
	NSMutableData*		trackBeatsData;
	NSXMLDocument*		trackBeats;
	NSURLConnection*	trackDurationConnection;
	NSMutableData*		trackDurationData;
	NSXMLDocument*		trackDuration;
	NSURLConnection*	trackEndOfFadeInConnection;
	NSMutableData*		trackEndOfFadeInData;
	NSXMLDocument*		trackEndOfFadeIn;
	NSURLConnection*	trackKeyConnection;
	NSMutableData*		trackKeyData;
	NSXMLDocument*		trackKey;
	NSURLConnection*	trackLoudnessConnection;
	NSMutableData*		trackLoudnessData;
	NSXMLDocument*		trackLoudness;
	NSURLConnection*	trackMetadataConnection;
	NSMutableData*		trackMetadataData;
	NSXMLDocument*		trackMetadata;
	NSURLConnection*	trackModeConnection;
	NSMutableData*		trackModeData;
	NSXMLDocument*		trackMode;
	NSURLConnection*	trackSectionsConnection;
	NSMutableData*		trackSectionsData;
	NSXMLDocument*		trackSections;
	NSURLConnection*	trackSegmentsConnection;
	NSMutableData*		trackSegmentsData;
	NSXMLDocument*		trackSegments;
	NSURLConnection*	trackStartOfFadeOutConnection;
	NSMutableData*		trackStartOfFadeOutData;
	NSXMLDocument*		trackStartOfFadeOut;
	NSURLConnection*	trackTatumsConnection;
	NSMutableData*		trackTatumsData;
	NSXMLDocument*		trackTatums;
	NSURLConnection*	trackTempoConnection;
	NSMutableData*		trackTempoData;
	NSXMLDocument*		trackTempo;
	NSURLConnection*	trackTimeSignatureConnection;
	NSMutableData*		trackTimeSignatureData;
	NSXMLDocument*		trackTimeSignature;
	
	NSMutableURLRequest* req;
	
	// EchoNest URL Parameters
	NSString* baseUrl;	// http://developer.echonest.com/api/;
	NSString* apiKey;		// Your API Key
	NSString* trackMD5;	// A Track MD5 if known.
}

@property (nonatomic, retain) NSString*	apiKey;
@property (nonatomic, retain) NSString*	trackMD5;
@property (nonatomic, retain) NSString*	baseUrl;

-(id) initWithApiKey:(NSString*)apikey andTrackMD5:(NSString*)trackMd5;

-(void) getBars;
-(void) getBeats;
-(void) getDuration;
-(void) getEndOfFadeIn;
-(void) getKey;
-(void) getLoudness;
-(void) getMetadata;
-(void) getMode;
-(void) getSections;
-(void) getSegments;
-(void) getStartOfFadeOut;
-(void) getTatums;
-(void) getTempo;
-(void) getTimeSignature;

@end
