ACHSCPTF ; IHS/ITSC/TPF/PMF - PRINT CHS CPT CODE REPORT-BY VENDOR/SUMMARY ; JUL 10, 2008 
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**14**;JUN 11,2001
 ;3.1*14 12.4.2007 IHS/OIT/FCJ ADDED CSV CHANGES
 ;
 D BRPT^ACHSFU
 S (ACHSPAGE,C,ACHSCHBS,ACHSDOCT,ACHSDGT,ACHSDOC,ACHSCHAT,ACHSCHBT,ACHSCHAS,ACHS43S,ACHS43T,ACHS57S,ACHS57T,ACHS64S,ACHS64T,ACHSCS,ACHSCT)=0
 S ACHSVNDR=""
P1 ; 
 S ACHSVNDR=$O(^TMP("ACHSCPT",$J,ACHSVNDR))
 G TOTL:ACHSVNDR=""
 I ACHSVNDR=0 G NODATA1
 I $D(^TMP("ACHSCPT",$J,ACHSVNDR,0)) G NODATA
 S ACHSCODE=""
 D HEADER,HEADER1
P2 ; 
 S ACHSCODE=$O(^TMP("ACHSCPT",$J,ACHSVNDR,ACHSCODE))
 G:ACHSCODE="" SUBTOTL
 S ACHSDOCS=$P($G(^TMP("ACHSCPT",$J,ACHSVNDR,ACHSCODE)),U)
 S ACHSCHB=$P($G(^TMP("ACHSCPT",$J,ACHSVNDR,ACHSCODE)),U,2)
 S ACHSCHA=$P($G(^TMP("ACHSCPT",$J,ACHSVNDR,ACHSCODE)),U,3)
 ;3.1*14 12.4.2007 IHS/OIT/FCJ ADDED CSV CHANGES NXT 4 LINES
 ;S ACHSCODP=$S($D(^ICPT(ACHSCODE,0)):$P($G(^ICPT(ACHSCODE,0)),U,2),1:"NOT ON FILE")
 S ACHSCODP=$S($D(^ICPT(ACHSCODE,0)):$P($$CPT^ICPTCOD(ACHSCODE),U,3),1:"NOT ON FILE")
 ;S ACHSCOD=$S($D(^ICPT(ACHSCODE,0)):$P($G(^ICPT(ACHSCODE,0)),U),1:ACHSCODE)
 S ACHSCOD=$S($D(^ICPT(ACHSCODE,0)):$P($$CPT^ICPTCOD(ACHSCODE),U,2),1:ACHSCODE)
PRINT ;Prints data totals
 W !?1,$J(ACHSCOD,6)_"-"_ACHSCODP,?40,$J(ACHSDOCS,4)
 S X=ACHSCHB,X2=2
 D COMMA^%DTC
 W ?50,X
 S X=ACHSCHA,X2=2
 D COMMA^%DTC
 W ?65,X
 I IOST["P-"&($Y>56) D HEADER,HEADER1
 I IOST["C-",'$D(IO("S"))&($Y>24) K DIR S DIR(0)="E" W !! D ^DIR G END:Y=0 D HEADER,HEADER1
 S Z=$G(^TMP("ACHSCPT",$J,ACHSVNDR,ACHSCODE))
 S ACHS43=$P(Z,U,4),ACHS57=$P(Z,U,5),ACHS64=$P(Z,U,6),ACHS43S=ACHS43S+ACHS43,ACHS57S=ACHS57S+ACHS57,ACHS64S=ACHS64S+ACHS64
 S ACHSCHBS=ACHSCHBS+ACHSCHB,ACHSCHAS=ACHSCHAS+ACHSCHA,ACHSDOCT=ACHSDOCT+ACHSDOCS,ACHSCS=ACHSCS+1
 S (ACHSCHB,ACHSDOCS,ACHSCHA,C)=0
 G P2
 ;
SUBTOTL ; Print subtotals.
 W !!,$$REPEAT^XLFSTR("-",80),!?1,"SUBTOTAL",?10,ACHSCS,?40,$J(ACHSDOCT,4)
 S X=ACHSCHBS,X2="2$"
 D COMMA^%DTC
 W ?50,X
 S X=ACHSCHAS,X2="2$"
 D COMMA^%DTC
 W ?65,X
 I ACHSCHBS>0&(ACHSCHAS>0) S X=(ACHSCHAS/ACHSCHBS)*100 W !!?1,"PERCENTAGE OF CHGS ALLOWED TO CHGS BILLED" W ?61,$E(X,1,5)_"%"
 W !!?3,"** HOSP - "_ACHS43S_" **",?32,"** DENT - "_ACHS57S_" **",?62,"** OUTP - "_ACHS64S_" **"
 S ACHSCHBT=ACHSCHBT+ACHSCHBS,ACHSCHAT=ACHSCHAT+ACHSCHAS,ACHSDGT=ACHSDGT+ACHSDOCT
 S ACHS43T=ACHS43T+ACHS43S,ACHS57T=ACHS57T+ACHS57S,ACHS64T=ACHS64T+ACHS64S,ACHSCT=ACHSCT+ACHSCS
 K DIR
 I IOST["C-",'$D(IO("S")) S DIR(0)="E" W !! D ^DIR G END:Y=0
 S (C,ACHSCHBS,ACHSCHAS,ACHSDOCT,ACHSPAGE,ACHS43S,ACHS57S,ACHS64S,ACHSCS)=0
 G P1
 ;
TOTL ; Print totals.
 W !!!!,$$REPEAT^XLFSTR("=",80),!!?1,"TOTAL",?10,ACHSCT,?40,$J(ACHSDGT,4)
 S X=ACHSCHBT,X2="2$"
 D COMMA^%DTC
 W ?50,X
 S X=ACHSCHAT,X2="2$"
 D COMMA^%DTC
 W ?65,X
 I ACHSCHBT>0&(ACHSCHAT>0) S X=(ACHSCHAT/ACHSCHBT)*100 W !!?1,"PERCENTAGE OF CHGS ALLOWED TO CHS BILLED" W ?61,$E(X,1,5)_"%"
 W !!?3,"** HOSP - "_ACHS43T_" **",?32,"** DENT - "_ACHS57T_" **",?62,"** OUTP - "_ACHS64T_" **"
 K DIR
 I IOST["C-",'$D(IO("S")) S DIR(0)="E" W !! D ^DIR G END:Y=0
END ;Close device, kill variables, quit
 S:$D(ZTQUEUED) ZTREQ="@"
 D ^%ZISC
 K ACHSPAGE,C,ACHSCHB,ACHSCHA,ACHSDOCS,ACHSCHBS
 K ACHS43,ACHS43S,ACHS43T,ACHS57,ACHS57S,ACHS57T,ACHS64,ACHS64S,ACHS64T
 K ACHSBEG,ACHSCOD,ACHSCODP,ACHSCS,ACHSCT,ACHSEND,Z
 K ACHSDOCT,ACHSDOC,ACHSCODE,ACHSDAT,ACHSTIM,ACHSDGT
 K ACHSQIO,ACHSCHBT,ACHSCHAT,ACHSCHAS,ACHSUSR,ACHSVNDR,I
 K X2,^TMP("ACHSCPT",$J),DIR
 Q
 ;
NODATA ; 
 D HEADER
 S %=$P($G(^AUTTVNDR(ACHSVNDR,0)),U),%=$P(%,",",2)_" "_$P(%,",",1)
 W !!!,$$C^XBFUNC("NO DATA AVAILABLE FOR "_%_" FOR SPECIFIED DATE RANGE",80),!!!!
 I IOST["C-",'$D(IO("S")),'$D(ZTQUEUED) K DIR S DIR(0)="E" U IO(0) D ^DIR K DIR Q:Y=0
 K ^TMP("ACHSCPT",$J,ACHSVNDR,0) S ACHSPAGE=0
 G P1
 ;
NODATA1 ; 
 K DIR
 D HEADER
 S DIR(0)="E"
 W !!!,"NO DATA AVAILABLE FOR SPECIFIED CRITERIA",!!!!
 I IOST["C-",'$D(IO("S")) D ^DIR G END:Y=0
 K DIR,^TMP("ACHSCPT",$J)
 D END
 G ^ACHSCPTD:'$D(ZTQUEUED)
 Q
 ;
HEADER ;Prints heading
 W @IOF
 S ACHSPAGE=ACHSPAGE+1
 S Y=$$HTE^XLFDT($H),ACHSDAT=$P(Y,"@",1),ACHSTIM=$P(Y,"@",2)
 W !,"*",ACHSDAT
 S X=$$LOC^ACHS
 W ?((80/2)-($L(X)/2)),X
 W ?71,ACHSTIM,"*",!,"*User: ",ACHSUSR,?70,"Device:",IO,"*"
 W !!
 S X="CPT CODE Summary Report BY VENDOR - Page "
 W ?((80/2)-($L(X)/2)),X_ACHSPAGE
 W !
 S X="For "_$$FMTE^XLFDT(ACHSBEG)_" To "_$$FMTE^XLFDT(ACHSEND)
 W ?((80/2)-($L(X)/2)),X,!
 W $$REPEAT^XLFSTR("*",80)
 Q
 ;
HEADER1 ;Prints Vendor 
 W !!?23,"Vendor: ",$S($D(^AUTTVNDR(ACHSVNDR,0)):$P($G(^AUTTVNDR(ACHSVNDR,0)),U),1:"NOT ON FILE"),!!?1,"CPTCODE",?40,"# DOCS #",?52,"$ CHG BLD $",?66,"$ CHG ALWD $",!,$$REPEAT^XLFSTR("~",80)
 Q
 ;