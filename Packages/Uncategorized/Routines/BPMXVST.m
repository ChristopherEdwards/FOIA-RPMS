BPMXVST ;IHS/OIT/LJF - REPOINT VISIT FILE POINTERS
 ;;1.0;IHS PATIENT MERGE;;MAR 01, 2010
 ;
DESC ;---- ROUTINE DESCRIPTION
 ;;
 ;;BPMXVST:
 ;;This routine loops through the Visit file looking for DELETED visits
 ;;belonging to the "FROM" patient, which it then repoints to the "TO"
 ;;patient.
 ;;
 ;;Only called if REPOINT DELETED VISITS parameter is turned ON
 ;;
 ;;This routine is called by the special merge routine driver - BPMXDRV
 ;;$$END
 ;
 N I,X F I=1:1 S X=$P($T(DESC+I),";;",2) Q:X["$$END"  W !,X
 Q
EN(BPMRY) ;EP; entry point from ^BPMXDRV
 ;      BPMRY  =  TEMP GLOBAL SET UP BY THE PATIENT MERGE SOFTWARE, 
 ;                 I.E., "^TMP(""XDFROM"",$J)"
 ;
 NEW BPMFR,BPMGFR,BPMGTO,BPMTO,FILE,GLOB
 ;
 S BPMFR=$O(@BPMRY@(0)) Q:'BPMFR
 S BPMTO=$O(@BPMRY@(BPMFR,0)) Q:'BPMTO
 S BPMGFR=$O(@BPMRY@(BPMFR,BPMTO,0)) Q:'+BPMGFR
 S BPMGTO=$O(@BPMRY@(BPMFR,BPMTO,BPMGFR,0)) Q:'+BPMGTO
 S GLOB="^TMP(""XDRFROM"""_","_$J_","_BPMFR_","_BPMTO_","_""""_BPMGFR_""""_","_""""_BPMGTO_""""_")"
 S FILE=@GLOB
 ;
 D REPOINT(BPMFR,BPMTO)
 Q
 ;
REPOINT(BPMFR,BPMTO) ; loop through visit file and change pointer
 NEW BPMD0
 S BPMD0=0
 F  S BPMD0=$O(^AUPNVSIT(BPMD0)) Q:'BPMD0  D
 . Q:$P($G(^AUPNVSIT(BPMD0,0)),U,5)'=BPMFR
 . Q:$P(^AUPNVSIT(BPMD0,0),U,11)'=1            ;skip if not a deleted visit
 . S $P(^AUPNVSIT(BPMD0,0),U,5)=BPMTO          ;stuff TO patient pointer
 Q
