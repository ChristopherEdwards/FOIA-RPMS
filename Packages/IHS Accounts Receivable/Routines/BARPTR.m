BARPTR ; IHS/SD/LSL - TRANSACTION LISTER AND SELECTOR ; 09/12/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**6,7,20,23**;OCT 26, 2005
 ;
 ;** transaction lister and selecter
 ;** pass an array that will be used as the display list
 ;** returns the ien of the selected transaction
 ;
 ; IHS/SD/SDR - v1.8 p6 - DD 4.2.1
 ;   Updated display to include Trans Dt, Allow.cat, TDN,
 ;   and status
 ; IHS/SD/SDR - v.18 p20 - HEAT27205 - Display <L> on locked batches
 ; HEAT77761 MAR 2013 P.OTTIS ADDEDD TRANSACTION # TO ERROR MESSAGE
 ; MAR 2013 P.OTTIS ADDED NEW VA billing 
 Q
 ;--------------------------------------------------------------
EN(BAR)         ; EP
 ; list details of transactions
 N BARTX,BARTR,BARCNT
 D TOP
 S DIC=90050.03
 S DR=".01;2;3;6;14;15;17"
 S (BARTR,BARCNT)=0
 F BARC=1:1 S BARTR=$O(^TMP($J,"BARVL",BARTR)) Q:'BARTR  D  Q:$G(BARQUIT)
 . D ENP^XBDIQ1(DIC,BARTR,DR,"BARTX(","0I")
 . S BARCNT=BARCNT+1
 . W !,BARCNT_"."
 . W ?3,$J(BARTX(2),8,2)
 . W:'$$CKDATE^BARPST($P(^BARTR(DUZ(2),BARTR,0),U,14),0,"COLLECTION") "<L>"
 . W ?15,$E(BARTX(6),1,30),?47,BARTX(14)
 . W ?76,BARTX(15)  ;coll. item
 . S D0=BARTX(6,"I")
 . I D0']"" D  Q    ;
 . . W !,"** ERROR--MISSING ALLOCATION INFO IN TRANSACTION # "_BARTR ;P.OTT
 . . D EOP^BARUTL(1)
 . S BARALLC=$$VALI^BARVPM(8) ;STRING
 . W !?13,BARTX(.01),?37,$S(BARALLC'="":$P($T(@BARALLC),";;",2),1:"<NO ALLOW CAT>")
 . W ?51
 . W $S($G(BARTX(17))'="":BARTX(17),$$GET1^DIQ(90051.1101,BARTX(15,"I")_","_BARTX(14,"I")_",",20,"E")'="":$$GET1^DIQ(90051.1101,BARTX(15,"I")_","_BARTX(14,"I")_",",20,"E"),1:"<NO TDN>")
 . W ?73,$S($O(^BAR(90052,"D",BARTX(14),0))'="":"LETTER",1:"")
 . S ^TMP($J,"BARVL","B",BARCNT,BARTR)=BARTX(6)_U_BARTX(6,"I")
 . K BARTX
 . I '(BARC#10) D
 . .K DIR
 . .S DIR(0)="EO"
 . .D ^DIR
 . .K DIR
 . .I X["^" S BARQUIT=1
 . Q
 K BARQUIT,BARC
 W !!
 I 'BARCNT W *7,"No transactions found!",!! D EOP^BARUTL(1) Q 0
 S DIR(0)="NO^1:"_BARCNT
 D ^DIR
 I $D(DUOUT)!('Y) Q 0
 S BARTR=$O(^TMP($J,"BARVL","B",Y,""))
 I BARTR="" W !,"No transactions found! (2)",!! D EOP^BARUTL(1) Q 0 ;P.OTT 77761
 I '$$CKDATE^BARPST($P(^BARTR(DUZ(2),BARTR,0),U,14),1,"SELECT COLLECTION BATCH") Q 0   ;DISALLOW OLD BATCHES; MRS:BAR*1.8*6 DD 4.2.4
 Q BARTR
 ; *********************************************************************
 ;
TOP ; EP
 N J
 D HOME^%ZIS
 I $L($G(^TMP($J,"BARVL","HEAD"))) DO
 . W $$EN^BARVDF("IOF"),!
 . S X=$S($L($G(^TMP($J,"BARVL","HEAD"))):^TMP($J,"BARVL","HEAD"),1:"Transaction List")
 . W ?IOM-$L(X)\2,X
 . W !?IOM-$L(X)\2
 . F J=1:1:$L(X) W "-"
 W !!,"#",?5,"Credit",?15,"Account",?47,"Batch",?76,"Item"
 W !?13,"TRANS DATE",?37,"ALLOW CAT",?51,"TDN",?73,"STATUS"
 W !
 S BARDSH=""
 S $P(BARDSH,"-",80)="" W BARDSH
 ;W !  IHS/SD/SDR bar*1.8*6 DD 4.2.1
 Q  ;********************************************************************
 ;THIS TABLE REPLICATES ^AUTTINTY INSURER TYPE (21 ENTRIES) P.OTT 4/12/2013
 ;AND MAPS INSURER TYPE CODE TO CATEGORY (IE: W --> OTHER)
H ;;PRIVATE INSURANCE;;HMO
M ;;PRIVATE INSURANCE;;MEDICARE SUPPL.
D ;;MEDICAID;;MEDICAID FI
R ;;MEDICARE;;MEDICARE FI
P ;;PRIVATE INSURANCE;;PRIVATE INSURANCE
W ;;OTHER;;WORKMEN'S COMP
C ;;OTHER;;CHAMPUS
N ;;OTHER;;NON-BENEFICIARY (NON-INDIAN)
I ;;OTHER;;INDIAN PATIENT
K ;;MEDICAID;;CHIP (KIDSCARE)
T ;;OTHER;;THIRD PARTY LIABILITY 
G ;;OTHER;;GUARANTOR
MD ;;MEDICARE;;MCR PART D
MH ;;MEDICARE;;MEDICARE HMO
MMC ;;MEDICARE;;MCR MANAGED CARE
TSI ;;OTHER;;TRIBAL SELF INSURED
SEP ;;OTHER;;STATE EXCHANGE PLAN
FPL ;;MEDICAID;;FPL 133 PERCENT
MC ;;MEDICARE;;MCR PART C
F ;;PRIVATE INSURANCE;;FRATERNAL ORGANIZATION
V ;;VETERAN;;VETERANS MEDICAL BENEFITS
  ;;***END OF TABLE** 
