// **************************************************************************
// base64.ph - Include file for Base64.
// ------------
// Author(s)   : dW!GhT
// Date Created: 07/06/2011 
// Version     : 1.01
// **************************************************************************
// Description: This provides an application with the ability to encode 
//              and decode base64 data
// **************************************************************************
// Usage:  Several #defines are required for the buffers used in the 
//         encode/decode process. 
//
//         These are used in both:
//            BASE64_ENCODED_STRING     Base64 encoded string
//            BASE64_DECODED_STRING     String result of encode/decode
//
//         Optional for both, defaults to '0'
//            BASE64_ENCODED_STRING_OFFSET  Offset within encoded str to start
//            BASE64_DECODED_STRING_OFFSET  Offset within decoded str to start
//
//         Optional for encoding:
//            BASE64_MIME               Encoded string will conform to 
//                                      MIME specs of cr/lf every 76 chars
//
// Example Usage:
//    The #defines allow you to define static or dynamic byte arrays as
//    your encode/decode targets.  An offset is also allowed, which defaults
//    to 0, so that you can specify a point to encode/decode to.
//
//    If you wanted to decode something from the packet payload, it could
//    look something like the following.
//       ...
//       byte decodedB64[100];
//       #define BASE64_ENCODED_STRING         pkt
//       #define BASE64_ENCODED_STRING_OFFSET  pib.payloadOffset
//       #define BASE64_DECODED_STRING         decodedB64
//       #include "base64.ph"
//       ...
//
//    If you wanted to encode something from a string into a pkt payload, it 
//    could look something like the following.
//       ...
//       byte myString[] = "A towel … is about the most massively useful " \
//                         "thing an interstellar hitch hiker can have.";
//       #define BASE64_DECODED_STRING         myString
//       #define BASE64_ENCODED_STRING         pkt
//       #define BASE64_ENCODED_STRING_OFFSET  pib.payloadOffset
//       #include "base64.ph"
//       ...
//
//    If you wanted to encode a string into another string, it could 
//    look something like the following.
//       ...
//       byte myString[] = "Computer, compute to the last digit the value" \
//                         " of pi -- Spock";
//       byte myB64String[ ((sizeof(encodeThis)/3)*4)+
//                         4*((sizeof(encodeThis)%3)>0) ] = {0};
//       #define BASE64_DECODED_STRING         myString
//       #define BASE64_ENCODED_STRING         myB64String
//       #include "base64.ph"
//       ...
//
// ***************************************************************************
#ifndef BASE64_PH_
#define BASE64_PH_

// Error check for required #defines
#ifndef BASE64_DECODED_STRING
#error BASE64_DECODED_STRING needs to be defined for base64.ph to compile.
#endif
#ifndef BASE64_ENCODED_STRING
#error BASE64_ENCODED_STRING needs to be defined for base64.ph to compile.
#endif

// Macro used to calculate the size of an base64 encoded string
#ifdef BASE64_MIME
#define BASE64_CALC_ENCODED_SIZE(X)  ((((X)/3)*4)+4*(((X)%3)>0)+((((X)/3)*4)/76)
#else
#define BASE64_CALC_ENCODED_SIZE(X)  ((((X)/3)*4)+4*(((X)%3)>0))
#endif

// Offsets within the encode/decode strings
#ifndef BASE64_ENCODED_STRING_OFFSET
#define BASE64_ENCODED_STRING_OFFSET  0
#endif
#ifndef BASE64_DECODED_STRING_OFFSET
#define BASE64_DECODED_STRING_OFFSET  0
#endif

// Return sizes of encode/decode
int  b64_decodedSize_;
int  b64_encodedSize_;

// Macros to retrieve the decode/encode sizes
#define BASE64_DECODED_SIZE()  b64_decodedSize_
#define BASE64_ENCODED_SIZE()  b64_encodedSize_

// Convenience typedef to indicate these are 
// characters we are dealing with.
#ifndef char
typedef byte char;
#endif

// Constants for CR/LF that gets added for MINE every 76 chars
const char  ACSII_LF  = 10;
const char  ACSII_CR  = 13;

// Our base string that we use to encode with
const char b64_encodeChar_[65] = 
           "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

// =========================================================================== 
// Encodes character data to base-64 data
// Returns the size of the decoded string.
//
// :NOTE: There is some loop unrolling for the end condition that makes
//        this code pretty fast.
// =========================================================================== 
int  base64Encode( int stringLength )
{
  b64_decodedSize_ = stringLength;
  
  // The result/encoded string
  b64_encodedSize_ = 0;
 
  // Increment over the length of the string, three characters at a time
  int  c;
  for (c = BASE64_DECODED_STRING_OFFSET; 
       c+2 < stringLength + BASE64_DECODED_STRING_OFFSET; c += 3) {
 
#ifdef MIME_BASE64
    // We add newlines after every 76 output characters, 
    // according to the MIME specs
    if ( (c-BASE64_DECODED_STRING_OFFSET) > 0 && 
        (((c-BASE64_DECODED_STRING_OFFSET) / 3) * 4) % 76 == 0) {
      BASE64_ENCODED_STRING[b64_encodedSize_++] = ACSII_CR;  
      BASE64_ENCODED_STRING[b64_encodedSize_++] = ACSII_LF; 
    }
#endif
 
    // These three 8-bit (ASCII) characters become one 24-bit number.
    int  n;
    n = (int)BASE64_DECODED_STRING[c] << 16;
    n += (int)BASE64_DECODED_STRING[c+1] << 8;
    n += (int)BASE64_DECODED_STRING[c+2];
    
    // that gets separated into four 6-bit numbers.
    char  n0, n1, n2, n3;
    n0 = (char)(n >> 18) & 0x3f;
    n1 = (char)(n >> 12) & 0x3f;
    n2 = (char)(n >> 6) & 0x3f;
    n3 = (char)n & 0x3f;
 
    // These four 6-bit numbers are used as indices 
    // into the base64 character list
    BASE64_ENCODED_STRING[b64_encodedSize_++] = b64_encodeChar_[n0];
    BASE64_ENCODED_STRING[b64_encodedSize_++] = b64_encodeChar_[n1];
    BASE64_ENCODED_STRING[b64_encodedSize_++] = b64_encodeChar_[n2];
    BASE64_ENCODED_STRING[b64_encodedSize_++] = b64_encodeChar_[n3];
  }
  
  // Encode the last 1-2 characters.  
  // :NOTE:  We do this outside of the loop to reduce the amount of tests
  //         that get performed in the loop.  This removes 2 tests per
  //         character by handling this end condition outside of the loop.
  if ( c != stringLength + BASE64_DECODED_STRING_OFFSET ) {
    // These three 8-bit (ASCII) characters become one 24-bit number.
    // If we run over the end we just add a zero pad. 
    int  n;
    n = (int)BASE64_DECODED_STRING[c] << 16;
    if( (c+1) < stringLength + BASE64_DECODED_STRING_OFFSET )
       n += (int)BASE64_DECODED_STRING[c+1] << 8;
    if( (c+2) < stringLength + BASE64_DECODED_STRING_OFFSET )
       n += (int)BASE64_DECODED_STRING[c+2];
    
    // that gets separated into four 6-bit numbers.
    char  n0, n1, n2, n3;
    n0 = (char)(n >> 18) & 0x3f;
    n1 = (char)(n >> 12) & 0x3f;
    n2 = (char)(n >> 6) & 0x3f;
    n3 = (char)n & 0x3f;
 
    // These four 6-bit numbers are used as indices 
    // into the base64 character list
    BASE64_ENCODED_STRING[b64_encodedSize_++] = b64_encodeChar_[n0];
    BASE64_ENCODED_STRING[b64_encodedSize_++] = b64_encodeChar_[n1];
    BASE64_ENCODED_STRING[b64_encodedSize_++] = b64_encodeChar_[n2];
    BASE64_ENCODED_STRING[b64_encodedSize_++] = b64_encodeChar_[n3];
  }
  
  // Add the padding to make this string a multiple of 3 characters.
  // The pad character is '='.
  c = stringLength % 3;
  if ( c > 0 ) {
    for (; c < 3; c++) { 
      BASE64_ENCODED_STRING[b64_encodedSize_-(3-c)] = '='; 
    } 
  }
  return b64_encodedSize_;
}


//
// Decode character indices quickly!  This table provides a lookup
// that will give the index to the decode character.  255 indicates
// an error/unused.  
//
const char b64_decodeChar_[256] = 
{
  255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
  255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
  255,255,255,255,255,62,255,255,255,63,52,53,54,55,56,57,58,59,60,61,255,255,
  255,255,255,255,255,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,
  22,23,24,25,255,255,255,255,255,255,26,27,28,29,30,31,32,33,34,35,36,37,38,39,
  40,41,42,43,44,45,46,47,48,49,50,51,255,255,255,255,255,255,255,255,255,255,
  255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
  255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
  255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
  255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
  255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
  255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
  255,255,255,255,255,255,255,255,255
};


// =========================================================================== 
// 
// Decodes character data to base-64 data.  
// Returns the size of the decoded string.
//
// :NOTE: There is some loop unrolling for the end condition that makes
//        this code pretty fast.
//
// =========================================================================== 
int  base64Decode( int stringLength ) 
{
  b64_encodedSize_ = stringLength;
  
  // The result/decoded string size
  b64_decodedSize_ = 0;

  // Decode 3 characters at a time
  int  c;
  for (c = BASE64_ENCODED_STRING_OFFSET; 
       c+4 < stringLength + BASE64_ENCODED_STRING_OFFSET; c += 4) {
    // Decode the four 6 bit indices 
    char  n0, n1, n2, n3;
    n0 = b64_decodeChar_[BASE64_ENCODED_STRING[c]];
    n1 = b64_decodeChar_[BASE64_ENCODED_STRING[c+1]];
    n2 = b64_decodeChar_[BASE64_ENCODED_STRING[c+2]];
    n3 = b64_decodeChar_[BASE64_ENCODED_STRING[c+3]];

    BASE64_DECODED_STRING[b64_decodedSize_++] = (char)((n0 << 2) + ((n1 & 0x30) >> 4));
    BASE64_DECODED_STRING[b64_decodedSize_++] = (char)(((n1 & 0xf) << 4) + 
                                        ((n2 & 0x3c) >> 2));
    BASE64_DECODED_STRING[b64_decodedSize_++] = (char)(((n2 & 0x3) << 6) + n3);
  }

  // Decode the last 1-3 characters.
  // :NOTE:  We do this outside of the loop to reduce the amount of tests
  //         that get performed in the loop.  This removes 2 tests per
  //         character by handling this end condition outside of the loop.
  if ( c < stringLength + BASE64_ENCODED_STRING_OFFSET ) {
    // Decode the four 6 bit indices 
    char  n0, n1, n2, n3;
    n0 = b64_decodeChar_[BASE64_ENCODED_STRING[c]];
    n1 = b64_decodeChar_[BASE64_ENCODED_STRING[c+1]];
    n2 = b64_decodeChar_[BASE64_ENCODED_STRING[c+2]];
    n3 = b64_decodeChar_[BASE64_ENCODED_STRING[c+3]];

    BASE64_DECODED_STRING[b64_decodedSize_++] = (char)((n0 << 2) + ((n1 & 0x30) >> 4));
    if ( BASE64_ENCODED_STRING[b64_encodedSize_-2] != '=' ) {
      BASE64_DECODED_STRING[b64_decodedSize_++] = (char)(((n1 & 0xf) << 4) + 
                                          ((n2 & 0x3c) >> 2));
      if ( BASE64_ENCODED_STRING[b64_encodedSize_-1] != '=' ) {
        BASE64_DECODED_STRING[b64_decodedSize_++] = (char)(((n2 & 0x3) << 6) + n3);
      }
    }
  }
  
  return b64_decodedSize_;
}

#endif /*BASE64_PH_*/
