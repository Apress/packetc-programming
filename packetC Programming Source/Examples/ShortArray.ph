// ***************************************************************************
//  shortArray.ph
// ------------
// Author      : dW!GhT
// Date Created: 04/28/2011
// Version     : 1.00
// ***************************************************************************
//  This provides macros and routines that will deal with allocating and
//  accessing short global arrays.
//
// :NOTE:  For speed no bounds checking is preformed. 
// ***************************************************************************
#ifndef SHORTARRAY_PH_
#define SHORTARRAY_PH_

// ===========================================================================
//  The bits will be held in an int array (32 bits).
// :NOTE: We have to +2 since packetC does not allow arrays of size 1.
// ===========================================================================
#define SHORT_ARRAY(BA,SZ)  int BA[((SZ)>>1)+2] = { (((SZ)>>1)+2)#0 }


// ***************************************************************************
// ***************************************************************************
//              Access/Modifiers that act on the storage array 
// ***************************************************************************
// ***************************************************************************

// ===========================================================================
//  Sets the short at the specified position.
// ===========================================================================

// This works best on POS that is a constant 
// C:C  = 2 RAVE instructions
// C:V  = 4 RAVE instructions
// V:C  = 17 RAVE instructions
// V:V  = 18 RAVE instructions
#define SET_SHORT_C(BA,POS,VAL)  { \
  ((BA)[(POS)>>1] &= ~(0xffff<<(((POS)&1)<<4))); \
  ((BA)[(POS)>>1] |= (((VAL)&0xffff)<<(((POS)&1)<<4))); \
}

// This works best on POS that is a variable.  
// C:C  = 11 RAVE instructions
// C:V  = 10 RAVE instructions
// V:C  = 14 RAVE instructions
// V:V  = 15 RAVE instructions
#define SET_SHORT_V(BA,POS,VAL)  { \
  int sPos; \
  sPos = (((POS)&1)<<4); \
  int cPos; \
  cPos = (POS)>>1; \
  (BA)[cPos] &= ~(0xffff<<sPos); \
  (BA)[cPos] |= (((VAL)&0xffff)<<sPos); \
}

// ===========================================================================
//  Returns the short at the specified position.
// ===========================================================================

// C  = 4 RAVE instructions
// V  = 7 RAVE instructions
#define GET_SHORT(BA,POS)  (short)((((BA)[(POS)>>1]) >> (((POS)&1)<<4)) )

#endif /*SHORTARRAY_PH_*/
