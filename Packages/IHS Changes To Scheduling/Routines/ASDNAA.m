ASDNAA ; IHS/ADC/PDW/ENM - NEXT AVAIL APPT REPORT ; [ 03/25/1999  11:48 AM ]
 ;;5.0;IHS SCHEDULING;;MAR 25, 1999
 ;
 S %ZIS="PQ" D ^%ZIS G END:POP
 I $D(IO("Q")) D  Q
 . S ZTRTN="START^ASDNAA",ZTDESC="NEXT AVAIL APPT"
 . D ^%ZTLOAD K ZTSK,IO("Q") D HOME^%ZIS,END
 ;
START ;EP; called by ztload
 U IO D LOOP,PRINT,END Q
 ;
 ;
LOOP ; -- loop thru clinics for appts
 NEW ASDC,ASDT,ASDS,I,J,ASDCT,X
 K ^TMP("ASDNAA",$J) S ASDC=0
 F  S ASDC=$O(^SC(ASDC)) Q:'ASDC  D
 . Q:'$$ACTV^ASDUT(ASDC)  ;inactive
 . S ASDT=DT-.0001,ASDEND=$$FMADD^XLFDT(DT,13)
 . F  S ASDT=$O(^SC(ASDC,"ST",ASDT)) Q:'ASDT!(ASDT>ASDEND)  D
 .. S ASDS=$G(^SC(ASDC,"ST",ASDT,1)) Q:ASDS=""
 .. Q:ASDS["CANCELLED"
 .. S ASDS=$P(ASDS,"|",2,999)
 .. F I="|","[","]","*"," ","0" S ASDS=$$STRIP^XLFSTR(ASDS,I)
 .. ;
 .. ; -- count up appts left
 .. S ASDCT=0
 .. F I=1:1:9 Q:ASDS=""  D
 ... S X=ASDS F J=1:1 Q:X=""  S:$E(X)=I ASDCT=ASDCT+I S X=$E(X,2,99)
 ... S ASDS=$$STRIP^XLFSTR(ASDS,I)
 .. ;
 .. ; -- sort by prin clinic and date
 .. S ^TMP("ASDNAA",$J,$$PC(ASDC),$$CLA(ASDC),ASDT)=ASDCT
 Q
 ;
PRINT ; -- loop thru ^tmp and print
 NEW ASDPC,ASDC,ASDT
 S ASDPG=0,ASDQ="" D DAYS,HED
 S ASDPC=0
 F  S ASDPC=$O(^TMP("ASDNAA",$J,ASDPC)) Q:ASDPC=""!(ASDQ=U)  D
 . S ASDC=0
 . F  S ASDC=$O(^TMP("ASDNAA",$J,ASDPC,ASDC)) Q:ASDC=""!(ASDQ=U)  D
 .. I $Y>(IOSL-4) D NEWPG Q:ASDQ=U
 .. I ASDPC'=ASDC,$$FIRST W !!,"Principal Clinic: ",ASDPC
 .. I ASDPC=ASDC W !
 .. W !,ASDC,?8,"|"
 .. S ASDT=0 F  S ASDT=$O(ASDAYS(ASDT)) Q:ASDT=""!(ASDQ=U)  D
 ... W $J($G(^TMP("ASDNAA",$J,ASDPC,ASDC,ASDT)),3)," |"
 Q
 ;
END ; -- eoj
 I IOST["C-",$G(ASDQ)'=U D PRTOPT^ASDVAR
 K ASDEND,ASDQ,ASDPG,DIR,ASDAYS K ^TMP("ASDNAA",$J) D ^%ZISC Q
 ;
NEWPG ; -- end of page control
 I IOST'["C-" D HED Q
 K DIR S DIR(0)="E" D ^DIR S ASDQ=X
 I ASDQ'=U D HED
 Q
 ;
HED ; -- heading
 NEW X
 I ASDPG>0!(IOST["C-") W @IOF
 W !!?20,"NUMBER OF APPTS AVAILABLE BY CLINIC AND DATE"
 S ASDPG=ASDPG+1 W ?70,"Page ",ASDPG
 S X=$$FMTE^XLFDT(DT)_" to "_$$FMTE^XLFDT(ASDEND)
 W !?(80-$L(X)/2),X,!
 W !?8,"| " S X=0 F  S X=$O(ASDAYS(X)) Q:X=""  W $E(X,6,7)," | "
 W !,$$REPEAT^XLFSTR("=",80)
 Q
 ;
DAYS ; -- creates array of date range
 NEW X
 K ASDAYS S ASDAYS(DT)="",X=DT
 F  S X=$$FMADD^XLFDT(X,1) Q:X>ASDEND  S ASDAYS(X)=""
 Q
 ;
CLA(C) ; -- returns clinic abbrev
 Q $S($P(^SC(C,0),U,2)]"":$P(^(0),U,2),1:$E($$CLN(C),1,8))
 ;
CLN(C) ; -- returns clinic's name
 Q $P(^SC(C,0),U)
 ;
PC(C) ; -- returns clinic's prin clinic
 NEW X S X=$P($G(^SC(C,"SL")),U,5)
 Q $S(X="":"none",1:$$CLN(X))
 ;
FIRST() ; -- returns 1 if first under prin clinic
 I ASDC=$O(^TMP("ASDNAA",$J,ASDPC,0)) Q 1
 Q 0
