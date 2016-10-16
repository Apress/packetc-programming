//==============================================================================
// namedoperators.ph – Variation on iso646.h
//
//    In C++ named operators can be used instead of their native punctuation
//    equivalents.  In packetC, these are able to be implemented through the
//    use of macros.
//
// author
//    cloudshield.com
//
// version
//    $Revision: 1.0 $
//   
// copyright notice
//    © 2009-2011 CloudShield Technologies, Inc.
//
//==============================================================================
#ifndef NAMED_OPERATORS_PH
#define NAMED_OPERATORS_PH
#define _NAMED_OPERATORS_PH 1.00

#define and    &&
#define and_eq   &=
#define bitand  &
#define bitor   |
#define compl   ~
#define not   !
#define not_eq   !=
#define or   ||
#define or_eq   |=
#define xor   ^
#define xor_eq   ^=


#endif