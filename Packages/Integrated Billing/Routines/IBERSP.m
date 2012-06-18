IBERSP	;ALB/ARH - CREATE/PRINT CHECK-OFF SHEET CPT LIST ; 11/5/91
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;request ambulatory surgery check-off sheet by group ie. not for an appointment
	;***
	;S XRTL=$ZU(0),XRTN="IBERSP-1" D T0^%ZOSV ;start rt clock
	D HOME^%ZIS W @IOF,!!,?20,"Print Clinic Check-Off Sheet",!!!
SLT	S DIC="^IBE(350.7,",DIC(0)="AEQ" D ^DIC K DIC I Y>0 S IBG(+Y)="" G SLT
	G:'$D(IBG) END
	W !!,"This report requires a 132 column printer." S %ZIS="QM" D ^%ZIS G:POP END
	I $D(IO("Q")) S ZTRTN="RQT^IBERSP",ZTSAVE("IBG(")="",ZTDESC="A.S. Check-Off Sheets" D ^%ZTLOAD K IO("Q") D HOME^%ZIS G END
	U IO
	;***
	;I $D(XRT0) S:'$D(XRTN) XRTN="IBERSP" D T1^%ZOSV ;stop rt clock
	D RQT
END	;
	;***
	;I $D(XRT0) S:'$D(XRTN) XRTN="IBERSP" D T1^%ZOSV ;stop rt clock
	I $D(ZTQUEUED) S ZTREQ="@" Q
	K DTOUT,DUOUT,IBG,X,Y D ^%ZISC
	Q
	;(possible) external entry pt.
	;print requested check-off sheets for groups in IBG (without patient data, with box)
RQT	;
	;***
	;S XRTL=$ZU(0),XRTN="IBERSP-2" D T0^%ZOSV ;start rt clock
	S IBGRP="" F  S IBGRP=$O(IBG(IBGRP)) Q:IBGRP=""  D CPT(IBGRP,"",0,DT,1) W @IOF Q:$$STOP^IBERS1
	K IBG,IBGRP,^TMP("IBRSC",$J)
	;***
	;I $D(XRT0) S:'$D(XRTN) XRTN="IBERSP" D T1^%ZOSV ;stop rt clock
	G END
	;
	;external entry point
CPT(GRP,DIV,TOF,ADT,BOX)	;prints the CPT list for particular group
	;print device must be defined, opened and the paper set on the line that printing is to begin on
	;does not close the device when done or set printer to TOF
	;Inputs:  GRP = the IFN (350.7) of the group to be printed
	;         DIV = division of clinic, needed for charge calculation
	;          DT = date of appointment, needed for charge calculation (DT if "")
	;         TOF = top of form, the line number at which to begin printing
	;         BOX = true if a card box should be printed in upper left corner
	;first creates a temp file in sequential format, then prints that file in column format
	;whoever calls this must delete ^TMP("IBRSC") themselves after they have printed all lists,
	;it is not killed here to speed up CPT lists by already having them partially formated for reuse
	D:'$D(^TMP("IBRSC",$J,GRP)) CREATE^IBERSP1 Q:'$D(^TMP("IBRSC",$J,GRP))
	I BOX D:'$D(^TMP("IBRSC",$J,"B")) BOX^IBERSP1 D PRNTBX
	D PRINT
	Q
	;
PRINT	;reformats list into multiple columns for specific TOF then prints it out
	N CAT,COL,PG,GCOL,HDR,LN,CW,MAXLN,MINLN,LINE,CONT,CHDR,SL,I,J,X,Y,N
	Q:'$D(^TMP("IBRSC",$J,+GRP))
	S SL=IOSL,CAT=0,(MAXLN,LN,MINLN,COL)=1,PG=$S(BOX:1,1:0),GCOL=^TMP("IBRSC",$J,GRP),HDR=^TMP("IBRSC",$J,GRP,0)
	S HDR="CPT Codes for "_HDR,HDR=$J(HDR,IOM/2+($L(HDR)\2)) D:'BOX HDR
	F I=1:1 S CAT=$O(^TMP("IBRSC",$J,GRP,CAT)) Q:CAT=""  D
	. S CONT=0 F  Q:SL'<(LN+TOF+3)  D NEWCOL
	. S CHDR=^TMP("IBRSC",$J,GRP,CAT,0),CW=$L(CHDR),N=0 F X="",CHDR D PL
	. F J=1:1 S N=$O(^TMP("IBRSC",$J,GRP,CAT,N)) Q:N=""  D
	.. S LINE=^(N) F  Q:SL>(LN+TOF)  S CONT=1 D NEWCOL
	.. S X=LINE D PL
	D P1 K ^TMP("IBRSC",$J,"F")
	Q
	;
PL	;sets each formated line into temp file, X is added to the end of the current line,
	;then the line is padded with spaces to the end of the column (plus # IC spaces)
	S Y=$G(^TMP("IBRSC",$J,"F",PG,LN)),Y=Y_$J("",((CW*(COL-1))-$L(Y)))
	S ^TMP("IBRSC",$J,"F",PG,LN)=Y_X,LN=LN+1 S:LN>MAXLN MAXLN=LN
	Q
	;
NEWCOL	;go to next column, or next page
	S COL=COL+1 D:COL>GCOL HDR S LN=MINLN I CONT F X="",CHDR D PL
	Q
	;
HDR	;set GROUP header into the temp file
	S LN=1,PG=PG+1 I COL>GCOL S TOF=0
	S Y=HDR,^TMP("IBRSC",$J,"F",PG,LN)=Y,LN=LN+1,COL=1,MINLN=LN
	Q
	;
P1	;print each line of finally formated temp file
	S X="" F I=1:1 S X=$O(^TMP("IBRSC",$J,"F",X)) Q:X'?1N.N  W:X>1 @IOF S Y="" F J=1:1 S Y=$O(^TMP("IBRSC",$J,"F",X,Y)) Q:Y=""  W !,^TMP("IBRSC",$J,"F",X,Y)
	Q
	;
PRNTBX	;print a box in upper left corner and title
	N HDR,CTR,IBLG,I5,I6,X,I
	S HDR=^TMP("IBRSC",$J,GRP,0),CTR=$G(^TMP("IBRSC",$J,"B")),IBLG=$S(($L(HDR)+30)>CTR:1,1:0),CTR=CTR\2
	S I6=$S(IBLG:$J(HDR,CTR+($L(HDR)\2)),1:"")
	S I5=$S(IBLG:$J("CPT Codes for ",(CTR+7)),1:$J("CPT Codes for "_HDR,CTR+7+($L(HDR)\2)))
	S X="" F I=1:1 S X=$O(^TMP("IBRSC",$J,"B",X)) Q:X=""  W !,^TMP("IBRSC",$J,"B",X)_$S($D(@("I"_I)):@("I"_I),1:"")
	S TOF=(TOF+I+1)
	Q
