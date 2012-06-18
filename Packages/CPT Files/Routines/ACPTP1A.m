ACPTP1A ; IHS/ASDST/DMJ,SDR - CPT PATCH 1 ;      [ 01/07/2005  12:02 PM ]
 ;;2005;CPT FILES;**1**;DEC 31, 2004
 ;
 ;
START ;START HERE
 I '$G(DT) D NOW^%DTC S DT=X
 S ACPTYR=3050000
 W $$EN^ACPTVDF("IOF")
 W !!,"HCPCS Version 2.05 Install",!
 D MSG
 K DIR S DIR(0)="E" D ^DIR K DIR Q:Y'=1
 W !,"Installing ",$E(ACPTYR,1,3)+1700," HCPCS codes.",!
 D OPEN
 I POP U IO(0) W !,"Could not open HCPCS file." Q
 D HREAD  ;hcpcs
 D XREF
 W !!,"INSTALL COMPLETE",!!
 S DIR(0)="E" D ^DIR
 K DIR,ACPT,ACPTYR
 Q
 ;
OPEN ;open host file
 D DIR
 S ACPTFL="acpt2005.01h"
 D OPEN^%ZISH("CPTHFILE",ACPTPTH,ACPTFL,"R")
 Q
HREAD ;READ HCPCS FILE
 U IO(0) W !,"Reading HCPCS Codes File.",!
 F ACPTCNT=1:1 D  Q:$$STATUS^%ZISH
 .U IO R ACPTREC Q:$$STATUS^%ZISH
 .S ACPTCD=$E(ACPTREC,1,5)
 .Q:ACPTCD'?1U4N
 .D ONE
 .D DOTS(ACPTCNT)
 D ^%ZISC
 K ACPTSD,ACPTLD,ACPTDESC
 K ACPTCSV,ACPTFLAG,ACPTREC
 Q
ONE ;one record
 S A=$E(ACPTREC,7,40) D DESC S ACPTSD=ACPTDESC
 S A=$E(ACPTREC,42,299) D DESC S ACPTLD(1)=ACPTDESC
 I '$D(^ICPT("B",ACPTCD)) D NEW
 S ACPTIEN=$O(^ICPT("B",ACPTCD,0))
 Q:ACPTIEN'>0
 S:ACPTSD'="" $P(^ICPT(ACPTIEN,0),"^",2)=ACPTSD
 S $P(^ICPT(ACPTIEN,0),"^",4)=""
 S $P(^ICPT(ACPTIEN,0),"^",7)=""
 K ^ICPT(ACPTIEN,"D")
 D WP^DIE(81,ACPTIEN_",",50,"","ACPTLD")
 Q
NEW ;new hcpcs code
 S ACPTIEN=$A($E(ACPTCD))_$E(ACPTCD,2,5)
 S ^ICPT(ACPTIEN,0)=ACPTCD
 S ^ICPT("B",ACPTCD,ACPTIEN)=""
 S $P(^ICPT(ACPTIEN,0),"^",6)=ACPTYR
 Q
 ;
DIR ;ASK DIRECTORY WHERE FILES WERE LOADED
 W !
 S DIR(0)="F",DIR("A")="Enter directory where HCPCS file is located."
 S DIR("B")="/usr/spool/uucppublic/"
 D ^DIR K DIR
 Q:$D(DUOUT)!$D(DTOUT)!$D(DIRUT)
 I ^%ZOSF("OS")["UNIX" D
 .S Y=$TR(Y,"\","/")
 .S:$E(Y)'="/" Y="/"_Y
 .S:$E(Y,$L(Y))'="/" Y=Y_"/"
 I ^%ZOSF("OS")'["UNIX" D
 .S Y=$TR(Y,"/","\")
 .I $E(Y)'="\",Y'[":" S Y="\"_Y
 .S:$E(Y,$L(Y))'="\" Y=Y_"\"
 S ACPTPTH=Y
 Q
DESC ;STRIP TRAILING BLANKS FROM DESCRIPTION FIELD
 S ACPTDESC=""
 N I F I=0:1:31 S A=$TR(A,$C(I))
 N I F I=1:1:$L(A," ") D
 .S ACPTWORD=$P(A," ",I)
 .Q:ACPTWORD=""
 .S:I>1 ACPTDESC=ACPTDESC_" "
 .S ACPTDESC=ACPTDESC_ACPTWORD
 K ACPTWORD
 Q
DOTS(X) ;EP - WRITE OUT A DOT EVERY HUNDRED
 U IO(0)
 W:'(X#100) "."
 Q
XREF ;RE-CROSS REFERENCE FILE
 W !,"WILL NOW RE-INDEX CPT FILE (this will take awhile).",!
 S DIK="^ICPT(" D IXALL^DIK
 D ^ACPTCXR
 Q
MSG ;display message
 F I=1:1 D  Q:ACPTTXT["***end***"
 .S ACPTTXT=$P($T(TXT+I),";;",2)
 .Q:ACPTTXT["end"
 .I ACPTTXT="NOTE:" W $$EN^ACPTVDF("RVN")
 .W !,ACPTTXT
 .I ACPTTXT="NOTE:" W $$EN^ACPTVDF("RVF")
 K ACPTTXT
 Q
TXT ;text lines
 ;;CPT version 2.05 patch# 1 contains HCPCS codes for 2005.
 ;;The install will read the HCPCS code file (acpt2005.01h)
 ;;from the directory you specify. 
 ;;
 ;;***end***
 Q
