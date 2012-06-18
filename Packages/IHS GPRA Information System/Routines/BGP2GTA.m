BGP2GTA ; IHS/CMI/LAB - BGPG Gui CRS Tables 2/2/2005 10:24:22 AM ;
 ;;12.0;IHS CLINICAL REPORTING;;JAN 9, 2012;Build 51
 ;
 ;
 ;
DIV(RETVAL) ;-- return all medical center divisions
 S X="MERR^BGP2GU",@^%ZOSF("TRAP") ; m error trap
 N BGPGI,BGPGDA
 S RETVAL="^BGPGTMP("_$J_")"
 S BGPGI=0
 S ^BGPGTMP($J,BGPGI)="T00050DIVISIONS"_$C(30)
 S BGPGDA=0 F  S BGPGDA=$O(^DG(40.8,"B",BGPGDA)) Q:BGPGDA=""  D
 . S BGPGI=BGPGI+1
 . S ^BGPGTMP($J,BGPGI)=BGPGDA_$C(30)
 S ^BGPGTMP($J,BGPGI+1)=$C(31)
 Q
 ;
GIALLC(RETVAL) ;-- get all GPRA measures for comm report
 S X="MERR^BGP2GU",@^%ZOSF("TRAP") ; m error trap
 N BGPI,X,Y,Z
 K ^BGPTMP($J)
 S RETVAL="^BGPTMP("_$J_")"
 S BGPI=0
 S ^BGPTMP($J,BGPI)="T00007BMXIEN^T00050Measure"_$C(30)
 S X=0 F  S X=$O(^BGPINDW("AOI",X)) Q:X'=+X  D
 . S Y=0 F  S Y=$O(^BGPINDW("AOI",X,Y)) Q:Y'=+Y  D
 .. Q:$P($G(^BGPINDW(Y,13)),U,1)=1
 .. ;Q:$P(^BGPINDW(Y,0),U,7)'=1
 .. S BGPI=BGPI+1
 .. S ^BGPTMP($J,BGPI)=Y_U_$P($G(^BGPINDW(Y,0)),U,3)_$C(30)
 S ^BGPTMP($J,BGPI+1)=$C(31)_$G(BGPERR)
 Q
 ;
