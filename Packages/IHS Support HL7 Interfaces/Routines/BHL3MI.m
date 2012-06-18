BHL3MI ; cmi/anchorage/maw - BHL Setup HL7 message and pass to APCD ; [ 06/07/2002 7:04 AM ]
 ;;3.01;BHL IHS Interfaces with GIS;**1,14**;JUN 01, 2002
 ;
 ;
 ;
 ;this routine will pull the message out of the UIF and give it back
 ;to APCD the way they expect
 ;
 ;cmi/anch/maw 10/7/2005 modified due to message structure at
 ;Claremore with new 3M interface
 ;
 ;
 ;
MAIN ;EP - this is the main routine driver
 D SET,MSH,PASS,EOJ^BHLSETI
 Q
 ;
SET ;-- this is the main routine driver
 Q:'$G(UIF)
 S BHLUIF=UIF
 S BHL3MC=1
 N BHLBSEG,BHLCNT
 S BHLCNT=1
 S BHL3DA=0 F  S BHL3DA=$O(^INTHU(UIF,3,BHL3DA)) Q:'BHL3DA  D
 . N BHLSEG
 . S BHLSEG=$G(^INTHU(UIF,3,BHL3DA,0))
 . N I
 . F I=1:1:$L(BHLSEG) D
 .. S $E(BHLBSEG,BHLCNT,BHLCNT)=$E(BHLSEG,I,I)
 .. D CHKSEG(BHLBSEG,BHL3MC)
 .. S BHLCNT=BHLCNT+1
 D SETSEG(BHL3MC,BHLBSEG)
 Q
 ;
CHKSEG(BSEG,MC) ;-- see if we are at a start of a segment
 I $E(BSEG,$L(BSEG)-2,$L(BSEG))="EVN" D SETSEG(MC,BSEG) Q
 I $E(BSEG,$L(BSEG)-2,$L(BSEG))="PID" D SETSEG(MC,BSEG) Q
 I $E(BSEG,$L(BSEG)-2,$L(BSEG))="PV1" D SETSEG(MC,BSEG) Q
 I $E(BSEG,$L(BSEG)-2,$L(BSEG))="DG1" D SETSEG(MC,BSEG) Q
 I $E(BSEG,$L(BSEG)-2,$L(BSEG))="PR1" D SETSEG(MC,BSEG) Q
 I $E(BSEG,$L(BSEG)-2,$L(BSEG))="Z3A" D SETSEG(MC,BSEG) Q
 I $E(BSEG,$L(BSEG)-2,$L(BSEG))="Z3R" D SETSEG(MC,BSEG) Q
 Q
 ;
SETSEG(C,BS) ;-- setup the segment array
 S APCDHL7M(C)=$E(BS,1,$L(BS)-3)
 S BHL3MC=BHL3MC+1
 S BHLBSEG=$E(BHLBSEG,$L(BHLBSEG)-2,$L(BHLBSEG))
 S BHLCNT=3
 Q
 ;
MSH ;-- let's setup the msh segment
 S BHLMDA=0 F  S BHLMDA=$O(APCDHL7M(BHLMDA)) Q:'BHLMDA  D
 . Q:$E(APCDHL7M(BHLMDA),1,3)'="MSH"
 . S FS=$E(APCDHL7M(BHLMDA),4,4)
 . S ENC=$P(APCDHL7M(BHLMDA),FS,2)
 Q
 ;
PASS ;-- call 3M filer
 D IN^APCD3M
 Q
 ;
