ACRFDHR5 ;IHS/OIRM/DSD/AEF - RECOVER UNTRANSMITTED DHRS [ 11/01/2001   9:44 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;;NOV 05, 2001
 ;
 ;This routine will loop through the FMS Document History Record file
 ;and find those DHRs that have not been transmitted, i.e., 
 ;don't have an entry in the UNIX EXPORT FILE field and put them into
 ;ARMS-BLUE or ARMS-RED batches for transmission to CORE.
 ;
 ;Payment DHRs can be recovered by reopening and re-exporting the
 ;payment batch.
 ;
EN ;EP -- MAIN ENTRY POINT
 ;
 N ACRASK,ACRRANGE
 D TXT
 I $$CHK D  Q
 . W !!,"Records exist in ARMS-BLUE and/or ARMS-RED batches.  These"
 . W !,"records must be cleared before running this option."
 . W !
 D ASK(.ACRASK)
 Q:'ACRASK
 I ACRASK=1 D DATE(ACRASK,.ACRRANGE)
 I ACRASK=2 D IEN(ACRASK,.ACRRANGE)
 Q:'ACRRANGE
 D DATA(ACRRANGE)
 Q
ASK(ACRASK)        ;
 ;----- RETURNS SORT PREFERENCE, BY DATE OR IEN
 ;
 N DIR,DIRUT,DTOUT,DUOUT,X,Y
 S ACRASK=0
 S DIR(0)="S^1:BY DATE GENERATED;2:BY IEN NUMBER"
 S DIR("A")="SORT BY"
 S DIR("?")="Enter 1 if you want to find DHRs by DATE GENERATED, 2 if you want to find DHRs by IEN number"
 D ^DIR
 Q:$D(DTOUT)!($D(DIRUT))!($D(DUOUT))
 S ACRASK=Y
 Q
DATE(ACRASK,ACRRANGE)        ;
 ;----- ASK AND RETURN DATE RANGE
 ;
DATELOOP ;
 N ACRBEG,ACREND,DIR,DIRUT,DTOUT,DUOUT,X,Y
 S ACRRANGE=""
 W !
 S DIR(0)="DO^::E"
 S DIR("A")="Start with DATE GENERATED"
 D ^DIR
 Q:$D(DTOUT)!($D(DIRUT))!($D(DUOUT))
 S ACRBEG=Y
 I ACRBEG<3000701 D  G DATELOOP
 . W !?5,"Cannot recover DHRs generated before July 1, 2000"
 S DIR("A")="End with DATE GENERATED"
 D ^DIR
 Q:$D(DTOUT)!($D(DIRUT))!($D(DUOUT))
 S ACREND=Y
 I ACRBEG>ACREND D  G DATELOOP
 . W !?5,"ENDING DATE cannot be less than BEGINNING DATE"
 S ACRRANGE=ACRASK_U_ACRBEG_U_ACREND
 Q
IEN(ACRASK,ACRRANGE)         ;
 ;----- ASK AND RETURN IEN RANGE
 ;
 ;RESTRICT TO DATES AFTER 7-1-00
IENLOOP ;
 ;
 N ACRBEG,ACREND,DIR,DIRUT,DTOUT,DUOUT,X,Y
 S ACRRANGE=""
 W !
 S DIR(0)="N"
 S DIR("A")="Begin with IEN NUMBER"
 S DIR("?")="Enter Iternal Entry Number (IEN)"
 D ^DIR
 Q:$D(DTOUT)!($D(DIRUT))!($D(DUOUT))
 S ACRBEG=Y
 S DIR("A")="End with IEN NUMBER"
 D ^DIR
 Q:$D(DTOUT)!($D(DIRUT))!($D(DUOUT))
 S ACREND=Y
 I ACRBEG>ACREND D  G IENLOOP
 . W !?5,"ENDING IEN cannot be less than BEGINNING IEN"
 S ACRRANGE=ACRASK_U_ACRBEG_U_ACREND
 Q
DATA(ACRRANGE)     ;
 ;----- GATHERS DHR DATA AND PUTS INTO ARMS BATCH
 ;
 I $P(ACRRANGE,U)=1 D LOOP1(ACRRANGE)
 I $P(ACRRANGE,U)=2 D LOOP2(ACRRANGE)
 Q
LOOP1(ACRRANGE)    ;
 ;----- LOOP THROUGH DATE GENERATED XREF
 ;
 N ACRCNT,ACRDATE,ACREND,ACRIEN
 S ACRDATE=$P(ACRRANGE,U,2)
 S ACREND=$P(ACRRANGE,U,3)
 S ACRDATE=ACRDATE-1
 F  S ACRDATE=$O(^ACRDHR("D",ACRDATE)) Q:'ACRDATE  Q:ACRDATE>ACREND  D
 . S ACRIEN=0
 . F  S ACRIEN=$O(^ACRDHR("D",ACRDATE,ACRIEN)) Q:'ACRIEN  D
 . . Q:$P($G(^ACRDHR(ACRIEN,20)),U,7)]""
 . . D SET(ACRIEN)
 I $G(ACRCNT) D
 . W !!?5,ACRCNT," records have been placed in ARMS batch"
 I '$G(ACRCNT) D
 . W !!?5,"No records found      "
 H 3
 Q
LOOP2(ACRRANGE)    ;
 ;----- LOOP THROUGH IENS
 ;
 N ACRCNT,ACREND,ACRIEN
 S ACRIEN=$P(ACRRANGE,U,2)
 S ACREND=$P(ACRRANGE,U,3)
 S ACRIEN=ACRIEN-1
 F  S ACRIEN=$O(^ACRDHR(ACRIEN)) Q:'ACRIEN  Q:ACRIEN>ACREND  D
 . Q:$P($G(^ACRDHR(ACRIEN,0)),U,2)<3000701
 . Q:$P($G(^ACRDHR(ACRIEN,20)),U,7)]""
 . D SET(ACRIEN)
 I $G(ACRCNT) D
 . W !!?5,ACRCNT," records have been placed in ARMS batch"
 I '$G(ACRCNT) D
 . W !!?5,"No records found"
 H 3
 Q
SET(ACRIEN)        ;
 ;----- SET DHRS INTO ARMS BATCH
 ;
 ;      This subroutine calls DHRRCD^ACRFDHR1 to add an entry to the
 ;      ARMS-BLUE or ARMS-RED batch in the DHR Data Records file.
 ;      It sets up the variables needed for this call.
 ;
 ;      ACR3     =  TRANSACTION TYPE
 ;      ACRDEPT  =  DEPARTMENT ACCOUNT
 ;      ACRDOC0  =  ZERO NODE OF DOCUMENT IN FMS DOCUMENT FILE
 ;      ACRDR    =  DR EDIT STRING
 ;      ACRFY    =  FISCAL YEAR OF FUNDS FROM DEPARTMENT ACCOUNT
 ;      ACRIV    =  PAYMENT TRANSACTION INDICATOR
 ;      ACRRECOV =  RECOVERED DHRS INDICATOR (COMING THRU THIS ROUTINE)
 ;      ACRREF   =  DOCUMENT REFERENCE CODE
 ;
 N ACR3,ACRDATA,ACRDEPT,ACRDOC0,ACRDR,ACRFY,ACRIV,ACRRECOV,ACRREF,X
 S ACRRECOV=1
 I '$G(ACRACPT) D
 . S X=$P($G(^ACRSYS(1,"DT1")),U,13)
 . Q:'X
 . S ACRACPT=$P($G(^AUTTACPT(X,0)),U)
 S ACRDOC0=$P($G(^ACRDHR(ACRIEN,0)),U,4)
 I ACRDOC0 S ACRDOC0=^ACRDOC(ACRDOC0,0) D
 . S ACRDEPT=$P(ACRDOC0,U,6)
 I $G(ACRDEPT) S ACRFY=$P($G(^ACRLOCB(ACRDEPT,"DT")),U)
 S ACRDATA=^ACRDHR(ACRIEN,1)
 S ACR3=$P(ACRDATA,U,3)
 S ACRIV="PAY"
 I ACR3="050" S ACRIV=""
 I ACR3="081" S ACRIV=""
 S ACRREF=$P(ACRDATA,U,6)
 I ACRREF="" S ACRREF=$P(ACRDATA,U,8)
 S ACRDR="1////"_$P(ACRDATA,U)
 S ACRDR=ACRDR_";2////"_$P(ACRDATA,U,2)
 S ACRDR=ACRDR_";3////"_$P(ACRDATA,U,3)
 S ACRDR=ACRDR_";4////"_$P(ACRDATA,U,4)
 S ACRDR=ACRDR_";5////"_$P(ACRDATA,U,5)
 S ACRDR=ACRDR_";6////"_$P(ACRDATA,U,6)
 S ACRDR=ACRDR_";7////"_$P(ACRDATA,U,7)
 S ACRDR=ACRDR_";8////"_$P(ACRDATA,U,8)
 S ACRDR=ACRDR_";9////"_$P(ACRDATA,U,9)
 S ACRDR=ACRDR_";10////"_$P(ACRDATA,U,10)
 S ACRDR=ACRDR_";11////"_$P(ACRDATA,U,11)
 S ACRDR=ACRDR_";12////"_$P(ACRDATA,U,12)
 S ACRDR=ACRDR_";13////"_$P(ACRDATA,U,13)
 S ACRDR=ACRDR_";14////"_$P(ACRDATA,U,14)
 S ACRDR=ACRDR_";15////"_$P(ACRDATA,U,15)
 S ACRDR=ACRDR_";16////"_$P(ACRDATA,U,16)
 S ACRDR=ACRDR_";17////"_$P(ACRDATA,U,17)
 S ACRDR=ACRDR_";18////"_$$PAD^ACRFUTL($P(ACRDATA,U,18),"L",10,"")
 S ACRDR=ACRDR_";19////"_$E($P(ACRDATA,U,19),1,2)
 S ACRDR=ACRDR_";20////"_$P(ACRDATA,U,20)
 S ACRDR=ACRDR_";21////"_$P(ACRDATA,U,21)
 S ACRDR=ACRDR_";22////"_$P(ACRDATA,U,22)
 S ACRDR=ACRDR_";23////"_$P(ACRDATA,U,23)
 S ACRDR=ACRDR_";24////"_$P(ACRDATA,U,24)
 S ACRDR=ACRDR_";25////"_$P(ACRDATA,U,25)
 S ACRDR=ACRDR_";26////"_$P(ACRDATA,U,26)
 S ACRDR=ACRDR_";27////"_$P(ACRDATA,U,27)
 S ACRDR=ACRDR_";28////"_$P(ACRDATA,U,28)
 S ACRDR=ACRDR_";99////"_ACRIEN
 ;
 D DHRRCD^ACRFDHR1
 Q
CHK() ;----- CHECKS TO SEE IF RECORDS EXISTIN ARMS-BLUE OR ARMS-RED
 ;
 ;      RETURNS:
 ;      0 IF NO RECORDS ARE FOUND
 ;      1 IF RECORDS ARE FOUND
 ;
 N D0,D1,D2
 S Y=0
 F D0=5,6 D
 . S D1=0
 . F  S D1=$O(^AFSHRCDS(D0,"D",D1)) Q:'D1  D
 . . S D2=0
 . . F  S D2=$O(^AFSHRCDS(D0,"D",D1,"I",D2)) Q:'D2  D
 . . . I $O(^AFSHRCDS(D0,"D",D1,"I",D2,"S",0)) S Y=1
 Q Y
TXT ;----- WRITE TEXT
 ;
 N I,X
 F I=1:1 S X=$T(TXT1+I) Q:X["$$END"  W !?5,$P(X,";",3)
 Q
TXT1 ;;
 ;;
 ;;This option will loop through the DHR history file and find the
 ;;transactions for the specified date or IEN range which
 ;;have not been transmitted to CORE.  These transactions will be
 ;;placed into an ARMS batch for transmission.  It is recommended
 ;;that all records be cleared from the ARMS-BLUE and ARMS-RED
 ;;batches before running this option.
 ;;
 ;;$$END
