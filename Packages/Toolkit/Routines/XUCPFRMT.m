XUCPFRMT ;SFISC/HVB/VYD/JC - Resource Usage Table or Graph ;6/20/95  08:47 [ 04/02/2003   8:47 AM ]
 ;;7.3;TOOLKIT;**1001**;APR 1, 2003
 ;;7.3;TOOLKIT;**5**;Apr 25, 1995
 I $D(^XTMP("XUCP","zzz"))'=11 W !!!,"There is no data to print from.",!,"Please run SORT RAW RESOURCE USAGE DATA option first." Q
 W !!!,"I will write out Resource Usage by Namespace, based on the preceding sort.",!
 N XTR,FRMT,ACT,%H,SDT,EDT,NODE,FNAME,XUCPQ,TOFILE,T,X,X1,C,D,I,N
 S DIR(0)="Y",DIR("A")="Subtotal by Node",DIR("B")="YES" D ^DIR K DIR Q:$D(DTOUT)!$D(DUOUT)  S ACT=$S(Y:"NODE",1:"CUM")
 I ACT'["CUM" S DIR(0)="Y",DIR("A")="Would you also like cumulative by option for all nodes",DIR("B")="YES" D ^DIR K DIR Q:$D(DTOUT)!$D(DUOUT)  S:Y ACT=ACT_"CUM"
 S DIR(0)="NA^1:8:0",DIR("A")="Namespace length: ",DIR("B")=4 D ^DIR K DIR Q:$D(DTOUT)!$D(DUOUT)  S XTR=Y
 S DIR(0)="SA^T:Table;G:Graph",DIR("A")="Format for report (<T>able/<G>raph): ",DIR("B")="T" D ^DIR K DIR Q:$D(DTOUT)!$D(DUOUT)  S FRMT=Y
DEVICE S NODE=$O(^XTMP("XUCP",""))
 S %H=$P(^XTMP("XUCP","zzz"),"^") D YX^%DTC S SDT=Y,%H=$P(^XTMP("XUCP","zzz"),"^",2) D YX^%DTC S EDT=Y
 S SDT=$TR(SDT," ,@:"),EDT=$TR(EDT," ,@:")
 S FNAME=$S(ACT["CUM":"CUM"_$E(NODE,1,4),1:NODE)_"_"_SDT_"_"_EDT_".XUCP"_FRMT
 S DIR("A")="Write to file ("_FNAME_")",DIR(0)="Y",DIR("B")="YES"
 D ^DIR K DIR S TOFILE=Y Q:$D(DTOUT)!$D(DUOUT)
 S:TOFILE %ZIS("HFSNAME")=FNAME,%ZIS("HFSMODE")="W",IOP="HFS"_$S(FRMT="G":";132",1:";80")
 I TOFILE S DIR("A")="Would you like to queue this job for background execution",DIR(0)="Y",DIR("B")="YES" D ^DIR K DIR S XUCPQ=Y Q:$D(DTOUT)!$D(DUOUT)
 S:TOFILE&$G(XUCPQ) IOP="Q;"_IOP
 S %ZIS=$S('TOFILE:"MQ",$G(XUCPQ)&TOFILE:"NQ",1:"") D ^%ZIS Q:POP
 I FRMT="T",IOM<80 W !,"The TABLE format requires at least 80 column device." G DEVICE
 I FRMT="G",IOM<132 W !,"The GRAPH format requires at least 132 column device." G DEVICE
 I $D(IO("Q")) S ZTRTN="DQ^XUCPFRMT" D  Q
 .S ZTDESC="Resource Usage by Option ("_$S(FRMT="G":"Graph",1:"Table")_")"
 .S (ZTSAVE("XTR"),ZTSAVE("FRMT"),ZTSAVE("ACT"))="" D ^%ZTLOAD,HOME^%ZIS
 .W:$D(ZTSK) !,"Queued as task ",ZTSK,!
DQ ;PRINT REPORT (POSSIBLY BY TASKMAN)
 G:$D(^XTMP("XUCP","zzz"))<11 END ;quit if no sorted data to output
 N OPT,NODE,DATE,JOB,TIME,SC,SD,SN,XOPT,SDT,EDT
 S X=^%ZOSF("ERRTN"),@^%ZOSF("TRAP") ;necessary because of the NEW cmnd
 S %H=$P(^XTMP("XUCP","zzz"),U) D YX^%DTC S SDT=Y,%H=$P(^("zzz"),U,2) D YX^%DTC S EDT=Y
 K ^TMP($J)
COLLECT ;
 S (OPT,NODE,DATE,JOB,TIME)=""
 F  S OPT=$O(^XTMP("XUCP","zzz",OPT)) Q:OPT=""  D
 .F  S NODE=$O(^XTMP("XUCP","zzz",OPT,NODE)) Q:NODE=""  D
 ..F  S DATE=$O(^XTMP("XUCP","zzz",OPT,NODE,DATE)) Q:DATE=""  D
 ...F  S JOB=$O(^XTMP("XUCP","zzz",OPT,NODE,DATE,JOB)) Q:JOB=""  D
 ....F  S TIME=$O(^XTMP("XUCP","zzz",OPT,NODE,DATE,JOB,TIME)) Q:TIME=""  S X=^(TIME),XOPT=$E(OPT,1,XTR) D
 .....I ACT["NODE" D
 ......S X1=$G(^TMP($J,"N",NODE,XOPT))+1,^(XOPT)=X1
 ......S X1=$G(^TMP($J,"C",NODE,XOPT))+$P(X,U),^(XOPT)=X1
 ......S X1=$G(^TMP($J,"D",NODE,XOPT))+$P(X,U,2),^(XOPT)=X1
 ......S X1=$G(^TMP($J,"T",NODE,XOPT))+$P(X,U,5),^(XOPT)=X1
 .....I ACT["CUM" D
 ......S X1=$G(^TMP($J,"N","zCUM",XOPT))+1,^(XOPT)=X1
 ......S X1=$G(^TMP($J,"C","zCUM",XOPT))+$P(X,U),^(XOPT)=X1
 ......S X1=$G(^TMP($J,"D","zCUM",XOPT))+$P(X,U,2),^(XOPT)=X1
 ......S X1=$G(^TMP($J,"T","zCUM",XOPT))+$P(X,U,5),^(XOPT)=X1
 U IO
PRINT ;PRINT DATA SUBTOTALED BY NODE (NODE zCUM IS ACTUALLY TOTALS)
 S OPT="",NODE=$S(ACT["NODE":"",1:"ZZZ")
 F  S NODE=$O(^TMP($J,"C",NODE)) Q:NODE=""!(NODE="zCUM"&(ACT'["CUM"))  D
 .S (SC,SD,SN)=0
HEADER .W:IOST'["HFS" @IOF W !?(9+((FRMT="G")*27))
 .W $S(NODE'="zCUM":"Node "_NODE,1:"Station "_$E($O(^XTMP("XUCP",0)),1,4))
 .W " from ",SDT," to ",EDT,!
 .W:$L($P(^XTMP("XUCP","zzz"),U,3)) ?(8+((FRMT="G")*27)),"*** Merged data may not be continuous over the date range! ***",!
 .I FRMT="G" W "OPT",?10,"CPUSEC",?118,"DIO",?124,"SEC",?131,"N",!!
 .E  W !,?8,$J($E("OPT",1,XTR),XTR),$J("CPU",7),$J("DIO",7),$J("SEC",7) D
 ..W $J("N",5),$J("C/N",7),$J("D/N",7),$J("S/N",7),$J("C/S",6),$J("D/S",5),!!
NDLOOP .F  S OPT=$O(^TMP($J,"C",NODE,OPT)) Q:OPT=""  D
 ..S C=^TMP($J,"C",NODE,OPT),D=^TMP($J,"D",NODE,OPT),T=^TMP($J,"T",NODE,OPT),N=^TMP($J,"N",NODE,OPT)
 ..D GRPHOUT:FRMT="G",TABLOUT:FRMT="T"
 ..S SC=SC+^TMP($J,"C",NODE,OPT),SD=SD+^TMP($J,"D",NODE,OPT),SN=SN+^TMP($J,"N",NODE,OPT) ;accum totals
TOTALS .W ! W:FRMT="T" ?3+XTR W "TOTAL" W:FRMT="G" ?7
 .W $J(SC+.5\1,7) W:FRMT="G" ?114
 .W $J(SD,7),?$X+$S(FRMT="G":5,1:6),$J(SN,6)
END D ^%ZISC K ^TMP($J),XTR,FRMT,ACT,T,X,X1,Y,Y1,C,D,I,N,ZTDESC,ZTRTN,ZTSAVE,ZTSK
 Q
GRPHOUT W $J(OPT,XTR),?8,$J(C,6,0) S X=C/5\1 W:X>50 "<" S:X>50 X=50 W ?(65-X) F I=1:1:X W "*"
 S (Y,Y1)=D/500\1 S:Y>49 Y=49 F I=1:1:Y W "-"
 W:Y1>49 ">" W ?115,$J(D,6),$J(T+.5\1,6),$J(N,5),!
 Q
TABLOUT W ?8,$J(OPT,XTR),$J(C+.5\1,7),$J(D,7),$J(T+.5\1,7),$J(N,5),$J(C*100+.5/N\1/100,7,2),$J(D*10+.5/N\1/10,7,1),$J(T*10+.5/N\1/10,7,1),$J(C*1000+.5/T\1/1000,6,2),$J(D*100+.5/T\1/100,5,1),!
 Q
