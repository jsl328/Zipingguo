//
//  PRNeuQuant.m
//  DandelionDemo
//
//  Created by Bob Li on 13-12-6.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCNeuQuant.h"

@implementation DCNeuQuant



/*
 * NeuQuant Neural-Net Quantization Algorithm
 * ------------------------------------------
 *
 * Copyright (c) 1994 Anthony Dekker
 *
 * NEUQUANT Neural-Net quantization algorithm by Anthony Dekker, 1994. See
 * "Kohonen neural networks for optimal colour quantization" in "Network:
 * Computation in Neural Systems" Vol. 5 (1994) pp 351-367. for a discussion of
 * the algorithm.
 *
 * Any party obtaining a copy of these files from the author, directly or
 * indirectly, is granted, free of charge, a full and unrestricted irrevocable,
 * world-wide, paid up, royalty-free, nonexclusive right and license to deal in
 * this software and documentation files (the "Software"), including without
 * limitation the rights to use, copy, modify, merge, publish, distribute,
 * sublicense, and/or sell copies of the Software, and to permit persons who
 * receive copies from any such party to do so, with the only requirement being
 * that this copyright notice remain intact.
 */

// Ported to Java 12/00 K Weiner
    
    /* radpower for precomputation */
    
    /*
     * Initialise network in range (0,0,0) to (255,255,255) and set parameters
     * -----------------------------------------------------------------------
     */
-(id) initWithPic:(DCByteArray*) thepic len:(int) len sample:(int) sample {
    
    self = [super init];
    
    if (self) {
        
        netindex = [[DCIntArray alloc] initWithSize:256];
        bias = [[DCIntArray alloc] initWithSize:netsize];
        freq = [[DCIntArray alloc] initWithSize:netsize];
        radpower = [[DCIntArray alloc] initWithSize:initrad];
        
        
        int i;
        
        thepicture = thepic;
        lengthcount = len;
        samplefac = sample;
        
        network = [[DCIntArray2D alloc] initWithRowCount:netsize columnCount:4];
        for (i = 0; i < netsize; i++) {
            int value = (i << (netbiasshift + 8)) / netsize;
            [network setInt:value atRow:i column:0];
            [network setInt:value atRow:i column:1];
            [network setInt:value atRow:i column:2];
            freq.a[i] = intbias / netsize; /* 1/netsize */
            bias.a[i] = 0;
        }
        
    }
    
    return self;
}

-(DCByteArray*) colorMap {
    
    DCByteArray* map = [[DCByteArray alloc] initWithSize:3 * netsize];
    
    int* index = malloc(sizeof(int) * netsize);
        for (int i = 0; i < netsize; i++)
            index[[network intAtRow:i column:3]] = i;
        int k = 0;
        for (int i = 0; i < netsize; i++) {
            int j = index[i];
            map.a[k++] = (char)[network intAtRow:j column:0];
            map.a[k++] = (char)[network intAtRow:j column:1];
            map.a[k++] = (char)[network intAtRow:j column:2];
        }
    
    free(index);
    
    return map;
}
    
    /*
     * Insertion sort of network and building of netindex[0..255] (to do after
     * unbias)
     * -------------------------------------------------------------------------------
     */
     -(void) inxbuild {
        
        int i, j, smallpos, smallval;
        int* p;
        int* q;
        int previouscol, startpos;
        
        previouscol = 0;
        startpos = 0;
        for (i = 0; i < netsize; i++) {
            p = [network columnsAtRow:i];
            smallpos = i;
            smallval = p[1]; /* index on g */
            /* find smallest in i..netsize-1 */
            for (j = i + 1; j < netsize; j++) {
                q = [network columnsAtRow:j];
                if (q[1] < smallval) { /* index on g */
                    smallpos = j;
                    smallval = q[1]; /* index on g */
                }
            }
            q = [network columnsAtRow:smallpos];
            /* swap p (i) and q (smallpos) entries */
            if (i != smallpos) {
                j = q[0];
                q[0] = p[0];
                p[0] = j;
                j = q[1];
                q[1] = p[1];
                p[1] = j;
                j = q[2];
                q[2] = p[2];
                p[2] = j;
                j = q[3];
                q[3] = p[3];
                p[3] = j;
            }
            /* smallval entry is now in position i */
            if (smallval != previouscol) {
                netindex.a[previouscol] = (startpos + i) >> 1;
                for (j = previouscol + 1; j < smallval; j++)
                    netindex.a[j] = i;
                previouscol = smallval;
                startpos = i;
            }
        }
         netindex.a[previouscol] = (startpos + maxnetpos) >> 1;
        for (j = previouscol + 1; j < 256; j++)
            netindex.a[j] = maxnetpos; /* really 256 */
    }
    
    /*
     * Main Learning Loop ------------------
     */
    -(void) learn {
        
        int i, j, b, g, r;
        int radius, rad, alpha, step, delta, samplepixels;
        DCByteArray* p;
        int pix, lim;
        
        if (lengthcount < minpicturebytes)
            samplefac = 1;
        alphadec = 30 + ((samplefac - 1) / 3);
        p = thepicture;
        pix = 0;
        lim = lengthcount;
        samplepixels = lengthcount / (3 * samplefac);
        delta = samplepixels / ncycles;
        alpha = initalpha;
        radius = initradius;
        
        rad = radius >> radiusbiasshift;
        if (rad <= 1)
            rad = 0;
        for (i = 0; i < rad; i++)
            radpower.a[i] = alpha * (((rad * rad - i * i) * radbias) / (rad * rad));
        
        // fprintf(stderr,"beginning 1D learning: initial radius=%d\n", rad);
        
        if (lengthcount < minpicturebytes)
            step = 3;
        else if ((lengthcount % prime1) != 0)
            step = 3 * prime1;
        else {
            if ((lengthcount % prime2) != 0)
                step = 3 * prime2;
            else {
                if ((lengthcount % prime3) != 0)
                    step = 3 * prime3;
                else
                    step = 3 * prime4;
            }
        }
        
        i = 0;
        while (i < samplepixels) {
            b = (p.a[pix + 0] & 0xff) << netbiasshift;
            g = (p.a[pix + 1] & 0xff) << netbiasshift;
            r = (p.a[pix + 2] & 0xff) << netbiasshift;
            j = [self contest:b g:g r:r];
            
            [self altersingle:alpha i:j b:b g:g r:r];
            if (rad != 0)
                [self alterneigh:rad i:j b:b g:g r:r]; /* alter neighbours */
            
            pix += step;
            if (pix >= lim)
                pix -= lengthcount;
            
            i++;
            if (delta == 0)
                delta = 1;
            if (i % delta == 0) {
                alpha -= alpha / alphadec;
                radius -= radius / radiusdec;
                rad = radius >> radiusbiasshift;
                if (rad <= 1)
                    rad = 0;
                for (j = 0; j < rad; j++)
                    radpower.a[j] = alpha * (((rad * rad - j * j) * radbias) / (rad * rad));
            }
        }
        // fprintf(stderr,"finished 1D learning: final alpha=%f
        // !\n",((float)alpha)/initalpha);
    }
    
    /*
     * Search for BGR values 0..255 (after net is unbiased) and return colour
     * index
     * ----------------------------------------------------------------------------
     */
-(int) mapWithB:(int) b g:(int) g r:(int) r {
        
        int i, j, dist, a, bestd;
        int* p;
        int best;
        
        bestd = 1000; /* biggest possible dist is 256*3 */
        best = -1;
        i = netindex.a[g]; /* index on g */
        j = i - 1; /* start at netindex[g] and work outwards */
        
        while ((i < netsize) || (j >= 0)) {
            if (i < netsize) {
                p = [network columnsAtRow:i];
                dist = p[1] - g; /* inx key */
                if (dist >= bestd)
                    i = netsize; /* stop iter */
                else {
                    i++;
                    if (dist < 0)
                        dist = -dist;
                    a = p[0] - b;
                    if (a < 0)
                        a = -a;
                    dist += a;
                    if (dist < bestd) {
                        a = p[2] - r;
                        if (a < 0)
                            a = -a;
                        dist += a;
                        if (dist < bestd) {
                            bestd = dist;
                            best = p[3];
                        }
                    }
                }
            }
            if (j >= 0) {
                p = [network columnsAtRow:j];
                dist = g - p[1]; /* inx key - reverse dif */
                if (dist >= bestd)
                    j = -1; /* stop iter */
                else {
                    j--;
                    if (dist < 0)
                        dist = -dist;
                    a = p[0] - b;
                    if (a < 0)
                        a = -a;
                    dist += a;
                    if (dist < bestd) {
                        a = p[2] - r;
                        if (a < 0)
                            a = -a;
                        dist += a;
                        if (dist < bestd) {
                            bestd = dist;
                            best = p[3];
                        }
                    }
                }
            }
        }
        return (best);
    }
    
    -(DCByteArray*) process {
        [self learn];
        [self unbiasnet];
        [self inxbuild];
        return [self colorMap];
    }
    
    /*
     * Unbias network to give byte values 0..255 and record position i to prepare
     * for sort
     * -----------------------------------------------------------------------------------
     */
    -(void) unbiasnet {
        
        int i;//, j;
        
        for (i = 0; i < netsize; i++) {
            [network setInt:[network intAtRow:i column:0] >> netbiasshift atRow:i column:0];
            [network setInt:[network intAtRow:i column:1] >> netbiasshift atRow:i column:1];
            [network setInt:[network intAtRow:i column:2] >> netbiasshift atRow:i column:2];
            [network setInt:i atRow:i column:3]; /* record colour no */
        }
    }
    
    /*
     * Move adjacent neurons by precomputed alpha*(1-((i-j)^2/[r]^2)) in
     * radpower[|i-j|]
     * ---------------------------------------------------------------------------------
     */
-(void) alterneigh:(int) rad i:(int) i b:(int) b g:(int) g r:(int) r {
        
        int j, k, lo, hi, a, m;
        int* p;
        
        lo = i - rad;
        if (lo < -1)
            lo = -1;
        hi = i + rad;
        if (hi > netsize)
            hi = netsize;

        j = i + 1;
        k = i - 1;
        m = 1;
        while ((j < hi) || (k > lo)) {
            a = radpower.a[m++];
            if (j < hi) {
                p = [network columnsAtRow:j++];
                p[0] -= (a * (p[0] - b)) / alpharadbias;
                p[1] -= (a * (p[1] - g)) / alpharadbias;
                p[2] -= (a * (p[2] - r)) / alpharadbias; 
            }
            if (k > lo) {
                p = [network columnsAtRow:k--];
                p[0] -= (a * (p[0] - b)) / alpharadbias;
                p[1] -= (a * (p[1] - g)) / alpharadbias;
                p[2] -= (a * (p[2] - r)) / alpharadbias;
            }
        }
    }
    
    /*
     * Move neuron i towards biased (b,g,r) by factor alpha
     * ----------------------------------------------------
     */
-(void) altersingle:(int) alpha i:(int) i b:(int) b g:(int) g r:(int) r {
        
    /* alter hit neuron */
    int* n = [network columnsAtRow:i];
    n[0] -= (alpha * (n[0] - b)) / initalpha;
    n[1] -= (alpha * (n[1] - g)) / initalpha;
    n[2] -= (alpha * (n[2] - r)) / initalpha;     
}
    
    /*
     * Search for biased BGR values ----------------------------
     */
-(int) contest:(int) b g:(int) g r:(int) r {
        
        /* finds closest neuron (min dist) and updates freq */
        /* finds best neuron (min dist-bias) and returns position */
        /* for frequently chosen neurons, freq[i] is high and bias[i] is negative */
        /* bias[i] = gamma*((1/netsize)-freq[i]) */
    
        int i, dist, a, biasdist, betafreq;
        int bestpos, bestbiaspos, bestd, bestbiasd;
        int* n;
        
        bestd = ~(((int) 1) << 31);
        bestbiasd = bestd;
        bestpos = -1;
        bestbiaspos = bestpos;
        
        for (i = 0; i < netsize; i++) {
            n = [network columnsAtRow:i];
            dist = n[0] - b;
            if (dist < 0)
                dist = -dist;
            a = n[1] - g;
            if (a < 0)
                a = -a;
            dist += a;
            a = n[2] - r;
            if (a < 0)
                a = -a;
            dist += a;
            if (dist < bestd) {
                bestd = dist;
                bestpos = i;
            }
            biasdist = dist - ((bias.a[i]) >> (intbiasshift - netbiasshift));
            if (biasdist < bestbiasd) {
                bestbiasd = biasdist;
                bestbiaspos = i;
            }
            betafreq = (freq.a[i] >> betashift);
            freq.a[i] -= betafreq;
            bias.a[i] += (betafreq << gammashift);
        }
        freq.a[bestpos] += beta;
        freq.a[bestpos] -= betagamma;
        return (bestbiaspos);
    }

-(void) free {
    [thepicture free];
    [network free];
    [netindex free];
    [bias free];
    [freq free];
    [radpower free];
}

@end
