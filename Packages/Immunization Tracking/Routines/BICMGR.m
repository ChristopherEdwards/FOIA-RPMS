BICMGR ;IHS/CMI/MWR - ADD/EDIT CASE MANAGER; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  CALLED BY OPTION: "BI CASE MANAGERS ADD/EDIT" TO ADD OR
 ;;  DEACTIVATE CASE MANAGERS.
 ;
 ;
 ;----------
START ;EP
 ;---> DIE Add/Edit Case Managers.
 D SETVARS^BIUTL5
 N Y
 F  D  Q:$G(Y)<0
 .D TITLE^BIUTL5("ADD/EDIT CASE MANAGERS")
 .D TEXT1
 .D DIC^BIFMAN(9002084.01,"QEMAL",.Y,"   Select CASE MANAGER: ")
 .Q:Y<0
 .D DIE^BIFMAN(9002084.01,.02,+Y,.BIPOP)
 .S:BIPOP Y=-1
 Q
 ;
 ;
 ;----------
TEXT1 ;EP
 ;;This option allows you to add new Case Managers, so that they can
 ;;be selected when editing a patient's Case Data.
 ;;
 ;;You may also add a "DATE INACTIVATED" here for a Case Manager who
 ;;is no longer active in your program.  ANY DATE in a Case Manager's
 ;;Date Inactivated field will prevent that Case Manager from being
 ;;selected when editing a patient's Case Data.
 ;;
 ;;Occasionally, you may want to RE-activate a Case Manager.  You may
 ;;do this by deleting the date in the DATE INACTIVATED field (enter
 ;;@ at the DATE INACTIVATED prompt).
 ;;
 ;;
 D PRINTX("TEXT1")
 Q
 ;
 ;
 ;----------
TRANS ;EP
 ;---> Transfer one Case Manager's patients to another Case Manager.
 ;
 D TITLE^BIUTL5("TRANSFER A CASE MANAGER'S PATIENTS")
 D TEXT2
 D DIC^BIFMAN(9002084.01,"QEMA",.Y,"   Select OLD CASE MANAGER: ")
 Q:Y<0
 S BICMGR=+Y
 D DIC^BIFMAN(9002084.01,"QEMA",.Y,"   Select NEW CASE MANAGER: ")
 Q:Y<0
 S BICMGR1=+Y
 W !!?3,"All patients currently assigned to: ",$$PERSON^BIUTL1(BICMGR)
 W !?3,"will be reassigned to.............: ",$$PERSON^BIUTL1(BICMGR1)
 ;
 W !!?3,"Do you wish to proceed?"
 S DIR("?")="     Enter YES to swap Case Managers."
 S DIR(0)="Y",DIR("A")="   Enter Yes or No"
 D ^DIR W !
 Q:$D(DIRUT)!('Y)
 N BILOCK S BILOCK=0
 S N=0,M=0
 F  S N=$O(^BIP("C",BICMGR,N)) Q:'N  D
 .N BIPOP S BIPOP=0
 .D DIE^BIFMAN(9002084,".1////"_BICMGR1,N,.BIPOP,1)
 .I BIPOP S BILOCK=1 Q
 .S M=M+1
 ;
 W !?3,M," patients transferred from ",$$PERSON^BIUTL1(BICMGR)
 W " to ",$$PERSON^BIUTL1(BICMGR1),"."
 ;---> If some patients were locked, notify user.
 D:BILOCK TEXT3
 D DIRZ^BIUTL3()
 D EXIT
 Q
 ;
 ;
 ;----------
TEXT2 ;EP
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
 D PRINTX("TEXT2")
 Q
 ;
 ;
 ;----------
TEXT3 ;EP
 ;;
 ;;NOTE! One or more patients were being edited by another user during
 ;;      this transfer.   Those patients did not get reassigned.
 ;;      This transfer should be run again later to pick up any
 ;;      remaining patients.
 D PRINTX("TEXT3",3)
 Q
 ;
 ;
 ;----------
PRINTX(BILINL,BITAB) ;EP
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
 ;
 ;
 ;----------
EXIT ;EP
 ;---> End of job cleanup.
 D KILLALL^BIUTL8()
 Q
