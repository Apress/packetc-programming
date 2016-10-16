//==============================================================================
//  protocols.ph - packetC standard include for layer 2 through 4 headers.
//
//    Fundamental to packetC is the identification and processing of packet
//    headers using descriptors to map fields into a named reference model.
//    The descriptors in protocols.ph are intended to be a staple that all
//    programs share to ensure common naming of layer 2 through 4 header 
//    fields.  
//
// :NOTE: Not all layer 2 through 4 headers and layer 7 protocols are 
//       included in this file.
//
// author
//    cloudshield.com
//
// version
//    $Revision: 1.02 $
//
// copyright notice
//    © 2009-2011 CloudShield Technologies, Inc.
//
//==============================================================================
#ifndef PROTOCOLS_PH
#define PROTOCOLS_PH

// Header file versioning
const int PROTOCOLS_PH_VERSION_ = 1.0.2.0;
%pragma control PROTOCOLS_PH_VERSION_(export);

// Macros to allow recasting of enumerated fields to access 
// and compare them to scalar values. 
// :WARNING: You are bypassing type safety at this point.
#define  RAW_BYTE(x)   (byte)(x)
#define  RAW_SHORT(x)  (short)(x)
#define  RAW_INT(x)    (int)(x)

// Define a type that is used for IP addresses
// in the form of xxx.xxx.xxx.xxx  i.e. 192.168.0.101
typedef int IpAddress;

// Define a type that is used for MAC addresses 
// in the form of xx:xx:xx:xx:xx  i.e. 05:32:b1:f3:09
struct MacAddress
{
  byte b0, b1, b2, b3, b4, b5; 
};

//==============================================================================
//  Ethernet II Descriptor
//
//  Most common layer 2 Ethernet header utilized in networks, referred to as 
//  just Ethernet instead of Ethernet II due to common usage.
//
//==============================================================================
enum short EthernetType {
  ETHERNET_TYPE_IP              = 0x0800, // IPv4
  ETHERNET_TYPE_ARP             = 0x0806, // Address Resolution Protocol
  ETHERNET_TYPE_RARP            = 0x0835, // Reverse Address Resolution Protocol
  ETHERNET_TYPE_APPLETALK       = 0x809b, // AppleTalk (Ethertalk)
  ETHERNET_TYPE_AARP            = 0x80f3, // Appletalk ARP
  ETHERNET_TYPE_Novell_IPX      = 0x8137, // Novell IPX (alt)
  ETHERNET_TYPE_Novell          = 0x8138, // Novell
  ETHERNET_TYPE_MPLS_UNICAST    = 0x8847, // MPLS Unicast
  ETHERNET_TYPE_MPLS_MULTICAST  = 0x8848, // MPLS Multicast
  ETHERNET_TYPE_PPPoE_DISCOVERY = 0x8863, // PPPoE Discovery Stage  
  ETHERNET_TYPE_PPPoE_SESSION   = 0x8864, // PPPoE Session Stage
  ETHERNET_TYPE_8021Q           = 0x8100, // identifies IEEE 802.1Q tag
  ETHERNET_TYPE_8023            = 0x05dc, // <= 1500 (0x05DC) are 802.3
  ETHERNET_TYPE_IP6             = 0x86dd, // IPv6
  ETHERNET_TYPE_CLOUDSHIELD     = 0xC5C5,  // CloudShield Custom Frames 
  
  ETHERNET_TYPE_MASK            = 0x0000,
  ETHERNET_TYPE_NOMASK          = 0xFFFF
};

descriptor EthernetStruct
{
  MacAddress    destinationAddress; // MAC Address: i.e. 00:0B:A9:00:00:00
  MacAddress    sourceAddress;      //   ..
  EthernetType  type;               // Compare with ETHERNET_TYPE_xx
} ethernet at pib.l2Offset;

typedef byte EthernetStructBytes[sizeof(EthernetStruct)];

//==============================================================================
//  Ethernet II 802.1Q VLAN Descriptors (Single and Double VLAN Tagged)
//
//  802.1Q defines Ethernet headers with LAN segmentation in the layer 2 
//  Ethernet header that is also utilized in WAN deployments for aggregation and
//  virtual LAN services.  VLAN tags are at the end of the standard Ethernet II
//  header and are denoted by a type field of 0x8100.  Following the last tag 
//  should be a standard type field containing a value such as 0x0800 to 
//  describe the encapsulated data.
//
//  An 802.1Q frame also contains User Priority information, 8 possible values,
//  which are part of 802.1P standards.  The VLAN ID will generally be 0 when
//  the frame is intended as an 802.1P frame.
//
//==============================================================================
#define ETHERNET8021Q_VLANDID_PRIORITY 0x000    /* vlanId = 0 is 802.1p   */
#define ETHERNET8021Q_VLANDID_RESERVED 0xfff    /* vlanId = 4095 reserved */

struct VlanTag
{
  EthernetType  type;     // ETHERNET_TYPE_8021Q = 0x8100
  bits short
  {
    userPriority    :  3;   // 802.1p Priority Field
    formatIndicator :  1;   // Must be 0 for Ethernet
    vlanId          : 12;   // 802.1q VLAN Tag Identification
  } tag;
}; 

descriptor Ethernet8021QStruct
{
  MacAddress    destinationAddress; // MAC Address: i.e. 00:0B:A9:00:00:00
  MacAddress    sourceAddress;      //    ..
  VlanTag       vlan;               // VLAN tag
  EthernetType  type;               // Type for payload, not ETHERNET_TYPE_8021Q
} ethernet8021Q at pib.l2Offset;

typedef byte Ethernet8021QStructBytes[sizeof(Ethernet8021QStruct)];

descriptor Ethernet8021QQStruct
{
  MacAddress    destinationAddress; // MAC Address: i.e. 00:0B:A9:00:00:00
  MacAddress    sourceAddress;      //   ..
  VlanTag       outerVlan;          // Outer VLAN tag
  VlanTag       innerVlan;          // Inner VLAN tag
  EthernetType  type;               // Type for payload, not ETHERNET_TYPE_8021Q
} ethernet8021QQ at pib.l2Offset;

typedef byte Ethernet8021QQStructBytes[sizeof(Ethernet8021QQStruct)];

//==============================================================================
//  Ethernet 802.3 Descriptor
//
//  Common original layer 2 Ethernet header utilized in networks.  The length
//  field <= 1500 signifies 802.3 versus a value > 1500 signifies this is the 
//  type field and is not 802.3 but rather a newer Ethernet II header.
//
//==============================================================================

descriptor Ethernet8023Struct
{
  MacAddress  destinationAddress; // MAC Address: i.e. 00:0B:A9:00:00:00
  MacAddress  sourceAddress;      //   .. 
  short       length;             // Must be <= ETHERNET_TYPE_8023 (1500) length.
} ethernet8023 at pib.l2Offset;

typedef byte Ethernet8023StructBytes[sizeof(Ethernet8023Struct)];

//==============================================================================
//  Standard IPv4 Descriptor
//
//  Most common layer 3 IP header utilized in networks.  Descriptions taken 
//  from RFC 791.
//
//==============================================================================

enum byte IpProtocol {
// --------------------
//  Common Protocols
// --------------------
  IP_PROTOCOL_ICMP        = 0x01,  // Internet Control Message Protocol   
                                   //   RFC 792
  IP_PROTOCOL_IGMP        = 0x02,  // Internet Group Management Protocol  
                                   //   RFC 1112
  IP_PROTOCOL_TCP         = 0x06,  // Transmission Control Protocol   
                                   //   RFC 793
  IP_PROTOCOL_UDP         = 0x11,  // User Datagram Protocol  
                                   //   RFC 768
  IP_PROTOCOL_IPV6        = 0x29,  // IPv6 (encapsulation)  
                                   //   RFC 2473
  IP_PROTOCOL_OSPF        = 0x59,  // Open Shortest Path First  
                                   //   RFC 1583
  IP_PROTOCOL_SCTP        = 0x84,  // Stream Control Transmission Protocol  

// ------------------------
//  Other Known Protocols
// ------------------------
  IP_PROTOCOL_HOPOPT      = 0x00,  // IPv6 Hop-by-Hop Option  RFC 2460
  IP_PROTOCOL_GGP         = 0x03,  // Gateway-to-Gateway Protocol   RFC 823
  IP_PROTOCOL_IP          = 0x04,  // IP in IP (encapsulation)  RFC 2003
  IP_PROTOCOL_ST          = 0x05,  // Internet Stream Protocol  RFC 1190, 
                                   //   RFC 1819
  IP_PROTOCOL_CBT         = 0x07,  // Core-based trees  RFC 2189
  IP_PROTOCOL_EGP         = 0x08,  // Exterior Gateway Protocol   RFC 888
  IP_PROTOCOL_IGP         = 0x09,  // Interior Gateway Protocol (any private 
                                   //   interior gateway (used by Cisco for 
                                   //   their IGRP))   
  IP_PROTOCOL_BBN_RCC_MON = 0x0A,  // BBN RCC Monitoring  
  IP_PROTOCOL_NVP_II      = 0x0B,  // Network Voice Protocol  RFC 741
  IP_PROTOCOL_PUP         = 0x0C,  // Xerox PUP   
  IP_PROTOCOL_ARGUS       = 0x0D,  // ARGUS   
  IP_PROTOCOL_EMCON       = 0x0E,  // EMCON   
  IP_PROTOCOL_XNET        = 0x0F,  // Cross Net Debugger  IEN 158
  IP_PROTOCOL_CHAOS       = 0x10,  // Chaos   
  IP_PROTOCOL_MUX         = 0x12,  // Multiplexing  IEN 90
  IP_PROTOCOL_DCN_MEAS    = 0x13,  // DCN Measurement Subsystems  
  IP_PROTOCOL_HMP         = 0x14,  // Host Monitoring Protocol  RFC 869
  IP_PROTOCOL_PRM         = 0x15,  // Packet Radio Measurement  
  IP_PROTOCOL_XNS_IDP     = 0x16,  // XEROX NS IDP  
  IP_PROTOCOL_TRUNK_1     = 0x17,  // Trunk-1   
  IP_PROTOCOL_TRUNK_2     = 0x18,  // Trunk-2   
  IP_PROTOCOL_LEAF_1      = 0x19,  // Leaf-1  
  IP_PROTOCOL_LEAF_2      = 0x1A,  // Leaf-2  
  IP_PROTOCOL_RDP         = 0x1B,  // Reliable Datagram Protocol  RFC 908
  IP_PROTOCOL_IRTP        = 0x1C,  // Internet Reliable Transaction Protocol  
                                   //   RFC 938
  IP_PROTOCOL_ISO_TP4     = 0x1D,  // ISO Transport Protocol Class 4  RFC 905
  IP_PROTOCOL_NETBLT      = 0x1E,  // Bulk Data Transfer Protocol   RFC 998
  IP_PROTOCOL_MFE_NSP     = 0x1F,  // MFE Network Services Protocol   
  IP_PROTOCOL_MERIT_INP   = 0x20,  // MERIT Internodal Protocol   
  IP_PROTOCOL_DCCP        = 0x21,  // Datagram Congestion Control Protocol  
                                   //   RFC 4340
  IP_PROTOCOL_3PC         = 0x22,  // Third Party Connect Protocol  
  IP_PROTOCOL_IDPR        = 0x23,  // Inter-Domain Policy Routing Protocol  
                                   //   RFC 1479
  IP_PROTOCOL_XTP         = 0x24,  // Xpress Transport Protocol   
  IP_PROTOCOL_DDP         = 0x25,  // Datagram Delivery Protocol  
  IP_PROTOCOL_IDPR_CMTP   = 0x26,  // IDPR Control Message Transport Protocol   
  IP_PROTOCOL_TPPP        = 0x27,  // TP++ Transport Protocol   
  IP_PROTOCOL_IL          = 0x28,  // IL Transport Protocol   
  IP_PROTOCOL_SDRP        = 0x2A,  // Source Demand Routing Protocol  
  IP_PROTOCOL_IPV6_ROUTE  = 0x2B,  // Routing Header for IPv6   RFC 2460
  IP_PROTOCOL_IPV6_FRAG   = 0x2C,  // Fragment Header for IPv6  RFC 2460
  IP_PROTOCOL_IDRP        = 0x2D,  // Inter-Domain Routing Protocol   
  IP_PROTOCOL_RSVP        = 0x2E,  // Resource Reservation Protocol   RFC 2205
  IP_PROTOCOL_GRE         = 0x2F,  // Generic Routing Encapsulation   
  IP_PROTOCOL_MHRP        = 0x30,  // Mobile Host Routing Protocol  
  IP_PROTOCOL_BNA         = 0x31,  // BNA   
  IP_PROTOCOL_ESP         = 0x32,  // Encapsulating Security Payload  RFC 2406
  IP_PROTOCOL_AH          = 0x33,  // Authentication Header   RFC 2402
  IP_PROTOCOL_I_NLSP      = 0x34,  // Integrated Net Layer Security Protocol  
                                   //   TUBA
  IP_PROTOCOL_SWIPE       = 0x35,  // SwIPe   IP with Encryption
  IP_PROTOCOL_NARP        = 0x36,  // NBMA Address Resolution Protocol  
                                   //   RFC 1735
  IP_PROTOCOL_MOBILE      = 0x37,  // IP Mobility (Min Encap)   RFC 2004
  IP_PROTOCOL_TLSP        = 0x38,  // Transport Layer Security Protocol (using 
                                   //   Kryptonet key management)  
  IP_PROTOCOL_SKIP        = 0x39,  // Simple Key-Management for Internet 
                                   //   Protocol   RFC 2356
  IP_PROTOCOL_IPV6_ICMP   = 0x3A,  // ICMP for IPv6   RFC 4443, RFC 4884
  IP_PROTOCOL_IPV6_NONTX  = 0x3B,  // No Next Header for IPv6   RFC 2460
  IP_PROTOCOL_IPV6_OPTS   = 0x3C,  // Destination Options for IPv6  RFC 2460
  IP_PROTOCOL_ANY_HOST_INTERNAL = 0x3D, // Any host internal protocol  
  IP_PROTOCOL_CFTP        = 0x3E,  // CFTP  
  IP_PROTOCOL_ANY_LOCAL_NETWORK = 0x3F, // Any local network   
  IP_PROTOCOL_SAT_EXPAK   = 0x40,  // SATNET and Backroom EXPAK   
  IP_PROTOCOL_KRYPTOLAN   = 0x41,  // Kryptolan   
  IP_PROTOCOL_RVD         = 0x42,  // MIT Remote Virtual Disk Protocol  
  IP_PROTOCOL_IPPC        = 0x43,  // Internet Pluribus Packet Core   
  IP_PROTOCOL_ANY_DISTRIBUTED_FILESYSTEM  = 0x44,// Any distributed file system   
  IP_PROTOCOL_SAT_MON     = 0x45,  // SATNET Monitoring   
  IP_PROTOCOL_VISA        = 0x46,  // VISA Protocol   
  IP_PROTOCOL_IPCV        = 0x47,  // Internet Packet Core Utility  
  IP_PROTOCOL_CPNX        = 0x48,  // Computer Protocol Network Executive   
  IP_PROTOCOL_CPHB        = 0x49,  // Computer Protocol Heart Beat  
  IP_PROTOCOL_WSN         = 0x4A,  // Wang Span Network   
  IP_PROTOCOL_PVP         = 0x4B,  // Packet Video Protocol   
  IP_PROTOCOL_BR_SAT_MON  = 0x4C,  // Backroom SATNET Monitoring  
  IP_PROTOCOL_SUN_ND      = 0x4D,  // SUN ND PROTOCOL-Temporary   
  IP_PROTOCOL_WB_MON      = 0x4E,  // WIDEBAND Monitoring   
  IP_PROTOCOL_WB_EXPAK    = 0x4F,  // WIDEBAND EXPAK  
  IP_PROTOCOL_ISO_IP      = 0x50,  // International Organization for 
                                   //   Standardization Internet Protocol  
  IP_PROTOCOL_VMTP        = 0x51,  // Versatile Message Transaction Protocol  
                                   //   RFC 1045
  IP_PROTOCOL_SECURE_VMTP = 0x52,  // Secure Versatile Message Transaction 
                                   //   Protocol   RFC 1045
  IP_PROTOCOL_VINES       = 0x53,  // VINES   
  IP_PROTOCOL_TTP         = 0x54,  // TTP   
//  IP_PROTOCOL_IPTM        = 0x54,  // Internet Protocol Traffic Manager   
  IP_PROTOCOL_NSFNET_IGP  = 0x55,  // NSFNET-IGP  
  IP_PROTOCOL_DGP         = 0x56,  // Dissimilar Gateway Protocol   
  IP_PROTOCOL_TCF         = 0x57,  // TCF   
  IP_PROTOCOL_EIGRP       = 0x58,  // EIGRP   
  IP_PROTOCOL_SPRITE_RPC  = 0x5A,  // Sprite RPC Protocol   
  IP_PROTOCOL_LARP        = 0x5B,  // Locus Address Resolution Protocol   
  IP_PROTOCOL_MTP         = 0x5C,  // Multicast Transport Protocol  
  IP_PROTOCOL_AX25        = 0x5D,  // AX.25   
  IP_PROTOCOL_IPIP        = 0x5E,  // IP-within-IP Encapsulation Protocol   
  IP_PROTOCOL_MICP        = 0x5F,  // Mobile Internetworking Control Protocol   
  IP_PROTOCOL_SCC_SP      = 0x60,  // Semaphore Communications Sec. Pro   
  IP_PROTOCOL_ETHERIP     = 0x61,  // Ethernet-within-IP Encapsulation RFC 3378
  IP_PROTOCOL_ENCAP       = 0x62,  // Encapsulation Header  RFC 1241
  IP_PROTOCOL_ANY_PRIVATE_ENCRYPTION  = 0x63,// Any private encryption scheme   
  IP_PROTOCOL_GMTP        = 0x64,  // GMTP  
  IP_PROTOCOL_IFMP        = 0x65,  // Ipsilon Flow Management Protocol  
  IP_PROTOCOL_PNNI        = 0x66,  // PNNI over IP  
  IP_PROTOCOL_PIM         = 0x67,  // Protocol Independent Multicast  
  IP_PROTOCOL_ARIS        = 0x68,  // IBM's ARIS (Aggregate Route IP Switching) 
  IP_PROTOCOL_SCPS        = 0x69,  // SCPS (Space Communications Protocol 
                                   // Standards)  
  IP_PROTOCOL_QNX         = 0x6A,  // QNX   
  IP_PROTOCOL_A_N         = 0x6B,  // Active Networks   
  IP_PROTOCOL_IPCOMP      = 0x6C,  // IP Payload Compression Protocol RFC 3173
  IP_PROTOCOL_SNP         = 0x6D,  // Sitara Networks Protocol  
  IP_PROTOCOL_COMPAQ_PEER = 0x6E,  // Compaq Peer Protocol  
  IP_PROTOCOL_IPX_IN_IP   = 0x6F,  // IPX in IP   
  IP_PROTOCOL_VRRP        = 0x70,  // Virtual Router Redundancy Protocol,Common 
                                   //   Address Redundancy Protocol 
                                   //   (not IANA assigned)  VRRP:RFC 3768
  IP_PROTOCOL_PGM         = 0x71,  // PGM Reliable Transport Protocol RFC 3208
  IP_PROTOCOL_ANY_0_HOP   = 0x72,  // Any 0-hop protocol  
  IP_PROTOCOL_L2TP        = 0x73,  // Layer Two Tunneling Protocol  
  IP_PROTOCOL_DDX         = 0x74,  // D-II Data Exchange (DDX)  
  IP_PROTOCOL_IATP        = 0x75,  // Interactive Agent Transfer Protocol   
  IP_PROTOCOL_STP         = 0x76,  // Schedule Transfer Protocol  
  IP_PROTOCOL_SRP         = 0x77,  // SpectraLink Radio Protocol  
  IP_PROTOCOL_UTI         = 0x78,  // UTI   
  IP_PROTOCOL_SMP         = 0x79,  // Simple Message Protocol   
  IP_PROTOCOL_SM          = 0x7A,  // SM  
  IP_PROTOCOL_PTP         = 0x7B,  // Performance Transparency Protocol   
  IP_PROTOCOL_IS_IS       = 0x7C,  // IS-IS over IPv4   
  IP_PROTOCOL_FIRE        = 0x7D,  //
  IP_PROTOCOL_CRTP        = 0x7E,  // Combat Radio Transport Protocol   
  IP_PROTOCOL_CRUDP       = 0x7F,  // Combat Radio User Datagram  
  IP_PROTOCOL_SSCOPMCE    = 0x80,      
  IP_PROTOCOL_IPLT        = 0x81,      
  IP_PROTOCOL_SPS         = 0x82,  // Secure Packet Shield  
  IP_PROTOCOL_PIPE        = 0x83,  // Private IP Encapsulation within IP  
                                   //  Expired I-D draft-petri-mobileip-pipe-00.txt
  IP_PROTOCOL_FC          = 0x85,  // Fibre Channel   
  IP_PROTOCOL_RSVP_E2E_IGNORE  = 0x86,  // RFC 3175
  IP_PROTOCOL_MOBILITY_HEADER  = 0x87,  // RFC 3775
  IP_PROTOCOL_UDP_LITE    = 0x88,  // RFC 3828
  IP_PROTOCOL_MPLS_IN_IP  = 0x89,  // RFC 4023
  IP_PROTOCOL_MANET       = 0x8A,  // MANET Protocols   RFC 5498
  IP_PROTOCOL_HIP         = 0x8B,  // Host Identity Protocol  RFC 5201
  IP_PROTOCOL_SHIM6       = 0x8C,  // Site Multihoming by IPv6 Intermediation
  
// :HACK: :NOTE: packetC does not allow duplicate enums
//  IP_PROTOCOL_NOMASK      = 0x00,
#define  IP_PROTOCOL_NOMASK   IP_PROTOCOL_HOPOPT
  IP_PROTOCOL_MASK        = 0xFF
}; 

// These are used for the tos.precedence field.  We #define'd these
// because there is no way to enum a bit field currently.
#define IPV_PRECEDENCE_NETWORK_CONTROL      0b111        
#define IPV_PRECEDENCE_INTERNETWORK_CONTROL 0b110        
#define IPV_PRECEDENCE_CRITIC_ECP           0b101        
#define IPV_PRECEDENCE_FLASH_OVERRIDE       0b100        
#define IPV_PRECEDENCE_FLASH                0b011       
#define IPV_PRECEDENCE_IMMEDIATE            0b010
#define IPV_PRECEDENCE_PRIORITY             0b001
#define IPV_PRECEDENCE_ROUTINE              0b000

descriptor Ipv4Struct 
{
  bits byte 
  { 
    version        : 4;     // Specifies the format of the IP packet header.
    headerLength   : 4;     // Specifies the length of the IP packet header in 
                            // 32 bit words, minimum for a valid header is 5.
  } bf;                   // No official name for byte, using bf for bit field.

  bits byte 
  {
    precedence     : 3;     // Indicate the importance of a datagram, see
                            // IPV_PRECEDENCE_xxxxx values
    delay          : 1;     // Requests low delay
    throughput     : 1;     // Requests high throughput
    reliability    : 1;     // Requests high reliability
    reserved       : 2;     // Not Used
  } tos;                  // Type of Service   RFC791

  short  totalLength;       // Contains the length of the datagram.
  short  identification;    // Used to identify the fragments of one datagram 
                            // from those of another.

  bits short 
  {
    evil           : 1;     // Reserved field renamed Evil Bit in RFC 3514
    dont           : 1;     // Don't Fragment
    more           : 1;     // More Fragments
    fragmentOffset :13;     // Fragment Offset (Offset is a reserved word) 
  } fragment;

  byte        ttl;          // Time to live
  IpProtocol  protocol;     // See IP_PROTOCOL_xxxx above
  short       checksum;     // Checksum of IPv4 header
  IpAddress   sourceAddress;      // Source IP address    
  IpAddress   destinationAddress; // Destination IP address
} ipv4 at pib.l3Offset;   // Optional data follows as IP Options

typedef byte Ipv4StructBytes[sizeof(Ipv4Struct)]; 

//==============================================================================
//  Standard IPv6 Descriptor
//
//  Standard form for layer 3 IPv6 header based upon RFC 1883 and 2460 with
//  Flow Label based upon RFC 1809.
//
//==============================================================================

// IPv6 addresses have two logical parts: a 64-bit network prefix, 
// and a 64-bit host address part.  An IPv6 address is represented 
// by 8 groups of 16-bit hexadecimal values separated by colons (:) 
// shown as follows:
//    2001:0db8:85a3:0000:0000:8a2e:0370:7334
//
struct Ipv6Address
{
//  int quad0, quad1, quad2, quad3;
  short  net0;    // Network prefix
  short  net1;    //   :
  short  net2;    //   :
  short  net3;    //   :
  short  host0;   // Host address
  short  host1;   //   :
  short  host2;   //   :
  short  host3;   //   :
};

descriptor Ipv6Struct 
{
  bits int
  { 
    version        : 4;       // IPv6 version number
    trafficClass   : 8;       // Internet traffic priority delivery value.
    flowLabel      :20;       // From 1 to 0xFFFFFF, Used Instead of Inspection.
  } bf;                     // Following Naming of Bit Field from IPv4.

  short       payloadLength;  // Length of Payload + Extensions (Not Header)

  IpProtocol  protocol;       // Same as IPv4 Protocol, plus IPv6 Next Header
  byte        hopLimit;       // For each router that forwards the packet, the 
                              // hop limit is decremented by 1. When the hop 
                              // limit field reaches zero, the packet is discarded.

  Ipv6Address sourceAddress;       // The IPv6 address of the sending node.
  Ipv6Address destinationAddress;  // The IPv6 address of the destination node.

} ipv6 at pib.l3Offset;     // IPv6 Uses Nested Headers Versus Options

typedef byte Ipv6StructBytes[sizeof(Ipv6Struct)]; 

//==============================================================================
//  Standard TCP Descriptor
//
//  A common layer 4 TCP header utilized in networks per RFC 793.  TCP Options 
//  are varied and differ in size based upon the option header type as each may
//  differ in size, often from 1 to 4 bytes.  As there are trailers to the TCP 
//  header, these can be developed as descriptors that sit at location 
//  pib.l4Offset+20 or if nested change 20 as appropriate based upon a runtime 
//  variable.
//
//==============================================================================

descriptor TcpStruct
{
  short sourcePort;             // Identifies the sending port
  short destinationPort;        // Identifies the recieving port
  int   sequenceNumber;         // Sequence Number
  int   acknowledgementNumber;  // If the ACK flag is set then the value of 
                                // this field is the next sequence number that 
                                // the receiver is expecting.

  bits byte 
  {
    length   :4; // # of 32-bit words in TCP Header, including Options
    reserved :4;
  } header;

  bits byte 
  {
    cwr:1;   // Congestion window reduced per RFC 3168
    ece:1;   // ECN-Echo per RFC 3168
    urg:1;   // Urgent
    ack:1;   // Acknowledgement
    psh:1;   // Push
    rst:1;   // Reset
    syn:1;   // Synchronize
    fin:1;   // Finish
  } flags;

  short windowSize;    // The size of the receive window
  short checksum;      // Used for error-checking of the header and data
  short urgentPointer; // If the URG flag is set, then this is an offset from 
                       // the sequence number indicating the last urgent byte

} tcp at pib.l4Offset;

typedef byte TcpStructBytes[sizeof(TcpStruct)]; 

//==============================================================================
//  Standard UDP Descriptor
//
//  A common layer 4 UDP header utilized in networks per RFC 768.
//
//==============================================================================

descriptor UdpStruct
{
  short  sourcePort;      // The port number of the sender. Cleared to zero 
                          // if not used.
  short  destinationPort; // The port this packet is addressed to.
  short  length;          // The length in bytes of the UDP header and the 
                          // encapsulated data. The minimum value is 8.
  short  checksum;        // Checksum that covers the UDP message. 
} udp at pib.l4Offset;

typedef byte UdpStructBytes[sizeof(UdpStruct)]; 

//==============================================================================
//  Standard ICMP version 4 Descriptor
//
//  A common layer 4 ICMP header for IPv4 utilized in networks. The data portion
//  of an ICMP packet immediately follows this header and is specific to the 
//  variety of ICMP Code and Type.  Additional varieties are provided as 
//  well to support the common Echo Request, Echo Reply, Redirect and 
//  Unreachable types.
//  Reference based upon RFC 950.
//
//==============================================================================

// Used in icmp.type field
enum byte IcmpType {    
  ICMP_TYPE_ECHO_RESPONSE           = 0x00, // See structure IcmpEchoStruct
  ICMP_TYPE_DESTINATION_UNREACHABLE = 0x03, // See structure IcmpUnreachableStruct
  ICMP_TYPE_SOURCE_QUENCH           = 0x04,
  ICMP_TYPE_REDIRECT_MESSAGE        = 0x05, // Set structure IcmpRedirectStruct
  ICMP_TYPE_ECHO_REQUEST            = 0x08,
  ICMP_TYPE_ROUTER_ADVERTISEMENT    = 0x09,
  ICMP_TYPE_ROUTER_SOLICITATION     = 0x0a,
  ICMP_TYPE_TIME_EXCEEDED           = 0x0b,
  ICMP_TYPE_PARAMETER_PROBLEM       = 0x0c,
  ICMP_TYPE_TIMESTAMP               = 0x0d,
  ICMP_TYPE_TIMESTAMP_REPLY         = 0x0e,
  ICMP_TYPE_INFORMATION_REQUEST     = 0x0f,
  ICMP_TYPE_INFORMATION_REPLY       = 0x10,
  ICMP_TYPE_ADDRESS_MASK_REQUEST    = 0x11,
  ICMP_TYPE_ADDRESS_MASK_REPLY      = 0x12,
  ICMP_TYPE_TRACEROUTE              = 0x1e, 
  
// :HACK: :NOTE: packetC does not allow duplicate enums
//  ICMP_TYPE_MASK                    = 0x00,
#define ICMP_TYPE_MASK  ICMP_TYPE_ECHO_RESPONSE
  ICMP_TYPE_NOMASK                  = 0xff
};

descriptor IcmpStruct
{
  IcmpType  type;         // Specifies the format of the ICMP message.
  byte      code;         // Further qualifies the ICMP message. 
  short     checksum;     // Checksum that covers the ICMP message. 
} icmp at pib.l4Offset;

typedef byte IcmpStructBytes[sizeof(IcmpStruct)]; 

//  ICMP Echo Reply structure
descriptor IcmpEchoStruct
{
  IcmpType  type;          // Must be ICMP_TYPE_ECHO_RESPONSE or REQUEST
  byte      code;          // Must be 0 for Echo
  short     checksum;      // Checksum that covers the ICMP message.
  short     identifier;    // Can be used to help match echo requests to the 
                           // associated reply. It may be cleared to zero. 
  short     sequence;      // Used to help match echo requests to the 
                           // associated reply. It may be cleared to zero.
} icmpEcho at pib.l4Offset;     // Optional data follows

typedef byte IcmpEchoStructBytes[sizeof(IcmpEchoStruct)];

//  ICMP Destination Unreachable structure
enum byte IcmpUnreachableCode {
  ICMP_CODE_NETWORK_UNREACHABLE        = 0x00,// Network Unreachable
  ICMP_CODE_HOST_UNREACHABLE           = 0x01,// Host Unreachable
  ICMP_CODE_PROTOCOL_UNREACHABLE       = 0x02,// Protocol unreachable error, 
                                              // designated transport protocol 
                                              // is not supported.
  ICMP_CODE_PORT_UNREACHABLE           = 0x03,// Port unreachable error,
                                              // designated protocol is unable 
                                              // to inform the host of the 
                                              // incoming message.
  ICMP_CODE_FRAGMENT_DONTFRAGMENT      = 0x04,// The datagram is too big. 
                                              // Packet fragmentation is required 
                                              // but the 'don't fragment' (DF) 
                                              // flag is on.
  ICMP_CODE_SOURCE_ROUTE_FAILED        = 0x05,// Source route failed error.
  ICMP_CODE_DESTINATION_NETWORK_UNKNOWN =0x06,// Destination network unknown error.
  ICMP_CODE_DESTINATION_HOST_UNKNOWN   = 0x07,// Destination host unknown error.
  ICMP_CODE_SOURCE_HOST_ISOLATED       = 0x08,// Source host isolated error 
                                              // (military use only).
  ICMP_CODE_NETWORK_ACCESS_PROHIBITED  = 0x09,// The destination network is 
                                              // administratively prohibited.
  ICMP_CODE_HOST_ACCESS_PROHIBITED     = 0x0a,// The destination host is 
                                              // administratively prohibited.
  ICMP_CODE_NETWORK_UNREACHABLE_FOR_TOS =0x0b,// The network is unreachable for 
                                              // Type Of Service.
  ICMP_CODE_HOST_UNREACHABLE_FOR_TOS   = 0x0c,// The host is unreachable for 
                                              // Type Of Service.
  ICMP_CODE_ADMINISTRATIVELY_PROHIBITED =0x0d,// Communication administratively 
                                              // prohibited (administrative 
                                              // filtering prevents packet from 
                                              // being forwarded).
  ICMP_CODE_HOST_PRECEDENCE_VIOLATION  = 0x0e,// Host precedence violation 
                                              // (indicates the requested precedence 
                                              // is not permitted for the combination 
                                              // of host or network and port).
  ICMP_CODE_PRECEDENCE_CUTOFF_IN_EFFECT =0x0f,// Precedence cutoff in effect 
                                              // (precedence of datagram is below 
                                              // the level set by the network 
                                              // administrators).
  
// :HACK: :NOTE: packetC does not allow duplicate enums  
//  ICMP_CODE_MASK                        = 0x00,
#define ICMP_CODE_MASK  ICMP_CODE_NETWORK_UNREACHABLE
  ICMP_CODE_NOMASK                      = 0xff
};

descriptor IcmpUnreachableStruct
{
  IcmpType  type;            // Must be ICMP_TYPE_DESTINATION_UNREACHABLE
  IcmpUnreachableCode  code; // Refer to ICMP_CODE_ Values
  short     checksum;        // Checksum that covers the ICMP message.
  int       unused;          // Must be 0
// :TODO: Extend ICMP Unreachable To Include Structured Data Portion
//IpHeader  ipHeader;           // IP Header Enclosed
//byte      datagram[8];        // First 64-bits of Failing Datagram.
} icmpUnreachable at pib.l4Offset; 

typedef byte IcmpUnreachableStructBytes[sizeof(IcmpUnreachableStruct)];

//  ICMP Redirect Message structure
enum byte IcmpRedirectCode {
  ICMP_CODE_REDIRECT_NETWORK_ERROR              = 0x00,
  ICMP_CODE_REDIRECT_HOST_ERROR                 = 0x01,
  ICMP_CODE_REDIRECT_SERVICE_AND_NETWORK_ERROR  = 0x02,
  ICMP_CODE_REDIRECT_SERVICE_AND_HOST_ERROR     = 0x03,
  
// :NOTE: packetC does not allow duplicate enums  
//  ICMP_CODE_MASK                                = 0x00,
#define ICMP_CODE_REDIRECT_MASK  ICMP_CODE_REDIRECT_NETWORK_ERROR
  ICMP_CODE_REDIRECT_NOMASK                     = 0xff
};

descriptor IcmpRedirectStruct
{
  IcmpType  type;          // Must be ICMP_TYPE_REDIRECT_MESSAGE
  IcmpRedirectCode  code;  // Refer to ICMP_CODE_REDIRECT_xxx Values
  short     checksum;      // Checksum that covers the ICMP message.
  IpAddress destinationAddress; // IP address to redirect to   
} icmpRedirect at pib.l4Offset;     

typedef byte IcmpRedirectStructBytes[sizeof(IcmpRedirectStruct)];


//==============================================================================
//  Standard ICMP version 6 Descriptor
//
//  IPv6 introduces many new values for fields in ICMP, however, generally it
//  follows the ICMP formats from IPv4.  The icmp descriptor above applies to 
//  IPv6 with only the change of code to length.
//
//  In IPv6, a type value of 0 through 127 is associated with errors.  As such,
//  ICMP Echo Request and Response is moved to 128 and 129, respectively.
//
//==============================================================================
enum byte Icmpv6Type {
  // ICMPv6 Errors messages
  ICMPV6_TYPE_DESTINATION_UNREACHABLE   = 0x01,
  ICMPV6_TYPE_PACKET_TOO_BIG            = 0x02, 
  ICMPV6_TYPE_TIME_EXCEEDED             = 0x03,
  ICMPV6_TYPE_PARAMETER_PROBLEM         = 0x04, 
  //  0x79 Reserved for expansion of ICMPv6 error messages
  
  // ICMPv6 Information messages
  ICMPV6_TYPE_REQUEST                   = 0x80,  // See structure Icmpv6EchoStruct
  ICMPV6_TYPE_RESPONSE                  = 0x81,  // See structure Icmpv6EchoStruct

  ICMPV6_TYPE_ROUTER_SOLICITATION       = 0x85,
  ICMPV6_TYPE_ROUTER_ADVERTISEMENT      = 0x86,
  ICMPV6_TYPE_NEIGHBOR_SOLICITATION     = 0x87,
  ICMPV6_TYPE_NEIGHBOR_ADVERTISEMENT    = 0x88,
  ICMPV6_TYPE_MULTICAST_ADVERTISEMENT   = 0x97,
  ICMPV6_TYPE_MULTICAST_SOLICITATION    = 0x98,
  ICMPV6_TYPE_MULTICAST_TERMINATION     = 0x99,
  //  0xff Reserved for expansion of ICMPv6 informational messages
  
  ICMPV6_TYPE_MASK                      = 0x00,
  ICMPV6_TYPE_NOMASK                    = 0xff
};

descriptor Icmpv6Struct         // Length Field Difference From IPv4
{
  Icmpv6Type type;              // ICMPv6 msg type
  byte       length;            // Length
  short      checksum;          // Header checksum 
} icmpv6 at pib.l4Offset;

typedef byte Icmpv6StructBytes[sizeof(Icmpv6Struct)]; 

descriptor Icmpv6EchoStruct     // Matches IPv4, Field Values Differ.
{
  Icmpv6Type type;              // Must be ICMPV6_TYPE_REQUEST or RESPONSE
  byte       code;              // Must be 0 for Echo
  short      checksum;          // Header checksum 
  short      identifier;        // Can be used to help match echo requests to the 
                                // associated reply. It may be cleared to zero.
  short      sequence;          // Used to help match echo requests to the 
                                // associated reply. It may be cleared to zero.
} icmpv6Echo at pib.l4Offset; // Optional data follows

typedef byte Icmpv6EchoStructBytes[sizeof(Icmpv6EchoStruct)];

//==============================================================================
//  Standard ARP Descriptor 
//
//  The following ARP descriptor is for IPv4 protocol addresses over Ethernet.
//  While fields remain the same for other varieties, lengths of fields change
//  when address sizes change an a separate descriptor would be necessary for 
//  non-Ethernet or non-IPv4 protocol addresses.
//
//==============================================================================

// :KLUDGE:
//  The IP addresses (sourceProtocolAddress and destinationProtocolAddress) 
//  are not int aligned so we have to cheat to get access to these in the 
//  ArpStruct by using a 4-byte structure to define them.
//
//  The user will have to typecast this field to an IpAddress
//  type to get access to the full field.
//
//        IpAddress  myIpAddr;
//        myIpAddr = (IpAddress)arp.destinationProtocolAddress;
//
//  The same goes for changing either one of these fields.
//
//        arp.sourceProtocolAddress = (IpQuad)10.10.4.211;
//

struct IpQuads
{ 
 byte quad0;
 byte quad1;
 byte quad2;
 byte quad3;
};

enum short ArpOpcode {
  ARP_OPCODE_REQUEST  = 0x0001,
  ARP_OPCODE_REPLY    = 0x0002,
  
  ARP_OPCODE_MASK     = 0x0000,
  ARP_OPCODE_NOMASK   = 0xffff
};

descriptor ArpStruct
{
   short       hardwareType;                // Specifies the Link Layer protocol 
                                            // type. Ethernet is 1.
   EthernetType  protocolType;              // Specifies the upper layer 
                                            // protocol for which the ARP request 
                                            // is intended. IPv4 is 0x0800 
                                            // matching Ethernet.
   byte        hardwareAddressLength;       // Length of a hardware address. 
                                            // Ethernet addresses size is 6.
   byte        protocolAddressLength;       // Length of addresses used in the 
                                            // upper layer protocol. IPv4 is 4.
   ArpOpcode   opcode;                      // See ARP_OPCODE_xxxx codes
   MacAddress  sourceHardwareAddress;       // Hardware (MAC) address of the sender 
   IpQuads     sourceProtocolAddress;       // Upper layer protocol addr of the sender
   MacAddress  destinationHardwareAddress;  // Hardware address of the intended receiver. 
                                            // This field is ignored in requests.
   IpQuads     destinationProtocolAddress;  // Upper layer protocol address of 
                                            // the intended receiver.
} arp at pib.l3Offset;

typedef byte ArpStructBytes[sizeof(ArpStruct)];


#endif /* PROTOCOLS_PH_ */



















