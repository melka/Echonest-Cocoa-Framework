//
//  ENTrack.h
//  EchoNest
// 
// The Echo Nest API Objective-C library
// http://the.echonest.com/
// Copyright (C) 2009 melka - Kamel Makhloufi
// http://melka.one.free.fr/blog/

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.


#import <Foundation/Foundation.h>

@interface ENBar : NSObject {	
	float confidence;
	float time;
}
@property float confidence;
@property float time;
@end

@interface ENBeat : ENBar {
}
@end

@interface ENDuration : NSObject {
	float time;
}
@property float time;
@end

@interface ENEndOfFadeIn : ENDuration {
}
@end

@interface ENStartOfFadeOut : ENDuration {
}
@end

@interface ENKey : NSObject {
	float confidence;
	int key;
}
@property float confidence;
@property int key;
@end

@interface ENLoudness : NSObject {
	float loudness;
}
@property float loudness;
@end

@interface ENSegmentLoudness : ENLoudness {
	float startTime;
	NSString* type;
}
@property float startTime;
@property (nonatomic,retain) NSString* type;
@end

@interface ENMetadata : NSObject {
	NSString*	status;
	NSString*	artist;
	NSString*	album;
	NSString*	title;
	float			duration;
	float			samplerate;
	float			bitrate;
}
@property (nonatomic,retain) NSString* status;
@property (nonatomic,retain) NSString* artist;
@property (nonatomic,retain) NSString* album;
@property (nonatomic,retain) NSString* title;
@property float duration;
@property float samplerate;
@property float bitrate;
@end

@interface ENMode : NSObject {
	float confidence;
	int	mode;
}
@property float confidence;
@property int mode;
@end

@interface ENSection : NSObject {
	float startTime;
	float time;
}
@property float startTime;
@property float time;
@end

@interface ENSegment : ENSection {
	NSArray*					pitches;
	NSArray*					timbre;
	ENSegmentLoudness*	globalLoudness;
	ENSegmentLoudness*	maxLoudness;
}
@property (nonatomic,retain) ENSegmentLoudness* globalLoudness;
@property (nonatomic,retain) ENSegmentLoudness* maxLoudness;
@property (nonatomic,retain) NSArray*				pitches;
@property (nonatomic,retain) NSArray*				timbre;
@end

@interface ENTatum : ENBar {
}
@end

@interface ENTempo : NSObject {
	float confidence;
	float tempo;
}
@property float confidence;
@property float tempo;
@end

@interface ENTimeSignature : NSObject {
	float confidence;
	float signature;
}
@property float confidence;
@property float signature;
@end


@interface ENTrack : NSObject {
	// URL LOADING
	NSURLConnection*	trackBarsConnection;
	NSMutableData*		trackBarsData;
	NSMutableArray*	trackBars;
	ENBar*				currentBar;
	
	NSURLConnection*	trackBeatsConnection;
	NSMutableData*		trackBeatsData;
	NSMutableArray*	trackBeats;
	ENBeat*				currentBeat;
	
	NSURLConnection*	trackDurationConnection;
	NSMutableData*		trackDurationData;
	ENDuration*			trackDuration;
	
	NSURLConnection*	trackEndOfFadeInConnection;
	NSMutableData*		trackEndOfFadeInData;
	ENEndOfFadeIn*		trackEndOfFadeIn;
	
	NSURLConnection*	trackKeyConnection;
	NSMutableData*		trackKeyData;
	ENKey*				trackKey;
	
	NSURLConnection*	trackLoudnessConnection;
	NSMutableData*		trackLoudnessData;
	ENLoudness*			trackLoudness;
	
	NSURLConnection*	trackMetadataConnection;
	NSMutableData*		trackMetadataData;
	ENMetadata*			trackMetadata;
	
	NSURLConnection*	trackModeConnection;
	NSMutableData*		trackModeData;
	ENMode*				trackMode;
	
	NSURLConnection*	trackSectionsConnection;
	NSMutableData*		trackSectionsData;
	NSMutableArray*	trackSections;
	ENSection*			currentSection;
	
	NSURLConnection*	trackSegmentsConnection;
	NSMutableData*		trackSegmentsData;
	NSMutableArray*	trackSegments;
	NSMutableArray*	pitches;
	NSMutableArray*	timbre;
	NSString*			currentLoudnessType;
	ENSegmentLoudness* currentSegmentMaxLoudness;
	ENSegmentLoudness* currentSegmentLoudness;
	ENSegment*			currentSegment;
	
	NSURLConnection*	trackStartOfFadeOutConnection;
	NSMutableData*		trackStartOfFadeOutData;
	ENStartOfFadeOut*	trackStartOfFadeOut;
	
	NSURLConnection*	trackTatumsConnection;
	NSMutableData*		trackTatumsData;
	NSMutableArray*	trackTatums;
	ENTatum*				currentTatum;
	
	NSURLConnection*	trackTempoConnection;
	NSMutableData*		trackTempoData;
	ENTempo*				trackTempo;
	
	NSURLConnection*	trackTimeSignatureConnection;
	NSMutableData*		trackTimeSignatureData;
	ENTimeSignature*	trackTimeSignature;
	
	NSMutableURLRequest* req;
	
	NSXMLParser*		xmlParser;
	NSMutableString*	currentStringValue;
	NSString*			notificationName;
	NSDictionary*		success;
	
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
