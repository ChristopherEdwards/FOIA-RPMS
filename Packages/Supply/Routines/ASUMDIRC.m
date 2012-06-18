ASUMDIRC ; IHS/ITSC/LMH -FRONT END TO ^DIC ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine is a utility which provided a local array of internal
 ;record numbers of records already read during an update session
 ;so that an external lookup would not be needed.  Although routins
 ;still call it instead of ^DIC, the local array (in effect a buffer)
 ;has now been commented out. The logic was initiated as a possible
 ;method of speeding up an update run, but with the new faster CPUs
 ;it is no longer needed.
 ;I $D(ASUA(ASUU("DIC"),X)) S Y=ASUA(ASUU("DIC"),X) Q
 S DIC(0)="MXZ"
CALLDIC ;
 S DIC=90020_ASUU("DIC")
 D ^DIC
 ;S ASUA(ASUU("DIC"),X)=+Y
 Q
LAYGO ;EP LOOKUP WITH LAYGO
 S DIC(0)="L"
 G CALLDIC
