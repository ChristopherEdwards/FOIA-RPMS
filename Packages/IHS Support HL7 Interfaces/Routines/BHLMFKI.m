BHLMFKI ;cmi/sitka/maw - Process Inbound MFK Message  
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;
 ;
 ;this routine will process the inbound ihs drug file update ack
 ;
MAIN ;-- this is the main routine driver
 D ^BHLSETI
 S INA("MCID")=$G(INV("MSH10"))
 D MFI,MFA,BUL
 D EOJ^BHLSETI
 Q
 ;
MFI ;-- get data out of MFI segment
 S BHLMFI=$G(INV("MFI1"))
 Q
 ;
MFA ;-- get data out of the MFA segment
 S BHLUS=$G(INV("MFA4"))
 Q
 ;
LOOK ;-- look up the entry in the drug file
 S BHLDIEN=$O(^PSDRUG("ZNDC",BHLNDC,0))
 Q
 ;
BUL ;-- send a bulletin
 S XMB="BHL DRUG MSTR TABLE RESPONSE"
 S XMB(1)=INA("MCID"),XMB(2)=BHLUS
 D ^XMB
 Q
 ;
