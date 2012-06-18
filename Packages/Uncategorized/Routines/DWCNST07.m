DWCNST07 ;NEW PROGRAM [ 11/13/96  11:18 AM ]
 ;WRITTEN BY DAN WALZ PIMC TO DISPLAY CONSULTS BY DATE AND CLIENT
 ;
 D ^DWSETSCR,^%AUCLS,HEAD,FQ G:$D(XIT) XIT D DTSEL G:Y<0 XIT D PRT
XIT K XIT,IOP,SDT,EDT,DIR
 D KILL^DWSETSCR
 Q
 ;
PRT K IOP
 Q:'$D(FLDS)
 S DIC=1966180,L=0,BY="'.01,8",FR(1)=SDT,FR(2)="A",TO(1)=EDT,TO(2)="ZZZZZZZZZZZZZZZ"
 S DHD="PIMC Consults by DATE and Client    ( **CONFIDENTIAL** )"
 D EN1^DIP
 Q
 ;
HEAD W ?26,HI_"*****************************",!,?26,"*",?54,"*",!,?26,"* PIMC CONSULTATION REQUEST *",!,?26,"*",?54,"*",!,?26,"*",?36,"Client List",?54,"*",!,?26,"*",?54,"*",!,?26,"*****************************"_NO,!!!
 W IV_"Display by DATE and CLIENT."_NO
 Q         
FQ S DIR(0)="S^Q:Quick List;F:Full List",DIR("A")="Select the Type of Report ",DIR("B")="Q",DIR("?")="Select 'Q' for a short report, or 'F' for a full report."
 D ^DIR
 K DIR
 I $D(DTOUT)!($D(DUOUT)) S XIT="" Q
 S FLDS=$S(Y="Q":"[1966180-QUICK-CLIENT-LIST]",1:"[1966180-FULL]")
 Q
DTSEL S %DT="AE",%DT("A")="Enter STARTING consult date: ",%DT("B")="T-7"
 D ^%DT
 I Y<0 S XIT="" Q
 S SDT=+Y
 S %DT="AE",%DT("A")="Enter ENDING consult date: ",%DT("B")="T"
 D ^%DT
 I Y<0 S XIT="" Q
 S EDT=+Y
 I EDT<SDT W $C(7)," ?? - Invalid date pair!" G DTSEL
 Q
