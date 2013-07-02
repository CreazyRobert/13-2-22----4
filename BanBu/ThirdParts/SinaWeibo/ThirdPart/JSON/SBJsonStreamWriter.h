/*
 Copyright (c) 2010, Stig Brautaset.
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are
 met:
 
   Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
  
   Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
 
   Neither the name of the the author nor the names of its contributors
   may be used to endorse or promote products derived from this software
   without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
 IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <Foundation/Foundation.h>

@class SBJsonStreamWriterState;

/**
 @brief The Stream Writer class.
 
 SBJsonStreamWriter accepts various messages and writes JSON text to an
 NSOutputStream designated at iniatilisation time. 
 
 A range of high-, mid- and low-level methods. You can mix and match calls
 to these. For example, you may want to call -writeArrayOpen to start an
 array and then repeatedly call -writeObject: with an object.
 
 In JSON the keys of an object must be strings. NSDictionary keys need
 not be, but attempting to convert an NSDictionary with non-string keys
 into JSON will result in an error.
 
 NSNumber instances created with the +initWithBool: method are
 converted into the JSON boolean "true" and "false" values, and vice
 versa. Any other NSNumber instances are converted to a JSON number the
 way you would expect.
 
 */

@interface SBJsonStreamWriter : NSObject {
@private
	NSString *error;
	SBJsonStreamWriterState **states;
	NSOutputStream *stream;
	NSUInteger depth, maxDepth;
    BOOL sortKeys, humanReadable;
}

/**
 @brief The maximum recursing depth.
 
 Defaults to 512. If the input is nested deeper than this the input will be deemed to be
 malicious and the parser returns nil, signalling an error. ("Nested too deep".) You can
 turn off this security feature by setting the maxDepth value to 0.
 */
@property (nonatomic)NSUInteger maxDepth;

/**
 @brief Whether we are generating human-readable (multiline) JSON.
 
 Set whether or not to generate human-readable JSON. The default is NO, which produces
 JSON without any whitespace between tokens. If set to YES, generates human-readable
 JSON with linebreaks after each array value and dictionary key/value pair, indented two
 spaces per nesting level.
 */
@property BOOL humanReadable;

/**
 @brief Whether or not to sort the dictionary keys in the output.
 
 If this is set to YES, the dictionary keys in the JSON output will be in sorted order.
 (This is useful if you need to compare two structures, for example.) The default is NO.
 */
@property BOOL sortKeys;

/**
 @brief Contains the error description after an error has occured.
 */
@property (copy, readonly) NSString *error;

/**
 @brief Initialise a stream writer.
 
 You have to create an output stream first. You should not open/close the  stream
 manually; this class takes care of that.
 */
- (id)initWithStream:(NSOutputStream*)stream;

/**
 @brief Write an NSDictionary to the JSON stream.
 */
- (BOOL)writeObject:(NSDictionary*)dict;

/**
 @brief Write an NSArray to the JSON stream.
 */
- (BOOL)writeArray:(NSArray *)array;

/// Start writing an Object to the stream
- (BOOL)writeObjectOpen;

/// Close the current object being written
- (BOOL)writeObjectClose;

/// Start writing an Array to the stream
- (BOOL)writeArrayOpen;

/// Close the current Array being written
- (BOOL)writeArrayClose;

/// Write a null to the stream
- (BOOL)writeNull;

/// Write a boolean to the stream
- (BOOL)writeBool:(BOOL)x;

//- (BOOL)writeInteger:(long)l;
//- (BOOL)writeDouble:(double)d;

/// Write a Number to the stream
- (BOOL)writeNumber:(NSNumber*)n;

/// Write a String to the stream
- (BOOL)writeString:(NSString*)s;

@end
