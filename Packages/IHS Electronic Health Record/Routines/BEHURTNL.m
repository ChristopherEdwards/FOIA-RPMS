BEHURTNL ;MSC/IND/DKM - List routine version information ;04-May-2006 08:19;DKM
 ;;1.2;BEH UTILITIES;;Mar 20, 2007
 ;=================================================================
ALL ;EP - Show version info for selected routines
 W !!,"Show version info for selected routines.",!!
 D DOIT(-1)
 Q
SINCE ;EP - Show version info for routines modified after a specified date
 W !!,"Show version info for routines changed since a given date/time.",!!
 D DOIT()
 Q
DOIT(DAT) ;
 N UCI,NUM,X,Y,Z
 X ^%ZOSF("UCI")
 S UCI=Y,NUM=$$BLDLST(.DAT)
 Q:'NUM
 D ^%ZIS
 Q:POP
 U IO
 W !!,$$SNGPLR^CIAU(NUM,"routine"),$S(DAT>0:" changed since "_$$ENTRY^CIAUDT(DAT),1:"")," on [",UCI,"] ",$$ENTRY^CIAUDT,!!
 S X=$C(1)
 F  S X=$O(^TMP("BEHURTNL",$J,X)) Q:'$L(X)  D
 .S Z=^TMP("BEHURTNL",$J,X)
 .S $P(Z,U)=$$ENTRY^CIAUDT(+Z),$P(Z,U,4)=$TR($P(Z,U,4),"*")
 .W !,X
 .F Y=1,2,4,3 W ?($P("10^30^50^1",U,Y)-1)," ",$P(Z,U,Y)
 K ^TMP("BEHURTNL",$J)
 R:$E(IOST,1,2)="C-" !!,"Press ENTER to continue...",X:DTIME,!
 D ^%ZISC
 Q
BLDLST(DATE) ;EP - Build the list of routines
 N RTN,LP,Y,Z,CNT
 K ^TMP("BEHURTNL",$J)
 I '$G(DATE) D  Q:DATE'>0 0
 .N %DT
 .S %DT="AEPTS"
 .D ^%DT
 .S DATE=Y
 W !!
 S Y=$$GETCH^CIAU("Select by (B)UILD or (R)OUTINE: ","BR",,,,"R")
 Q:"BR"'[Y 0
 W !!
 I Y'="B" D
 .X ^%ZOSF("RSEL")
 .M ^TMP("BEHURTNL",$J)=^UTILITY($J)
 .K ^UTILITY($J)
 E  F LP=1:1 D  Q:Y'>0
 .N DIC
 .S DIC=9.6,DIC(0)="AET",DIC("A")="Select Build #"_LP_": "
 .D ^DIC
 .S Y=+Y
 .D:Y>0 BUILD(Y)
 S CNT=0,RTN=$C(1)
 F  S RTN=$O(^TMP("BEHURTNL",$J,RTN)) Q:'$L(RTN)  D
 .S Y=$$TRIM^XLFSTR($TR($P($T(+1^@RTN),";",3),"[]"))
 .S Z=$P(Y," "),Y=$TR($P(Y," ",2,99)," ")
 .S Y=Z_$S($L(Y):"@"_Y,1:"")
 .S Z=$$DT^CIAU(Y,"PTS")
 .;S:Z'>0 Z=$$HTFM^XLFDT($G(^ROUTINE(RTN,0)))
 .S:Z<0 Z=0
 .I Z<DATE K ^TMP("BEHURTNL",$J,RTN)
 .E  S CNT=CNT+1,^TMP("BEHURTNL",$J,RTN)=Z_U_$TR($P($T(+2^@RTN),";;",2,999),";",U)
 Q CNT
 ; Extract routine names from build
BUILD(BLD) ;
 N X
 S:BLD'=+BLD BLD=+$$FIND1^DIC(9.6,,"X",BLD)
 Q:BLD'>0
 M ^TMP("BEHURTNL",$J)=^XPD(9.6,BLD,"KRN",9.8,"NM","B")
 S X=0
 F  S X=$O(^XPD(9.6,BLD,10,X)) Q:'X  D BUILD($P($G(^(X,0)),U))
 Q
