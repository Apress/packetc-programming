// ****************************************************************************
// NewSamplePacketCProject.ph - Header file for the Classifier (cl) project.
// ------------
// Author(s)   : Cloudshield Technologies           
// Date Created: Sat 09 Sep 2008 04:00:00 PM EDT 
// Checked in  : $Date: 2011/03/18 13:52:28 $
// Version     : $Revision: 1.5 $
// ****************************************************************************
#ifndef SAMPLE_PROJECT_CL_PH_
#define SAMPLE_PROJECT_CL_PH_

//declare global event counters
int clEthertype_[ 65536 ] = {0};
%pragma control clEthertype_ (export);
int clArpOpcode_[ 24 ] = {0};
%pragma control clArpOpcode_ (export);
int clIp4Protocol_[ 256 ] = {0};
%pragma control clIp4Protocol_ (export);
int clIp6NextHeader_[ 256 ] = {0};
%pragma control clIp6NextHeader_ (export);
int clIcmp4Type_[ 256 ] = {0};
%pragma control clIcmp4Type_ (export);
int clIcmp6Type_[ 256 ] = {0};
%pragma control clIcmp6Type_ (export);
int clTcpWKPort_[ 1024 ] = {0};
%pragma control clTcpWKPort_(export);
int clUdpWKPort_[ 1024 ] = {0};
%pragma control clUdpWKPort_(export);

// Declare macro
// Increment well known port array,
// Increment element zero if above 1024 
#define INCREMENT_PORT_STATS(data, array)\
	if ( data.sourcePort < 1024 ) {\
		array[ data.sourcePort ]++;\
	}\
	else if ( data.destinationPort < 1024 ) {\
		array[ data.destinationPort ]++;\
	}else array[ 0 ]++;

#endif /*SAMPLE_PROJECT_CL_PH_*/

