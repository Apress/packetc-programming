// ***************************************************************************
// UdpProcessor.ph - Include file for the UDP packet processor.
// ------------
// Author(s)   : dW!GhT
// Date Created: 04/01/2011 
// Version     : 1.00
// **************************************************************************
// Description:  Handle responding to a User Command passed in a UDP packet.  
//
//  This is a simple example that will do the following:
//    - increment the udpCounter_ variable by 1. 
//    - increment the udpCounter_ variable by amount passed.  
//    - reset the counter to 0.  
//    - a classic NOP.  "; )
//    - "READ_COUNTER" that will send back the UDP with the counter value
//
//  :NOTE:  Use this as a starting point for your custom command processor.
// 
// ***************************************************************************
#ifndef UDPPROCESSOR_PH_
#define UDPPROCESSOR_PH_

// ***************************************************************************
// Commands that this will handle
// ***************************************************************************
enum byte CmdType {
  CMDTYPE_NONE              = 0,    // Nothing/void/null/the loneliness of not
  CMDTYPE_RESET_COUNTER     = 1,    // Resets the global counter to 0
  CMDTYPE_INCREMENT_BY_1    = 2,    // Incr the counter by 1
  CMDTYPE_INCREMENT_BY_DATA = 3,    // Incr the counter by amount passed
  CMDTYPE_READ_COUNTER      = 4,    // Reads counter and passes back
  
  CMDTYPE_RESPONSE          = 0xfe,  // Used to indicate to the reciever
  CMDTYPE_NOP               = 0xff
};

// ***************************************************************************
// The payload of the UDP packet contains the passed data
// ***************************************************************************
descriptor udpDataStruct {
  int      amountToInc;
  CmdType  cmdType;     // Cmd is here to avoid alignment issues
} udpData at pib.payloadOffset;  


// ***************************************************************************
// This is the global variable that the commands will act upon
// ***************************************************************************
int udpCounter_ = 0;
%pragma control udpCounter_ (export);


// ***************************************************************************
// Helper function to turn the packet around sending a response to the
// caller process.
// ***************************************************************************
void SendResponseBack() {
  // Swap source/desc mac addrs 
  MacAddress  tempMacId;
  tempMacId = ethernet.destinationAddress;
  ethernet.destinationAddress = ethernet.sourceAddress;
  ethernet.sourceAddress = tempMacId;
  
  // Swap source/desc IP addrs 
  IpAddress  tempIpAddr;
  tempIpAddr = ipv4.destinationAddress;
  ipv4.destinationAddress = ipv4.sourceAddress;
  ipv4.sourceAddress = tempIpAddr;

  // We have to recalculate L3/L4 checksums before sending it on its way
  pib.flags.l3CheckSumRecalc = true;
  pib.flags.l4CheckSumRecalc = true;  
  
  return;
}

// ***************************************************************************
// HandleUdp will return the CmdType that was processed.
// ***************************************************************************
CmdType  HandleUdp() {
  // Execute the command passed 
  switch ( udpData.cmdType ) {
  case CMDTYPE_RESET_COUNTER:     // Reset the counter to zero
    udpCounter_ = 0;
    break;

  case CMDTYPE_INCREMENT_BY_1:    // Increment the counter by one
    ++udpCounter_;
    break;

  case CMDTYPE_INCREMENT_BY_DATA: // Used the data passed to inc counter
    udpCounter_ += udpData.amountToInc;
    break; 
     
  case CMDTYPE_READ_COUNTER:      // Pass the counter back to the caller
    // Put the counter into the payload
    udpData.amountToInc = udpCounter_;
    udpData.cmdType = CMDTYPE_RESPONSE;
    
    // Here we turn the UDP packet around sending it back
    SendResponseBack();
    break;
    
  case CMDTYPE_NOP:               // Nothing to do here... "; )
    // NOP means "no operation"... so don't do anything!!!
    break;

  default:
    // We don't know this command, do nothing
  }
  
  // Return the command type that was processed so the caller can act
  // accordingly as to drop or forward the packet.
  return udpData.cmdType;
}



#endif /*UDPPROCESSOR_PH_*/
