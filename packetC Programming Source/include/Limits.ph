//============================================================================
//
// limits.ph - packetC limits.h standard library replacement
//
//    Provide similar representations to those found in limits.h on different
//    platforms.
//
// author
//    cloudshield.com
//
// version
//    $Revision: 1.1 $
//
// copyright notice
//    © 2009-2011 CloudShield Technologies, Inc.
//
//============================================================================
#ifndef LIMITS_PH
#define LIMITS_PH
#define _LIMITS_PH_VERSION 1.02

//=============================================
//============== BASIC TYPE SIZES =============
//=============================================

const int  BYTE_BIT    = 8                    /* Number of bits for a byte  */
const int  SHORT_BIT   = 16                   /* Number of bits for a short */
const int  INT_BIT     = 32                   /* Number of bits for an int  */
// const int  LONG_BIT    = 64                   /* Number of bits for a long  */

const int  BYTE_MIN    = 0                    /* Minimum value of a byte    */
const int  BYTE_MAX    = 255                  /* Maximum value of a byte    */
const int  SHORT_MIN   = 0                    /* Minimum value of a short   */
const int  SHORT_MAX   = 65535                /* Maximum value of a short   */
const int  INT_MIN     = 0                    /* Minimum value of a int     */
const int  INT_MAX     = 4294967295           /* Maximum value of a int     */
//const int  LONG_MIN    = 0                    /* Minimum value of a int     */
//const int  LONG_MAX    = 18446744073709551615 /* Maximum value of a long    */


#endif /* LIMITS_PH_ */