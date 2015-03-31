BARUTL ; IHS/SD/LSL - UTILITY PROGRAM FOR FAC A/R ; 07/25/2010
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**13,19,21,23**;OCT 26, 2005
 ;;
 ; IHS/SD/LSL - 04/04/02 - V1.6 Patch 2 - NOIS XJG-0302-160095
 ;     Added FIND3PB function to find bill in 3P Bill file if given
 ;     A/R DUZ(2) and BILL IEN
 ;
 ; IHS/SD/SDR - 4/4/2002 - V1.6 Patch 2 - NOIS XXX-0202-200181
 ;     Added LWC line to to do converting to all lower case
 ;
 ; IHS/SD/LSL - 09/11/02 - V1.6 Patch 3 - HIPAA 276/277
 ;     Added INSIEN function to return the IEN of the INSURER FILE if
 ;     passed the DUZ(2) AND (A/R Bill IEN or the A/R Account IEN)
 ;
 ; IHS/SD/LSL - 09/11/02 - V1.6 Patch 3 - HIPAA 276/277
 ;     Added SBR function to return the Subscriber if passed the A/R
 ;     BILL IEN and DUZ(2)
 ;
 ; IHS/SD/LSL - 08/25/03 - V1.7 Patch 2
 ;      Modify INSIEN to quit with values outside of dot structure
 ; 
 ; IHS/SD/SDR 5/26/09 HEAT4301 BAR*1.8*13
 ;      Modify patch number in filename so batches are formatted
 ;      correctly by the HUB
 ; TMM 07/25/2010 V1.8*19 - Modify A/R Statistical report to 
 ;     include (Emloyer) Group Plan data.  requirement 4PMS10022.
 ; P.OTT 08/12/2013 FIXED $$SBR: QUIT WITH VALUE
 ;       Fixed BARPOLN (Policy Number reference to 702)
 ;       HEAT#131103 8/28/2013 FIXED <UNDEF> IF DUZ(2) IS NOT REGIONALLY SETUP
 ; *********************************************************************
 ;
 ;VARIOUS ENTRY POINTS
INIT ;EP Initialize Environment
 K DIR
 S IOP="HOME"
 D ^%ZIS
 I $G(DUZ(2))']"" D  Q
 . S BARQUIT=1
 . D EOP(1)
 ;
 ;HEAT#131101 
 I '$D(^DIC(4,DUZ(2))) D  Q
 . W !,"USER / SITE IS NOT CORRECTLY SETUP"
 . W !,"CONTACT YOUR A/R MANAGER",*7
 . S BARQUIT=1
 . D EOP(1)
 . Q
 ;
 I '$D(^BARBL(DUZ(2))) D  Q
 . W !,$P(^DIC(4,DUZ(2),0),U)," IS NOT REGIONALLY SETUP"
 . W !,"CONTACT YOUR A/R MANAGER",*7
 . S BARQUIT=1
 . D EOP(1)
 ;
 ;
 D CHKFILES
 D BARUSR^BARUTL0 ; user parameters
 D BARSITE^BARUTL0 ; site paramters
 D BARSPAR^BARUTL0 ; A/R site paramters
 D BARPSAT^BARUTL0 ;parent satellite
 ;
 ;S:'$D(CURDUZ2) CURDUZ2=DUZ(2)  ;IHS/SD/TPF BAR*1.8*21 HEAT43337 SET CURRENT DUZ(2) USED TO SEE IF CASHIER CHANGES FACILITY MIDSTREAM
 ;
 Q
 ; *********************************************************************
 ;
CLIDED ;EP COLLECTION ID file edit
 D BARUSR^BARUTL0
 K DIC
 S DIC="^BAR(90051.02,DUZ(2),"
 S DIC("S")="I $P(^(0),U,10)=BARUSR(29,""I"")"
 S DIC(0)="AEQML"
 D ^DIC
 I +Y'>0 K DIC Q
 S BARDA=+Y
 K DR
 ; if new stuff A/R section and location
 I +$P(Y,U,3) D
 . S DIE=DIC
 . S DA=+Y
 . S DR="8///^S X=DUZ(2);10////^S X=BARUSR(29,""I"")"
 . K DIC
 . S DIDEL=90050
 . D ^DIE
 . K DIDEL
 K DR,DIC,DIE,DA
 S DA=BARDA
 S DR="[BAR COLLECTION POINT EDIT]"
 S DDSFILE=90051.02
 D ^DDS
 G CLIDED
 ; *********************************************************************
 ;
NEWBILL ;EP
 ; file^dicn a new BIll with dic(dr)
 L +^BAR(90052.06,DUZ(2)):3 I '$T D
 .W !!,*7,"A/R Parameter file is locked by another user."
 .D EOP(1)
 D BARSPAR^BARUTL0
 I BARSPAR(6.5)=BARSPAR(6.07) S BARSPAR(7)=BARSPAR(7)+1
 E  S BARSPAR(6,"I")=DT,BARSPAR(7)=1
 K DIE,DR,DA
 S DIE=$$DIC^XBDIQ1(90052.06)
 S DA=+BARSPAR("ID")
 S DR="6////^S X=BARSPAR(6,""I"");7///^S X=BARSPAR(7)"
 S DIDEL=90050
 D ^DIE
 K DIDEL
 D BARSPAR^BARUTL0
 L -^BAR(90052.06)
 K DIC,DR,DA,DD,DO
 S X=BARSPAR(9)_"-"_BARSPAR(6.5)_"-"_BARSPAR(7)
 S DIC="^BARBL(DUZ(2),"
 S DIC(0)="XQMLZ"
 S DIC("DR")="8////^S X=DUZ(2);10///^S X=BARUSR(29);5///NOW;6////^S X=DUZ"
 S DLAYGO=90050
 K DD,DO
 D FILE^DICN
 K DLAYGO
 Q
 ; *********************************************************************
 ;
BARBL ;EP
 ; setup BARBL( array from the A/R bill file
 N DIC,DR,DIQ,XB
 S:$D(BARBL("ID")) DA=+BARBL("ID")
 S:$D(BARBLDA) DA=BARBLDA
 S DIC=90050.01
 S DR=".001:200"
 S DIQ="BARBL("
 S DIQ(0)="I"
 D EN^XBDIQ1
 Q
 ; *********************************************************************
 ;
ADDREGON ;EP
 ; add a regional site (needs DUZ(2))
 D ADDREGON^BARUTL0
 Q
 ; *********************************************************************
 ;
FNUM ;;$T filenumber to be regionally added/deleted
 ;;90051.01
 ;;90051.02
 ;;90050.02
 ;;90050.01
 ;;90052.05
 ;;90052.06
 ;;90052.07
 ;;90050.03
 ;;end of list
EFNUM ;----------
 ;
CHKFILES ;EP
 ; CHECK FILES
 K BARQUIT
 Q
 F BARI=1:1 S BARFLNUM=$P($T(FNUM+BARI),";;",2) Q:'BARFLNUM  D
 . S BARGL=^DIC(BARFLNUM,0,"GL")_"0)"
 . S BARECNT=$P($G(@BARGL),"^",4)
 . I 'BARECNT,BARFLNUM'=90050.03,BARFLNUM'=90051.01 D
 . . S BARQUIT=1
 . . W !,$P(^DIC(BARFLNUM,0),U),"  Needs to have entries added !"
 I $G(BARQUIT) D EOP(1)
 Q
 ; *********************************************************************
 ;
KILLREG ;EP
 ; Kill off a complete region
 K DIQ
 S DIC=4
 S DIQ="BARTMP("
 S DR=".01"
 S DA=DUZ(2)
 D EN^XBDIQ1
 I '$D(^BARBL(DUZ(2))) D  Q
 . W !,?5,BARTMP(.01),"DOES NOT EXIT"
 . K DIR
 . D EOP^BARUTL(1)
 ;
 K DIR
 S DIR(0)="Y"
 S DIR("B")="NO"
 S DIR("A")=BARTMP(.01)_" to be DELETED as an A/R Regional Site?"
 D ^DIR
 Q:Y'>0
 F BARI=1:1 S BARFLNUM=$P($T(FNUM+BARI),";;",2) Q:'BARFLNUM  D
 . S BARGL=^DIC(BARFLNUM,0,"GL")_"0)"
 . W !,"DELETED: ",?10,$P(@BARGL,U)
 . K @($P(BARGL,",0)")_")")
 W !!,BARTMP(.01)," Has been DELETED",!
 K DIR
 D EOP^BARUTL(1)
 Q
 ; *********************************************************************
 ;
SPEDIT ;EP - Site Parameter edit
 S DIC=90052.06
 S DIC(0)="AEQMLZ"
 D ^DIC
 Q:Y'>0
 S DIE=DIC
 S DA=+Y
 S DR="8////^S X=DUZ(2);2;3"
 S DIDEL=90050
 D ^DIE
 K DIDEL
 G SPEDIT
 ; *********************************************************************
 ;
PSHLP ;EP list par/sat and hot keys
 N Y
 S Y=0
 F  S Y=$O(BARPSAT(Y)) Q:Y'>0  W !,BARPSAT(Y,2),?5,BARPSAT(Y,.01)
 Q
 ; *********************************************************************
 ;
BAL(X,Y) ;EP
 ; balance at end of FM DATE y FOR ACCOUNT x
 N BARTOT,I
 S BARTOT=0,I=0
 S Y=$P(Y,".",1)+.9999
 F  S I=$O(^BARTR(DUZ(2),"AE",X,I)) Q:'I!(I>Y)  D
 .S BARTOT=BARTOT+$P(^BARTR(DUZ(2),I,0),"^",2)-$P(^(0),"^",3)
 S BARTOT=BARTOT*-1
 Q BARTOT
 ; *********************************************************************
 ;
EOP(X) ;EP
 ; end of page
 ;X=0, 1, or 2
 Q:$G(IOT)'["TRM"
 Q:$E($G(IOST))'="C"
 Q:$D(IO("S"))
 Q:$D(ZTQUEUED)
 F  W ! Q:$Y+4>IOSL
 Q:X=2
 K DIR
 S DIR(0)="E"
 S:X=1 DIR("A")="Enter RETURN to continue"
 D ^DIR
 K DIR
 Q
 ; *********************************************************************
 ;
UPC(X) ;EP - convert x to upper case
 N Y
 S Y=$TR($G(X),"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 Q Y
 ; *********************************************************************
 ;
LWC(X) ;EP - convert x to lower case
 N Y
 S Y=$TR($G(X),"ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz")
 Q Y
 ; *********************************************************************
 ;
FIND3PB(DUZO2,BARBLDA)       ; EP
 ;
 ; Given DUZ(2) and A/R Bill IEN
 ; Find 3P Bill
 ; If no 3P Bill return null
 ; otherwise return DUZ(2),3P BILL IEN
 ;
 I '+DUZO2 Q ""
 I '+BARBLDA Q ""
 N BARDOS,BARPAT,BAR
 S BAR("3P NAME")=$P($G(^BARBL(DUZO2,BARBLDA,0)),U)
 S BAR("3P NAME")=$P(BAR("3P NAME"),"-")
 S BARPAT=$P($G(^BARBL(DUZO2,BARBLDA,1)),U)
 S BARDOS=$P($G(^BARBL(DUZO2,BARBLDA,1)),U,2)
 K DIC
 N DA
 S DIC="^ABMDBILL(DUZ(2),"
 S DIC(0)="XM"
 S X=BAR("3P NAME")
 S BARHOLD=DUZ(2)
 S DUZ(2)=$P($G(^BARBL(DUZO2,BARBLDA,0)),U,22)   ; 3P DUZ(2)
 I DUZ(2)'="" D ^DIC I +Y>0 D FIND3PB2 I BAR3PLOC]"" S DUZ(2)=BARHOLD Q BAR3PLOC
 S DUZ(2)=$P($G(^BARBL(DUZO2,BARBLDA,1)),U,8)    ; Visit location
 I DUZ(2)'="" D ^DIC I +Y>0 D FIND3PB2 I BAR3PLOC]"" S DUZ(2)=BARHOLD Q BAR3PLOC
 S DUZ(2)=$P($G(^BARBL(DUZO2,BARBLDA,0)),U,8)    ; Parent location
 I DUZ(2)'="" D ^DIC I +Y>0 D FIND3PB2 I BAR3PLOC]"" S DUZ(2)=BARHOLD Q BAR3PLOC
 S DUZ(2)=BARHOLD
 Q ""
 ; *********************************************************************
 ;
FIND3PB2 ;
 N BAR3PPAT,BAR3PDOS
 S BAR3PLOC=""
 S BAR3PPAT=$P($G(^ABMDBILL(DUZ(2),+Y,0)),U,5)
 S BAR3PDOS=$P($G(^ABMDBILL(DUZ(2),+Y,7)),U,1)
 I BAR3PPAT=BARPAT,BAR3PDOS=BARDOS S BAR3PLOC=DUZ(2)_","_+Y
 S DUZ(2)=BARHOLD
 Q
 ; ********************************************************************
 ;
INSIEN(BAR1,BAR2,BAR3) ; EP
 ;
 ; Find IEN to Insurer file
 ; BAR1 = "BILL"/"ACCOUNT"
 ; BAR2 = BILL IEN/ACCOUNT IEN based on BAR1
 ; BAR3 = DUZ(2)
 ;
 S BARINS=""
 I '$D(BAR1),'$D(BAR2),'$D(BAR3) Q ""   ; Correct data not passed in
 I BAR1'="BILL",BAR1'="ACCOUNT" Q ""    ; BAR1 must be BILL or ACCOUNT
 I '+BAR2,'+BAR3 Q ""                   ; BAR2 and BAR3 must be numeric
 I BAR1="BILL" S BAR2=$$GET1^DIQ(90050.01,BAR2,3,"I")
 I +BAR2 D
 . S BARINS=$$GET1^DIQ(90050.02,BAR2,.01,"I")
 . S:$P(BARINS,";",2)'="AUTNINS(" BARINS=""  ; Account on bill is not Insurer
 . S BARINS=$P(BARINS,";")
 Q BARINS
 ; ********************************************************************
 ;
SBR(BARDUZ,BARBL) ; EP CALLED AS FUNCTION FROM BARRAOI
 ;
 ; Find Insurance Subscriber given Bill IEN and DUZ(2)
 ; BARBL = A/R BILL IEN
 ; BARDUZ = A/R DUZ(2)
 ;
 I '$D(BARBL),'$D(BARDUZ) Q ""          ; Correct data not passed in
 I '+BARBL,'+BARDUZ Q ""                ; Values must be numeric
 N BAR3PLOC,BAR3PIEN,BAR3DUZ            ; Preserve tmp vars
 S BAR3PLOC=$$FIND3PB^BARUTL(BARDUZ,BARBL)   ; Find 3P bill
 S BAR3DUZ=$P(BAR3PLOC,",")                  ; 3P DUZ(2)
 S BAR3PIEN=$P(BAR3PLOC,",",2)               ; 3P BILL IEN
 I '+BAR3DUZ Q ""
 I 'BAR3PIEN Q ""
 ; The call below will also set up ABMP array
 S BARSBR=$$SBR^ABMUTLP(BAR3PIEN,BAR3DUZ)    ; Subscriber
 S BARREL=ABMP("REL")                       ; Relationship
 Q BARSBR                                   ; fix: added ret value P.OTT
 ;start new code IHS/SD/SDR 5/26/09 HEAT4301 BAR*1.8*13
PATCH(PKG,VER) ;EP - returns last patch applied for a Package, PATCH^DATE
 ;        Patch includes Seq # if Released
 N PKGIEN,VERIEN,LATEST,PATCH,SUBIEN
 I $G(VER)="" S VER=$$VERSION^XPDUTL(PKG) Q:'VER -1
 S PKGIEN=$O(^DIC(9.4,"B",PKG,"")) Q:'PKGIEN -1
 S VERIEN=$O(^DIC(9.4,PKGIEN,22,"B",VER,"")) Q:'VERIEN -1
 S LATEST=-1,PATCH=-1,SUBIEN=0
 F  S SUBIEN=$O(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN)) Q:SUBIEN'>0  D
 . I $P(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN,0),U,2)>LATEST S LATEST=$P(^(0),U,2),PATCH=$P(^(0),U)
 . I $P(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN,0),U,2)=LATEST,$P(^(0),U)>PATCH S PATCH=$P(^(0),U)
 Q PATCH_U_LATEST
 ;end new code HEAT4301 BAR*1.8*13
 ;
 ;New GROUPLAN tag   ;M819*ADD*TMM*20100720
GROUPLAN(BARBL) ;  Return Group Plan (from Employer Group Insurance file)  
 ; BARBL = A/B Bill IEN
 ;---A/R Bill file data
 N BARACIEN,BARFIND,BARBLINS,BARGPIEN,BARGPNAM,BARGPNUM,BARINSE,BARINSI
 N BARLINE,BARPH,BARPHIEN,BARPOLH,BARPOLN,BARTMP,BARTMPBL,BARTMPEG,BARTMPPH
 S $P(BARLINE,"-",40)=""
 S BARACIEN=$$GET1^DIQ(90050.01,BARBL_",",3,"I")        ;A/R Bill - A/R Account IEN
 S BARBLINS=$$GET1^DIQ(90050.02,BARACIEN_",",.01,"I")
 I BARBLINS'["AUTNINS" Q 0_U_"NOT AUTNINS"_U_BARBL      ;not insurance company
 S BARINSI=$P(BARBLINS,";",1)
 S BARINSE=$$GET1^DIQ(9999999.18,BARINSI_",",.01,"E")
 S BARPAT=$$GET1^DIQ(90050.01,BARBL_",",101,"I")        ;Patient IEN
 I BARPAT="" S BARTMP=0_U_"BARPAT"_U_BARBL D  Q BARTMP
 . I $G(DEBUG) D
 .. W !,"BARBL=",BARBL," Patient (Policy Holder lookup) is null"
 .. S BARTMP=$G(^TMP($J,"BARDRST",BARBL))+1
 .. S ^TMP($J,"BARDRST",BARBL,BARTMP)="GRPPLAN_BARUTL^BARBL="_BARBL_"^0|BARPAT is null"_"|"_BARBL
 ;---Policy Holder file data
 S BARPOLH=$$GET1^DIQ(90050.01,BARBL_",",701,"I")       ;Policy Holder Name
 S BARPOLN=$$GET1^DIQ(90050.01,BARBL_",",702,"I")       ;Policy Number FIXED: P.OTT
 S BARFIND=0
 S BARGPIEN=""
 S BARPH="" F  S BARPH=$O(^AUPN3PPH("C",BARPAT,BARPH)) Q:BARPH=""!BARFIND=1  D
 . S BARPHINS=$$GET1^DIQ(9000003.1,BARPH_",",.03,"I")   ;Insurance company from Policy Holder file
 . I BARPHINS'=BARINSI Q
 . S BARFIND=1
 . S BARPHIEN=BARPH
 . S BARGPIEN=$$GET1^DIQ(9000003.1,BARPHIEN_",",.06,"I")    ;group IEN
 I 'BARFIND Q 0_U_"BARFIND"_U_BARBL
 ;---Employer Insurance Group data for this A/R bill
 I 'BARFIND D  Q 0_U_"BARFIND^"_BARBL
 I BARGPIEN="" Q 0_U_"BARGPIEN"_U_BARBL
 S BARGPNAM=$$GET1^DIQ(9999999.77,BARGPIEN_",",.01,"E")  ;group plan name
 S BARGPNUM=$$GET1^DIQ(9999999.77,BARGPIEN_",",.02,"E")  ;group plan number
 S BARTMPEG=BARGPIEN_"|"_BARGPNUM_"|"_BARGPNAM   ;Employer Group data
 S BARTMPPH=BARPHIEN_"|"_BARPOLH_"|"_BARPHINS_"|"_BARPAT    ;Policy Holder data
 S BARTMPBL=BARACIEN_"|"_BARINSI_"|"_BARINSE     ;A/R Bill data
 Q 1_U_BARTMPEG_U_BARTMPPH_U_BARTMPBL
 ;-----------------EOR------------
