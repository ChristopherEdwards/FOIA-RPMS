BARRNBRC ; IHS/SD/POT - Non Ben Payment Report PART 3 ; 08/20/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**24**;OCT 26,2005;Build 69
 ; IHS/SD/POT 07/15/13 HEAT114352 NEW REPORT BAR*1.8*24
 ; IHS/SD/POT 03/20/2014 FIXED ERROR IN PATIENT SELECTION "NO ACCOUNT ASSOCIATED WITH THIS PATIENT?!?" 
 Q
 ; ******
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
TYP ;
 K DIR,BARY("TYP"),BARY("ACCT")
 ;;;K BARY("PAT")
 K BARY("ALL"),BARY("ITYP")
 S BARY("TYP")="^N^"
 S BARY("TYP","NM")="NON-BENEFICIARY"
 Q
ACCT ; 
 ; Specific insurer of billing entity parameter
 Q
 ; *******
PAT ;
 ; Specific patient of billing entity parameter
 N BARTMP1,BARTMP2
PAT1 K BARY("TYP"),BARY("PAT")
 S DIC="^AUPNPAT("
 S DIC(0)="ZQEAM"
 D ^DIC
 K DIC
 Q:$D(DTOUT)!($D(DUOUT))
 K AUPNLK("ALL")
 Q:+Y<0
 ;3/20/2014 CODE DEACTIVATED
 ;I '$D(^BARAC(DUZ(2),"B",+Y_";AUPNPAT(")) D  G PAT
 ;. W !,"NO ACCOUNT ASSOCIATED WITH THIS PATIENT?!?"
 ;S BARTMP1=$O(^BARAC(DUZ(2),"B",+Y_";AUPNPAT("))
 ;I BARTMP1="" D  G PAT1
 ;. W !,"NO ACCOUNT ASSOCIATED WITH THIS PATIENT?!?"
 ;S BARTMP2=$P($G(^BARAC(DUZ(2),BARTMP1,1)),U,15) I BARTMP2 D  G PAT1
 ; . W !,"THIS IS NOT A NON-BENEFICIARY PATIENT"
 S BARY("PAT")=+Y
 S BARY("PAT","NM")=Y(0,0)
 Q
 ; **********
DT ; EP
 ; Select Date inclusion parameter
 K DIR,BARY("DT"),BARTYP
 S DIR(0)="SO^1:Visit Date;2:Transaction Date"
 S DIR("A")="Select TYPE of DATE Desired"
 D ^DIR
 K DIR
 I $D(DUOUT)!$D(DTOUT) S BARDONE=1 Q  ;P.OTT AUG
 S BARTYP=Y
 ;
DTYP ;
 K DIRUT,DUOUT,DTOUT
 S BARY("DT")=$S(BARTYP=1:"V",BARTYP=2:"T",1:"V")
 ;
 S BARDTYP="VISIT"
 S:BARTYP=2 BARDTYP="TRANSACTION"
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
 S DIC("S")="I $D(^VA(200,""AK.PROVIDER"",$P(^(0),U)))"
 S DIC="^VA(200,"
 S DIC(0)="QEAM"
 D ^DIC
 I $D(DTOUT)!($D(DUOUT)) S BARDONE=1 Q
 K DIC
 S:+Y>0 BARY("PRV")=+Y
 Q
 ; *******************************
ISNB(BARBL) ;
 N BARTMP,BARBSTAT,BARPTAC,BARACDA
 S BARACDA=$P($G(^BARBL(DUZ(2),BARBL)),U,3)
 K BARTMP
 D ENP^XBDIQ1(90050.01,BARBL,".01;3;13;15;16;17;17.2;22;101;102;108;112;113;114;115","BARTMP(","I")
 S BARBSTAT=BARTMP(17.2)  ;Bill Status in TPB which can be diff from A/R
 ;If bill is in list & has pmts applied, it should print on stmt anyway
 I BARBSTAT="CANCELLED" Q "0;CANCELLED"  ;S BARCXL=1  ; if cancelled 1.8*19
 S BARPTAC=$S(BARACDA=BARTMP(3,"I"):1,1:0)  ; PT Resp if INSURER TYPE=NON-BEN or INSURER=SELF
 N D0,X
 S D0=BARTMP(3,"I")
 S X=$$VAL^BARVPM(8) ;(STRING)
 ;W !,BARBL," ==> ",X," ===> IS NON-BEN: ",BARTMP(115)," ; ",BARTMP(115,"I")
 I X["NON-BEN"!(BARPTAC'=0) Q 1  ;
 Q 0
 ;90050.01,115  BEN/NON-BEN            1;15 SET
 ;                               '0' FOR NON-BENEFICIARY;
 ;                               '1' FOR BENEFICIARY;
GETNBIT() ;RETURNS INS TYPE (TO FIND IN ACCOUNT #)
 Q $O(^AUTNINS("B","NON-BENEFICIARY PATIENT",""))
 ;
