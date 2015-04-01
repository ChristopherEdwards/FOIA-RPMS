BARRSL1 ; IHS/SD/LSL - Selective Report Parameters-PART 2 ; 12/19/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**6,10,16,19,20,23,24**;OCT 26,2005;Build 69
 ; IHS/SD/TMM 7/20/10 1.8*19 Add Group Plan to A/R Statistical report.
 ;     When selecting A/R STATISTICAL REPORT by Billing Entity prompt
 ;             user for Group Plans to include in report data.
 ;     FIXPMS10019 #1 - TSR report, Add Adjustment inclusion 
 ;             parameter: "Sent To  Collections" 
 ;     Resolve UNDEFINED error <UNDEFINED>S4+12^DICL2 
 ;     Add STATUS CHANGE as Selection Type for TSR report
 ;
 ; IHS/SD/POTT 12/12 ADDED SELECTION OF CODING DX VERSION ICD-9 / ICD-10 - BAR1.8*23
 ; IHS/SD/POTT 03/13 ADDED NEW VA billing - BAR1.8*23
 ; IHS/SD/POTT 06/13 FIXED FLAWS IN SELECTING ICD9/10 DX - BAR1.8*23
 ; IHS/SD/POTT 07/13 DO NOT ALLOW SELECT ICD10 WHEN INFRASTRUCTURE NOT PRESENT - BAR1.8*23
 ; IHS/SD/POTT HEAT150941 02/09/14 Allow ALL DX9/10 - BAR1.8*24
 ;                        if no DX selected: show ALL DX of ALL available coding systems
 ;                        fixed escape from report after pressing ^ in DX prompts
 ; ;;;IHS/SD/POTT ICD-10 SANDBOX TESTING: FIXED ERR MESSAGE Low Diagnosis is Greater than the High IF DXLO=DXHI - BAR1.8*??
 ; IHS/SD/POTT BETA FIXED RETURN TO SELECT INCLUSION PARAMETERS: BAR1.8*24
 ;
 Q
 ; ******
 ;
TRANTYP ; EP
 D TRANTYP^BARRSL4 ;ASK FOR TRANSACTION TYPE
 Q
 ; 
LOC ; EP
 ; Select Location inclusion parameters
 W !
 K DIC,BARY("LOC")
 S DIC="^BAR(90052.05,DUZ(2),"
 S DIC(0)="ZAEMQ"
 S DIC("A")="Select Visit LOCATION: "
 D ^DIC
 K DIC
 Q:$D(DTOUT)!($D(DUOUT))
 Q:+Y<1
 S BARY("LOC")=+Y
 S BARY("LOC","NM")=Y(0,0)
 Q
 ; **************
TYP ; EP
 ; Select BILLING ENTITY Inclusion Parameter
 ; May not specify both billing entity and a/r account
 K DIR,BARY("TYP"),BARY("ACCT"),BARY("PAT"),BARY("ALL"),BARY("ITYP")
 ; - BAR1.8*23 UPDATED DISPATCH TABLE
 S DIR(0)="SO^1:MEDICARE"
 S DIR(0)=DIR(0)_";2:MEDICAID"
 S DIR(0)=DIR(0)_";3:PRIVATE INSURANCE"
 S DIR(0)=DIR(0)_";4:NON-BENEFICIARY PATIENTS"
 S DIR(0)=DIR(0)_";5:BENEFICIARY PATIENTS"
 S DIR(0)=DIR(0)_";6:SPECIFIC A/R ACCOUNT"
 S DIR(0)=DIR(0)_";7:SPECIFIC PATIENT"
 S DIR(0)=DIR(0)_";8:WORKMEN'S COMP"
 S DIR(0)=DIR(0)_";9:PRIVATE + WORKMEN'S COMP"
 S DIR(0)=DIR(0)_";10:CHIP"
 S DIR(0)=DIR(0)_";11:VETERANS ADMINISTRATION"
 S DIR(0)=DIR(0)_";12:OTHER"
 S DIR("A")="Select TYPE of BILLING ENTITY to Display"
 S DIR("?")="Enter TYPE of BILLING ENTITY to display, or press <return> for ALL"
 D ^DIR
 K DIR
 I $D(DUOUT)!($D(DTOUT)) Q
 Q:Y<1
 S BARY("TYP")=U_Y_U
 S BARY("TYP","NM")=Y(0)
 G ACCT:Y=6,PAT:Y=7
 ;P.OTT UPDATED DISPATCH TABLE  BAR1.8*23
 S:Y=1 BARY("TYP")="^R^MH^MD^MC^MMC^"
 S:Y=2 BARY("TYP")="^D^K^FPL^"
 S:Y=3 BARY("TYP")="^H^M^P^F^"
 S:Y=4 BARY("TYP")="^N^"
 S:Y=5 BARY("TYP")="^I^"
 S:Y=8 BARY("TYP")="^W^"
 S:Y=9 BARY("TYP")="^H^M^P^F^W^"
 S:Y=10 BARY("TYP")="^K^"
 S:Y=11 BARY("TYP")="^V^"
 S:Y=12 BARY("TYP")="^W^C^N^I^T^G^SEP^TSI^"
 Q
 ; ***********
ACCT ; 
 ; Specific insurer of billing entity parameter
 K DIC
 K BARY("TYP"),BARY("ACCT")
 S DIC="^BARAC(DUZ(2),"
 S DIC(0)="ZQEAM"
 D ^DIC
 K DIC
 Q:$D(DTOUT)!($D(DUOUT))
 Q:+Y<0
 S BARY("ACCT")=+Y
 S BARY("ACCT","NM")=Y(0,0)
 I $G(BAR("OPT"))="STA" F BARGRPI=1:1 D GETGRP Q:+Y<0
 Q
 ; *******
GETGRP ;  Prompt for Group #   ;New Tag... M819*ADD*TMM*20100720
 W !
 K DIC
 S DIC="^AUTNEGRP("
 S DIC("A")="ENTER IN THE GROUP NUMBER YOU WISH TO REPORT: "
 S DIC(0)="AEQMZ"
 D ^DIC
 I Y'>0 Q
 S BARY("GRP PLAN")=$G(BARGRPI)
 S BARY("GRP PLAN",+Y)=Y(0,0)  ;Y=Group Plan, Y(0,0)=Group Plan Name
 ;END 1.8*19
 Q
 ;
PAT ;
 ; Specific patient of billing entity parameter
 K BARY("TYP"),BARY("PAT")
 S DIC="^AUPNPAT("
 S DIC(0)="ZQEAM"
 D ^DIC
 K DIC
 Q:$D(DTOUT)!($D(DUOUT))
 K AUPNLK("ALL")
 Q:+Y<0
 S BARY("PAT")=+Y
 S BARY("PAT","NM")=Y(0,0)
 Q
 ; **********
ALL ; EP
 ; Select ALLOWANCE CATEGORY Inclusion Parameter  BAR1.8*23
 K DIR,BARY("TYP"),BARY("ACCT"),BARY("PAT"),BARY("ALL"),BARY("ITYP")
 S DIR(0)="SO^1:MEDICARE              (INS TYPES R MD MH MC MMC)" ;JULY 2003 
 S DIR(0)=DIR(0)_";2:MEDICAID              (INS TYPES D K FPL)"
 S DIR(0)=DIR(0)_";3:PRIVATE INSURANCE     (INS TYPES P H F M)"
 S DIR(0)=DIR(0)_";4:VETERANS              (INS TYPES V)"
 S DIR(0)=DIR(0)_";5:OTHER                 (INS TYPES W C N I G T SEP TSI)"
 S DIR("A")="Select TYPE of ALLOWANCE CATEGORY to Display"
 S DIR("?")="Enter TYPE of ALLOWANCE CATEGORY to display, or press <return> for ALL"
 D ^DIR
 K DIR
 I $D(DUOUT)!($D(DTOUT)) S BARDONE3=1 Q
 I Y<1 S BARDONE3=1 Q
 S BARY("ALL")=Y
 S BARY("ALL","NM")=Y(0)
 Q
 ; *******************
DT ; EP
 ; Select Date inclusion parameter
 D DT^BARRSL4
 Q
 ; **************************
PRV ; EP
 ; Select Provider Inclusion Parameter
 D PRV^BARRSL4
 Q
 ; *******************************
AR ; EP
 ; Select A/R Clerk Inclusion Parameter
 D AR^BARRSL4
 Q
 ; ******************
BATCH ; EP
 ; Select Collection Batch Inclusion Parameter
 D BATCH^BARRSL4
 Q
 ; *******
ITEM ; EP
 ; Select Collection Batch Item Inclusion Parameter
 D ITEM^BARRSL4
 Q
 ; *************
RTYP ; EP
 ; Select Report Type Inclusion Parameter
 D RTYP^BARRSL4
 Q
 ; *********************
DSVC ; EP Select One Discharge Service
 D DSVC^BARRSL4
 Q
 ; ********************  BAR1.8*23
ASKICD() ;         
 D ASKICD^BARRSL4()
 Q Y
CLNUPDX ;CLEAN UP DX
 D CLNUPDX^BARRSL4
 Q
DX ; EP
 S BARQ=0 ;^
 K BARY("DX9")
 K BARY("DX10")
 K BARY("DX-ICDVER")
DXCODE ;
 ;S BARICDV=$$ASKICD() I BARICDV="^" D  QUIT ;OLD CODE  BAR1.8*24
 ;FIXED RETURN TO SELECT INCLUSION PARAMETERS
 S BARICDV=$$ASKICD() I BARICDV="^"  S DUOUT=0,DIRUT=0 D  QUIT  ;NEW CODE  BAR1.8*24
 . D CLNUPDX
 I Y="B"!(Y=10) I $T(+1^ICDEX)="" D  G DXCODE
 . W !!!,"NOTE: SOME OF THE ICD-10 INFRASTRUCTURE UTILITIES ARE MISSING."
 . W !,"THIS REPORT CANNOT CURRENTLY PROVIDE ANY DATA BASED ON ICD-10 DX CODES"
 . Q
 S BARY("DX-ICDVER")=BARICDV
 I BARY("DX-ICDVER")=9 D  I $G(BARQ) Q
 . D DX9 I $G(BARQ) Q
 . D DXADD(9) I $G(BARQ) Q
 I BARY("DX-ICDVER")=10 D  I $G(BARQ) Q
 . D DX10 I $G(BARQ) Q
 . D DXADD(10) I $G(BARQ) Q
 I BARY("DX-ICDVER")="B" D  I $G(BARQ) Q
 . D DX9 I $G(BARQ) Q
 . D DXADD(9) I $G(BARQ) Q
 . D DX10 I $G(BARQ) Q
 . D DXADD(10) I $G(BARQ) Q
 I BARY("DX-ICDVER")=9!(BARY("DX-ICDVER")="B") I '$D(BARY("DX9")) D
 . K BARY("DX9")
 . S BARY("DX9")="ALL"  ;- BAR1.8*24
 . S BARY("DX9_ALL")="ALL"
 I BARY("DX-ICDVER")=10!(BARY("DX-ICDVER")="B") I '$D(BARY("DX10")) D
 . K BARY("DX10")
 . S BARY("DX10")="ALL"  ;- BAR1.8*24
 . S BARY("DX10_ALL")="ALL"
 W !!
 D SHOWDX
 S DIR("A")="Are you OK with this selection"
 S DIR("B")="YES"
 S DIR(0)="Y"
 D ^DIR
 K DIR
 I Y'=1 D  G DX
 . W !,"OK, make a new DX selection"
 Q
 ;
DX9 ;<------- 
 ;
DXLOW9 ;
 K BARY("DX9")
 K DIR,DIC,DA
 W !!
 W "Entry of Diagnosis Range ICD-9",!
 W "=============================="
 S DIR(0)="PO^80:ZAEMQ"
 S DIR("A")="Low ICD-9 Code (from) "
 I $$HAVICD10() S DIR("S")="I $P($G(^ICD9(Y,1)),U)=1" ;
 D ^DIR
 I $G(DUOUT) S BARQ=1 Q  ;3/25
 I +Y<1 Q  ;ENTER: GO FOR INDIVIDUAL DX
 S BARY("DX9",1)=$P(Y,U,2)
 ;
DXHI9 ;
 S DIR(0)="PO^80:ZAEMQ"
 S DIR("A")="High ICD-9 Code (to) "
 I $$HAVICD10() S DIR("S")="I $P($G(^ICD9(Y,1)),U)=1"
 D ^DIR
 I $G(DUOUT) S BARQ=1 Q
 I $D(BARY("DX9",1)) I +Y<1 G DXLOW9 ;IF LO DEFINED, ENTER
 I +Y<1 Q  ;ENTER
 S BARY("DX9",2)=$P(Y,U,2)
 I BARY("DX9",1)=BARY("DX9",2) QUIT  ; - BAR1.8*24
 I BARY("DX9",1)>BARY("DX9",2)!('+BARY("DX9",1)&($E(BARY("DX9",1),2,9)>$E(BARY("DX9",2),2,9))) D  G DXLOW9
 .  W !!,*7,"INPUT ERROR: Low Diagnosis is Greater than the High, TRY AGAIN!",!!
 Q
 ; ********************** 
DXADD(BARICD) ;
 NEW BARDXTYP
 S BARDXTYP="DX"_BARICD
 K BARY(BARDXTYP,3)
 F  D ADDDX(BARICD) Q:$G(BARQ)  Q:Y<0
 K BARY(BARDXTYP,4)
 W !!
 Q
ADDDX(BARICD) ;ADD ONE OR MORE SINGLE DG INTO BARY("DX9",3 or BARY("DX10",3
 K DIR,DIC,DA,BARDX
 N BARDXTYP
 S BARDXTYP="DX"_BARICD
 I $O(BARY(BARDXTYP,3,""))]"" D LIST(BARICD)
 W !!
 W "Entry of Diagnosis Code ICD-",BARICD,!
 W "=============================="
 S DIR(0)="PO^80:ZAEMQ"
 S DIR("A")="Individual ICD-"_BARICD_" Code"
 I BARICD=9 I $$HAVICD10() S DIR("S")="I $P($G(^ICD9(Y,1)),U)=1"
 I BARICD=10 I $$HAVICD10() S DIR("S")="I $P($G(^ICD9(Y,1)),U)=30"
 D ^DIR
 I $G(DUOUT) S BARQ=1 Q  ;3/25 
 ;I $D(DIRUT) Q
 I +Y<1 Q
 S BARDX=$P(Y,U,2)
 I BARDX="" S BARQ1=1 Q
 I $D(BARY(BARDXTYP,3,BARDX)) D  Q
 . W !,"      Removed from selection."
 . K BARY(BARDXTYP,3,BARDX)
 S BARY(BARDXTYP,3,BARDX)="" W !,"    Added to selection." Q
 Q
CONTDX(BARICD) ;
 QUIT
 K DIR,DIC,DA
 N BARDXTYP,BARDX1
 S BARDXTYP="DX"_BARICD
 S Y=0 K DIRUT
 S DIR("A")="DX-"_BARICD_" code which begins "
 S DIR(0)="FUO^3:30"
 S DIR("?")="Enter partial DX"_BARICD_" code (begins with)"
 I BARICD=9 S DIR("?")=DIR("?")_" in form NNN."
 I BARICD=9 S DIR("?")=DIR("?")_"in form ANN (A=A...Z  N=1...0)."
 D ^DIR
 I Y="" S Y=-1 Q
 S BARDX1=Y
 D LIST^BARRSLDX(BARDX1,0)
 I 'BARCNT W " no matching DXs found" Q
 I $D(BARY(BARDXTYP,4,BARDX1)) D  Q
 . I '$$ASKREM() Q
 . K BARY(BARDXTYP,4,BARDX1)
 . W !,BARDX1, "  removed from selection."
 W " (",BARCNT," matching DXs found) "
 S BARY(BARDXTYP,4,BARDX1)="" W !,BARDX1," added to selection." Q
 Q
DX10 ;
 ;
DXLOW10 ;
 K BARY("DX10")
 K DIR,DIC,DA
 W !!
 W "Entry of Diagnosis Range ICD-10",!
 W "==============================="
 S DIR(0)="PO^80:ZAEMQ"
 S DIR("A")="Low ICD-10 Code (from) "
 S DIR("S")="I $P($G(^ICD9(Y,1)),U)=30"
 D ^DIR
 I $G(DUOUT) S BARQ=1 Q  ;3/25
 I +Y<1 Q  ;ENTER: GO FOR INDIVIDUAL DX
 S BARY("DX10",1)=$P(Y,U,2)
 ;
DXHI10 ;
 S DIR(0)="PO^80:ZAEMQ" ;
 S DIR("A")="High ICD-10 Code (to) "
 S DIR("S")="I $P($G(^ICD9(Y,1)),U)=30"
 D ^DIR
 I $G(DUOUT) S BARQ=1 Q  ;
 ;if DX10LOW defined, and DX10HI was enterer nil; retrurn to DX10LOW entry
 I $G(BARY("DX10",1))]"" I +Y<1 G DXLOW10
 I +Y<1 Q  ;ENTER 
 S BARY("DX10",2)=$P(Y,U,2)
 ;;;I BARY("DX10",2)=BARY("DX10",1) Q  ; - BAR1.8*??
 I '(BARY("DX10",2)]]BARY("DX10",1)) D  G DXLOW10
 . W !!,*7,"INPUT ERROR: Low Diagnosis is Greater than the High, TRY AGAIN!",!!
 Q
 ; **********************
DXADINFO(BARX,BARY) ; 
 QUIT  ;
LIST(BARICD) ;
 N BAR1,BAR2,BAR3,BAR4
 W !!?5,"Currently selected diagnoses: "
 N BARDXTYP
 S BARDXTYP="DX"_BARICD
 S BAR1="" F  S BAR1=$O(BARY(BARDXTYP,3,BAR1)) Q:BAR1=""  W ! D DXINFO(BAR1) ;
 S BAR1="" F  S BAR1=$O(BARY(BARDXTYP,4,BAR1)) Q:BAR1=""  W !,"code begins ",BAR1
 Q
LBL ; EP
 ; Ask for large balance
 K DIR
 S DIR(0)="NAO^50:10000000:2"
 S DIR("A")="Large Balance: "
 S:$D(BARY("LBL")) DIR("B")=BARY("LBL")
 D ^DIR
 K DIR
 I $D(DUOUT)!(Y="")  Q
 S BARY("LBL")=+Y
 Q
 ; ******************
SBL ; EP
 ; Ask for small balance
 K DIR
 S DIR(0)="NAO^0:99:2"
 S DIR("A")="Small Balance: "
 S:$D(BARY("SBL")) DIR("B")=BARY("SBL")
 D ^DIR
 K DIR
 I $D(DUOUT)!(Y="")  Q
 S BARY("SBL")=+Y
 Q
 ; ****************
ITYP ; EP
 ; Ask for Insurer Type
 K DIR,BARY("ITYP"),BARY("ACCT"),BARY("PAT"),BARY("ALL"),BARY("TYP")
 K BARY("COLPT")
 ;PRIV
 S DIR(0)="SO^H:HMO"
 S DIR(0)=DIR(0)_";M:MEDICARE SUPPL."
 S DIR(0)=DIR(0)_";P:PRIVATE INSURANCE" 
 S DIR(0)=DIR(0)_";F:FRATERNAL ORGANIZATION" 
 ;OTHER
 S DIR(0)=DIR(0)_";T:THIRD PARTY LIABILITY" 
 S DIR(0)=DIR(0)_";W:WORKMEN'S COMP"
 S DIR(0)=DIR(0)_";C:CHAMPUS"
 S DIR(0)=DIR(0)_";N:NON-BENEFICIARY (NON-INDIAN)"
 S DIR(0)=DIR(0)_";I:INDIAN PATIENT"
 S DIR(0)=DIR(0)_";G:GUARANTOR"
 S DIR(0)=DIR(0)_";SEP:STATE EXCHANGE PLAN" 
 S DIR(0)=DIR(0)_";TSI:TRIBAL SELF INSURED" 
 ;MEDICAID 
 S DIR(0)=DIR(0)_";D:MEDICAID FI"
 S DIR(0)=DIR(0)_";K:CHIP (KIDSCARE)"
 S DIR(0)=DIR(0)_";FPL:FPL 133 PERCENT"
 ;MEDICARE
 S DIR(0)=DIR(0)_";R:MEDICARE FI"
 S DIR(0)=DIR(0)_";MD:MEDICARE PART D"
 S DIR(0)=DIR(0)_";MC:MEDICARE PART C"
 S DIR(0)=DIR(0)_";MH:MEDICARE HMO"
 S DIR(0)=DIR(0)_";MMC:MEDICARE MANAGED CARE"
 ;VETERANS
 S DIR(0)=DIR(0)_";V:VETERANS ADMINISTRATION"
 ;-------END OF TABLE 
 S DIR("A")="Select INSURER TYPE to Display"
 S DIR("?")="Enter TYPE of INSURER to display, or press <return> for ALL"
 D ^DIR
 K DIR
 I $D(DUOUT)!($D(DTOUT))!($D(DIRUT)) Q
 S BARY("ITYP")=Y
 S BARY("ITYP","NM")=Y(0)
 Q
 ; *****************
COLPT ; EP
 ; Select Collection Point and Date ranges
 K BARY("COLPT"),BARY("ITYP")
 S DIC="^BAR(90051.02,DUZ(2),"
 S DIC(0)="ZQEAM"
 D ^DIC
 K DIC
 Q:$D(DTOUT)!($D(DUOUT))
 Q:+Y<0
 S BARY("COLPT")=+Y
 S BARY("COLPT","NM")=Y(0,0)
 Q
 ;start new code bar*1.8*20 REQ10
DATASRC ;EP
 ;Select Data Source
 S DIR(0)="SO^1:ELECTRONIC;2:MANUAL;3:BOTH"
 S DIR("A")="Select DATA SOURCE to Display"
 I $D(BARY("DATA SRC")) S DIR("B")=BARY("DATA SRC")
 D ^DIR
 K DIR
 I $D(DUOUT)!($D(DTOUT))!($D(DIRUT)) Q
 S BARY("DATA SRC")=Y(0)
 Q
 ;end new code REQ10
SHOWDX ; - BAR1.8*23 LIST SELECTED DXs
 NEW BAR1,BAR2,BAR3,BARTMP1
 I $G(BARY("DX9"))="ALL" W !,"Display all ICD-9 Diagnosis"
 I $G(BARY("DX10"))="ALL" W !,"Display all ICD-10 Diagnosis"
 F BAR1="DX9","DX10" D
 . F BAR2=1,2,3 I $D(BARY(BAR1,BAR2)) D
 . . W !,"ICD"_$E(BAR1,3,4) ;
 . . I BAR2<3 D  Q
 . . . I BAR2=1 W " FROM "
 . . . I BAR2=2 W " TO   "
 . . . S BARDX=BARY(BAR1,BAR2)
 . . . D DXINFO(BARDX) ;
 . . W "      "
 . . S BARDX="" F  S BARDX=$O(BARY(BAR1,BAR2,BARDX)) Q:BARDX=""  D DXINFO(BARDX) W !
 . S BAR2=4 I $D(BARY(BAR1,BAR2)) D
 . . W !,BAR1
 . . W " begins"
 . . S BARDX="" F  S BARDX=$O(BARY(BAR1,BAR2,BARDX)) Q:BARDX=""  W ?12," ",BARDX W !
 Q
DXINFO(BARDX) ;
 NEW BAR2,BAR3,BAR4
 S BAR4=""
 W ?12," ",BARDX
 I $$HAVICD10() D  ;
 . S BAR2=BARDX_" "
 . S BAR3=$O(^ICD9("AB",BAR2,""))
 . I BAR3]"" S BAR4=$P($G(^ICD9(BAR3,67,1,0)),U,2)
 E  D
 . S BAR2=BARDX
 . S BAR3=$O(^ICD9("AB",BAR2,""))
 . I BAR3]"" S BAR4=$P($G(^ICD9(BAR3,0)),U,3)
 W ?20,BAR4 ;CODE - TEXT
 ;ICD9 - OLD GLOBAL VERSION: ^ICD9(2,0)="100.89^^LEPTOSPIRAL INFECT NEC^^1^^^^"
 ;ICD10 - NDE GLOBAL VERSION ^ICD9("AB","307.1 ",1361) =
 ;                           ^ICD9(1361,67,1,0)="2781001^ANOREXIA NERVOSA"
 Q
ASKREM() ;
 K DIR
 S DIR("A")="DX already selected. Do you want to remove it from selection (Y/N): "
 S DIR("B")="NO"
 S DIR(0)="YOA"
 D ^DIR
 K DIR
 I Y>0 Q 1
 Q 0
HAVICD10() ;RETURNS 1 IF ICD10 INSTALLED
 Q $T(+1^ICDEX)]""
 ;---------------------------EOR-------------------
 ;SHOW(X) ;
 I 'X Q
 W !,"Y=",Y,"  X=",X," DTOUT: ",$G(DTOUT)," DUOUT: ",$G(DUOUT)," DIRUT: ",$G(DIRUT)," DIROUT: ",$D(DIROUT),"  $g(barq)=",$G(BARQ)
 ;S DUOUT=0,DIRUT=0
 Q
