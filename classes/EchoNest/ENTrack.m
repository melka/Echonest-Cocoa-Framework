//
//  ENTrack.m
//  EchoNest
//
//  Created by Kamel Makhloufi on 17/06/09.
//  Copyright 2009 melka. All rights reserved.
//

#import "ENTrack.h"

@implementation ENTrack

@synthesize apiKey;
@synthesize trackMD5;
@synthesize baseUrl;

- (id) initWithApiKey:(NSString*)apikey andTrackMD5:(NSString*)trackMd5 {
	self = [super init];
	if (self != nil) {
		[self setBaseUrl:@"http://developer.echonest.com/api/"];
		[self setApiKey:apikey];
		[self setTrackMD5:trackMd5];
		req = [[NSMutableURLRequest alloc] init];
		[req setHTTPMethod:@"GET"];
		[req setValue:@"EchoNestCocoaFramework/Alpha1" forHTTPHeaderField:@"User-Agent"];
		//NSLog(@"MD5 : %@",[self trackMD5]);
	}
	return self;
}

-(void) getBars {
	trackBarsData = [[NSMutableData alloc] init];
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@get_bars?api_key=%@&md5=%@&version=3",[self baseUrl],[self apiKey], [self trackMD5]]];
	[req setURL:url];
	trackBarsConnection = [NSURLConnection connectionWithRequest:req delegate:self];
}
-(void) getBeats {
	trackBeatsData = [[NSMutableData alloc] init];
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@get_beats?api_key=%@&md5=%@&version=3",[self baseUrl],[self apiKey], [self trackMD5]]];
	[req setURL:url];
	trackBeatsConnection = [NSURLConnection connectionWithRequest:req delegate:self];
}
-(void) getDuration {
	trackDurationData = [[NSMutableData alloc] init];
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@get_duration?api_key=%@&md5=%@&version=3",[self baseUrl],[self apiKey], [self trackMD5]]];
	[req setURL:url];
	trackDurationConnection = [NSURLConnection connectionWithRequest:req delegate:self];
}
-(void) getEndOfFadeIn {
	trackEndOfFadeInData = [[NSMutableData alloc] init];
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@get_end_of_fade_in?api_key=%@&md5=%@&version=3",[self baseUrl],[self apiKey], [self trackMD5]]];
	[req setURL:url];
	trackEndOfFadeInConnection = [NSURLConnection connectionWithRequest:req delegate:self];
}
-(void) getKey {
	trackKeyData = [[NSMutableData alloc] init];
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@get_key?api_key=%@&md5=%@&version=3",[self baseUrl],[self apiKey], [self trackMD5]]];
	[req setURL:url];
	trackKeyConnection = [NSURLConnection connectionWithRequest:req delegate:self];
}
-(void) getLoudness {
	trackLoudnessData = [[NSMutableData alloc] init];
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@get_loudness?api_key=%@&md5=%@&version=3",[self baseUrl],[self apiKey], [self trackMD5]]];
	[req setURL:url];
	trackLoudnessConnection = [NSURLConnection connectionWithRequest:req delegate:self];
}
-(void) getMetadata {
	trackMetadataData = [[NSMutableData alloc] init];
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@get_metadata?api_key=%@&md5=%@&version=3",[self baseUrl],[self apiKey], [self trackMD5]]];
	[req setURL:url];
	//NSLog(@"%@",[req allHTTPHeaderFields]);
	trackMetadataConnection = [NSURLConnection connectionWithRequest:req delegate:self];
}
-(void) getMode {
	trackModeData = [[NSMutableData alloc] init];
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@get_mode?api_key=%@&md5=%@&version=3",[self baseUrl],[self apiKey], [self trackMD5]]];
	[req setURL:url];
	trackModeConnection = [NSURLConnection connectionWithRequest:req delegate:self];
}
-(void) getSections {
	trackSectionsData = [[NSMutableData alloc] init];
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@get_sections?api_key=%@&md5=%@&version=3",[self baseUrl],[self apiKey], [self trackMD5]]];
	[req setURL:url];
	trackSectionsConnection = [NSURLConnection connectionWithRequest:req delegate:self];
}
-(void) getSegments {
	trackSegmentsData = [[NSMutableData alloc] init];
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@get_segments?api_key=%@&md5=%@&version=3",[self baseUrl],[self apiKey], [self trackMD5]]];
	[req setURL:url];
	trackSegmentsConnection = [NSURLConnection connectionWithRequest:req delegate:self];
}
-(void) getStartOfFadeOut {
	trackStartOfFadeOutData = [[NSMutableData alloc] init];
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@get_start_of_fade_out?api_key=%@&md5=%@&version=3",[self baseUrl],[self apiKey], [self trackMD5]]];
	[req setURL:url];
	trackStartOfFadeOutConnection = [NSURLConnection connectionWithRequest:req delegate:self];
}
-(void) getTatums {
	trackTatumsData = [[NSMutableData alloc] init];
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@get_tatums?api_key=%@&md5=%@&version=3",[self baseUrl],[self apiKey], [self trackMD5]]];
	[req setURL:url];
	trackTatumsConnection = [NSURLConnection connectionWithRequest:req delegate:self];
}
-(void) getTempo {
	trackTempoData = [[NSMutableData alloc] init];
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@get_tempo?api_key=%@&md5=%@&version=3",[self baseUrl],[self apiKey], [self trackMD5]]];
	[req setURL:url];
	trackTempoConnection = [NSURLConnection connectionWithRequest:req delegate:self];
}
-(void) getTimeSignature {
	trackTimeSignatureData = [[NSMutableData alloc] init];
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@get_time_signature?api_key=%@&md5=%@&version=3",[self baseUrl],[self apiKey], [self trackMD5]]];
	[req setURL:url];
	trackTimeSignatureConnection = [NSURLConnection connectionWithRequest:req delegate:self];
}

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response{
	
}
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	if ([connection isEqual:trackBarsConnection]) {
		[trackBarsData appendData:data];
	}
	if ([connection isEqual:trackBeatsConnection]) {
		[trackBeatsData appendData:data];
	}
	if ([connection isEqual:trackDurationConnection]) {
		[trackDurationData appendData:data];
	}
	if ([connection isEqual:trackEndOfFadeInConnection]) {
		[trackEndOfFadeInData appendData:data];
	}
	if ([connection isEqual:trackKeyConnection]) {
		[trackKeyData appendData:data];
	}
	if ([connection isEqual:trackLoudnessConnection]) {
		[trackLoudnessData appendData:data];
	}
	if ([connection isEqual:trackMetadataConnection]) {
		[trackMetadataData appendData:data];
	}
	if ([connection isEqual:trackModeConnection]) {
		[trackModeData appendData:data];
	}
	if ([connection isEqual:trackSectionsConnection]) {
		[trackSectionsData appendData:data];
	}
	if ([connection isEqual:trackSegmentsConnection]) {
		[trackSegmentsData appendData:data];
	}
	if ([connection isEqual:trackStartOfFadeOutConnection]) {
		[trackStartOfFadeOutData appendData:data];
	}
	if ([connection isEqual:trackTatumsConnection]) {
		[trackTatumsData appendData:data];
	}
	if ([connection isEqual:trackTempoConnection]) {
		[trackTempoData appendData:data];
	}
	if ([connection isEqual:trackTimeSignatureConnection]) {
		[trackTimeSignatureData appendData:data];
	}
}
-(void) connectionDidFinishLoading:(NSURLConnection *)connection {
	NSNotification* not;
	NSDictionary* success;
	NSString* notName;
	NSArray* xml;
	NSXMLDocument* xmlValid;
	
	if ([connection isEqual:trackBarsConnection]) {
		trackBars = [[NSXMLDocument alloc] initWithData:trackBarsData options:NSXMLDocumentTidyXML error:nil];
		xmlValid = trackBars;
		xml = [trackBars objectsForXQuery:@"for $p in .//response/analysis/bar\nreturn $p" error:nil];
		notName = @"ENTrackBarsLoaded";
	}
	if ([connection isEqual:trackBeatsConnection]) {
		trackBeats = [[NSXMLDocument alloc] initWithData:trackBeatsData options:NSXMLDocumentTidyXML error:nil];
		xmlValid = trackBeats;
		xml = [trackBeats objectsForXQuery:@"for $p in .//response/analysis/beat\nreturn $p" error:nil];
		notName = @"ENTrackBeatsLoaded";
	}
	if ([connection isEqual:trackDurationConnection]) {
		trackDuration = [[NSXMLDocument alloc] initWithData:trackDurationData options:NSXMLDocumentTidyXML error:nil];
		xmlValid = trackDuration;
		xml = [trackDuration objectsForXQuery:@"for $p in .//response/analysis/duration\nreturn $p" error:nil];
		notName = @"ENTrackDurationLoaded";
	}
	if ([connection isEqual:trackEndOfFadeInConnection]) {
		trackEndOfFadeIn = [[NSXMLDocument alloc] initWithData:trackEndOfFadeInData options:NSXMLDocumentTidyXML error:nil];
		xmlValid = trackEndOfFadeIn;
		xml = [trackEndOfFadeIn objectsForXQuery:@"for $p in .//response/analysis/end_of_fade_in\nreturn $p" error:nil];
		notName = @"ENTrackEndOfFadeInLoaded";
	}
	if ([connection isEqual:trackKeyConnection]) {
		trackKey = [[NSXMLDocument alloc] initWithData:trackKeyData options:NSXMLDocumentTidyXML error:nil];
		xmlValid = trackKey;
		xml = [trackKey objectsForXQuery:@"for $p in .//response/analysis/key\nreturn $p" error:nil];
		notName = @"ENTrackKeyLoaded";
	}
	if ([connection isEqual:trackLoudnessConnection]) {
		trackLoudness = [[NSXMLDocument alloc] initWithData:trackLoudnessData options:NSXMLDocumentTidyXML error:nil];
		xmlValid = trackLoudness;
		xml = [trackLoudness objectsForXQuery:@"for $p in .//response/analysis/loudness\nreturn $p" error:nil];
		notName = @"ENTrackLoudnessLoaded";
	}
	if ([connection isEqual:trackMetadataConnection]) {
		trackMetadata = [[NSXMLDocument alloc] initWithData:trackMetadataData options:NSXMLDocumentTidyXML error:nil];
		xmlValid = trackMetadata;
		xml = [trackMetadata objectsForXQuery:@"for $p in .//response/analysis/*\nreturn $p" error:nil];
		notName = @"ENTrackMetadataLoaded";
	}
	if ([connection isEqual:trackModeConnection]) {
		trackMode = [[NSXMLDocument alloc] initWithData:trackModeData options:NSXMLDocumentTidyXML error:nil];
		xmlValid = trackMode;
		xml = [trackMode objectsForXQuery:@"for $p in .//response/analysis/mode\nreturn $p" error:nil];
		notName = @"ENTrackModeLoaded";
	}
	if ([connection isEqual:trackSectionsConnection]) {
		trackSections = [[NSXMLDocument alloc] initWithData:trackSectionsData options:NSXMLDocumentTidyXML error:nil];
		xmlValid = trackSections;
		xml = [trackSections objectsForXQuery:@"for $p in .//response/analysis/section\nreturn $p" error:nil];
		notName = @"ENTrackSectionsLoaded";
	}
	if ([connection isEqual:trackSegmentsConnection]) {
		trackSegments = [[NSXMLDocument alloc] initWithData:trackSegmentsData options:NSXMLDocumentTidyXML error:nil];
		xmlValid = trackSegments;
		xml = [trackSegments objectsForXQuery:@"for $p in .//response/analysis/segment\nreturn $p" error:nil];
		notName = @"ENTrackSegmentsLoaded";
	}
	if ([connection isEqual:trackStartOfFadeOutConnection]) {
		trackStartOfFadeOut = [[NSXMLDocument alloc] initWithData:trackStartOfFadeOutData options:NSXMLDocumentTidyXML error:nil];
		xmlValid = trackStartOfFadeOut;
		xml = [trackStartOfFadeOut objectsForXQuery:@"for $p in .//response/analysis/start_of_fade_out\nreturn $p" error:nil];
		notName = @"ENTrackStartOfFadeOutLoaded";
	}
	if ([connection isEqual:trackTatumsConnection]) {
		trackTatums = [[NSXMLDocument alloc] initWithData:trackTatumsData options:NSXMLDocumentTidyXML error:nil];
		xmlValid = trackTatums;
		xml = [trackTatums objectsForXQuery:@"for $p in .//response/analysis/tatum\nreturn $p" error:nil];
		notName = @"ENTrackTatumsLoaded";
	}
	if ([connection isEqual:trackTempoConnection]) {
		trackTempo = [[NSXMLDocument alloc] initWithData:trackTempoData options:NSXMLDocumentTidyXML error:nil];
		xmlValid = trackTempo;
		xml = [trackTempo objectsForXQuery:@"for $p in .//response/analysis/tempo\nreturn $p" error:nil];
		notName = @"ENTrackTempoLoaded";
	}
	if ([connection isEqual:trackTimeSignatureConnection]) {
		trackTimeSignature = [[NSXMLDocument alloc] initWithData:trackTimeSignatureData options:NSXMLDocumentTidyXML error:nil];
		xmlValid = trackTimeSignature;
		xml = [trackTimeSignature objectsForXQuery:@"for $p in .//response/analysis/time_signature\nreturn $p" error:nil];
		notName = @"ENTrackTimeSignatureLoaded";
	}
	
	NSArray* valid = [xmlValid objectsForXQuery:@"for $p in .//response/status/message\nwhere $p/text()=\"Success\"return $p" error:nil];

	if ([valid count] == 1) {
		success = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]	forKey:[NSString stringWithString:@"success"]];
	} else {
		success = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]	forKey:[NSString stringWithString:@"success"]];
	}	
	not = [NSNotification notificationWithName:notName object:xml userInfo:success];
	[[NSNotificationCenter defaultCenter] postNotification:not];
}

@end
