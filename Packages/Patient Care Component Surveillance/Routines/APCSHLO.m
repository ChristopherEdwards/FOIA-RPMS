APCSHLO ;cmi/flag/maw - APCL ILI CDC HL7 Export 5/12/2010 9:26:17 AM
 ;;3.0;IHS PCC REPORTS;**28**;FEB 05, 1997
 ;
 ;
 ;ihs/cmi/maw - 9/8/2010 added new segments based on patch 5 requirements
 ;
ILI(TYPE) ;EP -  lets create the ILI HL7 export here
 D BATCH(.HLPARM,TYPE)
 D APCSDATA(.HLMSTATE,.HLPARM,TYPE)
 I $G(HLMSTATE("IEN")) D GL(HLMSTATE("IEN"),TYPE)  ;ihs/cmi/maw 11/23/2010 added $G
 Q
 ;
BATCH(HLPARM,TYP) ;-- start the message batch here
 S HLPARM("COUNTRY")="USA"
 S HLPARM("VERSION")="2.5.1"
 I '$$NEWBATCH^HLOAPI(.HLPARM,.HLMSTATE,.ERROR) D  Q
 . S ERR=$G(ERR)
 Q
 ;
APCSDATA(HLMSTATE,HLPARM,TYP) ;-- loop through ^APCSDATA here and create each message
 N APCSDA,APCSCNT,APCSREC
 S APCSCNT=0
 S APCSDA=0 F  S APCSDA=$O(^APCSDATA($J,APCSDA)) Q:'APCSDA  D
 . S APCSCNT=APCSCNT+1
 . S APCSREC=$G(^APCSDATA($J,APCSDA))
 . N I
 . I TYP="ILI" F I=1:1:106 S APCSREC(I)=$P(APCSREC,",",I)
 . I TYP="ILILAB" D NEWMSG(.HLMSTATE,.HLPARM,APCSDA,"ORU","R01",TYP) Q
 . D NEWMSG(.HLMSTATE,.HLPARM,.APCSREC,"ADT","A08",TYP)
 Q
 ;
NEWMSG(HLST,HLPM,RC,MTYPE,EVNTTYPE,TYP) ;EP
 N ARY,HLQ,APPARMS,HLMSGIEN,HLECH,HLFS,ERR,WHO
 N LN,HL1,HRCN,FLD,LP,X,LN
 S LN=0
 S HLPM("MESSAGE TYPE")=MTYPE
 S HLPM("EVENT")=EVNTTYPE
 ;S HLPM("VERSION")="2.5.1"
 I '$$ADDMSG^HLOAPI(.HLST,.HLPM,.ERR) D  Q
 .S ERR=$G(ERR)
 S HLFS=HLPM("FIELD SEPARATOR")
 S HLECH=HLPM("ENCODING CHARACTERS")
 S HL1("ECH")=HLECH
 S HL1("FS")=HLFS
 S HL1("Q")=""
 S HL1("VER")=HLPM("VERSION")
 ;Create segments
 ;
 D EVN(MTYPE,EVNTTYPE)
 I TYP="ILI" D
 . I '$D(ERR) D PID(.RC)
 . I '$D(ERR) D PV1(.RC)
 . I '$D(ERR),$G(RC(8))]"" D DG1(.RC,1,RC(8))
 . I '$D(ERR),$G(RC(9))]"" D DG1(.RC,2,RC(9))
 . I '$D(ERR),$G(RC(10))]""  D DG1(.RC,3,RC(10))
 . I '$D(ERR),$G(RC(11))]"" D OBX(.RC)
 . I '$D(ERR) D ZLI(.RC)
 . ;I '$D(ERR),$G(RC(23))]"" D ZAV(.RC,1,RC(23),RC(24))
 . ;I '$D(ERR),$G(RC(25))]"" D ZAV(.RC,2,RC(25),RC(26))
 . ;I '$D(ERR),$G(RC(27))]"" D ZAV(.RC,3,RC(27),RC(28))
 . ;I '$D(ERR),$G(RC(29))]"" D ZAV(.RC,4,RC(29),RC(30))
 . I '$D(ERR),$G(RC(23))]"" D ZSR(.RC,1,RC(45))
 . I '$D(ERR),$G(RC(25))]"" D ZSR(.RC,2,RC(46))
 . I '$D(ERR),$G(RC(27))]"" D ZSR(.RC,3,RC(47))
 . I '$D(ERR),$G(RC(29))]"" D ZSR(.RC,4,RC(48))
 . I '$D(ERR),$G(RC(66))]"" D ZAN(.RC)
 . I '$D(ERR),$G(RC(71))]"" D ZCV(.RC)
 . ;I '$D(ERR),$G(RC(49))]"" D ZAE(.RC,1,RC(49))
 . ;I '$D(ERR),$G(RC(50))]"" D ZAE(.RC,2,RC(50))
 . ;I '$D(ERR),$G(RC(51))]"" D ZAE(.RC,3,RC(51))
 . ;I '$D(ERR),$G(RC(52))]"" D ZAE(.RC,4,RC(52))
 . ;I '$D(ERR),$G(RC(53))]"" D ZAS(.RC,1,RC(53),RC(54))
 . ;I '$D(ERR),$G(RC(53))]"" D ZAS(.RC,1,RC(55),RC(56))
 . ;I '$D(ERR),$G(RC(53))]"" D ZAS(.RC,1,RC(57),RC(58))
 . ;do ZAN here
 . ;do ZCV here
 I TYPE="ILILAB" D
 . I '$D(ERR) D PIDLAB(RC)
 . I '$D(ERR) D ZIDLAB(RC)
 . I '$D(ERR) D PV1LAB(RC)
 . I '$D(ERR) D OBXLAB(RC)
 . S APCSFCNT=0
 . I '$D(ERR) D DG1LAB(RC)
 . I '$D(ERR) D PR1LAB(RC)  ;TODO set this up for CPT's, need to look at loris lab code
 . K APCSFCNT
 I '$D(ERR) D
 .; Define sending and receiving parameters
 .S APPARMS("SENDING APPLICATION")="RPMS-ILI"
 .S APPARMS("ACCEPT ACK TYPE")="AL"  ;Commit ACK type
 .S APPARMS("APP ACK RESPONSE")="AACK^APCLSHL"  ;Callback when 'application ACK' is received
 .S APPARMS("ACCEPT ACK RESPONSE")="CACK^APCLSHL"  ;Callback when 'commit ACK' is received
 .S APPARMS("APP ACK TYPE")="AL"  ;Application ACK type
 .S APPARMS("QUEUE")="ILI ADT"   ;Incoming QUEUE
 .S WHO("RECEIVING APPLICATION")="CDC"
 .S WHO("FACILITY LINK NAME")="ILI"
 .;S WHO("STATION NUMBER")=11555  ;Used for testing on external RPMS system
 .I '$$SENDONE^HLOAPI1(.HLST,.APPARMS,.WHO,.ERR) D
 .. S ERR=$G(ERR)
 .;. NOTIF(DFN,"Unable to send HL7 message."_$S($D(ERR):" ERR:"_$G(ERR),1:""))
 Q
 ;
AACK ; EP - Application ACK callback - called when AA, AE or AR is received.
 N DATA,AACK,XQAID,XQDATA,XQA,XQAMSG,MSGID
 Q:'$G(HLMSGIEN)
 S MSGID=$P($G(^HLB(+HLMSGIEN,0)),U)
 S AACK=$G(^HLB(HLMSGIEN,4))
 I $P(AACK,U,3)'["|AA|" D
 .S XQAMSG="ILI message "_MSGID_" did not receive a correct application ack."
 .S XQAID="ILI,"_MSGID_","_50
 .S XQDATA=$P(AACK,U,3)
 .S XQA("G.APCS ILI")=""
 .D SETUP^XQALERT
 Q
 ;
CACK ; EP - Commit ACK callback - called when CA, CE or CR is received.
 N CACK,XQAID,XQAMSG,XQA,XQDATA,MSGID
 S MSGID=$P($G(^HLB(+HLMSGIEN,0)),U)
 S CACK=$G(^HLB(HLMSGIEN,4))
 I $P(CACK,U,3)'["|CA|" D
 .S XQAMSG="ILI message "_MSGID_" did not receive a correct commit acknowledgement."
 .S XQAID="ILI,"_MSGID_","_50
 .S XQDATA=$P(CACK,U,3)
 .S XQA("G.APCS ILI")=""
 .D SETUP^XQALERT
 Q
 ;
ERR ;
 Q
 ;
EVN(MTYPE,EVNTTYPE) ;Create the EVN segment
 N %,X,FLD,VAL
 D NOW^%DTC
 S X=$$HLDATE^HLFNC(%,"TS")
 D SET(.ARY,"EVN",0)
 D SET(.ARY,EVNTTYPE,1)
 ;S FLD=MTYPE_"^"_EVNTTYPE
 ;F LP=1:1:$L(FLD,$E(HLECH)) S VAL=$P(FLD,$E(HLECH),LP) D
 ;.D SET(.ARY,VAL,5,LP)
 D SET(.ARY,X,2)
 ;D SET(.ARY,"01",4)
 S X=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 Q
 ; Create PID segment
PID(R) ;EP
 S HLQ=HL1("Q")
 D SET(.ARY,"PID",0)
 D SET(.ARY,1,1)
 D SET(.ARY,R(1),2)
 D SET(.ARY,R(2),3)  ; Patient HRN
 D SET(.ARY,R(3),8)
 D SET(.ARY,$$HLD(R(4)),7)
 D SET(.ARY,R(5),11,8)
 S X=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 ;I $D(ERR) D NOTIF(DFN,ERR)
 Q
 ;
 ; Create PID segment
PIDLAB(R) ;EP
 N PID,PID3,PID8,PID7
 S PID=$G(^APCSDATA($J,R,"PID"))
 S PID3=$P(PID,U)
 S PID8=$P(PID,U,2)
 S PID7=$P(PID,U,3)
 S HLQ=HL1("Q")
 D SET(.ARY,"PID",0)
 D SET(.ARY,1,1)
 D SET(.ARY,PID3,3)  ; Patient HRN
 D SET(.ARY,PID8,8)
 D SET(.ARY,PID7,7)
 S X=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 ;I $D(ERR) D NOTIF(DFN,ERR)
 Q
 ;
ZIDLAB(R) ;-- create the ZID segment
 N ZID,ZID1
 S ZID=$G(^APCSDATA($J,R,"ZID"))
 S ZID1=$P(ZID,U)
 D SET(.ARY,"ZID",0)
 D SET(.ARY,1,1)
 D SET(.ARY,ZID1,2)
 S X=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 Q
 ;
PV1(R) ;-- setup the JVN PV1 segment
 D SET(.ARY,"PV1",0)
 D SET(.ARY,1,1)
 D SET(.ARY,R(6),3,1)
 D SET(.ARY,R(41),3,2)
 D SET(.ARY,R(12),15)
 D SET(.ARY,R(16),36)
 D SET(.ARY,$$HLD(R(7)),44)
 D SET(.ARY,$$HLD(R(17)),45)
 S X=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 ;I $D(ERR) D NOTIF(DFN,ERR)
 Q
 ;
PV1LAB(R) ;-- setup the PV1 LAB segment
 N PV1,PV13,PV132,PV115,PV144,PV145
 S PV1=$G(^APCSDATA($J,R,"PV1"))
 S PV13=$P(PV1,U,1)
 S PV132=$P(PV1,U,2)
 S PV115=$P(PV1,U,3)
 S PV144=$P(PV1,U,4)
 S PV145=$P(PV1,U,5)
 D SET(.ARY,"PV1",0)
 D SET(.ARY,1,1)
 D SET(.ARY,PV13,3,1)
 D SET(.ARY,PV132,3,2)
 D SET(.ARY,PV115,15)
 D SET(.ARY,PV144,44)
 D SET(.ARY,PV145,45)
 S X=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 ;I $D(ERR) D NOTIF(DFN,ERR)
 Q
 ;
DG1(R,SQ,DG13) ;-- set the repeating DG1
 D SET(.ARY,"DG1",0)
 D SET(.ARY,SQ,1)
 D SET(.ARY,"ICD",2)
 D SET(.ARY,DG13,3)
 S X=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 Q
 ;
DG1LAB(R) ;-- set the repeating DG1
 N BDA,DG1,DG13
 S BDA=0 F  S BDA=$O(^APCSDATA($J,R,"DG1",BDA)) Q:'BDA  D
 . S DG1=$G(^APCSDATA($J,R,"DG1",BDA))
 . S DG13=$P(DG1,U)
 . S APCSFCNT=APCSFCNT+1
 . ;D SET(.ARY,"DG1",0)
 . D SET(.ARY,"FT1",0)
 . D SET(.ARY,APCSFCNT,1)
 . ;D SET(.ARY,"ICD",2)
 . ;D SET(.ARY,DG13,3)
 . D SET(.ARY,DG13,19)
 . S X=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 Q
 ;
PR1LAB(R) ;-- set the repeating DG1
 N BDA,PR1,PR13
 S BDA=0 F  S BDA=$O(^APCSDATA($J,R,"PR1",BDA)) Q:'BDA  D
 . S PR1=$G(^APCSDATA($J,R,"PR1",BDA))
 . S PR13=$P(PR1,U)
 . S APCSFCNT=APCSFCNT+1
 . D SET(.ARY,"FT1",0)
 . D SET(.ARY,+$G(APCSFCNT),1)
 . D SET(.ARY,PR13,25)
 . ;D SET(.ARY,"PR1",0)
 . ;D SET(.ARY,BDA,1)
 . ;D SET(.ARY,"CPT",2)
 . ;D SET(.ARY,PR13,3)
 . S X=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 Q
 ;
OBX(R) ;-- setup the ILI OBX segment
 D SET(.ARY,"OBX",0)
 D SET(.ARY,1,1)
 D SET(.ARY,"ST",2)
 D SET(.ARY,"TMP",3)
 D SET(.ARY,R(11),5)
 S X=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 Q
 ;
OBXLAB(R) ;-- setup the ILI OBX segment
 N BDA,OBX,OBX1,OBX2,OBX31,OBX32,OBX5
 S BDA=0 F  S BDA=$O(^APCSDATA($J,R,"OBX",BDA)) Q:'BDA  D
 . S OBX=$G(^APCSDATA($J,R,"OBX",BDA))
 . S OBX1=$P(OBX,U)
 . S OBX2=$P(OBX,U,2)
 . S OBX3=$P(OBX,U,3)
 . I OBX3'="TMP" D
 .. S OBX31=$P(OBX3,"~")
 .. S OBX32=$P(OBX3,"~",2)
 . S OBX5=$P(OBX,U,4)
 . D SET(.ARY,"OBX",0)
 . D SET(.ARY,OBX1,1)
 . D SET(.ARY,OBX2,2)
 . I '$G(OBX31) D SET(.ARY,OBX3,3)
 . I $G(OBX31) D
 .. I $G(OBX31)]"" D SET(.ARY,OBX31,3,1)
 .. D SET(.ARY,OBX32,3,2)
 . D SET(.ARY,OBX5,5)
 . S X=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 Q
 ;
ZLI(R) ;-- setup the ILI ZLI segment
 D SET(.ARY,"ZLI",0)
 D SET(.ARY,1,1)
 D SET(.ARY,R(13),2)
 D SET(.ARY,$$HLD(R(14)),3)
 D SET(.ARY,R(15),4)
 D SET(.ARY,R(18),5)
 D SET(.ARY,$$HLD(R(19)),6)
 D SET(.ARY,R(20),7)
 D SET(.ARY,R(21),8)
 D SET(.ARY,R(22),9)
 D SET(.ARY,R(33),10)
 D SET(.ARY,R(34),11)
 D SET(.ARY,R(35),12)
 D SET(.ARY,R(36),13)
 D SET(.ARY,R(37),14)
 D SET(.ARY,$$HLD(R(38)),15)
 D SET(.ARY,R(39),16)
 D SET(.ARY,$$HLD(R(40)),17)
 D SET(.ARY,R(42),18)
 D SET(.ARY,R(43),19)
 D SET(.ARY,R(44),20)
 D SET(.ARY,R(59),21)
 D SET(.ARY,R(60),22)
 D SET(.ARY,R(61),23)
 D SET(.ARY,R(62),24)
 D SET(.ARY,R(63),25)
 D SET(.ARY,R(64),26)
 D SET(.ARY,R(65),27)
 S X=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 Q
 ;
ZAV(R,SQ,ZAV2,ZAV3) ;-- setup the ILI ZAV segment
 D SET(.ARY,"ZAV",0)
 D SET(.ARY,SQ,1)
 D SET(.ARY,$$HLD(ZAV2),2)
 D SET(.ARY,ZAV3,3)
 S X=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 Q
 ;
ZSR(R,SQ,ZSR2) ;-- setup the ILI ZSR segment
 D SET(.ARY,"ZSR",0)
 D SET(.ARY,SQ,1)
 D SET(.ARY,ZSR2,2)
 S X=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 Q
 ;
ZAE(R,SQ,ZAE2) ;-- setup the ILI ZAE segment
 D SET(.ARY,"ZAE",0)
 D SET(.ARY,SQ,1)
 D SET(.ARY,ZAE2,2)
 S X=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 Q
 ;
ZAS(R,SQ,ZAS2,ZAS3) ;-- setup the ILI ZAS segment
 D SET(.ARY,"ZAS",0)
 D SET(.ARY,SQ,1)
 D SET(.ARY,ZAS2,2)
 D SET(.ARY,$$HLD(ZAS3),3)
 S X=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 Q
 ;
ZAN(R) ;-- setup the ILI ZAN segment
 N I,ZANC,VAL
 S ZANC=1
 F I=66:1:70 D
 . I $G(R(I))]"" D
 .. S VAL=$G(R(I))
 .. D SET(.ARY,"ZAN",0)
 .. D SET(.ARY,ZANC,1)
 .. D SET(.ARY,VAL,2)
 .. S X=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 .. S ZANC=ZANC+1
 Q
 ;
ZCV(R) ;-- setup the ILI ZCV segment
 N J,ZCVC,VALC,VALD
 S ZCVC=1
 F I=71:2:105 D
 . I $G(R(I))]"" D
 .. S VALC=$G(R(I))
 .. S VALD=$G(R(I+1))
 .. D SET(.ARY,"ZCV",0)
 .. D SET(.ARY,ZCVC,1)
 .. D SET(.ARY,VALC,2)
 .. D SET(.ARY,VALD,3)
 .. S X=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 Q
 ;
 ; Create MSA segment
MSA ;EP
 N MSA
 D SET(.ARY,"MSA",0)
 D SET(.ARY,"AA",1)
 D SET(.ARY,"TODO-MSGID",2)
 D SET(.ARY,"Transaction Successful",3)
 ;D SET(.ARY,"todo-010",4)
 S MSA=$$ADDSEG^HLOAPI(.HLST,.ARY)
 Q
 ; Create MSH segment
 ;EP
 N MSH
 D SET(.ARY,"MSH",0)
 S MSH=$$ADDSEG^HLOAPI(.HLST,.ARY)
 Q
SET(ARY,V,F,C,S,R) ;EP
 D SET^HLOAPI(.ARY,.V,.F,.C,.S,.R)
 Q
 ; Fix for non-working ZIPCODE Field trigger in File 2
FIXZIP(DFN,ZIP) ;EP
 Q:$G(ZIP) ZIP
 Q $$GET1^DIQ(2,DFN,.116)
 ;
HLD(FDT) ;-- convert to HL7 date
 I $G(FDT)="" Q ""
 N D
 S %DT="X"
 S X=FDT D ^%DT
 S D=$$FMTHL7^XLFDT(Y)
 Q D
 ;
GL(IN,TYP) ;-- write out the batch to a global for saving in APCSSLAB
 K ^APCSTMP($J)
 N BDA,BDO,HLODAT,MSH,MSGP,MSG
 S APCSCNT=0
 S MSG=$P($G(^HLB(IN,0)),U,2)
 S BDA=0 F  S BDA=$O(^HLB(IN,3,BDA)) Q:'BDA  D
 . S MSH=""
 . S MSGP=$P($G(^HLB(IN,3,BDA,0)),U)
 . S BDO=0 F  S BDO=$O(^HLB(IN,3,BDA,BDO)) Q:'BDO  D
 .. S HLOMSH=$G(^HLB(IN,3,BDA,BDO))
 .. S MSH=MSH_HLOMSH
 . D SETGL(MSH)
 . D REST(MSG,MSGP)
 D WRITE(TYP)
 Q
 ;
REST(M,MP) ;-- write out the remainder of the segments to the global
 N MDA,DATA,MCNT
 S MCNT=0
 S MDA=0 F  S MDA=$O(^HLA(M,2,MP,1,MDA)) Q:'MDA  D
 . S DATA=$G(^HLA(M,2,MP,1,MDA,0))
 . Q:DATA=""
 . D SETGL(DATA)
 Q
 ;
SETGL(D) ;-- set the temp global
 S APCSCNT=APCSCNT+1
 S ^APCSTMP($J,APCSCNT)=D
 Q
 ;
WRITE(T) ; use XBGSAVE to save the temp global (APCSDATA) to a delimited
 ; file that is exported to the IE system
 N XBGL,XBQ,XBQTO,XBNAR,XBMED,XBFLT,XBUF,XBFN,APCSFN
 S XBGL="APCSTMP",XBMED="F",XBQ="N",XBFLT=1,XBF=$J,XBE=$J
 S XBNAR="EPI "_TYP_"_HL7 EXPORT"
 S APCSASU=$P($G(^AUTTLOC($P(^AUTTSITE(1,0),U),0)),U,10)  ;asufac for file name
 S (XBFN,APCSFN)="EPI"_TYP_"HL7_"_APCSASU_"_"_$$DATE(DT)_".txt"
 S XBS1="SURVEILLANCE ILI SEND"
 ;
 D ^XBGSAVE
 ;
 I XBFLG'=0 D
 . I XBFLG(1)="" W:'$D(ZTQUEUED) !!,TYP_" HL7 file successfully created",!!
 . I XBFLG(1)]"" W:'$D(ZTQUEUED) !!,TYP_" HL7 file NOT successfully created",!!
 . W:'$D(ZTQUEUED) !,"File was NOT successfully transferred to IHS/CDC",!,"you will need to manually ftp it.",!
 . W:'$D(ZTQUEUED) !,XBFLG(1),!!
 D SETLOG
 K ^APCSTMP($J),APCSCNT
 Q
DATE(D) ;EP
 Q (1700+$E(D,1,3))_$E(D,4,5)_$E(D,6,7)
 ;
SETLOG ;EP
 ;create entry with start date of DT
 N APCLFDA,APCLIENS,APCLERR
 S APCLIENS="+2,"_1_","
 S APCLFDA(9001003.313,APCLIENS,.01)=DT
 S APCLFDA(9001003.313,APCLIENS,.02)=APCSFN
 S APCLFDA(9001003.313,APCLIENS,.05)=$S(XBFLG:0,1:1)
 S APCLFDA(9001003.313,APCLIENS,.04)=APCSCNT
 D UPDATE^DIE("","APCLFDA","APCLIENS","APCLERR(1)")
 Q
