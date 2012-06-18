BWMGRP ;IHS/ANMC/MWR - MANAGER'S PATIENT EDITS ;15-Feb-2003 22:02;PLS
 ;;2.0;WOMEN'S HEALTH;**8**;MAY 16, 1996
 ;;* MICHAEL REMILLARD, DDS * ALASKA NATIVE MEDICAL CENTER *
 ;;  CALLED BY DIFFERENT OPTIONS TO EDIT A PATIENT'S PAP REGIMEN LOG
 ;;  AND PREGNANCY LOG.
 ;
PLOG ;EP
 ;---> CALLED BY OPTION: "BW EDIT PAP REGIMEN LOG".
 D SETVARS^BWUTL5
 N DR,Y
 F  D  Q:$G(Y)<0
 .D TITLE^BWUTL5("EDIT PAP REGIMEN LOG")
 .D PLOGTX W !
 .S A="   Select PATIENT (or Enter a new BEGIN DATE): "
 .D DIC^BWFMAN(9002086.04,"QEMAL",.Y,A)
 .Q:Y<0
 .D NAME("^BWPLOG(",+Y)
 .S DR=".01;.03;.05///NOW;.06////"_DUZ
 .D DIE^BWFMAN(9002086.04,DR,+Y,.BWPOP),DIRZ^BWUTL3
 .S:BWPOP Y=-1
 D EXIT
 Q
 ;
PLOGTX ;EP
 ;;WARNING: If you edit the "BEGIN DATE:" of an entry in the PAP REGIMEN
 ;;         Log, be SURE that another entry with the same "BEGIN DATE:"
 ;;         does not already exist for this patient.
 ;;
 ;;         (Ordinarily, the program checks this and will not allow
 ;;         two separate entries for the same patient on the same
 ;;         "BEGIN DATE:".  But under this option you, as the Manager,
 ;;         have greater edit capability.)
 S BWTAB=5,BWLINL="PLOGTX" D PRINTX
 Q
 ;
 ;
EDC ;EP
 ;---> CALLED BY OPTION: "BW EDIT PREGNANCY LOG".
 D SETVARS^BWUTL5
 N DR,Y
 F  D  Q:$G(Y)<0
 .D TITLE^BWUTL5("EDIT PREGNANCY LOG")
 .S A="   Select PATIENT (or Enter a new DATE): "
 .D DIC^BWFMAN(9002086.05,"QEMAL",.Y,A)
 .Q:Y<0
 .D NAME("^BWEDC(",+Y)
 .S DR=".01;.03;.04;.05///NOW;.06////"_DUZ
 .D DIE^BWFMAN(9002086.05,DR,+Y,.BWPOP)
 .S:BWPOP Y=-1
 D EXIT
 Q
 ;
EXIT ;EP
 W @IOF
 D KILLALL^BWUTL8
 Q
 ;
PRINTX ;EP
 ;---> PRINTS TEXT.
 N I,T,X S T="" F I=1:1:BWTAB S T=T_" "
 F I=1:1 S X=$T(@BWLINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
 ;
NAME(DIC,Y) ;EP
 N BWDFN
 S BWDFN=$P(@(DIC_Y_",0)"),U,2)
 W !!?3,$$NAME^BWUTL1(BWDFN),"   ",$$HRCN^BWUTL1(BWDFN),!
 Q
 ;
 ;
NONE ;EP
 S BWTITLE="* There are no PAP Regimen Log entries for this patient. *"
 D CENTERT^BWUTL5(.BWTITLE)
 W !!!!,BWTITLE,!!
 D DIRZ^BWUTL3
 Q
