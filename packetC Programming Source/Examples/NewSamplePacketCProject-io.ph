// *****************************************************************************
// NewSamplePacketCProject-io.ph - Header file for Input/Output (io) project
// ------------
// Author(s)   : Cloudshield Technologies 
// Date Created: Sat 06 Sep 2008 04:51:00 PM EDT    
// Checked in  : $Date: 2011/03/18 13:52:28 $
// Version     : $Revision: 1.5 $
// ****************************************************************************
#ifndef SAMPLE_PROJECT_IO_PH_
#define SAMPLE_PROJECT_IO_PH_

// Declare constants
const int PORTCOUNT = 16;
const int DISABLED = 255;

// Declare portmap list
int Portmap_[ PORTCOUNT ] = {
	1, 0, 3, 2,
	DISABLED, DISABLED, DISABLED, DISABLED,
	DISABLED, DISABLED, DISABLED, DISABLED,
	DISABLED, DISABLED, DISABLED, DISABLED
};

// Declare global event counters
int IoForward_;
%pragma control IoForward_ (export);
int IoDrop_;
%pragma control IoDrop_ (export);

// forward io macro
#define FORWARD_IO( pib, sys )\
	if ( Portmap_[sys.inPort] < PORTCOUNT ) {\
		sys.outPort = Portmap_[sys.inPort];\
		pib.action = FORWARD_PACKET;\
		IoForward_++;\
	} else {\
		pib.action = DROP_PACKET;\
		IoDrop_++;\
	}

// dropIo macro
#define DROP_IO( pib, sys )\
	pib.action = DROP_PACKET;\
	IoDrop_++;


#endif /*SAMPLE_PROJECT_IO_PH_*/

