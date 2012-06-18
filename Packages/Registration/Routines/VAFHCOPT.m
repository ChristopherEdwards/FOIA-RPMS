VAFHCOPT ;ALB/CM,PKE OUTPATIENT APPT (HL7 MESS) NIGHT JOB ;3/24/95
 ;;5.3;Registration;**91**;Aug 13, 1993
 ;
 ;This routine will loop through the Hospital Location file "S" node
 ;and generate an A08 message for all appointments for today
 ;that have a status of "No action taken" or "Future"
 ;
EN ;
 ;Check to see if sending is on or off
 N GO
 S GO=$$SEND^VAFHUTL()
 I GO=0 Q
 ;
 S ERRB="^TMP($J,""ADT-ERR""," K ^TMP($J,"ADT-ERR")
 K HL D INIT^HLFNC2("VAFH A08",.HL)
 I $D(HL)=1 S ERR="-1^"_HL QUIT
 ;
 N STAT,X1,X2
 ;This job should be set to run after midnight daily.
 D NOW^%DTC S START=X ;;;S START=2970101
 S X1=START,X2=1 D C^%DTC S STOP=X K X1,X2,%H,X,%,%I
 ;
 S ENT=0,GBL="^TMP(""HLS"",$J)" K ^TMP("HLS",$J)
 ;
 ;
 F  S ENT=$O(^SC(ENT)) Q:(ENT="")!(ENT'?.N)  D
 .S ENT1=START
 .F  S ENT1=$O(^SC(ENT,"S",ENT1)) Q:ENT1=""!(ENT1'?.N1".".N)!(ENT1>STOP)  D
 ..S ENT2=0
 ..F  S ENT2=$O(^SC(ENT,"S",ENT1,1,ENT2)) Q:ENT2=""!(ENT2'?.N)  D
 ...S DFN=$P(^SC(ENT,"S",ENT1,1,ENT2,0),"^")
 ...I (DFN="")!('$D(^DPT(DFN,0)))!('$D(^DPT(DFN,"S",ENT1))) Q
 ...;CHECK STATUS OF APPOINTMENT
 ...S STAT=$$STATUS^SDAM1(DFN,ENT1,ENT,$G(^DPT(DFN,"S",ENT1,0)),"")
 ...I $P(STAT,";",2)="FUTURE"!($P(STAT,";",2)="NO ACTION TAKEN") DO
 ... .S ERR=$$CREATE() I +ERR>0 S VPTR=$P(ERR,"^",6) D GEN
 ...I +$G(ERR)<0 S @ERRB@(1)=ERR D EBULL^VAFHUTL2("","","",ERRB)
 D EXIT
 Q
 ;
GEN ;
 ;Generate the following segments:
 ;MSH
 ;
 K HL D INIT^HLFNC2("VAFH A08",.HL)
 I $D(HL)=1 S ERR="-1^"_HL Q
 ;EVN
 S EVN=$$EVN^VAFHLEVN("A08","05")
 I +EVN=-1 S ERR="-1^Unable to generate EVN segment" Q
 ;PID
 S PID=$$EN^VAFHLPID(DFN,"2,3,4,5,6,7,8,9,11,12,13,14,16,19")
 ;ZPD
 S ZPD=$$EN^VAFHLZPD(DFN,"2,3,4,5,6,7,8,9,10,11,12,13,14,15")
 ;PV1 (outpatient)
 S PV1=$$OUT^VAFHLPV1(DFN,EVENT,EVDT,VPTR,"A")
 I +PV1=-1 S ERR="-1^Unable to generate PV1 segment" Q
 ;
 ; no dg1 segment will be created.  No diagnosis
 ;information will be known at this stage.
 ;
 K ^TMP("HLS",$J)
 S COUNT=1
 ;
 S @GBL@(COUNT)=EVN,COUNT=COUNT+1
 S @GBL@(COUNT)=PID,COUNT=COUNT+1
 S @GBL@(COUNT)=ZPD,COUNT=COUNT+1
 S @GBL@(COUNT)=PV1
 ;
 ;
 ;
 D GENERATE^HLMA("VAFH A08","GM",1,.HLRST,"",.HL)
 I HLRST,$P(HLRST,"^",2)=""
 E  S @ERRB@(1)=HLRST D EBULL^VAFHUTL2("","","",ERRB) K HLERR
 Q
EXIT ;
 D KILL^HLTRANS
 K @GBL
 K ZPD,DG1,PID,PV1,MSH,EVN,ENT,ENT1,ENT2,DFN,START,STOP,GBL,HLSDT
 K EVDT,HLMTN,EVENT,COUNT,HLEVN,HLENTRY,ERR,VPTR,ERRB
 Q
 ;
CREATE() ;
 ;creates new entry in pivot file
 N NODE,VPTR
 S EVDT=ENT1,VPTR=DFN_";DPT("
 S NODE=$$PIVNW^VAFHPIVT(DFN,EVDT,2,VPTR)
 I +NODE=-1 Q NODE
 S EVENT=$P(NODE,":")
 Q EVENT_"^"_NODE
