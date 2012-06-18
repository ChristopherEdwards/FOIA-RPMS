AUTVDUP ; IHS/DIR/JDM/DFM - SEARCH FOR DUP EIN NUMBERS IN VENDOR FILE ; [ 06/28/1999  2:24 PM ]
 ;;98.1;IHS DICTIONARIES (POINTERS);**2**;MAR 04, 1998
 ; IHS/ASDST/GTH AUT*98.1*2 - Y2K Fix, display 4-digit year.
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." Q
 D HOME^%ZIS,DT^DICRW
 W !!,$$CTR("This report will generate a list of VENDORS whose",80),!,$$CTR("file contains either a DUPLICATE or MISSING EIN.",80)
DEVICE ;Device Selection
 W *7,!!,$$CTR("Since this report may take awhile to compile",80),!,$$CTR("it is recommended that you QUEUE to a PRINTER.",80)
 K DIR S %ZIS="PQ" W ! D ^%ZIS I POP W !,"NO DEVICE SELECTED - REQUEST ABORTED" S DIR(0)="E" D ^DIR S IOP=$I D ^%ZIS G END:Y=0,DEVICE:Y=1
 I '$D(IO("Q")) G CALC
 ;
 S ZTRTN="CALC^AUTVDUP",ZTDESC="DUPLICATE EIN REPORT"
 D ^%ZTLOAD K IO("Q"),ZTSK D HOME^%ZIS
END ; 
 K DIR,DTOUT,DIROUT,DUOUT,DIRUT,C,I,^TMP($J)
 D ^%ZISC S:$D(ZTQUEUED) ZTREQ="@"
 Q
CALC ;EP - From TaskMan 
 NEW AUTBAD,AUTDAT,AUTEIN,AUTPAGE,AUTSKIP,AUTTIM,AUTVNDR
 I '$D(ZTQUEUED),'$D(IO("S")) U IO(0) D WAIT^DICD U IO
 K ^TMP($J),E,V ; E is EIN, V is IEN
 S V=0
 F  S V=$O(^AUTTVNDR(V)) Q:'V  I $D(^AUTTVNDR(V,11)) S ^TMP($J,"DUP",$S($P(^AUTTVNDR(V,11),U):$P(^AUTTVNDR(V,11),U)_$P(^AUTTVNDR(V,11),U,2),1:"NOT ON FILE"),V)=""
 I '$D(^TMP($J,"DUP")) G PRINT
 S E=0
CHECK1 ; Check EIN.
 S E=$O(^TMP($J,"DUP",E))
 I E="" K E,V,^TMP($J,"DUP") G PRINT
 S V=""
VNDR ; Check vendor(s) with this EIN.
 S V=$O(^TMP($J,"DUP",E,V))
 G:V="" CHECK1
 I '$O(^TMP($J,"DUP",E,V)),'$D(^TMP($J,E)) K ^TMP($J,"DUP",E) G VNDR
 S ^TMP($J,E,V)=$S($D(^AUTTVNDR(V,0)):$P(^(0),U),1:"UNKNOWN")
 G VNDR
PRINT ; 
 S (AUTEIN,AUTPAGE,AUTSKIP)=0
 D NOW^%DTC,YX^%DTC S AUTDAT=$P(Y,"@",1),AUTTIM=$P(Y,"@",2)
 D HEADER,HDR S C=0
 I '$D(^TMP($J)) G END
P1 S AUTEIN=$O(^TMP($J,AUTEIN))
 G TOTL:'AUTEIN S AUTVNDR=""
 I AUTSKIP'=AUTEIN W !
P2 S AUTVNDR=$O(^TMP($J,AUTEIN,AUTVNDR))
 G:AUTVNDR="" P1
 W !,?12,AUTEIN,?30,$E($P(^TMP($J,AUTEIN,AUTVNDR),U),1,30) S C=C+1
 D LSTUSED(AUTVNDR)
 I IOST["P-"&($Y>(IOSL-10)) D HEADER,HDR
 I IOST["C-",'$D(IO("S"))&($Y>(IOSL-4)) K DIR S DIR(0)="E" W !! D ^DIR Q:Y=0  D HEADER,HDR
 S AUTSKIP=AUTEIN
 G P2
TOTL W !!,?1,"TOTAL",?30,C
 I IOST["C-",'$D(IO("S")) K DIR S DIR(0)="E" W !! D ^DIR Q:Y=0
BADEIN ; Print list of Vendors with no EIN on file
 S AUTPAGE=0
 D BADHEAD
 I '$D(^TMP($J,"NOT ON FILE")) W !!,"Good for YOU!! All VENDORS in your file have EIN's!" G END
 S %=0 F  S %=$O(^TMP($J,"NOT ON FILE",%)) Q:'$D(^AUTTVNDR(%))  S ^TMP($J,"NOT ON FILE",$P(^AUTTVNDR(%,0),U))="" K ^TMP($J,"NOT ON FILE",%)
 W !! S AUTBAD="",C=0
BAD1 S AUTBAD=$O(^TMP($J,"NOT ON FILE",AUTBAD))
 G BADTOTL:AUTBAD=""
 W !,?12,AUTBAD S C=C+1
 I IOST["P-"&($Y>(IOSL-10)) D BADHEAD
 I IOST["C-",'$D(IO("S"))&($Y>(IOSL-4)) K DIR S DIR(0)="E" W !! D ^DIR Q:Y=0  D BADHEAD
 G BAD1
BADTOTL ; 
 W !!,?1,"TOTAL",?12,C
 I IOST["C-",'$D(IO("S")) K DIR S DIR(0)="E" W !! D ^DIR Q:Y=0
 W @IOF
 G END
HEADER ;Prints heading
 S AUTPAGE=AUTPAGE+1
 W @IOF,!,"*",AUTDAT,$$CTR($$LOC,(80-(2*$X))),?80-$L(AUTTIM_"*"),AUTTIM,"*",!,"*User: ",$$USR,$$CTR("DUPLICATE VENDOR EIN - Page "_AUTPAGE,(80-(2*$X))),?80-$L("Device:"_IO_"*"),"Device:",IO,"*",!,$$DUP("*",80)
 Q
HDR ;
 W !!?12,"VENDOR EIN",?30,"VENDOR NAME",?66,"LAST USED CHS",!,$$DUP("~",80),!
 Q
 ;
BADHEAD ; Prints heading of missing EIN's
 D HEADER
 W !!,$$CTR("The following do(es) not have an EIN entry in the VENDOR FILE.",80),!,$$CTR("PLEASE validate and correct.",80),!,$$DUP("~",80),!
 Q
 ;
LSTUSED(V) ; Checks last used date in ^ACHSF(,"VB"
 NEW D,I,L ; I = IEN, L = Location, V = Vendor ien
 S L=0
 ; begin IHS/ASDST/GTH AUT*98.1*2 - Y2K Fix, display 4-digit year.
 ; F  S L=$O(^ACHSF(L)) Q:'L  S I=0 F  S I=$O(^ACHSF(L,"VB",V,I)) Q:'I  S D=I
 ; Q:'$D(D)
 ; S %=$P($G(^ACHSF(I,"D",D,0)),U,2)
 ; W ?65,$E(%,4,5),"-",$E(%,6,7),"-",$E(%,2,3)
 ;
 F  Q:'$O(^ACHSF(L))  S L=$O(^ACHSF(L))  S I=0 F  S I=$O(^ACHSF(L,"VB",V,I)) Q:'I  S D(L)=I
 Q:'$D(D)
 S %=0
 F  S %=$O(D(%)) Q:'%  S D(%)=$P($G(^ACHSF(%,"D",D(%),0)),U,2)
 S (%,D)=0
 F  S %=$O(D(%)) Q:'%  I D(%)>D S D=D(%)
 W ?66,$$FMTE^XLFDT(D,5)
 ; end IHS/ASDST/GTH AUT*98.1*2 - Y2K Fix, display 4-digit year.
 ;
 Q
 ;
LOC() Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
USR() Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
CTR(X,Y) ; Center X in field of length Y.       
 S %=$S($D(Y):Y,$D(IOM):IOM,1:80)
 Q $J("",%-$L(X)\2)_X
DUP(X,Y) ; Duplicate X for Y times.
 S %="",$P(%,X,Y+1)=""
 Q %
