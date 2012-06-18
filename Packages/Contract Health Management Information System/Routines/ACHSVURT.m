ACHSVURT ; IHS/ITSC/PMF - VENDOR USAGE REPORT ;   [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 ;9/11/00   added verification of eligbility dates.  Changes
 ;          are courtesy of Jeanette Kompkoff, presently
 ;          of the Portland office
 ;
 ;
 ;
 S ACHSIO=IO
BDT ; Enter beginning date.
 S ACHSBDT=$$DATE^ACHS("B","Vendor Usage","ISSUE")
 G K:$D(DUOUT)!$D(DTOUT)!(ACHSBDT<1)
EDT ; Enter the ending date.
 S ACHSEDT=$$DATE^ACHS("E","Vendor Usage","ISSUE")
 G BDT:$D(DUOUT),K:$D(DTOUT)!(ACHSEDT<1),EDT:$$EBB^ACHS(ACHSBDT,ACHSEDT)
DOCS ; Select type of docs to print.
 S ACHSRPT=$$DIR^XBDIR("S^1:ALL documents;2:OPEN documents only","Print which documents","1","","","^D HELP^ACHS(""H1"",""ACHSVUR"")",2)
 G EDT:$D(DUOUT),K:$D(DTOUT)
 S %=$$DIR^XBDIR("Y","Print ONE vendor per page","N","","","^D HELP^ACHS(""H2"",""ACHSVUR"")",2)
 G DOCS:$D(DUOUT),K:$D(DTOUT)
 S ACHSVND=$S(%:"Y",1:"N")
DEV ; Select device for report.
 W !
 S %=$$PB^ACHS
 I %=U!$D(DTOUT)!$D(DUOUT) D K Q
 I %="B" D VIEWR^XBLM("CALC^ACHSVUR"),EN^XBVK("VALM") D K Q
 K IOP,%ZIS
 S %ZIS="PQ"
 D ^%ZIS,SLV^ACHSFU:$D(IO("S"))
 K %ZIS
 I POP W !,*7,"No device specified." D HOME^%ZIS G K
 G:'$D(IO("Q")) CALC
 K IO("Q")
 I $E(IOST)'="P" W *7,!,"Please queue to printers only." G DEV
 S ZTIO="",ACHSQIO=ION_";"_IOST_";"_IOM_";"_IOSL,ZTRTN="CALC^ACHSVUR",ZTDESC="CHS Vendor Report, "_ACHSRPT_", "_$$FMTE^XLFDT(ACHSBDT)_" to "_$$FMTE^XLFDT(ACHSEDT)_" for "_ACHSVND
 F %="ACHSQIO","ACHSVND","ACHSBDT","ACHSRPT","ACHSEDT" S ZTSAVE(%)=""
 D ^%ZTLOAD
 G:'$D(ZTSK) DEV
K ; Kill vars, close device, quit.
 K ACHSBDT,ACHSEDT,ACHSIO,ACHSQIO,ACHSRPT,ACHSVND,DTOUT,DUOUT,ZTSK
 D ^%ZISC
 Q
 ;
 ;end of interactive portion.  The rest performed by Taskman
 ;
 ;
CALC ;EP - TaskMan.
 D FC^ACHSUF
 I $D(ACHSERR),ACHSERR=1 G K
 S ACHSTRDT=ACHSBDT-1
 K ^TMP("ACHSVUR",$J)
 ;
TRDT ; Loop thru transaction date x-ref.
 S ACHSTRDT=$O(^ACHSF(DUZ(2),"TB",ACHSTRDT))
 G PRINT:+ACHSTRDT=0!(+ACHSTRDT>ACHSEDT)
 S ACHSTYPE=""
 ;
TRTYPE ; Loop thru transaction type.
 S ACHSTYPE=$O(^ACHSF(DUZ(2),"TB",ACHSTRDT,ACHSTYPE))
 G TRDT:ACHSTYPE="",TRTYPE:ACHSTYPE'="I"
 S DA=0
 ;
TRANS ; Loop thru transactions, compile report data.
 S DA=$O(^ACHSF(DUZ(2),"TB",ACHSTRDT,ACHSTYPE,DA))
 G TRDT:+DA=0,TRDT:'$D(^ACHSF(DUZ(2),"D",DA,0))
 S ACHSDOCN=$P(^ACHSF(DUZ(2),"D",DA,0),U),ACHSVPTR=$P(^(0),U,8),ACHSFY=$P(^(0),U,14),ACHSSTS=$P(^(0),U,12),DFN=$P(^(0),U,22),ACHSBLNK=+$P(^(0),U,3)
 S ACHS("$")=$S($D(^ACHSF(DUZ(2),"D",DA,"ZA")):+^ACHSF(DUZ(2),"D",DA,"ZA"),$D(^ACHSF(DUZ(2),"D",DA,"PA")):+^ACHSF(DUZ(2),"D",DA,"PA"),1:$P(^ACHSF(DUZ(2),"D",DA,0),U,9)) I $D(^ACHSF(DUZ(2),"D",DA,"PA")) S ACHS("$")=ACHS("$")_"*"
 G TRANS:(DFN'=+DFN)&('ACHSBLNK),TRANS:ACHSSTS=4!(ACHSRPT=2&(ACHSSTS>2))!(ACHSVPTR']""),TRANS:'$D(^AUTTVNDR(ACHSVPTR,0)) S ACHSVNDR=$P(^(0),U)
 I 'ACHSBLNK,'$D(^DPT(DFN,0)) G TRANS
 S ACHSDOC=ACHSFY_"-"_ACHSFC_"-"_ACHSDOCN,^TMP("ACHSVUR",$J,ACHSVNDR,ACHSVPTR,ACHSDOC,DA)=$S(ACHSBLNK=0:$P(^DPT(DFN,0),U),ACHSBLNK=1:"* BLANKET",ACHSBLNK=2:"* SPECIAL TRANS",1:"")_U_ACHS("$")
 G TRANS
 ;
PRINT ; Kill calc vars, print.
 K ACHSBLNK,ACHSDOCN,ACHSFY,ACHSSTS,ACHSTRDT,ACHSTYPE
 ;
 S ACHSVNDR="",(ACHSTOT,ACHSTOT("$"),ACHSPD,ACHSPD("$"))=0,ACHST1=$$C^XBFUNC("VENDOR USAGE REPORT - "_$S(ACHSRPT=2:"OPEN DOCUMENTS ONLY",1:"OPEN AND PAID DOCUMENTS"))
 S ACHST2=$$C^XBFUNC("For the period "_$$FMTE^XLFDT(ACHSBDT)_" through "_$$FMTE^XLFDT(ACHSEDT)),X3=0
 D BRPT^ACHSFU
 X:$D(IO("S")) ACHSPPO
 D HDR
 K ACHSHDR
A ;
 S ACHSVNDR=$O(^TMP("ACHSVUR",$J,ACHSVNDR))
 G ENDPRNT:ACHSVNDR=""
 S ACHSVPTR=0
B ;
 S ACHSVPTR=$O(^TMP("ACHSVUR",$J,ACHSVNDR,ACHSVPTR))
 G A:+ACHSVPTR=0,B:'$D(^AUTTVNDR(ACHSVPTR))
 I ACHSVND="Y",$D(ACHSHDR) D RTRN^ACHS G KILL:$D(DUOUT)!$D(DTOUT) D HDR
 W ACHSVNDR
 S ACHSHDR=""
 I $D(^AUTTVNDR(ACHSVPTR,13)) W ?37,$E($P(^(13),U,2),1,17) S X=$P(^(13),U,3) I X]"",$D(^DIC(5,X,0)) W $S($X>38:", ",1:""),$P(^(0),U,2)
 S ACHSDOC="",(ACHSVDOC,ACHSVDOC("$"))=0
 ;
C ;
 S ACHSDOC=$O(^TMP("ACHSVUR",$J,ACHSVNDR,ACHSVPTR,ACHSDOC)) G F:ACHSDOC="" S DA=$O(^(ACHSDOC,0)),ACHSNAME=$P(^(DA),U),ACHS("$")=$P(^(DA),U,2)
 G C:'$D(^ACHSF(DUZ(2),"D",DA,0)) S ACHSTOS=$P(^(0),U,4),DFN=$P(^(0),U,22)
 I +ACHSTOS>0 S ACHSTOS=$P($P($P($P(^DD(9002080.01,3,0),U,3),";",ACHSTOS),":",2)," ")
 S (Y,ACHSDOS)=""
 I $D(^ACHSF(DUZ(2),"D",DA,3)),+$P(^(3),U)>0 S Y=+$P(^(3),U),ACHSDOS=$E(Y,4,5)_"/"_$E(Y,6,7)_"/"_$E(Y,2,3)
 ;
D ;
 W !?3,ACHSDOC,?16,ACHSNAME,?49,ACHSTOS,?54,ACHSDOS
 ;
 ;start of jeanette's changes
 S ACHSBLNK=$P(^ACHSF(DUZ(2),"D",DA,0),U,3)
 I DFN S INSTYP=$S($D(^AUPNMCR(DFN)):"MCR",$D(^AUPNMCD("B",DFN)):"MCD",$D(^AUPNRRE(DFN)):"RRE",$D(^AUPNPRVT(DFN)):"PRVT",1:"")
 ;
 I 'DFN S INSTYP=""
 ;
 I (INSTYP="PRVT")&('ACHSBLNK) D PRVTST^ACHSVUR1
 I (INSTYP="MCR")&('ACHSBLNK) D MCRTST^ACHSVUR1
 I (INSTYP="MCD")&('ACHSBLNK) D MCDTST^ACHSVUR1
 I (INSTYP="RRE")&('ACHSBLNK) D RRETST^ACHSVUR1
 ;
 ;end of jeanette's changes in this tag
 ;
 ;
 S X=$FN(+ACHS("$"),",",2)
 W ?78-$L(X),X
 I ACHS("$")["*" W "*" S ACHSPD=ACHSPD+1,ACHSPD("$")=ACHSPD("$")+ACHS("$")
 I $Y>ACHSBM D RTRN^ACHS G KILL:$D(DUOUT)!$D(DTOUT) D HDR W:$D(ACHSVNDR) ACHSVNDR," (continued)"
 ;
E ;
 S ACHSVDOC=ACHSVDOC+1,ACHSVDOC("$")=ACHSVDOC("$")+ACHS("$"),ACHSTOT=ACHSTOT+1,ACHSTOT("$")=ACHSTOT("$")+ACHS("$")
 G C
 ;
F ;
 S X2="2$",X3=16,X=ACHSVDOC("$")
 D COMMA^%DTC
 W !?10,$$REPEAT^XLFSTR("-",55),!?10,"TOTALS     DOCUMENTS:",$J(ACHSVDOC,5),?42,"DOLLARS:",X,!,$$REPEAT^XLFSTR("-",79),!
 G B
 ;
ENDPRNT ;
 I ACHSVND="Y" D RTRN^ACHS G KILL:$D(DUOUT)!$D(DTOUT) D HDR
 W !,$$REPEAT^XLFSTR("=",79),!
 S X2="2$",X3=16,X=ACHSPD("$")
 D COMMA^%DTC
 W "TOTAL PAID",?21,"DOCUMENTS:",$J(ACHSPD,5),?42,"DOLLARS:",X,!
 S X=ACHSTOT("$")-ACHSPD("$")
 D COMMA^%DTC
 W "TOTAL OUTSTANDING",?21,"DOCUMENTS:",$J(ACHSTOT-ACHSPD,5),?42,"DOLLARS:",X,!,$$REPEAT^XLFSTR("-",79),!
 S X=ACHSTOT("$")
 D COMMA^%DTC
 W "GRAND TOTALS",?21,"DOCUMENTS:",$J(ACHSTOT,5),?42,"DOLLARS:",X
 D RTRN^ACHS:'$D(IO("S"))
 W @IOF
KILL ; Kill vars, close device, quit.
 X:$D(IO("S")) ACHSPPC
 K DA,DFN,ZTSK,^TMP("ACHSVUR",$J)
 D ERPT^ACHS,EN^XBVK("ACHS"),^ACHSVAR:'$D(ZTQUEUED)
 Q
 ;
HDR ; Paginate.
 S ACHSPG=ACHSPG+1
 W @IOF,!!?19,"***  CONTRACT HEALTH MANAGEMENT SYSTEM  ***",!,ACHSUSR,?71,"Page",$J(ACHSPG,3),!,ACHSLOC,!,ACHST1,!,ACHSTIME,!,ACHST2
 W !!,"VENDOR",?70,"DOLLARS",!?3,"DOCUMENT #   PATIENT NAME",?48,"TYPE    DOS",?64,"INS  (* = PAID)"
 W !,$$REPEAT^XLFSTR("=",79),!
 Q
 ;
H1 ;EP - From HELP^ACHS() via ^DIR.
 ;;@;!
 ;;Enter a '1' if you want to list all documents.
 ;;Enter a '2' if you want only OPEN documents to be listed.
 ;;###
 ;
H2 ;EP - From HELP^ACHS() via ^DIR.
 ;;@;!
 ;;Enter 'Y' to print one vendor per page.
 ;;'N' to print more than one vendor per page.
 ;;@;!!
 ;;###
 ;
