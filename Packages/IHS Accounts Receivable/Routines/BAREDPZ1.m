BAREDPZ1 ; IHS/SD/LSL - AHCCCS IMPORT ROUTINE ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 06/26/2002 - V1.6 Patch 2 - NOIS XXX-0602-200032
 ;     Modified to be FM22 compliant
 ;
 ; IHS/SD/LSL - 03/17/2003 - V1.7 Patch 1 - IM10293
 ;     If AHCCCS doesn't  send a bill number I modified PAYAMT
 ;     to look for NO BILL NUMBER IN FILE instead of crashing with
 ;     <SBSCR>*XECUTE*NEW+65^DICN
 ;
 ; IHS/SD/LSL - 02/09/2004 - V1.7 Patch 5 - IM12514
 ;       Denial codes for proprietary AHCCCS ERA not working properly
 ;
 ; *********************************************************************
 Q
 ;
SEP ;EP Set seperators
 S S="~",E="`",SE="  " ;SE is 2 spaces used in the CC seg Reason Element
 Q
 ; *********************************************************************
 ;
DT ;EP  Conversion of date to readable format
 S X=$E(X,5,6)_"/"_$E(X,7,8)_"/"_$E(X,1,4)
 S %DT="X"
 D ^%DT,DD^%DT
 S X=Y
 Q
 ; *********************************************************************
 ;
PAYAMT ;Load Claim data
 W:'(COUNT#10) "."
 W:'(COUNT#100) "  ",COUNT,!
 S COUNT=COUNT+1
 K DIC,DR,DA,DIE
 S DIC=$$DIC^XBDIQ1(90056.0205)
 S DIC(0)="XL"
 S DIC("P")="90056.0205A"
 S X=$P(VBILNM,"-")
 W !,X,?15,VBILNM
 I X="" D      ; LSL 03/17/0/3
 . W "NO BILL NUMBER IN FILE"
 . S X="NO BILL"
 S DA(1)=IMPDA
 K DD,DO,D0
 D FILE^DICN
 S CLMDA=+Y
 S DA=+Y
 S DIE=DIC
 K DIC
 K DR
 S DR=".04///^S X=VPAYAMT;.05///^S X=VBILAMT"
 D ^DIE
 S PAT=VPATLN_","_VPATFN_" "_VPATMN
 S DR=".06///^S X=PAT;.08///^S X=VDOSB;.09///^S X=VDOSE"
 D ^DIE
 S ADJDA=0
 Q
 ; *********************************************************************
 ;
ADJREA ;EP Process reason and amount into claim impda,clmda
 S VADJAMT=VBILAMT-VPAYAMT
 I '$L(VADJREA) Q
 S VADJCAT=$E(VADJCAT)
 I VADJCAT="A" Q
 I VADJCAT'="R" D  Q
 . S VADJREA=VADJCAT_" | "_$P(VADJREA,SE,2)
 . D SET1ADJ
 ; process reason code(s)
 S XXX=$P(VADJREA,": ",2)
 I '$F(XXX,SE) D  Q
 . S X=XXX
 . D CLMCODE^BAREDP02
 . S VADJREA=X
 . D SET1ADJ
 F I=1:1 S X=$P(XXX,SE,I) Q:'$L(X)  D
 . S:I>1 VADJAMT=0 ; assign amt to the 1st reason only
 . D CLMCODE^BAREDP02 ; lookup reason in Claim Level Reasons table
 . S VADJREA=X
 . D SET1ADJ
 Q
 ; *********************************************************************
 ;
SET1ADJ ; set one adjustment X|reason, AMT
 S ADJDA=ADJDA+1
 K DIE,DR,DA,X,DIC
 S DA(2)=IMPDA
 S DA(1)=CLMDA
 S X=ADJDA
 S DIC=$$DIC^XBDIQ1(90056.0208)
 S DIC("P")="90056.0208A"
 S DIC(0)="EXL"
 S DIC("DR")=".02///^S X=VADJAMT;.03////^S X=VADJREA"
 D ^DIC
 Q
 ; *********************************************************************
 ;
CHKNUM ;EP Enter Check mumber into Import
 K DIE,DR,DA
 S DIE=$$DIC^XBDIQ1(90056.02)
 S DA=IMPDA
 S DR=".09////^S X=VCHKNUM"
 D ^DIE
 ;
ECHECK ;
 Q
 ; *********************************************************************
 ;
LOAD ;EP Scan all AHCCCS imports loaded for new reason codes and stuff them
 ; into the Claim Level Reason Codes table for mapping.
EN ;
 S FDA=0
 F  S FDA=$O(^BAREDI("I",2917,FDA)) Q:FDA'>0  D FILE
 Q
 ; *********************************************************************
 ;
FILE ;
 S FDA0=^BAREDI("I",2917,FDA,0)
 I $P(FDA0,U,3)'=4 Q
 W !,FDA0
 D REASON
 Q
 ; *********************************************************************
 ;
REASON ;
 F L=1:1 Q:'$D(^BAREDI("I",2917,FDA,15,L))  S X=^(L,0) D
 . I '(L#100) W "."
 . I $E(X,1,2)="PN" D PN
 Q
 ; *********************************************************************
 ;
PN ;
 S CODE=$P(X,"`",2)
 S REA=$P(X,"`",3)
 I '$D(^BAREDI("1T",4,40,"B",CODE)) D
 . W !,CODE,?10,REA
 . S ^PWTMP("AHC",CODE)=REA
 Q
 ; *********************************************************************
 ;
PUT ; FILE NEW INTO CLAIM LEVEL MULTIPLE
 S CODE=""
 F  S CODE=$O(^PWTMP("AHC",CODE)) Q:CODE=""  D SET
 Q
 ; *********************************************************************
 ;
SET ;
 K DIC,DR,DA
 S X=CODE
 S REA=^PWTMP("AHC",CODE)
 S DA(1)=4
 W !,CODE,?10,REA
 Q
 ; *********************************************************************
 ;
END ;
 Q
 ; *********************************************************************
 ;
AHCCCS ;EP enter new table entries for AHCCCS
 ;;
 Q
 ; *********************************************************************
 ;
MAP ;EP repoint the distributed tabled reason pointers to the new ones installed
 Q
 ; *********************************************************************
 ;
1001 ;;BAD DEBT/COLLECTION AGENCY^3^WO
1002 ;;CODING ERROR^4^NONPAY
1003 ;;RX PROCESSING FEE^3^WO^123
1004 ;;OTHER TPL^4^NONPAY
1005 ;;MISSING DATA^4^NONPAY
1006 ;;INCORRECT PROVIDER TYPE^4^NONPAY
1007 ;;MISSING FIELD^4^NONPAY
1008 ;;DOCUMENTATION REQUIRED^4^NONPAY
