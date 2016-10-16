// ***************************************************************************
//  bitArray.ph
// ------------
// Author(s)   : dW!GhT
// Date Created: 04/01/2011 
// Version     : 1.00
// **************************************************************************
//  Description: This provides macros and routines that will deal with bit 
//               arrays, or also known as bitmaps, in a memory and processor 
//               efficient way.  
//
//  The user views the bitmap as one long bit string.
//
//    0100111100110011110101....0011101
//
// :NOTE:  For speed no bounds checking is preformed. 
// ***************************************************************************
#ifndef BITARRAY_PH_
#define BITARRAY_PH_ 

// ===========================================================================
//  The bits will be held in an int array (32 bits).
// :NOTE: We have to +2 since packetC does not allow arrays of size 1. The 
//        last chunk is used as a gating word so that some of the macros 
//        that scan the chunks do not run off the end of the array.
// ===========================================================================
#define BIT_ARRAY(BA,SZ)  int BA[((SZ)>>5)+2] = { (((SZ)>>5))#0, 2#0x7ffffffe }

#define ALL_SET_BITS    0xffffffff
#define ALL_CLEAR_BITS  0x00000000

// ***************************************************************************
// ***************************************************************************
//              Bit Twiddlers that act on the storage array 
// ***************************************************************************
// ***************************************************************************

// ===========================================================================
//  Sets the bit at the specified position.
// ===========================================================================
#define SET_BIT(BA,POS)  ((BA)[(POS)>>5] |= (1<<((POS)&31)))

// ===========================================================================
//  Clears (set to 0) the bit at the specified position.
// ===========================================================================
#define CLEAR_BIT(BA,POS)  ((BA)[(POS)>>5] &= ~(1<<((POS)&31)))

// ===========================================================================
//  Toggles the bit at the specified position.  If it was 1, it will be set
//  to 0.  If it was 0, it will be set to 1.
// ===========================================================================
#define TOGGLE_BIT(BA,POS)  ((BA)[(POS)>>5] ^= (1<<((POS)&31)))

// ===========================================================================
//  Returns the bit at the specified position.  It will be 0 or 1.
// ===========================================================================
#define GET_BIT(BA,POS)  ((((BA)[(POS)>>5]) >> ((POS)&31)) & 0x1)


// ***************************************************************************
// ***************************************************************************
//      Scanners used to locate set bits within the storage array chunks.
// ***************************************************************************
// ***************************************************************************

// ===========================================================================
//  Updates POS variable with the next bit set.  It will first move to the
//  first set chunk to move quickly to the set bit.
//  This will run till it finds a set bit.  The array is gated with a ALLSET 
//  entry so as to not have to test if we reached the end of the array.  The 
//  caller should test for the end of array condition on their own.
// ===========================================================================
#define NEXT_SET_BIT(BA,POS) while ( (BA)[POS>>5] == ALL_CLEAR_BITS ) \
                               { POS += 32; }; \
                             ++(POS); \
                             while ( !(((BA)[(POS)>>5] & (1<<((POS)&31))) >> \
                                      ((POS)&31)) ) \
                             { POS += 1; }

// ===========================================================================
//  Updates POS variable with the next cleared bit.  It will first move to the
//  first set chunk to move quickly to the cleared bit.
//  This will run till it finds a set bit.  The array is gated with a ALLSET 
//  entry so as to not have to test if we reached the end of the array.  The 
//  caller should test for the end of array condition on their own.
// ===========================================================================
#define NEXT_CLEARED_BIT(BA,POS) while ( (BA)[POS>>5] == ALL_SET_BITS ) \
                               { POS += 32; }; \
                             ++(POS); \
                             while ( (((BA)[(POS)>>5] & (1<<((POS)&31))) >> \
                                      ((POS)&31)) ) \
                             { POS += 1; }

// ===========================================================================
//  Updates the POS variable to the next chunk that has bits set in it.  This
//  moves a chunk (32bits) at a time and tests the chunk in that position so
//  POS does not have to align on a 32bit boundary.  POS is returned aligned
//  on a 32bit boundary.
//
// :NOTE: POS is updated to the chunk (32 bits) that contain a set bit.  For 
//        the benifit of execution speed the routine to determine the next 
//        set bit has been moved to NEXT_SET_BIT macro.
// ===========================================================================
#define NEXT_SET_CHUNK(BA,POS)  { while ( (BA)[POS>>5] == ALL_CLEAR_BITS ) \
                                    { POS += 32; } \
                                  POS &= ~0x1f; }

// ===========================================================================
//  Updates the POS variable to the next chunk that has all bits cleared. This
//  moves a chunk (32bits) at a time and tests the chunk in that position so
//  POS does not have to align on a 32bit boundary.  POS is returned aligned
//  on a 32bit boundary.
//
// :NOTE: POS is updated to the chunk (32 bits) that contains all cleared 
//        bits.  For the benifit of execution speed the routine to determine 
//        the next set bit has been moved to NEXT_SET_BIT macro.
// ===========================================================================
#define NEXT_CLEARED_CHUNK(BA,POS) { while ((BA)[POS>>5] != ALL_CLEARED_BITS)\
                                       { POS += 32; } \
                                     POS &= ~0x1f; }

// ===========================================================================
//  Returns a count of the number of bits set with a chunk.  This is also 
//  called the popCount or Hamming Weight.
// :NOTE: The "BX_()" macro is a helper for the CHUNK_BIT_COUNT macro and 
//        provides no useful function to the end user.
// ===========================================================================
#define CHUNK_BIT_COUNT(BA,POS) (((BX_((BA)[(POS)>>5])+(BX_((BA)[(POS)>>5])>>4)) \
                                  & 0x0F0F0F0F) % 255)
#define BX_(x) ((x) - (((x)>>1)&0x77777777) \
                    - (((x)>>2)&0x33333333) \
                    - (((x)>>3)&0x11111111))

#endif /*BITARRAY_PH_*/
