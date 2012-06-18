BDW1VBLZ ;IHS/CMI/LAB - rerun visit backload log;
 ;;1.0;IHS DATA WAREHOUSE;;JAN 23, 2006
 ;
 ;
START ;
 D EN^XBVK("BDW")
 S BDWO("RUN")="REDO" ;     Let ^BDWRDRI know this is a 'REDO'
 D BASICS^BDW1VBLI
 D CHKSITE^BDW1VBLI
 ;I $D(^BDWTMP) W !!,"^BDWTMP exists from previous run" D EOJ Q
 I $D(^BDWDATA) W !!,"^BDWDATA EXISTS FROM PREVIOUS RUN" D EOJ Q  ;           
 I BDW("QFLG")=66 W:'$D(ZTQUEUED) !,"Contact your site manager.  ^BDWTMP still exists." D  D EOJ Q
 .S DIR(0)="EO",DIR("A")="Press any key to continue" K DA D ^DIR K DIR
 I BDW("QFLG") D EOJ W !!,"Bye",!! Q
 D INIT ;               Get Log entry to redo
 I BDW("QFLG") D EOJ W !!,"Bye",!! Q
 D QUEUE^BDW1VBLI
 I BDW("QFLG") D EOJ W !!,"Bye",!! Q
 I $D(BDWO("QUEUE")) D EOJ W !!,"Okay your request is queued!",!! Q
 D DRIVER^BDW1VBL
EOJ ;
 D EN^XBVK("BDW")
 Q
INIT ;EP
 S DIC="^BDWBLOG(",DIC(0)="AEQ",DIC("S")="I $P(^(0),U,9)=DUZ(2)" D ^DIC K DIC
 I Y<0 S BDW("QFLG")=99 Q
 S BDW("RUN LOG")=+Y
 ;
 S X=^BDWBLOG(BDW("RUN LOG"),0),BDW("RUN BEGIN")=$P(X,U),BDW("RUN END")=$P(X,U,2),BDW("COUNT")=$P(X,U,6),BDW("ORIG TX DATE")=$P($P(X,U,3),".")
 S Y=BDW("RUN BEGIN") X ^DD("DD") S BDW("PRINT BEGIN")=Y
 S Y=BDW("RUN END") X ^DD("DD") S BDW("PRINT END")=Y
 S BDW("OLD VISITS")=$P(^BDWBLOG(BDW("RUN LOG"),0),U,6)
 W !!,"Log entry ",BDW("RUN LOG")," was for date range ",BDW("PRINT BEGIN")," through",!,BDW("PRINT END")," and generated ",BDW("COUNT")," transactions from ",BDW("OLD VISITS")," visits."
 ;
 W !!,"This routine will re-generate the Data Warehouse Encounter Records."
RDD ;
 S DIR(0)="Y",DIR("A")="Do you want to regenerate the transactions for this run",DIR("B")="N" K DA D ^DIR K DIR
 I $D(DIRUT)!'Y S BDW("QFLG")=99 Q
 S BDW("COUNT")=0
 Q
POST ;EP
 NEW X S X=$$ADD^XPDMENU("BDW BACKLOAD MENU","BDW BL VISITS RERUN","RRV",98)
 I 'X W "Attempt to add VISIT BACKLOAD RERUN option failed." H 3
 Q
