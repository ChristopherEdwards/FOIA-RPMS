BARRSL1 ; IHS/SD/LSL - Selective Report Parameters-PART 2 ; 12/19/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**6,10,16,19,20**;OCT 26,2005
 ; IHS/SD/TMM 7/20/10 1.8*19 Add Group Plan to A/R Statistical report.
 ;     When selecting A/R STATISTICAL REPORT by Billing Entity prompt
 ;             user for Group Plans to include in report data.
 ;     FIXPMS10019 #1 - TSR report, Add Adjustment inclusion 
 ;             parameter: "Sent To  Collections" 
 ;     Resolve UNDEFINED error <UNDEFINED>S4+12^DICL2 
 ;     Add STATUS CHANGE as Selection Type for TSR report
 Q
 ; ******
 ;BEGIN NEW SUBROUTINE FOR BAR*1.8*6 DD 4.1.5
TRANTYP ; EP
 ;ASK FOR TRANSACTION TYPE
 K BARY("TRANS TYPE")
 K Y
 K DIR
 S DIR(0)="SO^1:PAYMENT;2:ADJUSTMENT"
 I BAR("OPT")="TSR" S DIR(0)="SO^1:PAYMENT;2:ADJUSTMENT;3:STATUS CHANGE"  ;1.8*19 TMM
 S DIR("A")="Select ONE or MORE of the above INCLUSION PARAMETERS"
 S DIR("?")="The report can be restricted to one or more of the listed parameters. A parameter can be removed by reselecting it and making a null entry."
 S DIR("?",1)="If you choose PAYMENT you cannot chooose any adjustments and vise versa."
 D ^DIR
 I $D(DTOUT)!$D(DUOUT)!$D(DIRUT) S BARY("TRANS TYPE",40)="PAYMENT" Q
 ;40 = IEN OF 'PAYMENT' IN A/R TABLE ENTRY
 ;43 = IEN OF 'ADJUST ACCOUNT' IN A/R TABLE ENTRY
 ;993 = IEN OF 'SENT TO COLLECTIONS IN A/R TABLE ENTRY  ;1.8*19 TMM
 ;S BARY("TRANS TYPE",$S(Y=1:40,1:43))=$S(Y=1:"PAYMENT",1:"ADJUST ACCOUNT")  ;1.8*19 TMM
 S BARY("TRANS TYPE",$S(Y=1:40,Y=2:43,Y=3:993,1:43))=$S(Y=1:"PAYMENT",Y=2:"ADJUST ACCOUNT",Y=3:"STATUS CHANGE",1:"ADJUST ACCOUNT")  ;M819_4*DEL*TMM*20100819
 K DIR
 ;I $G(BARY("TRANS TYPE",43))="ADJUST ACCOUNT" D  ;bar*1.8*20
 I $G(BARY("TRANS TYPE",43))="ADJUST ACCOUNT"!(BAR("OPT")="PAY") D  ;bar*1.8*20
 .K DIC,DIE,DR,DA
 .S DIC(0)="AEZ"
 .S DIC=90052.01
 .S DIC("S")="I "",3,4,13,14,15,16,19,20,21,22,""[("",""_Y_"","")"  ;1.8*19 TMM
 .S DIC("W")="N C,DINAME W ""  "" W ""   "",$P(^(0),U,2)"
 .D ^DIC
 .Q:Y'>0  ;bar*1.8*20
 .N BARCAT
 .I Y>0 S BARCAT=+Y,BARY("TRANS TYPE","ADJ CAT",BARCAT)=Y(0)
 .;start bar*1.8*20
 .E  Q
 .W !
 .K DIC,DIE,DR,DA
 .S DIC(0)="AEZ"
 .S DIC=90052.02
 .S DIC("S")="I $P(^(0),U,2)=BARCAT"
 .D ^DIC
 .K BARCAT
 .I Y>0 S BARY("TRANS TYPE","ADJ TYPE",+Y)=Y(0)
 .;bar 1.8*20
 ; BEGIN 1.8*19 TMM
 I $G(BARY("TRANS TYPE",993))="STATUS CHANGE" D
 .K DIC,DIE,DR,DA
 .S DIC(0)="AEZ"
 .S DIC=90052.01
 .S DIC("S")="I "",25,""[("",""_Y_"","")"
 .S DIC("W")="N C,DINAME W ""  "" W ""   "",$P(^(0),U,2)"
 .D ^DIC
 .Q:Y'>0
 .N BARCAT
 .I Y>0 S BARCAT=+Y,BARY("TRANS TYPE","ADJ CAT",BARCAT)=Y(0)
 .E  Q
 .W !
 .K DIC,DIE,DR,DA
 .S DIC(0)="AEZ"
 .S DIC=90052.02
 .S DIC("S")="I $P(^(0),U,2)=BARCAT"
 .D ^DIC
 .K BARCAT
 .I Y>0 S BARY("TRANS TYPE","ADJ TYPE",+Y)=Y(0)
 .;END 1.8*19
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
 S DIR(0)=DIR(0)_";11:OTHER"   ;BAR*1.8*6 DD 4.1.5 IM21585
 S DIR("A")="Select TYPE of BILLING ENTITY to Display"
 S DIR("?")="Enter TYPE of BILLING ENTITY to display, or press <return> for ALL"
 D ^DIR
 K DIR
 I $D(DUOUT)!($D(DTOUT)) Q
 Q:Y<1
 ;S BARY("TYP")=Y
 ;S:Y=1 BARY("TYP")="R"
 ;S:Y=2 BARY("TYP")="D"
 ;S:Y=3 BARY("TYP")="PHFM"
 ;S:Y=4 BARY("TYP")="N"
 ;S:Y=5 BARY("TYP")="I"
 ;S:Y=8 BARY("TYP")="W"
 ;S:Y=9 BARY("TYP")="PHFMW"
 ;S:Y=10 BARY("TYP")="K"
 ;BEGIN NEW CODE BAR*1.8*6 DD 4.1.5 IM21585
 S BARY("TYP")=U_Y_U
 S:Y=1 BARY("TYP")=U_"R"_U_"MD"_U_"MH"_U  ;ADD MEDICARE PART D AND MEDICARE HMO
 S:Y=2 BARY("TYP")=U_"D"_U
 ;S:Y=3 BARY("TYP")=U_"P"_U_"H"_U_"F"_U_"M"_U_"T"_U  ;ADD THIRD PARTY LIABILITY;MRS:BAR*1.8*10 D148-4
 S:Y=3 BARY("TYP")=U_"P"_U_"H"_U_"F"_U_"M"_U         ;REMOVE TPL;MRS:BAR*1.8*10 D148-4
 S:Y=4 BARY("TYP")=U_"N"_U
 S:Y=5 BARY("TYP")=U_"I"_U
 S:Y=8 BARY("TYP")=U_"W"_U
 S:Y=9 BARY("TYP")=U_"P"_U_"H"_U_"F"_U_"M"_U_"W"
 S:Y=10 BARY("TYP")=U_"K"_U
 S:Y=11 BARY("TYP")=U_"G"_U  ;ADD GUARANTOR AS AN OTHER BUCKET
 ;END NEW CODE
 S BARY("TYP","NM")=Y(0)
 G ACCT:Y=6,PAT:Y=7
 Q
 ; ***********
ACCT ; 
 ; Specific insurer of billing entity parameter
 K DIC               ;M819_3*ADD*TMM*20100819
 K BARY("TYP"),BARY("ACCT")
 S DIC="^BARAC(DUZ(2),"
 S DIC(0)="ZQEAM"
 D ^DIC
 K DIC
 Q:$D(DTOUT)!($D(DUOUT))
 Q:+Y<0
 S BARY("ACCT")=+Y
 S BARY("ACCT","NM")=Y(0,0)
 ;IHS/SD/TMM 1.8*19 7/20/10
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
 ; Select ALLOWANCE CATEGORY Inclusion Parameter
 K DIR,BARY("TYP"),BARY("ACCT"),BARY("PAT"),BARY("ALL"),BARY("ITYP")
 ;S DIR(0)="SO^1:MEDICARE"
 S DIR(0)="SO^1:MEDICARE          (INS TYPES R MD MH)"  ;BAR*1.8*6 DD 4.1.1 IM21585
 ;S DIR(0)=DIR(0)_";2:MEDICAID"               ;BAR*1.8*6 DD 4.1.1
 S DIR(0)=DIR(0)_";2:MEDICAID          (INS TYPES D K)"  ;BAR*1.8*6 DD 4.1.1 
 ;S DIR(0)=DIR(0)_";3:PRIVATE INSURANCE (INS TYPES P H F M)"
 ;S DIR(0)=DIR(0)_";3:PRIVATE INSURANCE (INS TYPES P H F M T)"  ;BAR*1.8*6 DD 4.1.1 IM21585;MRS:BAR*1.8*10 D148-4
 S DIR(0)=DIR(0)_";3:PRIVATE INSURANCE (INS TYPES P H F M)"  ;MRS:BAR*1.8*10 D148-4
 ;S DIR(0)=DIR(0)_";4:CHIP" ;BAR*1.8*6 DD 4.1.1 
 ;S DIR(0)=DIR(0)_";5:OTHER             (INS TYPES W C N I)"
 ;S DIR(0)=DIR(0)_";4:OTHER             (INS TYPES W C N I G)"  ;BAR*1.8*6  DD 4.1.1 IM21585;MRS:BAR*1.8*10 D148-4
 S DIR(0)=DIR(0)_";4:OTHER             (INS TYPES W C N I G T)"  ;;MRS:BAR*1.8*10 D148-4
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
 K DIR,BARY("DT")
 I BARP("RTN")="BARRTAR" Q:$D(DIRUT)  D
 .K BARY("BATCH"),BARY("ITEM")
 .S BARTYP=4
 E  D  Q:+BARDONE!(Y<1)
 .S DIR(0)="SO^1:Approval Date;2:Visit Date;3:Export Date"
 .S:BAR("OPT")="IPDR" DIR(0)="SO^1:Approval Date;2:Admission Date"
 .;BAR*1.8*6 DD 4.1.5
 .S:BAR("OPT")="TSR" DIR(0)="SO^1:Visit Date;2:Approval Date;3:Export Date;4:Transaction Date;5:Batch Date"
 .; BAR*1.8*19 IHS/SD/PKD  7/2/10
 .S:BAR("OPT")="PAY" DIR(0)="SO^1:Approval Date;2:Visit Date;3:Export Date;4:Transaction Date;5:Batch Date"
 .;BEGIN BAR*1.8*16 IHS/SD/TPF 1/27/10
 .S:BAR("OPT")="DAYS" DIR(0)="SO^1:Visit Date"
 .;END
 .S DIR("A")="Select TYPE of DATE Desired"
 .D ^DIR
 .K DIR
 .I $D(DUOUT)!$D(DTOUT) S BARDONE=1
 .S BARTYP=Y
 ;
DTYP ;
 K DIRUT,DUOUT,DTOUT
 S BARY("DT")=$S(BARTYP=1:"A",BARTYP=3:"X",BARTYP=4:"T",1:"V")
 ; BAR*1.8*19 IHS/SD/PKD  7/2/10
 I BAR("OPT")="PAY" D
 .S BARY("DT")=$S(BARTYP=1:"A",BARTYP=2:"V",BARTYP=3:"X",BARTYP=4:"T",1:"B")
 .;END BAR*1.8*19 
 ;BAR*1.8*6 DD 4.1.5
 I BAR("OPT")="TSR" D
 .S BARY("DT")=$S(BARTYP=1:"V",BARTYP=2:"A",BARTYP=3:"X",BARTYP=4:"T",1:"B")
 .I BARTYP=2 S BARTYP=1 Q
 .S:BARTYP=1 BARTYP=2
 ;END
 ;BEGIN BAR*1.8*16 IHS/SD/TPF 1/27/10
 I BAR("OPT")="DAYS" D
 .S BARY("DT")="V"
 .S BARTYP=12
 ;
 S BARDTYP="VISIT"
 S:BARTYP=1 BARDTYP="APPROVAL"
 S:BARTYP=3 BARDTYP="EXPORT"
 S:BARTYP=4 BARDTYP="TRANSACTION"
 I BARDTYP="VISIT",BAR("OPT")="IPDR" S BARDTYP="ADMISSION"
 ;BAR*1.8*6 DD 4.1.5
 S:BARTYP=5 BARDTYP="BATCH"
 ;END
 S BARDTYP=BARDTYP_" DATE"
 W !!," ============ Entry of ",BARDTYP," Range =============",!
 S DIR("A")="Enter STARTING "_BARDTYP_" for the Report"
 S DIR(0)="DOE"
 D ^DIR
 G DT:$D(DIRUT)
 S BARY("DT",1)=Y
 W !
 S DIR("A")="Enter ENDING DATE for the Report"
 S DIR(0)="DOE"
 D ^DIR
 K DIR
 G DT:$D(DIRUT)
 S BARY("DT",2)=Y
 I BARY("DT",1)>BARY("DT",2) W !!,*7,"INPUT ERROR: Start Date is Greater than the End Date, TRY AGAIN!",!! G DTYP
 Q
 ; **************************
PRV ; EP
 ; Select Provider Inclusion Parameter
 K BARY("PRV")
 W !
 S DIC("S")="I $D(^VA(200,""AK.PROVIDER"",$P(^(0),U)))"  ;IHS/SD/TPF 5/22/2008 BAR*1.8*6 DD 4.1.5
 S DIC="^VA(200,"
 S DIC(0)="QEAM"
 D ^DIC
 I $D(DTOUT)!($D(DUOUT)) S BARDONE=1 Q
 K DIC
 S:+Y>0 BARY("PRV")=+Y
 Q
 ; *******************************
AR ; EP
 ; Select A/R Clerk Inclusion Parameter
 K BARY("AR")
 W !
 S DIC("B")=DUZ  ;IHS/SD/TPF 5/22/2008 BAR*1.8*6 DD 4.1.5
 S DIC="^VA(200,"
 S DIC(0)="ZQEAM"
 D ^DIC
 I $D(DTOUT)!($D(DUOUT)) S BARDONE=1 Q
 K DIC
 Q:+Y<1
 S BARY("AR")=+Y
 S BARY("AR","NM")=Y(0,0)
 Q
 ; ******************
BATCH ; EP
 ; Select Collection Batch Inclusion Parameter
 K BARY("BATCH"),BARY("ITEM"),BARY("COLPT")
 W !
 S DIC="^BARCOL(DUZ(2),"
 S DIC(0)="ZQEAM"
 S DIC("A")="Select Collection Batch: "
 S DIC("W")="D BATW^BARPST"
 S DIC("S")="I $P(^(0),U,3)=""P""&($G(BARUSR(29,""I""))=$P(^(0),U,10))"
 D ^DIC
 I $D(DTOUT)!($D(DUOUT)) S BARDONE=1 Q
 K DIC
 Q:+Y<1
 S BARCOL=+Y  ;BAR*1.8*6 ERROR WHEN TESTING IHS/SD/TPF 7/24/2008
 S BARY("BATCH")=+Y
 S BARY("BATCH","NM")=Y(0,0)
 Q
 ; *******
ITEM ; EP
 ; Select Collection Batch Item Inclusion Parameter
 D BATCH
 I +BARDONE!(+Y<1) Q
 W !
 S DA(1)=BARY("BATCH")
 S DIC="^BARCOL(DUZ(2),"_DA(1)_",1,"
 S DIC(0)="ZQEAM"
 S DIC("A")="Select Collection Batch Item: "
 S DIC("W")="D DICW^BARPST"
 ; Screen out cancelled items
 S DIC("S")="I $P(^(0),U,17)'=""C""&($P(^(0),U,17)'=""R"")"
 D ^DIC
 I $D(DTOUT)!($D(DUOUT)) S BARDONE=1 Q
 K DIC
 Q:+Y<1
 S BARY("ITEM")=+Y
 S BARY("ITEM","NM")=Y(0,0)
 Q
 ; *************
RTYP ; EP
 ; Select Report Type Inclusion Parameter
 K DIR,BARY("RTYP")
 S DIR(0)="SO^1:Detail;2:Summary;3:Detail and Summary"
 ; BAR*1.8*19 IHS/SD/PKD 6/01/10
 I BAR("OPT")="CXL" S DIR(0)="SO^1:Detail;2:Summary"
 S DIR("A")="Select TYPE of REPORT desired"
 S DIR("B")=1
 D ^DIR
 K DIR
 I $D(DUOUT)!$D(DTOUT) S BARDONE=1 Q
 S BARY("RTYP")=Y
 S BARY("RTYP","NM")=Y(0)
 Q
 ; *********************
DSVC ; EP
 ; Select One Discharge Service
 ; FACILITY TREATING SPECIALTY File ^DIC(45.7)
 K BARY("DSVC"),DIC,DA
 S DIC="^DIC(45.7,"
 S DIC(0)="ZAEMQ"
 S DIC("A")="Select Discharge Service:  "
 D ^DIC
 K DIC
 Q:$D(DTOUT)!($D(DUOUT))
 Q:+Y<1
 S BARY("DSVC")=+Y
 S BARY("DSVC","NM")=Y(0,0)
 Q
 ; ********************
DX ; EP
 ; Select Primary Diagnosis Range
 ; ICD DIAGNOSIS FILE
 K BARY("DX"),DIR,DIC,DA
 W !!,"Entry of Primary Diagnosis Range",!
 W "================================"
 ;
DXLOW ;
 S DIR(0)="PO^80:ZAEMQ"
 S DIR("A")="Low ICD Code"
 D ^DIR
 Q:$D(DIRUT)
 G DXLOW:+Y<1
 ;S BARY("DX",1)=$P(^ICD9(+Y,0),U)  ;MRS:BAR*1.8*10 CSV D148-1
 S BARY("DX",1)=$P(Y,U,2)           ;MRS:BAR*1.8*10 CSV D148-1
 ;
DXHI ;
 S DIR(0)="PO^80:ZAEMQ"
 S DIR("A")="High ICD Code"
 D ^DIR
 Q:$D(DIRUT)
 G DXHI:+Y<1
 ;S BARY("DX",2)=$P(^ICD9(+Y,0),U)  ;MRS:BAR*1.8*10 CSV D148-1
 S BARY("DX",2)=$P(Y,U,2)           ;MRS:BAR*1.8*10 CSV D148-1
 I BARY("DX",1)>BARY("DX",2)!('+BARY("DX",1)&($E(BARY("DX",1),2,9)>$E(BARY("DX",2),2,9))) D  G DX
 . W !!,*7,"INPUT ERROR: Low Diagnosis is Greater than the High, TRY AGAIN!",!!
 Q
 ; **********************
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
 S DIR(0)="SO^H:HMO"
 S DIR(0)=DIR(0)_";M:MEDICARE SUPPL."
 S DIR(0)=DIR(0)_";D:MEDICAID FI"
 S DIR(0)=DIR(0)_";R:MEDICARE FI"
 S DIR(0)=DIR(0)_";P:PRIVATE INSURANCE"
 S DIR(0)=DIR(0)_";W:WORKMEN'S COMP"
 S DIR(0)=DIR(0)_";C:CHAMPUS"
 S DIR(0)=DIR(0)_";F:FRATERNAL ORGANIZATION"
 S DIR(0)=DIR(0)_";N:NON-BENEFICIARY (NON-INDIAN)"
 S DIR(0)=DIR(0)_";I:INDIAN PATIENT"
 S DIR(0)=DIR(0)_";K:CHIP (KIDSCARE)"
 S DIR(0)=DIR(0)_";T:THIRD PARTY LIABILITY"
 S DIR(0)=DIR(0)_";G:GUARANTOR"
 S DIR(0)=DIR(0)_";MD:MEDICARE PART D"
 S DIR(0)=DIR(0)_";MH:MEDICARE HMO"
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
