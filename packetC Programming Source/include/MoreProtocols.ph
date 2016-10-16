//==============================================================================
//  moreprotocols.ph – Network protocol constants for use with descriptors.
//
//   Provide Pre-Defined constants and other definitions for the purpose of
//   simplifying of access to bit fields and other interesting combinations.
//               
//   Definitions will start with PROTO and be followed by the layer information
//   such as TCP then a name for the field.
//
//   Note that many elements are specified as define statements such that they
//   can be used as a constant parameter for 8, 16 and 32 bit functions without
//   type checking issues.
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
#ifndef MORE_PROTOCOLS_PH
#define MORE_PROTOCOLS_PH
#define _MORE_PROTOCOLS_PH 1.01

//======================================
//======== IP TOS / PRECEDENCE =========
//======================================

// Mask off the Top 3 Bits to Get Precedence
const byte PROTO_IP_PRECEDENCE_MASK            = 0xE0;

// Use the Following as Comparisons against Byte for Top 3 Bits
// Note that Precedence is a Field, Not Bit Settings
const byte PROTO_IP_PRECEDENCE_ROUTINE         = 0x00;
const byte PROTO_IP_PRECEDENCE_NORMAL          = 0x00;
const byte PROTO_IP_PRECEDENCE_PRIORITY        = 0x20;
const byte PROTO_IP_PRECEDENCE_IMMEDIATE       = 0x40;
const byte PROTO_IP_PRECEDENCE_FLASH           = 0x60;
const byte PROTO_IP_PRECEDENCE_FLASHOVERRIDE   = 0x80;
const byte PROTO_IP_PRECEDENCE_CRITICAL        = 0xA0;
const byte PROTO_IP_PRECEDENCE_INTERNETWORK    = 0xC0;
const byte PROTO_IP_PRECEDENCE_NETWORKCONTROL  = 0xE0;
const byte PROTO_IP_PRECEDENCE_NETWORK_CONTROL = 0xE0;


// Mask off the Lower 5 Bits to Get TOS Bits Only
const byte PROTO_IP_TOS_MASK                   = 0x1F;

// Type of Service Bit Fields
// DELAY - when set to '1' the packet requests low delay.
const byte PROTO_IP_TOS_DELAY                  = 0x10;

// Throughout - when set to '1' the packet requests high throughput.
const byte PROTO_IP_TOS_THROUGHPUT             = 0x08;

// Reliability - when set to '1' the packet requests high reliability.
const byte PROTO_IP_TOS_RELIABILITY            = 0x04;

// Cost - when set to '1' the packet has a low cost.
const byte PROTO_IP_TOS_COST                   = 0x02;

// MBZ - Checking Bit
const byte PROTO_IP_TOS_MBZ                    = 0x01;

//======================================
//====== IP OPTION FIELD DECODING ======
//======================================

// Copied Flag Bit Specifies Options Relationship to Fragmented Datagrams
//   0 - Option IS NOT copied to each fragmented datagram.
//   1 - Option IS copied to fragmented datagrams.
const byte PROTO_IP_OPTION_FLAG                = 0x80;

// If IP Option Class Field is 2, it is a TimeStamp Packet
const byte PROTO_IP_OPTION_TIMESTAMP           = 0x40;
const byte PROTO_IP_OPTION_CLASS_TIMESTAMP     = 0x40;

// Mask off the Class Field
const byte PROTO_IP_OPTION_CLASS_MASK          = 0x60;

// Mask off the Option Number Field
const byte PROTO_IP_OPTION_NUMBER_MASK         = 0x1F;

// The IP Option Number Specifies Format and Usage of IP Options
// Refer to RFCs for Details.  Common Numbers are Listed:
//   0 - Indicates End of Option List.  If present, No Length or Data Present
//   1 - No Operation, If present, No Length or Data Present
//   2 - Security the length is 11 octets and the various security codes
//       can be found in RFC 791.
//   3 - Loose Source Routing
//   4 - Internet Timestamp
//   7 - Record Route
//   8 - Stream ID - Length of 4 Bytes.
//   9 - Strict Source Routing
const byte PROTO_IP_OPTION_NUMBER_END          = 0x00;
const byte PROTO_IP_OPTION_END                 = 0x00;
const byte PROTO_IP_OPTION_NUMBER_NOP          = 0x01;
const byte PROTO_IP_OPTION_NOP                 = 0x01;
const byte PROTO_IP_OPTION_NUMBER_TIMESTAMP    = 0x04;

const byte PROTO_IP_OPTION_NUMBER_RECORDROUTE  = 0x07;
const byte PROTO_IP_OPTION_RECORDROUTE         = 0x07;


//======================================
//=========== TCP FLAGS ================
//======================================

// Mask Off TCP Flag Bits
const byte PROTO_TCP_FLAGS_MASK   = 0x1F;

// URG - Urgent Pointer Field Significant
const byte PROTO_TCP_FLAGS_URG    = 0x20;
const byte PROTO_TCP_URG          = 0x20;

// ACK - Acknowledgment Field Significant
const byte PROTO_TCP_FLAGS_ACK    = 0x10;
const byte PROTO_TCP_ACK          = 0x10;

// PSH - Push Function Requested, pass data to application as soon as possible
const byte PROTO_TCP_FLAGS_PSH    = 0x08;
const byte PROTO_TCP_PSH          = 0x08;
const byte PROTO_TCP_FLAGS_PUSH   = 0x08;
const byte PROTO_TCP_PUSH         = 0x08;

// RST - Reset the Connection
const byte PROTO_TCP_FLAGS_RST    = 0x04;
const byte PROTO_TCP_RST          = 0x04;
const byte PROTO_TCP_FLAGS_RESET  = 0x04;
const byte PROTO_TCP_RESET        = 0x04;

// SYN - Syncronize Sequence Numbers
const byte PROTO_TCP_FLAGS_SYN    = 0x02;
const byte PROTO_TCP_SYN          = 0x02;

// FIN - No More Data From Sender - Finish Session
const byte PROTO_TCP_FLAGS_FIN    = 0x01;
const byte PROTO_TCP_FIN          = 0x01;

//======================================
//=========== WELL KNOWN PORTS =========
//======================================

const short PROTO_PORT_FTP_DATA      = 20;
const short PROTO_PORT_FTP           = 21;
const short PROTO_PORT_FTP_CONTROL   = 21;
const short PROTO_PORT_SSH           = 22;
const short PROTO_PORT_TELNET        = 23;
const short PROTO_PORT_SMTP          = 25;
const short PROTO_PORT_DNS           = 53;
const short PROTO_PORT_BIND          = 53;
const short PROTO_PORT_TFTP          = 69;
const short PROTO_PORT_WWW           = 80;
const short PROTO_PORT_HTTP          = 80;
const short PROTO_PORT_POP           = 110;
const short PROTO_PORT_POP3          = 110;
const short PROTO_PORT_PORTMAPPER    = 111;
const short PROTO_PORT_NNTP          = 119;
const short PROTO_PORT_NTP           = 123;
const short PROTO_PORT_SNMP          = 161;
const short PROTO_PORT_SNMP_TRAP     = 162;
const short PROTO_PORT_BGP           = 179;
const short PROTO_PORT_IRC           = 194;
const short PROTO_PORT_IMAP3         = 220;
const short PROTO_PORT_IMAP          = 220;
const short PROTO_PORT_LDAP          = 389;
const short PROTO_PORT_HTTPS         = 443;
const short PROTO_PORT_DHCP_CLIENT   = 546;
const short PROTO_PORT_DHCP_SERVER   = 547;
const short PROTO_PORT_NDM_REQUEST   = 1363;  // Peder's Mark on Well Known Ports!
const short PROTO_PORT_NDM_SERVER    = 1364;  // Peder's Mark on Well Known Ports!
const short PROTO_PORT_NFS           = 2049;

#endif /* MORE_PROTOCOLS_PH */