//============================================================================
//
// ascii.ph - ASCII character constants for use in packetC.
//
//     Provides pre-defined constants for ASCII Character Sets 0-127.
//     Enables the rapid access to directly comparing text characters
//     in packet to a named character value.
//
// assumptions
//
//     All values defined are of type const byte using all UPPERCASE.
//     These are simply new definitions for constants.  Note that
//     many characters are not legal packetC names so all names
//     use spelled out descriptions (e.g. SEMICOLON versus ; is
//     used.)  One exception to style guide is that a lowercase of
//     ASCII a-z is provided in two variants (one all UPPERCASE with
//     _LC appended and one simply with the letter in lowercase).
//     As packetC is case sensitive, ASCII_A and ASCII_a are distinct.
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
//============================================================================
#ifndef ASCII_PH
#define ASCII_PH
#define _ASCII_PH_VERSION 1.01

#define _ASCII_MACROS ENABLED

//==================- START of ASCII =========================================


const byte  ASCII_NUL = 0;
const byte  ASCII_SOH = 1;
const byte  ASCII_STX = 2;
const byte  ASCII_ETX = 3;
const byte  ASCII_EOT = 4;
const byte  ASCII_ENQ = 5;
const byte  ASCII_ACK = 6;
const byte  ACSII_BEL = 7;
const byte  ACSII_BS  = 8;
const byte  ACSII_HT  = 9;
const byte  ACSII_NL  = 10;
const byte  ACSII_VT  = 11;
const byte  ACSII_NP  = 12;
const byte  ACSII_CR  = 13;
const byte  ACSII_SO  = 14;
const byte  ACSII_SI  = 15;
const byte  ACSII_DLE = 16;
const byte  ACSII_DC1 = 17;
const byte  ACSII_DC2 = 18;
const byte  ACSII_DC3 = 19;
const byte  ACSII_DC4 = 20;
const byte  ACSII_NAK = 21;
const byte  ACSII_SYN = 22;
const byte  ACSII_ETB = 23;
const byte  ASCII_CAN = 24;
const byte  ASCII_EM  = 25;
const byte  ASCII_SUB = 26;
const byte  ASCII_ESC = 27;
const byte  ASCII_FS  = 28;
const byte  ASCII_GS  = 29;
const byte  ASCII_RS  = 30;
const byte  ASCII_US  = 31;
const byte  ASCII_SP  = 32;
const byte  ASCII_SPACE            = ' ';
const byte  ASCII_EXCLAMATIONPOINT = '!';
const byte  ASCII_BANG             = '!';
const byte  ASCII_DBLQUOTE         = 34;
const byte  ASCII_DOUBLEQUOTE      = 34;
const byte  ASCII_POUND            = '#';
const byte  ASCII_DOLLARSIGN       = '$';
const byte  ASCII_PERCENT          = '%';
const byte  ASCII_AMPERSAND        = '&';
const byte  ASCII_AND              = '&';
const byte  ASCII_QUOTE            = 39;
const byte  ASCII_SINGLEQUOTE      = 39;
const byte  ASCII_LEFTPARENTHESES  = '(';
const byte  ASCII_LEFTPAREN        = '(';
const byte  ASCII_RIGHTPARENTHESES = ')';
const byte  ASCII_RIGHTPAREN       = ')';
const byte  ASCII_STAR             = '*';
const byte  ASCII_ASTERISK         = '*';
const byte  ASCII_PLUS             = '+';
const byte  ASCII_PLUSSIGN         = '+';
const byte  ASCII_COMMA            = ',';
const byte  ASCII_MINUS            = '-';
const byte  ASCII_DASH             = '-';
const byte  ASCII_DOT              = '.';
const byte  ASCII_DECIMALPOINT     = '.';
const byte  ASCII_SLASH            = '/';
const byte  ASCII_FORWARDSLASH     = '/';
const byte  ASCII_0   = '0';
const byte  ASCII_1   = '1';
const byte  ASCII_2   = '2';
const byte  ASCII_3   = '3';
const byte  ASCII_4   = '4';
const byte  ASCII_5   = '5';
const byte  ASCII_6   = '6';
const byte  ASCII_7   = '7';
const byte  ASCII_8   = '8';
const byte  ASCII_9   = '9';
const byte  ASCII_COLON            = ':';
const byte  ASCII_SEMICOLON        = ';';
const byte  ASCII_LESSTHAN         = '<';
const byte  ASCII_EQUALS           = '=';
const byte  ASCII_GREATERTHAN      = '>';
const byte  ASCII_QUESTIONMARK     = '?';
const byte  ASCII_ATSIGN           = '@';
const byte  ASCII_A   = 'A';
const byte  ASCII_B   = 'B';
const byte  ASCII_C   = 'C';
const byte  ASCII_D   = 'D';
const byte  ASCII_E   = 'E';
const byte  ASCII_F   = 'F';
const byte  ASCII_G   = 'G';
const byte  ASCII_H   = 'H';
const byte  ASCII_I   = 'I';
const byte  ASCII_J   = 'J';
const byte  ASCII_K   = 'K';
const byte  ASCII_L   = 'L';
const byte  ASCII_M   = 'M';
const byte  ASCII_N   = 'N';
const byte  ASCII_O   = 'O';
const byte  ASCII_P   = 'P';
const byte  ASCII_Q   = 'Q';
const byte  ASCII_R   = 'R';
const byte  ASCII_S   = 'S';
const byte  ASCII_T   = 'T';
const byte  ASCII_U   = 'U';
const byte  ASCII_V   = 'V';
const byte  ASCII_W   = 'W';
const byte  ASCII_X   = 'X';
const byte  ASCII_Y   = 'Y';
const byte  ASCII_Z   = 'Z';
const byte  ASCII_LEFTBRACKET      = '[';
const byte  ASCII_BACKSLASH        = '\';
const byte  ASCII_RIGHTBRACKET     = ']';
const byte  ASCII_CARAT            = '^';
const byte  ASCII_CARROT           = '^';
const byte  ASCII_UNDERSCORE       = '_';
const byte  ASCII_BACKAPOSTROPHE   = '`';
const byte  ASCII_a = 'a';
const byte  ASCII_b = 'b';
const byte  ASCII_c = 'c';
const byte  ASCII_d = 'd';
const byte  ASCII_e = 'e';
const byte  ASCII_f = 'f';
const byte  ASCII_g = 'g';
const byte  ASCII_h = 'h';
const byte  ASCII_i = 'i';
const byte  ASCII_j = 'j';
const byte  ASCII_k = 'k';
const byte  ASCII_l = 'l';
const byte  ASCII_m = 'm';
const byte  ASCII_n = 'n';
const byte  ASCII_o = 'o';
const byte  ASCII_p = 'p';
const byte  ASCII_q = 'q';
const byte  ASCII_r = 'r';
const byte  ASCII_s = 's';
const byte  ASCII_t = 't';
const byte  ASCII_u = 'u';
const byte  ASCII_v = 'v';
const byte  ASCII_w = 'w';
const byte  ASCII_x = 'x';
const byte  ASCII_y = 'y';
const byte  ASCII_z = 'z';
const byte  ASCII_LEFTBRACE        = '{';
const byte  ASCII_VERTICALBAR      = '|';
const byte  ASCII_OR               = '|';
const byte  ASCII_RIGHTBRACE       = '}';
const byte  ASCII_TILDE            = '~';
const byte  ASCII_DEL = 127;


/*==========================================================================*/
/*                                                                          */
/* ASCII Validation Functions and Macros                                    */
/*                                                                          */
/* The following implementation of isascii style macros are based upon the  */
/* lookup table model introduced by J.E. Hendrix in the Small C Compiler    */
/* book.  The macros, table and implementations have all been changed,      */
/* however, the methodology bases itself on simplified early C programming  */
/* habits of optimizations in the representation of even the most basic     */
/* algorithms and functions.                                                */
/*                                                                          */
/*==========================================================================*/

/* REMOVE #define for _ASCII_MACROS at top for turning these off!           */
#ifdef _ASCII_MACROS


#define ASCII_ALNUM     1
#define ASCII_ALPHA     2
#define ASCII_CNTRL     4
#define ASCII_DIGIT     8
#define ASCII_GRAPH    16
#define ASCII_LOWER    32
#define ASCII_PRINT    64
#define ASCII_PUNCT   128
#define ASCII_BLANK   256
#define ASCII_UPPER   512
#define ASCII_XDIGIT 1024

/*==========================================================================*/
/*                                                                          */
/* Each bit position within the table represents a different ASCII type for */
/* lookup.  The input character is used as an index and the #define from    */
/* above is used as a mask to determine if the character matches the type   */
/* of character being checked.  The approach is designed to be optimized in */
/* that everything is a macro not introducing function calls, however, the  */
/* trade-off of the bitwise and, &, operation was used to avoid a unique    */
/* table for each character type, although that would have been one opcode  */
/* faster.  While there are only 256 character entries, a int is used to    */
/* represent the bits since there are more than 8 character types.          */
/*                                                                          */
/*==========================================================================*/

const int ASCII_TABLE[256] =
{
0x0004, 0x0004, 0x0004, 0x0004, 0x0004, 0x0004, 0x0004, 0x0004,
0x0004, 0x0104, 0x0104, 0x0104, 0x0104, 0x0104, 0x0004, 0x0004,
0x0004, 0x0004, 0x0004, 0x0004, 0x0004, 0x0004, 0x0004, 0x0004,
0x0004, 0x0004, 0x0004, 0x0004, 0x0004, 0x0004, 0x0004, 0x0004,
0x0140, 0x00D0, 0x00D0, 0x00D0, 0x00D0, 0x00D0, 0x00D0, 0x00D0,
0x00D0, 0x00D0, 0x00D0, 0x00D0, 0x00D0, 0x00D0, 0x00D0, 0x00D0,
0x0459, 0x0459, 0x0459, 0x0459, 0x0459, 0x0459, 0x0459, 0x0459,
0x0459, 0x0459, 0x00D0, 0x00D0, 0x00D0, 0x00D0, 0x00D0, 0x00D0,
0x00D0, 0x0653, 0x0653, 0x0653, 0x0653, 0x0653, 0x0653, 0x0253,
0x0253, 0x0253, 0x0253, 0x0253, 0x0253, 0x0253, 0x0253, 0x0253,
0x0253, 0x0253, 0x0253, 0x0253, 0x0253, 0x0253, 0x0253, 0x0253,
0x0253, 0x0253, 0x0253, 0x00D0, 0x00D0, 0x00D0, 0x00D0, 0x00D0,
0x00D0, 0x0473, 0x0473, 0x0473, 0x0473, 0x0473, 0x0473, 0x0073,
0x0073, 0x0073, 0x0073, 0x0073, 0x0073, 0x0073, 0x0073, 0x0073,
0x0073, 0x0073, 0x0073, 0x0073, 0x0073, 0x0073, 0x0073, 0x0073,
0x0073, 0x0073, 0x0073, 0x00D0, 0x00D0, 0x00D0, 0x00D0, 0x0004,

0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
};

#define ISALNUM(c)  ((bool) (ASCII_TABLE[(byte) c] & ASCII_ALNUM))  /* 'a'-'z', 'A'-'Z', '0'-'9' */
#define ISALPHA(c)  ((bool) (ASCII_TABLE[(byte) c] & ASCII_ALPHA))  /* 'a'-'z', 'A'-'Z' */
#define ISACNTRL(c) ((bool) (ASCII_TABLE[(byte) c] & ASCII_CNTRL))  /* 0-31, 127 */
#define ISDIGIT(c)  ((bool) (ASCII_TABLE[(byte) c] & ASCII_DIGIT))  /* '0'-'9' */
#define ISGRAPH(c)  ((bool) (ASCII_TABLE[(byte) c] & ASCII_GRAPH))  /* '!'-'~' */
#define ISLOWER(c)  ((bool) (ASCII_TABLE[(byte) c] & ASCII_LOWER))  /* 'a'-'z' */
#define ISPRINT(c)  ((bool) (ASCII_TABLE[(byte) c] & ASCII_PRINT))  /* ' '-'~' */
#define ISPUNCT(c)  ((bool) (ASCII_TABLE[(byte) c] & ASCII_PUNCT))  /* !alnum && !cntrl && !space */
#define ISSPACE(c)  ((bool) (ASCII_TABLE[(byte) c] & ASCII_BLANK))  /* HT, LF, VT, FF, CR, ' ' */
#define ISUPPER(c)  ((bool) (ASCII_TABLE[(byte) c] & ASCII_UPPER))  /* 'A'-'Z' */
#define ISDIGIT(c)  ((bool) (ASCII_TABLE[(byte) c] & ASCII_XDIGIT)) /* '0'-'9', 'a'-'f', 'A'-'F' */

/*==========================================================================*/
/*                                                                          */
/* isAscii - Returns Boolean true or false as per cloudshield.ph            */
/*           Follows macro function naming for sync with above.             */
/*                                                                          */
/*==========================================================================*/
bool isAscii(byte c)
{
if (c < 128)
   {
     return true;
   }
else
   {
     return false;
   };
}

/*==========================================================================*/
/*                                                                          */
/* atoi - The atoi function takes in a single parameter that is the offset  */
/*        into the packet pointing to the *FIRST* digit in the integer      */
/*        value.  The function will output a single 32-bit local variable   */
/*        containing the converted value.                                   */
/*                                                                          */
/*  The function will process up to 10 characters and expects that          */
/*              the format is well formed and the first non-digit character */
/*              is a termination marker. Commas and other separators will   */
/*              terminate processing.  The packet will not be modified.     */
/*                                                                          */
/*==========================================================================*/
int atoi( int pktIdx )
{
  int iRetVal = 0;
  int numDigits = 0;

  while ( ++numDigits < 10 &&
      pkt[pktIdx] <= '9' && pkt[pktIdx] >= '0' )
  {
    iRetVal = (iRetVal * 10) + (int)(pkt[pktIdx] - '0');
    ++pktIdx;
  }

  return iRetVal;
}


#endif  /* _ASCII_MACROS  */


//===================== END of ASCII =========================================

#endif /* ASCII_PH_ */