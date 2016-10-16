// **************************************************************************
// ClassifyPacket.ph - Include file for the Example Arp/Ping program.
// ------------
// Author(s)   : dW!GhT
// Date Created: 03/01/2011 
// Version     : 1.00
// **************************************************************************
// Description: This provides a simple example of how to classify packets
//              using the protocols.ph descriptors.  It is suggested that 
//              the user use this as a start to expand on for use in their
//              own projects.
//
// Returns:  Enumeration PktType (see declaration below)
// 
// ***************************************************************************
#ifndef CLASSIFYPACKET_PH_
#define CLASSIFYPACKET_PH_

#include <protocols.ph>

// ***************************************************************************
// Msg types that get processed
// ***************************************************************************
enum int PktType {
  PKTTYPE_NONE          = 0,  // None if not significate to us
  PKTTYPE_ICMP          = 1,  // Internet Control Message Protocol
  PKTTYPE_PING_REQUEST  = 2,  //   ICMP echo request, PING
  PKTTYPE_PING_RESPONSE = 3,  //   ICMP echo response, PING
  PKTTYPE_ARP           = 4,  // Address Resolution Protocol
  PKTTYPE_ARP_REQUEST   = 5,  //   ARP request
  PKTTYPE_ARP_REPLY     = 6,  //   ARP reply
  PKTTYPE_TCP           = 7,  // Transmission Control Protocol
  PKTTYPE_IP4           = 8,  // IPv4
  PKTTYPE_IP6           = 9,  // IPv6
  PKTTYPE_8021Q         = 10, // VLAN tagging
  PKTTYPE_UDP           = 11  // User Defined Packet
};
 
// ***************************************************************************
//
// Processes the current packet type.
//
// NOTE:  Only these are processed in detail
//          - Ping (icmp echo request)
//          - ARP request/reply
//
// any other packet type will be returned as its ethernet type.
//
// ***************************************************************************
PktType  classifyPacket() 
{
  // Set the intial msg type to nothing we are interested in
  PktType  pktType = PKTTYPE_NONE;
  
  // ***********************************
  // Classify packet based on ethertype
  // ***********************************
  switch (ethernet.type)
  {
  // ***********************
  //        IPv4 
  // ***********************
  case ETHERNET_TYPE_IP:
    pktType = PKTTYPE_IP4;
    //classify packet based on protocol
    switch (ipv4.protocol)
    {
    // ****************
    // Internet Control Message Protocol 
    // ****************
    case IP_PROTOCOL_ICMP:
      pktType = PKTTYPE_ICMP;
      
      // Ck if this is a ping request
      if ( icmpEcho.type == ICMP_TYPE_ECHO_REQUEST ) { 
        // *PING* request
        pktType = PKTTYPE_PING_REQUEST; 
      } else if ( icmpEcho.type == ICMP_TYPE_ECHO_RESPONSE ) { 
        // *PING* response
        pktType = PKTTYPE_PING_RESPONSE; 
      }
      break; 

    // ****************
    //   User defined
    // ****************
    case IP_PROTOCOL_UDP:
      pktType = PKTTYPE_UDP;
      break;

    // ****************
    //  Transmission Control Protocol 
    // ****************
    case IP_PROTOCOL_TCP:
      pktType = PKTTYPE_TCP;
      break; 
      

    default:
      // do nothing here
    }
    break;

  // ***************************
  // Address Resolution Protocol 
  // ***************************
  case ETHERNET_TYPE_ARP:
    pktType = PKTTYPE_ARP;
    
    // See if this is a ARP request or reply packet 
    if ( arp.opcode == ARP_OPCODE_REQUEST ) { 
      pktType = PKTTYPE_ARP_REQUEST; 
    } else if ( arp.opcode == ARP_OPCODE_REPLY ) {
      pktType = PKTTYPE_ARP_REPLY; 
    }
    break;
    
  // ***************************
  //          IPv6 
  // ***************************
  case ETHERNET_TYPE_IP6:
    pktType = PKTTYPE_IP6;
    break;

  // ***************************
  //       VLAN Tagging  
  // ***************************
  case ETHERNET_TYPE_8021Q:
    pktType = PKTTYPE_8021Q;
    break;
    

  default:
    // do nothing here
  }

  return pktType;
}


#endif /*CLASSIFYPACKET_PH_*/
