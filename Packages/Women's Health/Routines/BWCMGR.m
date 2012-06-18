BWCMGR ;IHS/ANMC/MWR - ADD/EDIT CASE MANAGER;15-Feb-2003 21:50;PLS
 ;;2.0;WOMEN'S HEALTH;**8**;MAY 16, 1996
 ;;* MICHAEL REMILLARD, DDS * ALASKA NATIVE MEDICAL CENTER *
 ;;  CALLED BY OPTION: "BW ADD/EDIT CASE MANAGERS" TO ADD AND EDIT
 ;;  CASE MANAGERS.
 ;
 ;---> DIE ADD/EDIT CASE MANAGERS LOOP.
 D SETVARS^BWUTL5
 N Y
 F  D  Q:$G(Y)<0
 .D TITLE^BWUTL5("ADD/EDIT CASE MANAGERS")
 .D DIC^BWFMAN(9002086.01,"QEMAL",.Y,"   Select CASE MANAGER: ")
 .Q:Y<0
 .D DIE^BWFMAN(9002086.01,.02,+Y,.BWPOP)
 .S:BWPOP Y=-1
 ;
EXIT ;EP
 D KILLALL^BWUTL8
 Q
 ;
TRANS ;EP
 ;---> TRANSFER ONE CASE MANAGER'S PATIENTS TO ANOTHER CASE MANAGER.
 ;
 D TRANS1
 D EXIT
 Q
 ;
TRANS1 ;EP
 D TITLE^BWUTL5("TRANSFER A CASE MANAGER'S PATIENTS")
 D TEXT1
 D DIC^BWFMAN(9002086.01,"QEMA",.Y,"   Select OLD CASE MANAGER: ")
 Q:Y<0
 S BWCMGR=+Y
 D DIC^BWFMAN(9002086.01,"QEMA",.Y,"   Select NEW CASE MANAGER: ")
 Q:Y<0
 S BWCMGR1=+Y
 W !!?3,"All patients currently assigned to: ",$$PERSON^BWUTL1(BWCMGR)
 W !?3,"will be reassigned to.............: ",$$PERSON^BWUTL1(BWCMGR1)
 ;
 ;---> YES/NO
 W !!?3,"Do you wish to proceed?"
 S DIR("?")="     Enter YES to swap Case Managers."
 S DIR(0)="Y",DIR("A")="   Enter Yes or No"
 D ^DIR W !
 Q:$D(DIRUT)!('Y)
 S N=0,M=0
 F  S N=$O(^BWP("C",BWCMGR,N)) Q:'N  D
 .D DIE^BWFMAN(9002086,".1////"_BWCMGR1,N,.BWPOP)
 .Q:BWPOP  S M=M+1
 W !?3,M," patients transferred from ",$$PERSON^BWUTL1(BWCMGR)
 W " to ",$$PERSON^BWUTL1(BWCMGR1),"."  D DIRZ^BWUTL3
 Q
 ;
TEXT1 ;EP
 ;;The purpose of this utility is to aid in the transfer of all of one
 ;;Case Manager's patients to another Case Manager, such as when there
 ;;is a turnover in staff.  The program will ask you for an "OLD" Case
 ;;Manager and then for a "NEW" Case Manager.  All patients who were
 ;;previously assigned to the "OLD" Case Manager will be reassigned to
 ;;the "NEW" Case Manager.
 ;;
 ;;If the "NEW" Case Manager you are looking for cannot be selected,
 ;;that person must first be added to the file of Case Managers by
 ;;using the "Add/Edit Case Managers" option.
 ;;
 S BWTAB=5,BWLINL="TEXT1" D PRINTX
 Q
 ;
PRINTX ;EP
 N I,T,X S T="" F I=1:1:BWTAB S T=T_" "
 F I=1:1 S X=$T(@BWLINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
