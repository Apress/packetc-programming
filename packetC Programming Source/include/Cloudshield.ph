//==============================================================================
//  cloudshield.ph - packetC standard include for CloudShield platforms.
//
//    This packetC standard include file defines platform specific structures
//    related to intrinsic functionality within the language.  In addition, 
//    structures and data types that are built into the compiler are provided
//    in this document as comments to enable programmers to understand and 
//    validate types.
//
// author
//    cloudshield.com
//
// version
//    $Revision: 1.10 $
//	
// copyright notice
//    � 2009-2011 CloudShield Technologies, Inc.
//
//==============================================================================
#ifndef CLOUDSHIELD_PH
#define CLOUDSHIELD_PH
#define _CLOUDSHIELD_PH_VERSION 1.02
#define __PACKETC__ TRUE


//==============================================================================
//  PacketAction Enumerated Type
//
//  Used with action in $PIB to define what to do with packet at end of main().
//
//==============================================================================
// enum int PacketAction
// {
//   DROP_PACKET    = 0,
//   FORWARD_PACKET = 1,
//   REQUEUE_PACKET = 2
// };


//==============================================================================
//  Layer Type Enumerations
//
//  L2Type, L3Type and L4Type are used by the $PIB to describe current packet.
//
//==============================================================================
// enum int L2Type 
// {
//   L2TYPE_OTHER                  = 0,
//   L2TYPE_SONET_PPP              = 1,
//   L2TYPE_SONET_HDLC             = 2,
//   L2TYPE_SONET_HDLC_PPP_MPLS    = 17,
//   L2TYPE_SONET_HDLC_MPLS        = 18,
//   L2TYPE_ETHII                  = 3,
//   L2TYPE_ETHII_MPLS             = 19,
//   L2TYPE_ETHII_8021Q            = 35,
//   L2TYPE_ETHII_8021Q_MPLS       = 51,
//   L2TYPE_802_3_SNAP_MPLS        = 21,
//   L2TYPE_802_3_SNAP_802_1Q      = 37,
//   L2TYPE_802_3_SNAP_802_1Q_MPLS = 53,
//   L2TYPE_802_3                  = 4,
//   L2TYPE_802_3_MPLS             = 20,
//   L2TYPE_802_3_SNAP             = 5,
//   L2TYPE_802_3_802_1Q           = 36
// };
// 
// enum int L3Type
// {
//   L3TYPE_OTHER = 0,
//   L3TYPE_IPV4  = 1,
//   L3TYPE_IPV6  = 2,
//   L3TYPE_ARP   = 3,
//   L3TYPE_RARP  = 4,
//   L3TYPE_IPX   = 5
// };
// 
// enum int L4Type
// {
//   L4TYPE_OTHER  = 0,
//   L4TYPE_TCP    = 1,
//   L4TYPE_UDP    = 2,
//   L4TYPE_ICMP   = 3,
//   L4TYPE_ICMPV6 = 4,
//   L4TYPE_ESP    = 5,
//   L4TYPE_AH     = 6,
//   L4TYPE_GRE    = 7,
//   L4TYPE_SCTP   = 8
// };


//==============================================================================
//  Packet Information Block
//
//  The typedef for structure $PIB is instantiated as pib and delivered as a 
//  parameter to main() containing information about the current packet.
//  The pib acts as both an input structure as well as the end state of the pib
//  determines actions to be taken against the packet at the end of main().
//
//==============================================================================
// struct $PIB 
// {
//   PacketAction	action;
//   int		logAccelTarget;
//   int		length;
//   bits int  
//   {
//     replica           : 1;
//     l3CheckSumValid   : 1;
//     l3CheckSumRecalc  : 1;
//     l4CheckSumValid   : 1;
//     l4CheckSumRecalc  : 1;
//     ipv6Fragment      : 1;
//     ipv4              : 1;
//     ipv6              : 1;
//     logAccelReplicate : 1;
//     logAccelModify    : 1;
//     logAccelMethod    : 1;
//     logAccelDatasize  : 1;
//     mpls              : 1;
//     vlan              : 1;
//     FASTDidMatch      : 1;
//     pad               : 17;
//   } flags;
//   L2Type		l2Type;
//   L3Type		l3Type;
//   L4Type		l4Type;
//   int		  l2Offset;
//   int		  mplsOffset;
//   int		  l3Offset;
//   int		  l4Offset;
//   int      payloadOffset;
//   int      FASTAssocData;
//   int      FASTModRule;
//   int      FASTFlowID;
// };


//==============================================================================
//  Message Group Levels
//
//  The MessageGroup enumerated type is used to set a severity level for a log()
//  message.  This field can be set once in a context and all future events that
//  are generated during the processing of the packet will utilize this value.
//  The $SYS structure utilized MessageGroup with field messageGroup.
//
//==============================================================================
// enum int MessageGroup
// {
//   MSG_CRITICAL = 1,
//   MSG_MAJOR    = 2,
//   MSG_MINOR    = 3,
//   MSG_WARNING  = 4,
//   MSG_INFO     = 5
// };


//==============================================================================
//  Message Constants
//
//  The following constants provide a maximum message number and length for a 
//  log() message generated by the packetC system.  Use in conjunction with the
//  messageId field in $SYS.
//
//==============================================================================
// const int MAX_PACKETC_MSGS    = 255;
// const int MAX_PACKETC_MSG_LEN = 80;

//==============================================================================
//  Time Construct Structure
//
//  This structure is used to represent the 64-bit fields used in time elements 
//  of the $SYS structure.  For ticks this is the upper and lower 32-bits of a 
//  64-bit counter.  For UTC Time values, this relates to the seconds (high) and
//  microseconds (low) since UTC (1/1/1970) in a single 64-bit structure.
//
//  This structure replaced XTime structure from cloudshield.ph version 1.00
//
//==============================================================================
// struct Time64 {
//   int highOrder;
//   int lowOrder;
// };

//==============================================================================
//  System Information
//
//  The typedef for structure $SYS is instantiated as sys and delivered as a 
//  parameter to main() containing information about the current system.
//  The system information structure, sys, acts as both a source of information
//  about the system the packetC is operating on as well as system level 
//  that may affect choices in processing.  In particular this structure 
//  data about the physical interface packets were received on an whether this
//  is an Ethernet or SONET system.  Some attributes may affect the system's 
//  processing of operations as well as provide real-time information about the
//  system that may change during the processing of a packet.
//
//  This release (v1.01) of cloudshield.ph introduces UTC time support.  Note 
//  the change of the old xtime(now ticksL in struct time) and time(now ticks).  
//
//==============================================================================
// struct $SYS 
// {
//   int           messageId;
//   MessageGroup  messageGroup;
//   int           inPort;
//   int           outPort;
//   int           context;
//   int           ticks;
//   struct Time64Values {   
//                        Time64  ticksL;
//                        Time64  utcTime;
//                        Time64  utcTimeUncorrected;
//                        Time64  utcTimeDrift;   
//                       } time; 
//   int           bufferCount;
//   int           queueDepth;
//   int           logFailures;
//   bits int  
//   {
//     sonet : 1;
//     pad   : 31;
//   } flags;
//   int           requeueCount;
//   int           tcsFlow;
//   int           tcsRule;
//   int           outBlade;
//   int           inBlade;
//   int           replicatePort;
//   int           replicateBlade;
// };


//==============================================================================
//  Search Results Structure
//
//  When a match or find operator is used on a search set, a structure is then
//  returned with the result.  This structure is the typedef for that result.
//
//==============================================================================
// struct SearchResult
// {
//   int   index;
//   int   position;
// };


//==============================================================================
//  Exception Constants
//
//  Try catch based exception handlers are core to packetC.  There are a set of 
//  pre-defined exceptions for intrinsic operators to packetC.  The section 
//  of exception constants below are what is implemented in the associated 
//  packetC compiler.
//
//==============================================================================
// typedef int Exception;
// const Exception		ERR_ANY_EXCEPTION   = 0;
// const Exception		ERR_DB_FULL         = 1;
// const Exception		ERR_DB_READ         = 2;
// const Exception		ERR_DB_NOMATCH      = 3;
// const Exception		ERR_PKT_INSERT      = 4;
// const Exception		ERR_PKT_DELETE      = 5;
// const Exception		ERR_PKT_NOREPLICATE = 6;
// const Exception		ERR_SET_NOMATCH     = 7;
// const Exception		ERR_SET_NOPERFORM   = 8;
// const Exception		ERR_SET_NOTFOUND    = 9;
// const Exception		ERR_PKT_NOTREQUEUED = 10;

//==============================================================================
//  User Defined Exception Constants
//
//  packetC users can create their own exceptions constants to throw by using
//  the ERR_LAST_DEFINED constant.
//
//     const Exception   ERR_MY_EXCEPTION  = ERR_LAST_DEFINED + 1
//
//==============================================================================
// const Exception		ERR_LAST_DEFINED    = 64;

//==============================================================================
//  Packet Type 
//
//  Each system may have a slightly different constraint on the buffer for each
//  packet.  The typedef below defines the $PACKET for the system. 
//
//==============================================================================
// typedef byte $PACKET[9 * 1024 - 1];


//==============================================================================
//  Truth Constants
//
//  In packetC no boolean types exist, however, true and false are pre-defined.
//  To enforce consistency and strict type matching, bool is defined.
//
//==============================================================================
// const int true  = 1;
// const int false = 0;
typedef int bool;

//==============================================================================
//  Search Set Constants
//
//  Null is a valid value in strings and regular expressions.  Constants are
//  pre-defined for these values.
//
//==============================================================================
// const byte NULL_STOP[1]  = "\x00";
// const byte NULL_REGEX[4] = ".*?\x00";

//==============================================================================
// Stream Buffer
//
// Our packetC implementation currently supports the 'buffer' qualifier for a
// single declaration; a predefined byte array, streambuffer[390*1000*1000],
// that provides a large special memory store that is fast, shared across 
// application copies and, possibly, volatile. 
//
// The stream buffer can be accessed by multiple packet application copies.  
// Access is not atomic so the user will have to provide locks to orchestrate
// access to this storage. Stream Buffer contents may be volatile if the user
// does not orchestrate access by multiple application copies.
//
// Variables stored in buffer memory are particularly well suited for network
// processing tasks that require large amounts of contiguous memory to be used
// by cooperating copies of a packet application. For example, buffer storage
// is advantageous for stream reassembly, in which multiple application copies
// assemble the contents of related packets in proper sequence, e.g., so that
// the collective payload can be scanned for items of interest.
//
//==============================================================================
// buffer byte streambuffer[390*1000*1000];

#endif

