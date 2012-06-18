BARUP ; IHS/SD/LSL - UPLOAD BILL FROM 3P ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**19**;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 11/27/02 - V1.7 - QAA-1200-130051
 ;    Inserted documentation.
 ;
 ; IHS/SD/LSL - 06/09/03 - V1.7 Patch 1
 ;      Don't new BAROPT.  Needed to determine if path to this
 ;      routine originated from an AR Upload menu option.
 ;
 ; *********************************************************************
 ;
 ; Global change to use indirection  ABMA - @BAR3PUP@
 ;
 ;** Upload from 3P BILL file to A/R BILL/IHS file
 ;
 ;** This routine is intended to be called from the 3p billing module
 ;   at the time an item is created in the 3P BILL file.
 ;
 ;** Calling this routine at the entry point TPB^BARUP(ABMA ARRAY)
 ;   will create an entry in the A/R BILL/IHS file.
 ;
 ;** Calling this routine at the entry point TPBPRT^BARUP(ABMA ARRAY)
 ;   will update the 3P Print date and the date billed for ageing
 ;
 ;** ACTION from 3P ABMAPASS will now be numeric. 
 ;    99 - indicates a cancelled bill in 3P
 ;    1,2,3 - indicates that the active insurer is primary,secondary,etc
 ;
 Q
 ; *********************************************************************
 ;
TPB(BAR3PUP)         ;** entry point from third party billing
 ;
 Q:'$L($G(@BAR3PUP@("BLNM")))
 N BARDUZ2
 ;
INIT ;
 D EN^XBNEW("NEW0^BARUP","ABMA,BAR3PUP,BAROPT")
 Q
 ; *********************************************************************
 ;
NEW0 ;
CHECK ;
 S BARDUZ2=DUZ(2)
 S X=@BAR3PUP@("BLNM")
 I @BAR3PUP@("ACTION")="99" D ^BARBLCN Q  ; Cancelling bill in 3PB
 K BARGO
 D SET                                    ; Set up variables
 Q:'$G(BARGO)
 D UPLOAD^BARUP1                          ; Create bill in A/R
 ;IHS/SD/AR BAR*1.8*19 06.17.2010
 S BARMIEN=0
 F  S BARMIEN=$O(@BAR3PUP@(74,BARMIEN)) Q:(+$G(BARMIEN)<1)  D
 . D MSGTX^BARUP1  ;	CREATE MESSAGE TRANSACTION
 S DUZ(2)=BARDUZ2
 K BARDUZ2
 Q
 ; *********************************************************************
 ;
SET ;EP - set up variables
 ;
GETSERV ;** hospital service section
 S BARSERV=$O(^DIC(49,"B","BUSINESS OFFICE",""))  ; Serv/Sect=BO
 ;
 ; -------------------------------
GETPAR ;** visit location comes from #.03 of 3p bill file
 ;**  GET duz(2)
 ;   get parent from parent/satellite file
 S BARSAT=$G(@BAR3PUP@("VSLC"))           ; Satellite = 3P Visit loc           
 S BARPAR=0                               ; Parent
 ; check site active at DOS to ensure bill added to correct site
 S DA=0
 F  S DA=$O(^BAR(90052.06,DA)) Q:DA'>0  D  Q:BARPAR
 . Q:'$D(^BAR(90052.06,DA,DA))  ; Pos Parent UNDEF Site Parameter
 . Q:'$D(^BAR(90052.05,DA,BARSAT))  ; Satellite UNDEF Parent/Satellit
 . Q:+$P($G(^BAR(90052.05,DA,BARSAT,0)),U,5)  ; Par/Sat not usable
 . ; Q if sat NOT active at DOS
 . I @BAR3PUP@("DOSB")<$P($G(^BAR(90052.05,DA,BARSAT,0)),U,6) Q
 . ; Q if sat became NOT active before DOS
 . I $P($G(^BAR(90052.05,DA,BARSAT,0)),U,7),(@BAR3PUP@("DOSB")>$P($G(^BAR(90052.05,DA,BARSAT,0)),U,7)) Q
 . S BARPAR=$S(BARSAT:$P($G(^BAR(90052.05,DA,BARSAT,0)),U,3),1:"")
 I 'BARPAR D  Q                     ; No parent defined for satellite
 . W !!,"A parent facility could not be found in A/R for this 3P visit location."
 . W !,"Therefore, a bill could not be created in A/R."
 . W !,"Please check A/R Parent/Satellite Setup in A/R."
 S DUZ(2)=BARPAR
 ;
 ; -------------------------------
 ; check to see if site ready for 3P bills, if Site not define or
 ; if 12 piece not set to 1 quit
 Q:'$P($G(^BAR(90052.06,BARPAR,BARPAR,0)),U,12)
 S BARGO=1
 ;
 ; -------------------------------
GETACC ;** a/r facility account
 S BARACC=$G(@BAR3PUP@("INS"))_";AUTNINS("
 S:+BARACC=0 BARACC=$G(@BAR3PUP@("PTNM"))_";AUPNPAT("
 S BARACEIN=$O(^BARAC(DUZ(2),"B",BARACC,""))
 S:'BARACEIN BARACEIN=$$SETACC(BARACC) ; IEN to  A/R FACILITY ACCOUNT
 ;
 ; -------------------------------
GETTYP ;** bill type from file ^BAR(90052.01
 S BARBLTYP=$S(@BAR3PUP@("ACTION")=99:"",@BAR3PUP@("ACTION")>1:"R",1:"P")
 ;
INSORD ;
 S BARTMP1(205)=$G(@BAR3PUP@("PRIM"))
 S BARTMP1(206)=$G(@BAR3PUP@("SEC"))
 S BARTMP1(207)=$G(@BAR3PUP@("TERT"))
 F J=205:1:207 D
 . Q:'$L(BARTMP1(J))
 . S BARACC=BARTMP1(J)_";AUTNINS("
 . S BARACODA=$O(^BARAC(DUZ(2),"B",BARACC,""))
 . I 'BARACODA S BARACODA=$$SETACC(BARACC)
 . S BARTMP1(J)=BARACODA
 ;
 ; -------------------------------
GETSTAT ;** bill status = open
 N DIC D
 .S DIC="^BARTBL(",DIC(0)="M",X="OPEN"
 .S DIC("S")="I $P(^(0),U,2)=$O(^BAR(90052.01,""B"",""BILL STATUS"",0))"
 .K D,DO
 .D ^DIC
 .K DIC
 .S BARSTAT=$S(+Y:+Y,1:"")
 .Q
 ;
 ; -------------------------------
PATDATA ;** patient data from patient file
 S (BARSSN,BARHRN,BARTYP,BARPBEN,BARTOC)=""
 S BARPTDA=$G(@BAR3PUP@("PTNM"))
 I 'BARPTDA G GETPRV
 S BARSSN=$P($G(^DPT(BARPTDA,0)),U,9)
 I $G(@BAR3PUP@("VSLC")) S BARHRN=$P($G(^AUPNPAT(BARPTDA,41,@BAR3PUP@("VSLC"),0)),U,2)
 S BARPTYP="??"
 S BARPBEN=""
 S X="AUPNPAT1"
 X ^%ZOSF("TEST")
 I $T S BARPBEN=$$BEN^AUPNPAT1(BARPTDA)
 S BARPBEN=$S(BARPBEN=1:1,BARPBEN="":"",1:0)
 ;
 ; -------------------------------
GETPRV ;** primary provider
 S BARPRV=$G(@BAR3PUP@("PROV"))
 Q
 ; ********************************************************************
 ;
SETACC(BARACC) ;EP - establish record in A/R FACILITY ACCOUNT file
 N DIC,BARACODA
 S DIC="^BARAC(DUZ(2),"
 S DIC(0)="L"
 S X=BARACC
 S DIC("DR")="2////^S X=96"
 S DIC("DR")=DIC("DR")_";3////^S X=DT"
 S DIC("DR")=DIC("DR")_";8////^S X=$G(DUZ(2))"
 S DIC("DR")=DIC("DR")_";10////^S X=$G(BARSERV)"
 S DLAYGO=90050
 K DD,DO
 D FILE^DICN
 K DLAYGO,DIC
 S BARACODA=$S(+Y<0:"",1:+Y)
 Q BARACODA
