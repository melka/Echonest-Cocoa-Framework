//
//  EchoNest.h
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
#import "ENArtist.h"
#import "ENTrack.h"
#include <CommonCrypto/CommonDigest.h>
/**
 Base Class for dealing with the Echonest API
 */
@interface EchoNest : NSObject {
	// ARTIST
	ENArtist* artist;
	
	// TRACK
	ENTrack* track;
	
@private
	NSMutableURLRequest* req;
	NSNumber* success;
	
	// GENERAL
	NSURLConnection* apiKeyValidationConnection;
	NSMutableData* apiKeyValidationData;
	
	// CHARTS
	NSURLConnection* topHottArtistsConnection;
	NSMutableData* topHottArtistsData;
	NSURLConnection* topHottTracksConnection;
	NSMutableData* topHottTracksData;

	// SEARCH
	NSURLConnection* artistSearchConnection;
	NSMutableData* artistSearchData;
	NSURLConnection* trackSearchConnection;
	NSMutableData* trackSearchData;
	
	// TRACK UPLOAD
	NSURLConnection*	trackUploadConnection;
	NSMutableData*		trackUploadData;
	NSMutableData*		trackUploadResponseData;
	NSURLConnection*	trackUploadValidationConnection;
	NSMutableData*		trackUploadValidationData;
	
	// TEMP DATAS
	NSXMLParser*		xmlParser;
	NSMutableString*	currentStringValue;
	NSString*			notificationName;

	// VERIFICATION
	BOOL apiKeyIsValid;
	
	// EchoNest URL Parameters
	NSString* baseUrl;	// http://developer.echonest.com/api/;
	NSString* apiKey;		// Your API Key
	NSString* artistId;	// An Artist ID if known. Example Artist ID : music://id.echonest.com/~/AR/ARVXU2X1187B9AE6D8
	NSString* trackMD5;	// A Track ID if known. Example Track ID : music://id.echonest.com/~/TR/TRLFPPE11C3F10749F
	NSString* filePath;	// A Track ID if known. Example Track ID : music://id.echonest.com/~/TR/TRLFPPE11C3F10749F
}

@property (nonatomic, retain) NSString*	apiKey;
@property (nonatomic, retain) NSString*	artistId;
@property (nonatomic, retain) NSString*	trackMD5;
@property (nonatomic, retain) NSString*	baseUrl;
@property (nonatomic, retain) NSString*	filePath;

-(id) initWithAPIKey:(NSString*)APIKey andArtistID:(NSString*)artistID andTrackMD5:(NSString*)trackMD5;
-(id) initWithAPIKey:(NSString*)APIKey andArtistID:(NSString*)artistID;
-(id) initWithAPIKey:(NSString*)APIKey;
-(id) init;
-(void) validateApiKey;
-(void) searchArtistWithString:(NSString*)input;
-(void) searchTracksWithString:(NSString*)input;
-(void) initializeArtist;
-(void) initializeTrack;
-(void) uploadFile:(NSString*)path;
-(void) uploadData;
-(void) uploadURL:(NSString*)url;

-(ENArtist*)artist;
-(ENTrack*)track;

-(NSString *) urlencode: (NSString *) url;
-(NSString*) md5:(NSData*)data;

@end
