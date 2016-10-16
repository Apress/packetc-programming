// **************************************************************************
// ArpPing.ph - Include file for ARP/Ping handling.
// ------------
// Author(s)   : dWiGhT
// Date Created: 03/01/2011 
// Version     : 1.00
// **************************************************************************
// Description: This provides an application with the ability to respond
//              to ARPs and ICMP (Ping) requests.
// ***************************************************************************
#ifndef ARPPING_PH_
#define ARPPING_PH_

// ***************************************************************************
//  Error check to make sure that the correct #defines have been used
//  and can be used correct
// ***************************************************************************
#ifndef ARPPING_MACID
#error ARPPING_MACID needs to be #defined to identify the CS box.  It should look like this "#define ARPPING_MACID 0x00, 0x0C, 0x41, 0x97, 0x24, 0x15"
#else
const byte MacId_[6] = { ARPPING_MACID };
#endif

#ifndef ARPPING_IPADDR
#error ARPPING_IPADDR needs to be #defined to define the IP address this response to.  It should look like this "#define ARPPING_IPADDR 10.101.1.241"
#else
IpAddress  CMD_PROCESS_IPADDR   = ARPPING_IPADDR; // IP that this responses to  
#endif


// ***************************************************************************
//  Packet request type that is returned from HandleArpPing()
// ***************************************************************************
enum int ReqType {
  REQTYPE_NONE            = 0,  // Pkt was not an ARP or a PING
  REQTYPE_PING_PROCESSED  = 1,  // Pkt was a PING request that we processed
  REQTYPE_ARP_PROCESSED   = 2   // Pkt was a ARP request that we processed
};


// ***************************************************************************
// 
//  Handle responding to a Ping request.
//
//  Here we filling the source to be this (mac/ip) and turn the 
//  destination around to respond back to the requestor.
//
// ***************************************************************************
int pingId_ = 0;
bool  HandlePingRequest() {
  bool  handlePingRequest = false;

  // Only process valid packets
  if ( pib.flags.l4CheckSumValid == true ) 
    if ( ipv4.destinationAddress == CMD_PROCESS_IPADDR ) {
    // Set the time to live (ttl) to 30secs
    ipv4.ttl = 30;
    
    // Increment the ping id field, increments for each response
    ipv4.identification = (short)(++pingId_);
    
    // Set the type/code to a response echo (ping)
    icmpEcho.type = ICMP_TYPE_ECHO_RESPONSE;   // RESPONSE
    icmpEcho.code = 0x00;   // ECHO
    
    // Return this modified packet to the sender
    // Swap source/desc mac addrs 
    ethernet.destinationAddress = ethernet.sourceAddress;
    ethernet.sourceAddress = (MacAddress)MacId_;
    
    // Swap source/desc IP addrs 
    ipv4.destinationAddress = ipv4.sourceAddress;
    ipv4.sourceAddress = CMD_PROCESS_IPADDR;

    // We have to recalculate L3/L4 checksums before sending it on its way
    pib.flags.l3CheckSumRecalc = true;
    pib.flags.l4CheckSumRecalc = true;  
    
    handlePingRequest = true;
  }
  return handlePingRequest;
}

// ***************************************************************************
//
//  Handle responding to a ARP request.
//
//  Here we filling the source to be this (macid/ip) and turn the 
//  destination around to respond back to the requestor with our macid.
//
// ***************************************************************************
bool  HandleArpRequest() {
  bool  handleArpRequest = false;
  
  if ( arp.destinationProtocolAddress == (IpQuads)CMD_PROCESS_IPADDR ) {
    // Set up the source mac/ip to be here
    ethernet.destinationAddress = ethernet.sourceAddress;
    ethernet.sourceAddress = (MacAddress)MacId_;
  
    // Flip the dest to be the source
    arp.destinationHardwareAddress = arp.sourceHardwareAddress;
    arp.destinationProtocolAddress = arp.sourceProtocolAddress;
    
    // the source is from here
    arp.sourceHardwareAddress = (MacAddress)MacId_;
    arp.sourceProtocolAddress = (IpQuads)CMD_PROCESS_IPADDR;
    
    // Change this packet into a ARP reply
    arp.opcode = ARP_OPCODE_REPLY;
    
    handleArpRequest = true;
  }
  
  return handleArpRequest; 
} 


// ***************************************************************************
// 
//  Handles classifying a packet to see if it is an ARP or PING request.
//
//  We call the correct handler and return the type of packet we processed.
//
// ***************************************************************************
ReqType HandleArpPing() {
  ReqType  handleArpPing = REQTYPE_NONE;
  
  switch (ethernet.type)
  {
  case ETHERNET_TYPE_IP:
    // ************************
    // Internet Control Message Protocol 
    // ************************
    if ( ipv4.protocol == IP_PROTOCOL_ICMP )
      if ( icmpEcho.type == ICMP_TYPE_ECHO_REQUEST ) {
        // *PING* request
        if ( HandlePingRequest() == true ) {
          handleArpPing = REQTYPE_PING_PROCESSED;
        }
    }
    break;

  // ***************************
  // Address Resolution Protocol 
  // ***************************
  case ETHERNET_TYPE_ARP:
    // See if this is a ARP request or reply packet 
    if ( arp.opcode == ARP_OPCODE_REQUEST ) {
      // ARP request
      if ( HandleArpRequest()== true ) {
        handleArpPing = REQTYPE_ARP_PROCESSED;
      }
    } 
    break;
    
  default:
    // do nothing with any other packet type
  }

  return handleArpPing;
}

#endif /*ARPPING_PH_*/
