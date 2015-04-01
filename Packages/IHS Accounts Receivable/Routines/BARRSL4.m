BARRSL4 ; IHS/SD/LSL - Selective Report Parameters-PART 2 ; 12/19/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**23,24**;OCT 26,2005;Build 69
 ; CODE EXTENSION OF BARRSL1
 ;
 ; IHS/SD/POTT 12/12 ADDED SELECTION OF CODING DX VERSION ICD-9 / ICD-10 - BAR1.8*23
 ; IHS/SD/POTT 06/13 FIXED FLAWS IN SELECTING ICD9/10 DX - BAR1.8*23
 ; IHS/SD/POTT 07/13 DO NOT ALLOW SELECT ICD10 WHEN INFRASTRUCTURE NOT PRESENT - BAR1.8*23
 ; IHS/SD/POTT HEAT150941 02/09/14 Allow ALL DX9/10 - BAR1.8*24
 ;                        if no DX selected: show ALL DX of ALL available coding systems - BAR1.8*24
 ;*******************************************************************************
 Q
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
 S BARY("TRANS TYPE",$S(Y=1:40,Y=2:43,Y=3:993,1:43))=$S(Y=1:"PAYMENT",Y=2:"ADJUST ACCOUNT",Y=3:"STATUS CHANGE",1:"ADJUST ACCOUNT")  ;M819_4*DEL*TMM*20100819
 K DIR
 I $G(BARY("TRANS TYPE",43))="ADJUST ACCOUNT"!(BAR("OPT")="PAY") D
 . K DIC,DIE,DR,DA
 . S DIC(0)="AEZ"
 . S DIC=90052.01
 . S DIC("S")="I "",3,4,13,14,15,16,19,20,21,22,""[("",""_Y_"","")"
 . S DIC("W")="N C,DINAME W ""  "" W ""   "",$P(^(0),U,2)"
 . D ^DIC
 . Q:Y'>0  ;bar*1.8*20
 . N BARCAT
 . I Y>0 S BARCAT=+Y,BARY("TRANS TYPE","ADJ CAT",BARCAT)=Y(0)
 . E  Q
 . W !
 . K DIC,DIE,DR,DA
 . S DIC(0)="AEZ"
 . S DIC=90052.02
 . S DIC("S")="I $P(^(0),U,2)=BARCAT"
 . D ^DIC
 . K BARCAT
 . I Y>0 S BARY("TRANS TYPE","ADJ TYPE",+Y)=Y(0)
 I $G(BARY("TRANS TYPE",993))="STATUS CHANGE" D
 . K DIC,DIE,DR,DA
 . S DIC(0)="AEZ"
 . S DIC=90052.01
 . S DIC("S")="I "",25,""[("",""_Y_"","")"
 . S DIC("W")="N C,DINAME W ""  "" W ""   "",$P(^(0),U,2)"
 . D ^DIC
 . Q:Y'>0
 . N BARCAT
 . I Y>0 S BARCAT=+Y,BARY("TRANS TYPE","ADJ CAT",BARCAT)=Y(0)
 . E  Q
 . W !
 . K DIC,DIE,DR,DA
 . S DIC(0)="AEZ"
 . S DIC=90052.02
 . S DIC("S")="I $P(^(0),U,2)=BARCAT"
 . D ^DIC
 . K BARCAT
 . I Y>0 S BARY("TRANS TYPE","ADJ TYPE",+Y)=Y(0)
 . ;END 1.8*19
 Q
DT ; EP
 ; Select Date inclusion parameter
 K DIR,BARY("DT")
 I BARP("RTN")="BARRTAR" Q:$D(DIRUT)  D
 . K BARY("BATCH"),BARY("ITEM")
 . S BARTYP=4
 E  D  Q:+BARDONE!(Y<1)
 . S DIR(0)="SO^1:Approval Date;2:Visit Date;3:Export Date"
 . S:BAR("OPT")="IPDR" DIR(0)="SO^1:Approval Date;2:Admission Date"
 . S:BAR("OPT")="TSR" DIR(0)="SO^1:Visit Date;2:Approval Date;3:Export Date;4:Transaction Date;5:Batch Date"
 . S:BAR("OPT")="PAY" DIR(0)="SO^1:Approval Date;2:Visit Date;3:Export Date;4:Transaction Date;5:Batch Date"
 . S:BAR("OPT")="DAYS" DIR(0)="SO^1:Visit Date"
 . S DIR("A")="Select TYPE of DATE Desired"
 . D ^DIR
 . K DIR
 . I $D(DUOUT)!$D(DTOUT) S BARDONE=1
 . S BARTYP=Y
 ;
DTYP ;
 K DIRUT,DUOUT,DTOUT
 S BARY("DT")=$S(BARTYP=1:"A",BARTYP=3:"X",BARTYP=4:"T",1:"V")
 I BAR("OPT")="PAY" D
 . S BARY("DT")=$S(BARTYP=1:"A",BARTYP=2:"V",BARTYP=3:"X",BARTYP=4:"T",1:"B")
 I BAR("OPT")="TSR" D
 . S BARY("DT")=$S(BARTYP=1:"V",BARTYP=2:"A",BARTYP=3:"X",BARTYP=4:"T",1:"B")
 . I BARTYP=2 S BARTYP=1 Q
 . S:BARTYP=1 BARTYP=2
 I BAR("OPT")="DAYS" D
 . S BARY("DT")="V"
 . S BARTYP=12
 ;
 S BARDTYP="VISIT"
 S:BARTYP=1 BARDTYP="APPROVAL"
 S:BARTYP=3 BARDTYP="EXPORT"
 S:BARTYP=4 BARDTYP="TRANSACTION"
 I BARDTYP="VISIT",BAR("OPT")="IPDR" S BARDTYP="ADMISSION"
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
ASKICD() ; - BAR1.8*24
 K DIRUT,DIR,Y
 S Y=$$DIR^XBDIR("S^9:ICD-9;10:ICD-10;B:Both coding versions","Select ICD Version ","","","","",1)
 K DA
 Q Y
CLNUPDX ;CLEAN UP DX
 ;K BARY("DXTYPE") HEAT150941
 K BARY("DX-ICDVER")  ;- BAR1.8*24
 K BARY("DX9")
 K BARY("DX10")
 Q
 ; 
 ;-------------EOR------------ 
