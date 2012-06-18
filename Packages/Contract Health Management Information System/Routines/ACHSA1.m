ACHSA1 ; IHS/ITSC/PMF - ENTER DOCUMENTS (2/8)-(PT,HRN,FAC,EDOS,PRO) ;    [ 09/22/2004  3:53 PM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**3,4,5,6,7,16**;JUNE 11, 2001
 ;ACHS*3.1*3  new method of display 'other resources'
 ;ACHS*3.1*4  fix bug in pawnee
 ;ACHS*3.1*5 12/06/2002 fix another pawnee bug
 ;ACHS*3.1*6 4/14/2003 Test vendor fields on Fed sites
 ;ACHS*3.1*7 9/8/2003-Comment out patch 6 items until AUT is ready
 ;ACHS*3.1*16 10/21/2009 IHS.OIT.FCJ Added test for Vendor CCR
 ;
 ;12/4/00  pmf  add changes for pawnee special benefit
 ;
 ;pawnee change here
 I +$P($G(^AUTTLOC(DUZ(2),0)),U,10)=505613 D  G @TAG
 . N ACHSPWNE S ACHSPWNE=0
 . D PAWNEE
 . ; either go on, go to the end, or go back.
 . ; if no value matches, go to the end.
 . ;ACHS*3.1*5 098/26/2002 pmf  tag name is wrong
 . ;S TAG="END"
 . S TAG="ENDC"
 . I ACHSPWNE="OK" S TAG="B0C"
 . I ACHSPWNE="BACK" S TAG="A3^ACHSA"
 . Q
 ;
B0 ; Get patient name, if not Blanket or Spec. Trans.
 ;
 I $D(ACHSBLKF)!($D(ACHSSLOC)) G B3    ;IF BLANKET FORM OR ????
 G B0B:'$D(DFN)!('$D(ACHSHRN))         ;GOTO PATIENT LOOKUP
 G B0B:DFN&('$D(^DPT(DFN,0)))          ;GOTO PATIENT LOOKUP
 S Y=DFN
 ;
 D ^AUPNPAT                            ;SET STANDARD PATIENT VARIABLES
 ;
 ;BEGIN Y2K FIX BLOCK
 W !!,"Patient Info: ",$E($P($G(^DPT(DFN,0)),U),U,22),?37,SEX,?39,$E(DOB,4,5),"-",$E(DOB,6,7),"-",$E(DOB,1,3)+1700,?48,SSN,?60,$G(ACHSHRN)
 ;END Y2K FIX BLOCK
 I $G(ACHSREF(.03)) G B0C   ;DID %RSE AND FOUND NOWHERE BUT HERE?????
 ;
 ;PATIENT LOOKUP
B0B ;
 D PTLK^ACHS                ;STANDARD CHS PATIENT LOOKUP
 K ACHSHRN,ACHSPATF
 I $D(DTOUT) D END^ACHSA Q  ;KILL VARS AND QUIT
 I $D(DUOUT)!'$D(DFN) Q     ;GO BACK TO CALLING RTN ACHSA
 S Y=DFN
 ;
 D ^AUPNPAT                  ;POST PATIENT SELECTION VARIABLE SETS
 ;
B0C ;
 I $G(ACHSPATF),$G(ACHSHRN) G B4
 ;
 ;IF 'MULT. FACILITY PATIENT LOOKUP' IS NO SKIP TO CHECK ELIGIBILITY
 I $$PARM^ACHS(2,5)'="Y" S ACHSPATF=DUZ(2),ACHSHRN=$$HRN^ACHS(DFN,ACHSPATF) G B4
 ;
B1 ; Display/Select Facility(s) at which Patient is Registered.
 ;
 ;IF JUST ONE HRN THIS WILL GET IT ;'HEALTH RECORD NO.' NODE 
 S ACHS=0
 F ACHSPATF=0:0 Q:'$O(^AUPNPAT(DFN,41,ACHSPATF))  D
 .S ACHSPATF=$O(^AUPNPAT(DFN,41,ACHSPATF))
 .S ACHS=ACHS+1
 ;
 ;
 I ACHS=0 W !!,"NO CHARTS AVAILABLE!!" G B3
 I ACHS=1 S ACHSHRN=$$HRN^ACHS(DFN,ACHSPATF) G B4
 S ACHS=0
 ;
 ;PRINT OUT THE LIST OF CHARTS AVAILABLE
 W !!,"ITM #","     CHART #",?20,"FACILITY NAME",!
 F ACHSPATF=0:0 S ACHSPATF=$O(^AUPNPAT(DFN,41,ACHSPATF)) Q:+ACHSPATF=0  S ACHS=ACHS+1,ACHSHRN=$P($G(^AUPNPAT(DFN,41,ACHSPATF,0)),U,2),ACHS(ACHS)=ACHSPATF_U_ACHSHRN W !,$J(ACHS,4),?11,ACHSHRN,?20,$P($G(^DIC(4,ACHSPATF,0)),U)
 ;
B2 ;
 ;
 S Y=$$DIR^XBDIR("N^1:"_ACHS,"SELECT ITEM # FOR APPROPRIATE FACILITY & CHART # COMBINATION","","","","",2)
 Q:$D(DUOUT)
 I $D(DTOUT) D END^ACHSA Q
 S ACHSHRN=$P(ACHS(+Y),U,2)
 S ACHSPATF=$P(ACHS(+Y),U)
 G B4
 ;
B3 ;SECTION USED FOR ENTERING BLANKET DESCRIPTION
 ;
 D ^ACHSA2                            ;ENTER DOCUMENT 3 OF 8
 ;
 I $D(DUOUT)!'$D(ACHSBLT) D A3^ACHSA Q
 I $G(ACHSQUIT) D END^ACHSA Q
 I $D(ACHSBLKF)!($D(ACHSSLOC)) S (ACHSPATF,ACHSHRN)=""
 ;
B4 ; Check CHS eligible.
 G B5:$D(ACHSBLKF)!($D(ACHSSLOC))
 ;
 ;IF 'PATIENT ADDRESS REQUIRED' 
 I $$PARM^ACHS(2,4)'="N" G NOCITY:'$D(^DPT(DFN,.11)) G NOCITY:$P($G(^DPT(DFN,.11)),U,4)=""!($P($G(^DPT(DFN,.11)),U,5)="")
 ;
 ;
 ;1/11/02  pmf  rewrote ACHSRP31 as ACHSRPIN.  new version is
 ;smaller, faster, cleaner, WORKS better, more modular, more
 ;usable, easier to read, better commented, and so on.
 ;S ACHSTAB=0 ; ACHS*3.1*3
 ;D EN^ACHSRP31 ;ACHS*3.1*3
 D GET^ACHSRPIN,PRT^ACHSRPIN ; ACHS*3.1*3
 ;K ACHSTAB ; ACHS*3.1*3
 ;
 ;
 ;IF 'CHECK FOR CHS ELIGIBILITY' 
 I $$PARM^ACHS(2,8)="N" W !!,"'",$P($G(^DD(9002080,14.08,0)),U),"' parameter = '",$$PARM^ACHS(2,8),"'.",!!,"CHS Eligibility not checked.",!,"Parameter 'CHECK FOR CHS ELIGIBILITY' not set." G B5
 ;
 ;
 I '$D(^AUPNPAT(DFN,11)) W *7,!!,"ELIGIBILITY INFORMATION MISSING (NODE 11 IN 'PATIENT FILE') _ Transaction Cancelled" D ENDC G B0
 ;
 ;ELIGIBILITY STATUS
 S ACHSELIG=$P($G(^AUPNPAT(DFN,11)),U,12)
 I ACHSELIG'="C" W !!,*7,"Patient NOT ELIGIBLE for Contract Health Services",!,"Current status is: ",$S(ACHSELIG="I":"INELIGIBLE",ACHSELIG="D":"DIRECT ONLY",ACHSELIG="P":"PENDING VERIFICATION",1:"UNDEFINED") D ENDC G B0
 ;
 ;new code from jeanette.  check for inactive or dead patients
 I $P($G(^AUPNPAT(DFN,41,ACHSPATF,0)),U,5)="I" W !!,*7,"*****Patient is not registered as active*****",!!,"*****See Patient Regististration*****" D ENDC G B0
 ;I $P($G(^DPT(DFN,0)),U,10)'=""  W !!,*7,"*****Patients record indicates a death date.*****",!!,"*****See Patient Registration.*****" D ENDC G B0
 ;
 ;
B5 ;EP - Enter Estimated DOS, 1 year either side of TODAY.
 K DIR,ACHSOKFL
 ;Y2K -- BEGIN
 ;Y2K NORMALIZE THE DATES TO YYYYMMDD
 ;
 ;IF 'FISCAL YEAR'
 I $P($G(^ACHSF(DUZ(2),0)),U,7)=1 S ACHSXXXX=(ACHSACFY-1)_$P($G(^ACHSF(DUZ(2),0)),U,6) S ACHSXXXZ=(ACHSACFY_$P($G(^ACHSF(DUZ(2),0)),U,6))-1 ;Y2000
 ;
 I $P($G(^ACHSF(DUZ(2),0)),U,7)=0 S ACHSXXXX=ACHSACFY_$P($G(^ACHSF(DUZ(2),0)),U,6) S ACHSXXXZ=((ACHSACFY+1)_$P($G(^ACHSF(DUZ(2),0)),U,6))-1 ;Y2000
 ;
 ;Y2K -- END
B51 ;
 W !!
 S DIR(0)="D^::EX",DIR("A")="Enter Estimated Date of Service"
 I $D(ACHSEDOS),ACHSEDOS]"" S DIR("B")=$$FMTE^XLFDT(ACHSEDOS)
 D ^DIR
 I $D(DUOUT)!$D(DTOUT) D END^ACHSA Q   ;GO KILL VARS AND END
 S (ACHSEDOS,ACHSZZZX)=Y
 I $D(ACHSOKFL) S (ACHSCONP,ACHSCTNA,ACHSAGRN,ACHSAGRP)="" G B5A
 W:Y<(DT-10000) *7,!,"  Date is more than ONE YEAR ago.",!
 I Y>(DT+10000) W *7,!,"  Cannot be more than ONE YEAR in the future.",! G B51
 ;Y2K -- BEGIN
 S ACHSZZZZ=17000000+ACHSZZZX ;Y2000
 ;Y2K -- END
 I ACHSZZZZ<ACHSXXXX!(ACHSZZZZ>ACHSXXXZ) D  G:ACHSOKFL=1 B51
 . W *7,!!?15,$$REPEAT^XLFSTR("*",40)
 . W !?15,"*    Estimated DOS is NOT within the   *",!?15,"*     FISCAL YEAR you have selected.   *",!?15,"* Press <RETURN> if OK. Or '^' to exit *",!?15,$$REPEAT^XLFSTR("*",40)
 . S DIR("B")=$$FMTE^XLFDT(ACHSZZZX)
 . S ACHSOKFL=1
 ;
 ;
 S (ACHSCTNA,ACHSAGRN,ACHSAGRP,ACHSCONP)=""
B5A ;EP - Select provider/vendor.
 S DIC("S")="I $P($G(^AUTTVNDR(Y,0)),U,5)="""""    ;CHECK 'INACTIVATED DATE'
 S DIC="^AUTTVNDR(",DIC(0)="AEMQZ"
 S DIC("A")="Select PROVIDER/VENDOR: "
 I $G(ACHSPROV),$D(^AUTTVNDR(ACHSPROV,0)) S DIC("B")=$P($G(^AUTTVNDR(ACHSPROV,0)),U)
 ;
 D ^DIC        ;LOOKUP PROVIDER
 ;
 K DIC
 ;
 ;IHS/SET/JVK ACHS*3.1*6 IF A FED SITE CHECK FOR COMPLETE EIN INFO
 ;S ACHSVFLG=""
 ;I $$PARM^ACHS(0,8)'="Y",Y>1,DT>3030901 D VCHK^ACHSVDVD
 ;
 G B0:$D(DUOUT)
 I $D(DTOUT) D END^ACHSA Q
 I Y<1 W *7,"  Must Have Vendor" G B5A
 ;
 ;I ACHSVFLG W !,"You must fix the missing vendor entries listed above" G B5A ;IHS/SET/JVK ACHS*3.1*6
 S ACHSPROV=+Y,ACHSCONP="",ACHSHON="",E=0,ACHSDFLG=2
 ;
 D ^ACHSVDVD          ;CHECK FOR DUPES WHEN ENTERING NEW VENDOR
 ;
 G:'$G(ACHSPROV) B5A  ;NO VENDOR FOUND TRY AGAIN
 ;
 ;
 S X=$P($G(^AUTTVNDR(ACHSPROV,11)),U,3)   ;VENDOR TYPE PTR
 I +X<1 F  W !,"Please enter 2-digit code for Vendor type.",! S DIE="^AUTTVNDR(",DA=ACHSPROV,DR=1103 D ^DIE K DIE G B5A:$D(Y) Q:$P($G(^AUTTVNDR(ACHSPROV,11)),U,3)
 ;
 ;ACHS*3.1*16 10/21/2009 OIT.IHS.FCJ ADDED NEXT LINE TO TEST FOR PARAMETER AND VENDOR CCR
 I $$PARM^ACHS(0,15)="Y",(($P($G(^AUTTVNDR(ACHSPROV,0)),U,8)="N")!($P($G(^AUTTVNDR(ACHSPROV,0)),U,8)="")) W !,"Vendor is not CCR certified, please update vendor information.",! G B5A
 ;
PAN ; If HIGH VOLUME PROVIDER, prompt for Patient Account Number, optional.
 I $D(^ACHSF(DUZ(2),18,"B",ACHSPROV)) S ACHSPAN=$$DIR^XBDIR("9002080.01,26.01","",$G(ACHSPAN))
 ;
 D ^ACHSA3    ;ENTER DOCUMENTS (4/8) CON,DESC,PRD,ONUM
 Q
 ;
 ;
ENDC ;
 W !
 D RTRN^ACHS
 S DUOUT=""
 K DFN
 W @IOF
 Q
 ;
NOCITY ; Cancel If No City or State for patient.
 W *7,!!,"This patient does not have a complete mailing address",!,"in the medical records files."
 W !!,"No document may be issued until the mailing address is complete.",!!!,"'",$P($G(^DD(9002080,14.04,0)),U),"' parameter = '",$$PARM^ACHS(2,4),"'.",!!
 D RTRN^ACHS
 S ACHSTYP=0
 Q
 ;
PAWNEE  ; 
 ;IHS/ITSC/PMF  12/1/00  add this tag to accomodate a special
 ;Pawnee benefit.  set var ACHSPWNE based on what happens
 ;
 S DIC=1808000,DIC(0)="IQAZEM" S:$D(DFN) DIC("B")=$P($G(^DPT(DFN,0)),U)
 D ^DIC K DIC
 I $D(DUOUT)!(+Y<0) S ACHSPWNE="BACK" Q
 S (ACHSDFN,DFN)=+Y,ACHSBPNO=$P($G(^AZOPBPP(+Y,0)),U,2)
 K ACHSHRN,ACHSPATF
 S PBEXDT=+$P($G(^AZOPBPP(+Y,0)),U,3),Y=PBEXDT X ^DD("DD")
 ;
 ;ACHS*3.1*4   3/28/02  pmf  need to quit at the end of this if
 ;I PBEXDT<DT W !!,*7,"PBPP Eligibility Card Expired on ",Y,"  --  TRANSACTION CANCELLED" S ACHSPWNE="NOTOK"  ;  ACHS*3.1*4
 I PBEXDT<DT W !!,*7,"PBPP Eligibility Card Expired on ",Y,"  --  TRANSACTION CANCELLED" S ACHSPWNE="NOTOK" Q  ;  ACHS*3.1*4
 S ACHSPWNE="OK"
 Q
 ;
