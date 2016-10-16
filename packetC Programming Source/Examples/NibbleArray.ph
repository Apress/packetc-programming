// ***************************************************************************
//  nibbleArray.ph
// ------------
// Author      : dW!GhT
// Date Created: 04/28/2011
// Version     : 1.00
// ***************************************************************************
//  This provides macros and routines that will deal with allocating and
//  accessing byte global arrays.
//
// :NOTE:  For speed no bounds checking is preformed. 
// ***************************************************************************
#ifndef NIBBLEARRAY_PH_
#define NIBBLEARRAY_PH_

// ===========================================================================
//  The bytes will be held in an int array (32 bits).
// :NOTE: We have to +2 since packetC does not allow arrays of size 1.
// ===========================================================================
#define NIBBLE_ARRAY(BA,SZ)  int BA[((SZ)>>2)+2] = { (((SZ)>>2)+2)#0 }


// ***************************************************************************
// ***************************************************************************
//              Access/Modifiers that act on the storage array 
// ***************************************************************************
// ***************************************************************************

// ===========================================================================
//  Sets the byte at the specified position.
// ===========================================================================

// This works best on a POS that is a constant.
#define SET_NIBBLE_C(BA,POS,VAL)  { \
  ((BA)[(POS)>>3] &= ~(0xf<<(((POS)&7)<<2))); \
  ((BA)[(POS)>>3] |= ((VAL&0xf)<<(((POS)&7)<<2))); \
}

// This works best on a POS that is a variable. 
#define SET_NIBBLE_V(BA,POS,VAL)  { \
  int sPos; \
  sPos = (((POS)&7)<<2); \
  int cPos; \
  cPos = (POS)>>2; \
  (BA)[cPos] &= ~(0xf<<sPos); \
  (BA)[cPos] |= (((VAL)&0xf)<<sPos); \
}

// ===========================================================================
//  Returns the bit at the specified position.  It will be 0 or 1.
// ===========================================================================
#define GET_NIBBLE(BA,POS) ((((BA)[(POS)>>3]) >> ((((POS)&7))<<2)) &0xf)

// ===========================================================================
//  Increments the byte at the specified position.
// ===========================================================================
#define INC_NIBBLE(BA,POS) ( ((BA)[(POS)>>3]) += (1<<((((POS)&7))<<2)) )

// ===========================================================================
//  Decrements the byte at the specified position.
// ===========================================================================
#define DEC_NIBBLE(BA,POS) ( ((BA)[(POS)>>3]) -= (1<<((((POS)&7))<<2)) )

#endif /*NIBBLEARRAY_PH_*/
