BHLI ; cmi/sitka/maw - BHL Inbound Filer Processor ;  
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;
 ;
 ;this routine will get the IEN of the message and start the process
 ;of filing
 ;
MAIN ;-- this is the main routine driver
 D ^BHLSETI
 G EOJ^BHLSETI:$D(BHLERR("FATAL"))
 D ^BHLFO
 D FILE
 D EOJ^BHLSETI
 Q
 ;
FILE ;-- this will call the routines that actually file the message
 S BHLFDA=0 F  S BHLFDA=$O(BHLFO(BHLFDA)) Q:'BHLFDA!$D(BHLERR("FATAL"))  D
 . S BHLR=$G(BHLFO(BHLFDA))
 . S BHLFILE="^BHL"_BHLR_"I"
 . S X=$P(BHLFILE,U,2) X ^%ZOSF("TEST")
 . Q:'$T
 . D @BHLFILE
 . Q:$D(BHLERR("FATAL"))
 Q
 ;
