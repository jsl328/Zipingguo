//
//  LZWEncoder.m
//  DandelionDemo
//
//  Created by Bob Li on 13-12-6.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "LZWEncoder.h"
#import "DCStreamWriter.h"

@implementation LZWEncoder


// ==============================================================================
// Adapted from Jef Poskanzer's Java port by way of J. M. G. Elliott.
// K Weiner 12/00

-(id) initWithWidth:(int) width height:(int) height pixels:(DCByteArray*) pixels color_depth:(int) color_depth {
    
    self = [super init];
    
    if (self) {
        
        maxbits = BITS; // user settable max # bits/code
        maxmaxcode = 1 << BITS; // should NEVER generate this code
        htab = [[DCIntArray alloc] initWithSize:HSIZE];
        codetab = [[DCIntArray alloc] initWithSize:HSIZE];
        hsize = HSIZE; // for dynamic table sizing
        free_ent = 0; // first unused entry
        clear_flg = NO;
        cur_accum = 0;
        cur_bits = 0;
        
        masks = [[DCIntArray alloc] initWithSize:17];
        masks.a[0] = 0x0000;
        masks.a[1] = 0x0001;
        masks.a[2] = 0x0003;
        masks.a[3] = 0x0007;
        masks.a[4] = 0x000F;
        masks.a[5] = 0x001F;
        masks.a[6] = 0x003F;
        masks.a[7] = 0x007F;
        masks.a[8] = 0x00FF;
        masks.a[9] = 0x01FF;
        masks.a[10] = 0x03FF;
        masks.a[11] = 0x07FF;
        masks.a[12] = 0x0FFF;
        masks.a[13] = 0x1FFF;
        masks.a[14] = 0x3FFF;
        masks.a[15] = 0x7FFF;
        masks.a[16] = 0xFFFF;
        
        accum = [[DCByteArray alloc] initWithSize:256];
        
        // ----------------------------------------------------------------------------
        
        imgW = width;
        imgH = height;
        pixAry = pixels;
        initCodeSize = MAX(2, color_depth);
        
    }
    
    return self;
}


    // Add a character to the end of the current packet, and if it is 254
    // characters, flush the packet to disk.
-(void) char_out:(short) c outs:(DCStreamWriter*) outs {
        accum.a[a_count++] = c;
        if (a_count >= 254)
            [self flush_char:outs];
    }
    
    // Clear out the hash table
    
    // table clear for block compress
-(void) cl_block:(DCStreamWriter*) outs {
        [self cl_hash:hsize];
        free_ent = ClearCode + 2;
        clear_flg = true;
    
    [self output:ClearCode outs:outs];
}
    
    // reset code table
-(void) cl_hash:(int) p_hsize {
    for (int i = 0; i < p_hsize; ++i)
        htab.a[i] = -1;
}
    
-(void) compress:(int) init_bits outs:(DCStreamWriter*) outs {
        int fcode;
        int i /* = 0 */;
        int c;
        int ent;
        int disp;
        int hsize_reg;
        int hshift;
        
        // Set up the globals: g_init_bits - initial number of bits
        g_init_bits = init_bits;
        
        // Set up the necessary values
        clear_flg = false;
        n_bits = g_init_bits;
    maxcode = [self MAXCODE:n_bits];
        
        ClearCode = 1 << (init_bits - 1);
        EOFCode = ClearCode + 1;
        free_ent = ClearCode + 2;
        
        a_count = 0; // clear packet
        
        ent = [self nextPixel];
        
        hshift = 0;
        for (fcode = hsize; fcode < 65536; fcode *= 2)
            ++hshift;
        hshift = 8 - hshift; // set hash code range bound
        
        hsize_reg = hsize;
        [self cl_hash:hsize_reg]; // clear hash table
    
        [self output:ClearCode outs:outs];
        
    outer_loop: while ((c = [self nextPixel]) != LZW_EOF) {
        fcode = (c << maxbits) + ent;
        i = (c << hshift) ^ ent; // xor hashing
        
        BOOL continueOuter = NO;
        
        if (htab.a[i] == fcode) {
            ent = codetab.a[i];
            continue;
        } else if (htab.a[i] >= 0) // non-empty slot
        {
            disp = hsize_reg - i; // secondary hash (after G. Knott)
            if (i == 0)
                disp = 1;
            do {
                if ((i -= disp) < 0)
                    i += hsize_reg;
                
                if (htab.a[i] == fcode) {
                    ent = codetab.a[i];
                    //continue outer_loop;
                    continueOuter = YES;
                    break;
                }
            } while (htab.a[i] >= 0);
            
        }
        
        if (continueOuter) {
            continue;
        }
        
        [self output:ent outs:outs];
        ent = c;
        if (free_ent < maxmaxcode) {
            codetab.a[i] = free_ent++; // code -> hashtable
            htab.a[i] = fcode;
        } else
            [self cl_block:outs];
    }
        // Put out the final code.
    [self output:ent outs:outs];
    [self output:EOFCode outs:outs];
}
    
    // ----------------------------------------------------------------------------
-(void) encode:(DCStreamWriter*) os {
    [os writeByte:initCodeSize]; // write "initial code size" byte
    
        remaining = imgW * imgH; // reset navigation variables
        curPixel = 0;
    
    [self compress:initCodeSize + 1 outs:os]; // compress and write the pixel data
        
    [os writeByte:0]; // write block terminator
}
    
    // Flush the packet to disk, and reset the accumulator
-(void) flush_char:(DCStreamWriter*) outs {
        if (a_count > 0) {
            [outs writeByte:a_count];
            [outs writeByteArray:accum.a length:a_count];
            //outs.write(a_count);
           // outs.write(accum, 0, a_count);
            a_count = 0;
        }
    }
    
-(int) MAXCODE:(int) pn_bits {
        return (1 << pn_bits) - 1;
    }
    
    // ----------------------------------------------------------------------------
    // Return the next pixel from the image
    // ----------------------------------------------------------------------------
     -(int) nextPixel {
        if (remaining == 0)
            return LZW_EOF;

        --remaining;
        
        short pix = pixAry.a[curPixel++];
        
        return pix & 0xff;
    }
    
-(void) output:(int) code outs:(DCStreamWriter*) outs {
        cur_accum &= masks.a[cur_bits];
        
        if (cur_bits > 0)
            cur_accum |= (code << cur_bits);
        else
            cur_accum = code;
        
        cur_bits += n_bits;
        
        while (cur_bits >= 8) {
            [self char_out:(short) (cur_accum & 0xff) outs:outs];
            cur_accum >>= 8;
            cur_bits -= 8;
        }
        
        // If the next entry is going to be too big for the code size,
        // then increase it, if possible.
        if (free_ent > maxcode || clear_flg) {
            if (clear_flg) {
                maxcode = [self MAXCODE:n_bits = g_init_bits];
                clear_flg = false;
            } else {
                ++n_bits;
                if (n_bits == maxbits)
                    maxcode = maxmaxcode;
                else
                    maxcode = [self MAXCODE:n_bits];
            }
        }
        
        if (code == EOFCode) {
            // At EOF, write the rest of the buffer.
            while (cur_bits > 0) {
                [self char_out:(short) (cur_accum & 0xff) outs:outs];
                cur_accum >>= 8;
                cur_bits -= 8;
            }
            
            [self flush_char:outs];
        }
    }


@end
