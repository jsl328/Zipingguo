//
//  LZWEncoder.h
//  DandelionDemo
//
//  Created by Bob Li on 13-12-6.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCIntArray.h"
#import "DCByteArray.h"
#import "DCStreamWriter.h"

#define LZW_EOF -1
#define BITS 12
#define HSIZE 5003 // 80% occupancy

@interface LZWEncoder : NSObject {

int imgW, imgH;

DCByteArray* pixAry;

int initCodeSize;

int remaining;

int curPixel;

// GIFCOMPR.C - GIF Image compression routines
//
// Lempel-Ziv compression based on 'compress'. GIF modifications by
// David Rowley (mgardi@watdcsu.waterloo.edu)

// General DEFINEs

// GIF Image compression - modified 'compress'
//
// Based on: compress.c - File compression ala IEEE Computer, June 1984.
//
// By Authors: Spencer W. Thomas (decvax!harpo!utah-cs!utah-gr!thomas)
// Jim McKie (decvax!mcvax!jim)
// Steve Davies (decvax!vax135!petsd!peora!srd)
// Ken Turkowski (decvax!decwrl!turtlevax!ken)
// James A. Woods (decvax!ihnp4!ames!jaw)
// Joe Orost (decvax!vax135!petsd!joe)

int n_bits; // number of bits/code

int maxbits; // user settable max # bits/code

int maxcode; // maximum code, given n_bits

int maxmaxcode; // should NEVER generate this code

DCIntArray* htab;

DCIntArray* codetab;

int hsize; // for dynamic table sizing

int free_ent; // first unused entry

// block compression parameters -- after all codes are used up,
// and compression rate changes, start over.
BOOL clear_flg;

// Algorithm: use open addressing double hashing (no chaining) on the
// prefix code / next character combination. We do a variant of Knuth's
// algorithm D (vol. 3, sec. 6.4) along with G. Knott's relatively-prime
// secondary probe. Here, the modular division first probe is gives way
// to a faster exclusive-or manipulation. Also do block compression with
// an adaptive reset, whereby the code table is cleared when the compression
// ratio decreases, but after the table fills. The variable-length output
// codes are re-sized at this point, and a special CLEAR code is generated
// for the decompressor. Late addition: construct the table according to
// file size for noticeable speed improvement on small files. Please direct
// questions about this implementation to ames!jaw.

int g_init_bits;

int ClearCode;

int EOFCode;

// output
//
// Output the given code.
// Inputs:
// code: A n_bits-bit integer. If == -1, then EOF. This assumes
// that n_bits =< wordsize - 1.
// Outputs:
// Outputs code to the file.
// Assumptions:
// Chars are 8 bits long.
// Algorithm:
// Maintain a BITS character long buffer (so that 8 codes will
// fit in it exactly). Use the VAX insv instruction to insert each
// code in turn. When the buffer fills up empty it and start over.

int cur_accum;

int cur_bits;

DCIntArray* masks;

// Number of characters so far in this 'packet'
int a_count;

// Define the storage for the packet accumulator
DCByteArray* accum;

}

-(id) initWithWidth:(int) width height:(int) height pixels:(DCByteArray*) pixels color_depth:(int) color_depth;

-(void) encode:(DCStreamWriter*) os;

@end
