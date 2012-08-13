CIAVIN1 ;MSC/IND/DKM - RPC Registration ;04-May-2006 08:19;DKM
 ;;1.1V2;VUECENTRIC FRAMEWORK;;Mar 20, 2007
 ;;Copyright 2000-2006, Medsphere Systems Corporation
 ;=================================================================
 ; Perform various registration actions
REGISTER N X,CTX
 S CTX=$$GETOPT^CIAURPC("CIAV VUECENTRIC")
 Q:'CTX
 F X="CIAV","CIAU","DG","DDR","RGUT","BEH" D REGNMSP^CIAURPC(X,CTX)
 F X="OR CPRS GUI CHART" D DOREG(X)
 D REGPROT^CIAURPC("XU USER TERMINATE","CIAV USER TERMINATE")
 Q
 ; Add an option as a subcontext to VueCentric
 ; Remove any redundant RPC's
DOREG(OPT) ;
 N RPC,CNT1,CNT2,STAT,IEN
 S IEN=$$GETOPT^CIAURPC(OPT)
 Q:'IEN
 W !!,"Registering ",OPT," as a subcontext under CIAV VUECENTRIC...",!
 I $$REGCTX^CIAURPC(IEN,CTX)
 W "Removing redundant RPC references...",!
 S (CNT1,CNT2)=0
 F RPC=0:0 S RPC=$O(^DIC(19,IEN,"RPC","B",RPC)) Q:'RPC  D
 .S STAT=$$REGRPC^CIAURPC(RPC,CTX,1)
 .Q:STAT=-1
 .W $$GET1^DIQ(8994,RPC,.01)_" - "
 .I STAT=1 W "Removed",! S CNT1=CNT1+1
 .E  I 'STAT W "Not removed",! S CNT2=CNT2+1
 W !,CNT1," remote procedure(s) removed",!
 W:CNT2 CNT2," remote procedure(s) could not be removed",!!
 Q
