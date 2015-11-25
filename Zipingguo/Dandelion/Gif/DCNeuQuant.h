//
//  PRNeuQuant.h
//  DandelionDemo
//
//  Created by Bob Li on 13-12-6.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCIntArray2D.h"
#import "DCIntArray.h"
#import "DCByteArray.h"

#define netsize 256 /* number of colours used */
/* four primes near 500 - assume no image has a length so large */
/* that it is divisible by all four primes */
#define prime1 499
#define prime2 491
#define prime3 487
#define prime4 503
#define minpicturebytes (3 * prime4)
#define maxnetpos (netsize - 1)
#define netbiasshift 4 /* bias for colour values */
#define ncycles 100 /* no. of learning cycles */

/* defs for freq and bias */
#define intbiasshift 16 /* bias for fractions */
#define intbias (((int) 1) << intbiasshift)

#define gammashift 10 /* gamma = 1024 */

#define gamma (((int) 1) << gammashift)

#define betashift 10

#define beta (intbias >> betashift) /* beta = 1/1024 */

#define betagamma (intbias << (gammashift - betashift))

/* defs for decreasing radius factor */
#define initrad (netsize >> 3) /*
                                                      * for 256 cols, radius
                                                      * starts
                                                      */

#define radiusbiasshift 6 /* at 32.0 biased by 6 bits */

#define radiusbias (((int) 1) << radiusbiasshift)

#define initradius (initrad * radiusbias) /*
                                                                 * and
                                                                 * decreases
                                                                 * by a
                                                                 */

#define radiusdec 30 /* factor of 1/30 each cycle */

/* defs for decreasing alpha factor */
#define alphabiasshift 10 /* alpha starts at 1.0 */

#define initalpha (((int) 1) << alphabiasshift)

/* radbias and alpharadbias used for radpower calculation */
#define radbiasshift 8

#define radbias (((int) 1) << radbiasshift)

#define alpharadbshift (alphabiasshift + radbiasshift)

#define alpharadbias (((int) 1) << alpharadbshift)


@interface DCNeuQuant : NSObject {
    
    /* minimum size for input image */
    
    /*
     * Program Skeleton ---------------- [select samplefac in range 1..30] [read
     * image from input file] pic = (unsigned char*) malloc(3*width*height);
     * initnet(pic,3*width*height,samplefac); learn(); unbiasnet(); [write output
     * image header, using writecolourmap(f)] inxbuild(); write output image using
     * inxsearch(b,g,r)
     */
    
    /*
     * Network Definitions -------------------
     */
    

    int alphadec; /* biased by 10 bits */
    
    
    /*
     * Types and Global Variables --------------------------
     */
    
    DCByteArray* thepicture; /* the input image itself */
    
    int lengthcount; /* lengthcount = H*W*3 */
    
    int samplefac; /* sampling factor 1..30 */
    
    // typedef int pixel[4]; /* BGRc */
    DCIntArray2D* network; /* the network itself - [netsize][4] */
    
    DCIntArray* netindex;
    
    /* for network lookup - really 256 */
    
    DCIntArray* bias;
    
    /* bias and freq arrays for learning */
    DCIntArray* freq;
    
    DCIntArray* radpower;
}

-(id) initWithPic:(DCByteArray*) thepic len:(int) len sample:(int) sample;

-(DCByteArray*) process;

-(int) mapWithB:(int) b g:(int) g r:(int) r;

-(void) free;

@end
