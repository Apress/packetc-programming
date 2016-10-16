// ***************************************************************************
//  byteArray.ph
// ------------
// Author      : dW!GhT
// Date Created: 04/28/2011
// Version     : 1.00
// ***************************************************************************
//  This provides macros and routines that will deal with allocating and
//  accessing in global arrays.
//
// :NOTE:  For speed no bounds checking is preformed. 
// ***************************************************************************
#ifndef BYTEARRAY_PH_
#define BYTEARRAY_PH_

// ===========================================================================
//  The bytes will be held in an int array (32 bits).
// :NOTE: We have to +2 since packetC does not allow arrays of size 1.
// ===========================================================================
#define BYTE_ARRAY(BA,SZ)  int BA[((SZ)>>2)+2] = { (((SZ)>>2)+2)#0 }


// ***************************************************************************
// ***************************************************************************
//              Access/Modifiers that act on the storage array 
// ***************************************************************************
// ***************************************************************************

// ===========================================================================
//  Sets the byte at the specified position.
// ===========================================================================

// This works best on a POS that is a constant.
#define SET_BYTE_C(BA,POS,VAL)  { \
  ((BA)[(POS)>>2] &= ~(0xff<<(((POS)&3)<<3))); \
  ((BA)[(POS)>>2] |= ((VAL&0xff)<<(((POS)&3)<<3))); \
}

// This works best on a POS that is a variable. 
#define SET_BYTE_V(BA,POS,VAL)  { \
  int sPos; \
  sPos = (((POS)&3)<<3); \
  int cPos; \
  cPos = (POS)>>2; \
  (BA)[cPos] &= ~(0xff<<sPos); \
  (BA)[cPos] |= (((VAL)&0xff)<<sPos); \
}

// ===========================================================================
//  Returns the bit at the specified position.  It will be 0 or 1.
// ===========================================================================
#define GET_BYTE(BA,POS)  (byte)(((BA)[(POS)>>2]) >> ((((POS)&3))<<3))

#endif /*BYTEARRAY_PH_*/
