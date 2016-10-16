//============================================================================
//
// trojanprotocols.ph - packetC sdk include file of trojan protocol constants
//
//    Provide Pre-Defined constants for well known Trojan
//    ports.  As these change often and many run on otherwise well
//    known ports, this file is not a definitive classification
//    recommendation for protocols by port.  As such, consider
//    TrojanProtocols.ph having its main value for humor and
//    experimentation. Enjoy!
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
//==================- START of TROJAN ========================================
#ifndef TROJAN_PROTOCOLS_PH
#define TROJAN_PROTOCOLS_PH
#define _TROJAN_PROTOCOLS_PH_VERSION 1.00
//=============================================
//==========- WELL KNOWN TROJAN PORTS =========
//=============================================

const short TROJAN_BLADERUNNER   =   21;   // Blade Runner, Doly Trojan, Fore,
                 // Invisible FTP, WebEx, WinCrash
const short TROJAN_TINYTELNET   =   23;   // Tiny Telnet Server
const short TROJAN_ANTIGEN   =   25;   // Antigen, Email Password Sender,
                 // Haebu Coceda, Shtrilitz, Stealth,
                 // Terminator, WinPC, WinSpy
const short TROJAN_PARADISE     =   31;   // Hacker's Paradise
const short TROJAN_EXECUTOR     =   80;   // Executor
const short TROJAN_PARADISE2    =   456;  // Hacker's Paradise
const short TROJAN_PHASE_ZERO   =   555;  // Phase Zero, Stealth Spy, Ini-Killer
const short TROJAN_SATANZ       =   666;  // Satanz Backdoor
const short TROJAN_SILENCER     =   1001; // Silencer, WebEx
const short TROJAN_DOLY         =   1011; // Doly Trojan
const short TROJAN_PSYBER       =   1170; // Psyber Stream Server, Voice
const short TROJAN_ULTORS       =   1234; // Ultors Trojan
const short TROJAN_VOODOO_DOLL  =   1245; // VooDoo Doll
const short TROJAN_FTP99CMP     =   1492; // FTP99CMP
const short TROJAN_SHIVKA_BURKA =   1600; // Shivka-Burka
const short TROJAN_SPYSENDER    =   1807; // SpySender
const short TROJAN_SHOCKRAVE    =   1981; // Shockrave
const short TROJAN_BACKDOOR     =   1999; // BackDoor
const short TROJAN_COW          =   2001; // Trojan Cow
const short TROJAN_RIPPER       =   2023; // Ripper
const short TROJAN_BUGS         =   2115; // Bugs
const short TROJAN_DEEP_THROAT  =   2140; // Deep Throat, The Invasor
const short TROJAN_PHINEAS      =   2801; // Phineas Phucker
const short TROJAN_WINCRASH     =   3024; // WinCrash
const short TROJAN_MASTERS_PARA =   3129; // Masters Paradise
const short TROJAN_INVASOR      =   3150; // Deep Throat, The Invasor
const short TROJAN_PORTAL_DOOM  =   3700; // Portal of Doom
const short TROJAN_WINCRASH2    =   4092; // WinCrash
const short TROJAN_ICQTROJAN    =   4590; // ICQTrojan
const short TROJAN_SOCK_TROIE   =   5000; // Sockets de Troie
const short TROJAN_SOCK_TROIE2  =   5001; // Sockets de Troie
const short TROJAN_FIREHOTCKTER =   5321; // Firehotcker
const short TROJAN_BLADERUNNER2 =   5400; // Blade Runner
const short TROJAN_BLADERUNNER3 =   5401; // Blade Runner
const short TROJAN_BLADERUNNER4 =   5402; // Blade Runner
const short TROJAN_ROBO_HACK    =   5569; // Robo-Hack
const short TROJAN_WINCRASH3    =   5742; // WinCrash
const short TROJAN_DEEP_THROAT2 =   6670; // DeepThroat
const short TROJAN_DEEP_THROAT3 =   6771; // DeepThroat
const short TROJAN_GATECRASHER  =   6969; // GateCrasher, Priority
const short TROJAN_REMOTE_GRAB  =   7000; // Remote Grab
const short TROJAN_NETMONITOR   =   7300; // NetMonitor
const short TROJAN_NETMONITOR2  =   7301; // NetMonitor
const short TROJAN_NETMONITOR3  =   7306; // NetMonitor
const short TROJAN_NETMONITOR4  =   7307; // NetMonitor
const short TROJAN_NETMONITOR5  =   7308; // NetMonitor
const short TROJAN_ICKILLER     =   7789; // ICKiller
const short TROJAN_PORTAL_DOOM2 =   9872; // Portal of Doom
const short TROJAN_PORTAL_DOOM3 =   9873; // Portal of Doom
const short TROJAN_PORTAL_DOOM4 =   9874; // Portal of Doom
const short TROJAN_PORTAL_DOOM5 =   9875; // Portal of Doom
const short TROJAN_INI_KILLER   =   9989; // iNi-Killer
const short TROJAN_PORTAL_DOOM6 =  10167; // Portal of Doom
const short TROJAN_SENNA_SPY    =  11000; // Senna Spy
const short TROJAN_PROGENIC     =  11223; // Progenic trojan
const short TROJAN_HACK99_KEY   =  12223; // Hack&99 KeyLogger
const short TROJAN_GANABUS      =  12345; // GabanBus, NetBus
const short TROJAN_GANABUS2     =  12346; // GabanBus, NetBus
const short TROJAN_WHACK_A_MOLE =  12361; // Whack-a-mole
const short TROJAN_WHACK_A_MOLE2=  12362; // Whack-a-mole
const short TROJAN_PRIORITY     =  16969; // Priority
const short TROJAN_MILLENIUM    =  20001; // Millennium
const short TROJAN_NETBUS_PRO   =  20034; // NetBus 2 Pro
const short TROJAN_GIRLFRIEND   =  21544; // GirlFriend
const short TROJAN_PROSIAK      =  22222; // Prosiak
const short TROJAN_EVIL_FTP     =  23456; // Evil FTP, Ugly FTP
const short TROJAN_DELTA        =  26274; // Delta
const short TROJAN_BACK_ORIFICE =  31337; // Back Orifice
const short TROJAN_DEEP_BO      =  31338; // Back Orifice, DeepBO
const short TROJAN_NETSPY       =  31339; // NetSpy DK
const short TROJAN_BOWHACK      =  31666; // BOWhack
const short TROJAN_PROSIAK2     =  33333; // Prosiak
const short TROJAN_BIGGLUCK     =  34324; // BigGluck, TN
const short TROJAN_THE_SPY      =  40412; // The Spy
const short TROJAN_MASTERS_PARA2=  40421; // Masters Paradise
const short TROJAN_MASTERS_PARA3=  40422; // Masters Paradise
const short TROJAN_MASTERS_PARA4=  40423; // Masters Paradise
const short TROJAN_MASTERS_PARA5=  40426; // Masters Paradise
const short TROJAN_DELTA2       =  47262; // Delta
const short TROJAN_SOCK_TROIE3  =  50505; // Sockets de Troie
const short TROJAN_FORE         =  50766; // Fore
const short TROJAN_REMOTE_DOWN  =  53001; // Remote Windows Shutdown
const short TROJAN_TELECOMMANDO =  61466; // Telecommando
const short TROJAN_DEVIL        =  65000; // Devil

//====================- END of TROJAN =======================================
#endif /* TROJAN_PROTOCOLS_PH_ */