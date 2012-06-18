BHSWPROF ;IHS/CIA/MGH - Lookup and display of women's health profile ;17-Mar-2006 10:36;MGH
 ;;1.0;HEALTH SUMMARY COMPONENTS;;March 17, 2006
 ;==================================================================
 ;;Routine is a re-write of the IHS routine to display the women's
 ;health profile in a VA health summar format
 ;;* MICHAEL REMILLARD, DDS * ALASKA NATIVE MEDICAL CENTER *
 ;;  CALL ED BY OPTION: "BW PATIENT PROFILE" TO DISPLAY PROFILE.
 ;;  PATCHED AT LINELABEL PROFCALL.  IHS/ANMC/MWR 11/20/96
 ;
EP(BWDFN,BWD,BWEXT) ;PEP called without user interaction to display profile
 ;IHS/CMI/LAB - patch 6 added this subroutine this is
 ;called from the health summary.
 ;---> PATCHED: EARLIER METHODS FOR OTHER PACKAGES TO PRODUCE A
 ;---> WOMEN'S HEALTH PROFILE WERE TO CUMBERSOME AND ERROR PRONE.
 ;---> USED TO CALL A PATIENT PROFILE (DISPLAY ONLY) WITH PATIENT
 ;---> ALREADY SELECTED.  DFN PASSED AS FIRST PARAMETER.
 N BWERRORS,BWUSER
 N BWNAME,BWNAMAGE,BWCHRT,BWCMGR,BWCNEED,BWPAPRG,BWBNEED,BWEDC,BWERRORS
 Q:'$G(BWDFN)
 Q:$G(BWD)=""  ;did not pass brief/detailed
 Q:'$D(^BWP(BWDFN,0))
EP1 ;
 S BWERRORS=1
 D SORT^BWPROF2
 D COPYGBL
 Q
HEADER ;Put the header data into ^TMP("BHS",$J,1,COUNT)
 N FIRST
 S ^TMP("BHS",$J,1,1)=$$PNLAB^BWUTL5(DUZ(2))_"   "_BWCHRT
 S FIRST="Case Manager: "_BWCMGR
 S ^TMP("BHS",$J,1,2)=FIRST_"^Facility: "_$E($$INSTTX^BWUTL6(DUZ(2)),1,19)
 S FIRST="Cx Tx Need  : "_BWCNEED
 S ^TMP("BHS",$J,1,3)=FIRST_"^Inact Date: "_$$SLDT2^BWUTL5($$INACT^BWUTL1(BWDFN))
 S FIRST="PAP Regimen : "_BWPAPRG
 N X
 S X=$P(^BWP(BWDFN,0),U,29)
 S ^TMP("BHS",$J,1,4)=FIRST_"^Income Elig: "_$S(X=1:"YES",X=2:"NO",X=3:"REFUSED",1:"NOT DETERMINED")
 S FIRST="Br Tx Need  : "_BWBNEED
 N X
 S X=$P(^BWP(BWDFN,0),U,30)
 S ^TMP("BHS",$J,1,5)=FIRST_"^Income Date: "_$$SLDT2^BWUTL5(X)
 Q
EXIT ;EP
 D KILLALL^BWUTL8
 Q
COPYGBL ;EP
 ;---> COPY ^TMP("BW",$J,1 TO ^TMP("BHS",$J,2 TO MAKE IT FLAT.
 N I,M,N,P,Q,COUNT
 ;Enter the patient array first
 D HEADER
 S N=0,I=0
 F  S N=$O(^TMP("BW",$J,1,N)) Q:N=""  D
 .S M=0
 .F  S M=$O(^TMP("BW",$J,1,N,M)) Q:M=""  D
 ..S P=0
 ..F  S P=$O(^TMP("BW",$J,1,N,M,P)) Q:P=""  D
 ...S Q=0
 ...F  S Q=$O(^TMP("BW",$J,1,N,M,P,Q)) Q:Q=""  D
 ....S I=I+1,^TMP("BHS",$J,2,I)=^TMP("BW",$J,1,N,M,P,Q)
 Q
