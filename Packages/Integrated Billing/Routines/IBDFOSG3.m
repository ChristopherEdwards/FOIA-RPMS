IBDFOSG3 ;ALB/MAF/AAS - NUMBER OF ENCOUNTERS WITH CPT'S AND DX'S REPORT ;3/18/96
 ;;3.0;AUTOMATED INFO COLLECTION SYS;;APR 24, 1997
 ;
% I '$D(DT) D DT^DICRW
 D END
 W !!,"Number of Encounters with CPT, Diagnosis"
 S VAUTD=1 I $D(^DG(43,1,"GL")) D DIVISION^VAUTOMA G:Y=-1 END
 S IBDFDAT=$$HTE^XLFDT($H)
 ;
DATE ; -- select date
 S (IBBDT,IBDFBEG)=2940401,(IBEDT,IBDFEND)=2960331
 ;
DEV ; -- select device, run option
 S %ZIS="QM" D ^%ZIS G:POP END
 I $D(IO("Q")) S ZTRTN="DQ^IBDFOSG3",ZTSAVE("IB*")="",ZTSAVE("VA*")="",ZTDESC="IBD - Number of Encounters with Stop Codes, CPT, Diagnosis" D ^%ZTLOAD K IO("Q"),ZTSK D HOME^%ZIS G END
 ;
 U IO
 S X=132 X ^%ZOSF("RM")
DQ D PRINT G END
 Q
 ;
END ; -- Clean up
 K ^TMP("MNTH",$J),^TMP("DTOT",$J),^TMP("GTOT",$J) W !
 I $D(ZTQUEUED) S ZTREQ="@" Q
 D ^%ZISC
 K IBBDT,IBCS,IBDDT,IBDDT1,IBDFMN,IBDFMN1,IBDFMNI,IBDFN,IBDIV,IBDIVNM,IBI,IBIFN,IBJ,IBMNTH,IBNODE,IBPARNT,IBPIECE,IBPR,IBPROC,IBSTOP,POP,SDCNT,U
 K IBDFBEG,IBDFDAT,IBDFDIV,IBDFDVE,IBDFEND,IBEDT,IBFLG4,IBHDT,IBQUIT,IBTSBDT,IBTSEDT,SDDXY,X,Y,IBCLIN,IBPAG,VAUTD
 Q
 ;K X,Y,DFN,IBPAG,IBHDT,IBDT,IBBDT,IBEDT,IBQUIT,IBDFDVE
 ;K IBCNT,IBDFBEG,IBDFCLI,IBDFDA,IBDFDAT,IBDFDIV,IBDFEND,IBDFIFN,IBDFNODE,IBDFNUM,IBDFSA,IBDFT,IBDFTMP,IBDFTMP1,IBDFTMP2,IBDFTPRT
 ;K IBFLG1,IBFLG2,IBFLG3,IBFLG4,IBFLG5,IBFLG6,IBFLG7,IBFLG8,IBFLG9,IBMCNODE,IBMCSND,IBNAM,IBTSBDT,IBTSEDT
 ;K VAUTC,VAUTD
 Q
 ;
PRINT ; -- print report
 ;    Data sorted into ^tmp arrays
 ;                    
 ;    Monthly Totals  := ^tmp("mnth",$j,division,year/month)=
 ;    Division Totals := ^tmp("dtot",$j,division)       =
 ;    Grand Totals    := ^tmp("gtot",$j)                =
 ;
 S (IBPAG,IBDFDVE)=0,IBHDT=$$HTE^XLFDT($H,1),IBQUIT=0
 S IBTSBDT=IBBDT-.1,IBTSEDT=IBEDT+.9
 D QUIT
 D START^IBDFOSG4
 ;
PR ;
 I '$D(^TMP("MNTH",$J)) D HDR W !!,"No Data Meeting This Criteria for the Date Range Chosen",! Q
 N IBDFDV,IBDFCL,IBDNODE,IBDFTMP,IBDFPAT,IBDFPT,IBDFT
 S (IBDFDV,IBDFCL,IBDFPT)=0
 F IBDFDIV=0:0 S IBDFDV=$O(^TMP("MNTH",$J,IBDFDV)) Q:IBDFDV']""!(IBQUIT)  D HDR Q:IBQUIT  D
 .D DIVH
 .S IBDFMN=0
 .F IBDFMNI=0:0 S IBDFMN=$O(^TMP("MNTH",$J,IBDFDV,IBDFMN)) Q:IBDFMN=""  D ONEMN I $O(^TMP("MNTH",$J,IBDFDV,IBDFMN))="" S IBDFDVE=1 D ONEDV
 ;
 ;  -- Print Totals Page
 S IBDFDVE=0
 Q:IBQUIT
 D HDR
 S (IBDFDV,IBDFCL,IBDFPT)=0
 S IBFLG4=1 ;1 := on division totals page
 F IBDFDIV=0:0 S IBDFDV=$O(^TMP("DTOT",$J,IBDFDV)) Q:IBDFDV']""!(IBQUIT)  D ONEDV
 Q:IBQUIT
 D DASH
 D LINE("GRAND TOTAL",^TMP("GTOT",$J))
 Q
 ;
ONEMN ; -- Print one months data
 Q:IBQUIT
 N IBDFNM1
 Q:'$D(^TMP("MNTH",$J,IBDFDV,IBDFMN))!(^TMP("MNTH",$J,IBDFDV,IBDFMN)="0^0^0")
 S Y=IBDFMN D DD^%DT S IBDFMN1=Y
 D LINE(IBDFMN1,^TMP("MNTH",$J,IBDFDV,IBDFMN))
 Q
 ;
ONEDV ;  -- Print Division totals
 Q:IBQUIT
 I IOSL<($Y+5) D HDR Q:IBQUIT
 Q:^TMP("DTOT",$J,IBDFDV)="0^0^0"&('$D(IBFLG4))
 I IBDFDVE=1 D DASH S IBDFDVE=0
 D LINE($E(IBDFDV,1,25)_"  ("_$P($$SITE^VASITE(,$O(^DG(40.8,"B",IBDFDV,0))),"^",3)_")",^TMP("DTOT",$J,IBDFDV))
 Q
 ;
LINE(NAME,IBX) ;
 ; -- print detail line
 ;    input Name := text to be printed
 ;          ibx  ;= 3 piece global node containing data
 ;
 I IOSL<($Y+5) D HDR Q:IBQUIT
 W !,$E(NAME,1,35)
 W ?39,$J($P(IBX,"^",2),8)
 W ?57,$J($P(IBX,"^",3),8)
 Q
 ;
HDR ; -- Print header for report
 Q:IBQUIT
 I $E(IOST,1,2)="C-",IBPAG D PAUSE^VALM1 I $D(DIRUT) S IBQUIT=1 Q
 I $E(IOST,1,2)="C-"!(IBPAG) W @IOF
 S IBPAG=IBPAG+1
 W !,"# Encounters / CPT's, Dx",?(IOM-33),"Page ",IBPAG,"  ",IBHDT
 W !,"For Period beginning on ",$$FMTE^XLFDT(IBBDT,2)," to ",$$FMTE^XLFDT(IBEDT,2)
 W !,?44,"CPT",?56,"Diagnosis"
 W !,$TR($J(" ",IOM)," ","-")
 I $D(ZTQUEUED),$$S^%ZTLOAD S ZTSTOP=1,IBQUIT=1 W !!,"....task stopped at user request" Q
 Q
 ;
 ;
QUIT K ^TMP("MNTH",$J),^TMP("DTOT",$J),^TMP("GTOT",$J) W !
 Q
 ;
 ;
DASH W !,"------------------",?39,"--------",?57,"--------"
 Q
 ;
DIVH ;  -- Write division header
 I IOSL<($Y+5) D HDR Q:IBQUIT
 Q:^TMP("DTOT",$J,IBDFDV)="0^0^0"
 W !!,?(IOM-$L(IBDFDV)+10/2),"DIVISION: ",IBDFDV_"  ("_$P($$SITE^VASITE(,$O(^DG(40.8,"B",IBDFDV,0))),"^",3)_")",!
 Q
