BOPT2 ;IHS/ILC/ALG/CIA/PLS - ILC Send and Receive (cont);28-Feb-2006 14:42;SM
 ;;1.0;AUTOMATED DISPENSING INTERFACE;**1**;Jul 26, 2005
 ;not an entry point
 Q
MSH ;EP - Build Header
 ;set encoding characrters
 N MCID,PROCID,VERID,TIME,OUT1
 S FLD="|",HLFS="|"
 S ENCD="^~\&",HLECH="^~\&"
 S COM=$E(ENCD,1)
 S REP=$E(ENCD,2)
 S ESC=$E(ENCD,3)
 S SCOM=$E(ENCD,4)
 ;GET DATA
 S RECAPP=$P($G(^BOP(90355,1,0)),U,3)
 S:RECAPP="" RECAPP="AOW-MEDSTN"
 S MCID=$P(NODE,"^",7)
 S PROCID=$P(NODE,"^",8)
 S VERID=$P(NODE,"^",9)
 S SNDAPP=RECAPP
 S NODE1=$G(^BOP(90355.1,COUNTER,1))
 S SITE=$P(NODE1,"^",11)
 S TIME=$P(NODE,"^",5)
 S TIME=$$HLDATE^HLFNC(TIME),TIME=$P(TIME,"-",1)
 S OUT1=$C(11)_"MSH"_FLD_ENCD_FLD_SNDAPP_FLD_SITE_FLD_RECAPP_FLD_FLD_TIME_FLD_FLD_TYPE_COM_ACTION
 S OUT1=OUT1_FLD_MCID_FLD_PROCID_FLD_VERID_"|"_$C(13)
 S CONT=CONT+1
 S OUT(CONT)=OUT1
 Q
EVN ;EP - BUILD EVENT SEGMENT
 N EVNDT,OUT2
 S EVNDT=$P(NODE,"^",3)
 S:$P(EVNDT,".",2)=24 $P(EVNDT,".",2)=2359
 S EVNDT=$$HLDATE^HLFNC(EVNDT),EVNDT=$P(EVNDT,"-",1)
 S OUT2="EVN"_FLD_ACTION_FLD_EVNDT_"|||"_$C(13)
 S CONT=CONT+1
 S OUT(CONT)=OUT2
 Q
PID ;EP - BUILD PID
 N PID1,PNAM,BDAY,SEX,RACE,PHH,PHW,PAN,SSN,OUT3,ADR,BOPWHO,X
 S PID1=$P(NODE1,"^",2)
 S X=$P(NODE1,"^",3)
 S PNAM=$$HLNAME^HLFNC(X)
 S BDAY=$P(NODE1,"^",4)
 I $E(BDAY,4,5)="00" S $E(BDAY,4,5)="01"
 I $E(BDAY,6,7)="00" S $E(BDAY,6,7)="01"
 S BDAY=$$HLDATE^HLFNC(BDAY),BDAY=$P(BDAY,"-",1)
 S SEX=$P(NODE1,"^",5)
 S RACE=$P(NODE1,"^",6)
 S ADR=$$ADRFIX(NODE1)
 S PHH=$P(NODE1,"^",12)
 S PHW=$P(NODE1,"^",13)
 S PAN=$P(NODE1,"^",14)
 S SSN=$P(NODE1,"^",15)
 ;
 ;  for omnicell
 S BOPWHO=$$INTFACE^BOPTU(1) I $G(BOPWHO)="O" S (BDAY,SEX,ADDR,PHH,PHW)=""
 S OUT3="PID"_FLD_$G(BOPWHO)_FLD_FLD_PID1_COM_COM_COM_SITE_FLD_FLD_PNAM_FLD_FLD_BDAY   ;DUG 2/11/04
 S OUT3=OUT3_FLD_SEX_FLD_FLD_FLD_ADR_FLD_FLD_PHH_FLD_PHW_FLD_FLD_FLD_FLD
 S OUT3=OUT3_PAN_"|"_$C(13)
 S CONT=CONT+1
 S OUT(CONT)=OUT3
 Q
 ;
ADRFIX(DATA) ;FIX ADDRESS TO HL7
 N ADR1,ADR2,ADR3,ADR4
 S ADR1=$P(DATA,"^",7)
 S ADR2=$P(DATA,"^",8)
 S ADR3=$P(DATA,"^",9)
 S ADR4=$P(DATA,"^",10)
 Q ADR1_COM_ADR2_COM_ADR3_COM_ADR4
 ;
PV1 ;EP - Build PV1
 N OUT4,PCLSS,LOCAT,LOCAT2,PLOCAT,PDOC,SERV,ACTSAT,ADMTM,BOPWHO
 S NODE10=^BOP(90355.1,COUNTER,10)
 S PCLSS=$P(NODE10,"^",1)
 ;
 ;Location
 S LOCAT=$P(NODE10,"^",2)
 ;
 ;Room/Bed
 S LOCAT2=$P(NODE10,"^",3)
 ;
 S OLDLOC=$P(NODE10,"^",10)
 S PTYPE=$P(NODE10,U,11)
 ;handle room and bed
 S X=$P(NODE10,"^",4)
 S PDOC=$$HLNAME^HLFNC(X)
 ; new code for consult doc
 S X=$P(NODE10,"^",20)
 S CDOC=$$HLNAME^HLFNC(X) S:CDOC'="" CDOC=COM_CDOC
 ; end of code
 S SERV=$P(NODE10,"^",5)
 ;
 ;Defaults
 I '$G(BOPTYPE) S BOPTPE=0
 I $G(BOPITE)="" S BOPITE="AEC"
 ;
 ;Here is where location is paired with the room/bed and put into the
 ;string PLOCAT.  PLOCAT is sent across the interface is its structure
 ;is:  plocation ^ proom ^ pbed (as seen by the client)
 ;BOPTYPE is used for a calculation type
 ;
 ;TYPE=2 (Ex: Hines)
 ;
 ;The location is sent as the Plocation
 ;The VISTA room/bed can be in 3 formats:  xxx-yyy converted to xxx^yyy
 ;xxx-yyy-NNNN converted to xxx^yyy or xxx-yyy-N converted to xxxyyy^N
 ;
 I BOPTYPE=2 D
 .S LX=LOCAT2,LOCAT=$TR(LOCAT,"-","")
 .I $L(LOCAT2,"-")=2 S LX=$P(LOCAT2,"-")_COM_$P(LOCAT2,"-",2)
 .I $L(LOCAT2,"-")=3,$P(LOCAT2,"-",3)?4N.N S LX=$P(LOCAT2,"-")_COM_$P(LOCAT2,"-",2)
 .I $L(LOCAT2,"-")=3,$P(LOCAT2,"-",3)?1N S LX=$P(LOCAT2,"-")_$P(LOCAT2,"-",2)_COM_$P(LOCAT2,"-",3)
 .S PLOCAT=LOCAT_COM_LX_COM_SITE
 ;
 ;The following code is for facilities that use the
 ;NursingUnit-Room-Bed as the format of the Room-Bed field.
 I $S(BOPTYPE=1:1,BOPITE["PALO-ALTO":1,1:0) D
 .N I,L S PLOCAT=""
 .F I=1:1:3 S L=$P(LOCAT2,"-",I) S PLOCAT=PLOCAT_L_COM
 .S PLOCAT=PLOCAT_SITE
 ;
 ; The following is for sites where the ward location is
 ; 6DM but the nursing unit is 6D and they want the 6DM to go out to
 ; remote system
 I BOPTYPE=3 S PLOCAT=LOCAT_COM_$P(LOCAT2,"-",2)_COM_$P(LOCAT2,"-",3)_COM_SITE
 ;
 ; The following code is for type 4 sites. location room bed ignore '-' piece 3
 I BOPTYPE=4 S PLOCAT=LOCAT_COM_$P(LOCAT2,"-")_COM_$P(LOCAT2,"-",2)_COM_SITE
 ;
 ;The following code is for the default handling of Nursing Units,
 ;Rooms and Beds, BOPTYPE=0 (or "").  The Nursing Unit is
 ;correct and the Room-Bed can be separated as the first and second
 ;"-" pieces.
 I +BOPTYPE=0!(BOPTYPE=5) D
 .I BOPTYPE=5,$L(LOCAT2,"-")=3 S LOCAT2=$P(LOCAT2,"-")_$P(LOCAT2,"-",2)
 .S PLOCAT=LOCAT_COM_$P(LOCAT2,"-")_COM_$P(LOCAT2,"-",2)_COM_SITE
 ;
 S BFLD="||||||||||"
 S ACTSAT=$P(NODE10,"^",8)
 S ADMTM=$P(NODE10,"^",6)
 S:$P(ADMTM,".",2)=24 $P(ADMTM,".",2)=2359
 ;DO CHANGE FORMAT TO HL7 TIME
 S ADMTM=$$HLDATE^HLFNC(ADMTM),ADMTM=$P(ADMTM,"-",1)
 S DISDT=$P(NODE10,"^",7)
 S:$P(DISDT,".",2)=24 $P(DISDT,".",2)=2359
 S DISDT=$$HLDATE^HLFNC(DISDT),DISDT=$P(DISDT,"-",1)
 ;
 ; for omnicell
 S BOPWHO=$$INTFACE^BOPTU(1) I $G(BOPWHO)]"" S (SERV,ACTSAT)=""
 ; S OUT4="PV1"_FLD_FLD_PCLSS_FLD_PLOCAT_FLD_FLD_FLD_COM_OLDLOC_FLD_COM_PDOC_FLD_FLD_FLD_SERV_BFLD_BFLD
 S OUT4="PV1"_FLD_FLD_PCLSS_FLD_PLOCAT_FLD_FLD_FLD_COM_OLDLOC_FLD_COM_PDOC_FLD_FLD_CDOC_FLD_SERV_$E(BFLD,1,7)_COM_PDOC_FLD_PTYPE_FLD_BFLD
 S OUT4=OUT4_BFLD_ACTSAT_FLD_FLD_FLD_FLD_FLD_ADMTM
 S OUT4=OUT4_FLD_DISDT_"|"_$C(13)
 S CONT=CONT+1
 S OUT(CONT)=OUT4
 K OUT4,PCLSS,LOCAT,LOCAT2,PLOCAT,PDOC,SERV,ACTSAT,ADMTM,BOPWHO
 Q
MRG ;EP - Build a merge
 S PRIOR=""
 Q
