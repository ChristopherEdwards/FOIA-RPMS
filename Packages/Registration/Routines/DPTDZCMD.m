DPTDZCMD ; IHS/TUCSON/JCM - Check merge direction ;
 ;;1.0;PATIENT MERGE;;FEB 02, 1994
 ;
 ;this routine is executed after the user selects a merge direction
 ;for the pair of duplicate records.  It is IHS specific.
START ;
 Q:$D(ZTQUEUED)  ;quit if in background
 Q:$D(XDRM("AUTO"))  ;quit if automatic merge is on
 Q:'$D(XDRFL)  ;quit it file variable does not exist
 Q:XDRFL'=2  ;quit if file not VA PATIENT
 S DPTDZCMD("X")=X
 I $G(XDRCD)]"" S DPTDZCMD("TO")=$S(X=2:XDRCD,1:XDRCD2),DPTDZCMD("FROM")=$S(X=2:XDRCD2,1:XDRCD)
 I $G(XDRMCD)]"" S DPTDZCMD("TO")=$S(X=2:XDRMCD,1:XDRMCD2),DPTDZCMD("FROM")=$S(X=2:XDRMCD2,1:XDRMCD)
 S DPTDZCMD("RPMS SITE")=+^AUTTSITE(1,0)
 I '$D(^AUPNPAT(DPTDZCMD("TO"),41,DPTDZCMD("RPMS SITE"))),$D(^AUPNPAT(DPTDZCMD("FROM"),41,DPTDZCMD("RPMS SITE"))) D
 .W !!,$C(7),$C(7),"The FROM patient you have selected has a chart at ",$P(^DIC(4,DPTDZCMD("RPMS SITE"),0),U)
 .W !,"and the TO or TARGET patient does not.  The general rule is that when one",!,"patient has a chart at your site and the other does not, that you merge into",!,"the patient with a chart at your site."
 .S DPTDZCMD("WARNING")=""
 .Q
 I $D(^AUPNPAT(DPTDZCMD("TO"),41,DPTDZCMD("RPMS SITE"),0)),'$E($P(^AUPNPAT(DPTDZCMD("TO"),41,DPTDZCMD("RPMS SITE"),0),U,2)) D
 .W !!,$C(7),$C(7),"The TO or TARGET patient has a Temporary chart number!!","The general rule is to merge FROM a patient with a temporary number.",!
 .S DPTDZCMD("WARNING")=""
 I $D(DPTDZCMD("WARNING")) D CONFIRM
EOJ ;
 K DPTDZCMD
 Q
CONFIRM ;
 W !!,"Are you sure you have selected the correct merge direction (Y/N) N//" R DPTDZCMD("ANS"):DTIME E  S DPTDZCMD("ANS")="N"
 S:DPTDZCMD("ANS")="" DPTDZCMD("ANS")="N"
 I "YyNn"'[$E(DPTDZCMD("ANS")) W "  Please re-enter a Y or N",$C(7) G CONFIRM
 Q:"Yy"[$E(DPTDZCMD("ANS"))
 K X,Y
 Q
