BIREPQ5 ;IHS/CMI/MWR - REPORT, QTR IMM LIST REJECTS;MAY 30,2007
 ;;8.2;IMMUNIZATION;;SEP 11,2007
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  QUARTERLY IMM REPORT, VIEW PATIENTS: REJECTED, APPROPRIATE, OR ALL.
 ;
 ;---> Called by ProtocolS BI REPORT QTR PATIENTS REJECTED, APPRO, ALL.
 ;---> on the Protocol Menu BI MENU REPORT QTR VIEW to view
 ;
 ;----------
MAIN(BIVAL) ;
 ;---> Display Patients.
 ;---> Parameters:
 ;     1 - BIVAL (opt) Value indicates which patients:
 ;                     0=All, 1=Rejects only, 2=Appropriate only.
 ;
 S:(($G(BIVAL)<1)!($G(BIVAL)>2)) BIVAL=0
 N VALMCNT
 ;---> If <STKOV> errors appear here, increase STACK in SYSGEN,
 ;---> System Configuration Parameters.
 ;
 D START(BIVAL)
 D RESET1^BIREPQ1
 Q
 ;
 ;
 ;----------
START(BIVAL) ;EP
 ;---> Display Patients.
 ;---> Parameters:
 ;     1 - BIVAL (opt) Value indicates which patients.
 ;                     0=All patients, 1=Rejects only, 2=Appropriate only
 ;
 ;---> If Vaccine Table is not standard, display Error Text and quit.
 I $D(^BISITE(-1)) D ERRCD^BIUTL2(503,,1) Q
 D SETVARS^BIUTL5
 ;
 N BIPOP
 D  D DIRZ^BIUTL3(.BIPOP)
 .I $G(BIVAL)=1 D  Q
 ..D TITLE^BIUTL5("VIEW PATIENTS NOT APPROPRIATE IN QUARTERLY REPORT"),TEXT1 Q
 .I $G(BIVAL)=2 D  Q
 ..D TITLE^BIUTL5("VIEW PATIENTS APPROPRIATE IN QUARTERLY REPORT"),TEXT2
 .D TITLE^BIUTL5("VIEW ALL PATIENTS REVIEWED IN QUARTERLY REPORT"),TEXT3 Q
 Q:$G(BIPOP)
 W !!?5,"Please hold...",!
 ;
 ;---> Get Total Patients from ^TMP("BIDUL",$J,1,DOB,NAME,BIDFN)
 ;---> From STOR^BIREPQ4, call to STORE^BIDUR1.
 N BIT S BIT=0
 D
 .N M,N,P
 .S N=0 F  S N=$O(^TMP("BIDUL",$J,1,N)) Q:N=""  D
 ..S M=0 F  S M=$O(^TMP("BIDUL",$J,1,N,M)) Q:M=""  D
 ...N BIVAL1
 ...S P=0 F  S P=$O(^TMP("BIDUL",$J,1,N,M,P)) Q:P=""  S BIVAL1=^(P) D
 ....I $G(BIVAL) Q:BIVAL'=BIVAL1
 ....S BIT=BIT+1
 ;
 ;---> For now, comment out any additional info, per Group's request v8.0.
 ;N BINFO S BINFO="1,2,3,5,7,8"
 N BIPG
 S BIPG=$S(BIVAL=1:"Not Appropriate",BIVAL=2:"Appropriate",1:"Both Groups")
 S BIPG="Report - "_BIPG
 N BIAG S BIAG="3-27"
 ;---> Clear View global.
 K ^TMP("BIDULV",$J)
 ;---> For now, no Additional Info.
 ;D START^BIDUVLS1(BIQDT,BINFO,BIPG,BIAG,BIT,BIVAL)
 D START^BIDUVLS1(BIQDT,,BIPG,BIAG,BIT,BIVAL,1)
 Q
 ;
 ;
 ;----------
TEXT1 ;EP
 ;;This action will display a List of the patients who were NOT within
 ;;the recommended guidelines for immunizations and therefore were
 ;;NOT included in the tallies for the "Approp. for Age" row of the
 ;;report.
 ;;
 ;;NOTE! It is possible that some patients rejected by the report
 ;;      (as Not Appropriate for Age) are NOT DUE for any immunizations.
 ;;      Immunizations given after the recommended age cutoff will
 ;;      cause a patient to be rejected from the "Approp for Age" tally.
 ;;      Also, any immunizations given after the Quarter Ending Date
 ;;      of the report are not counted.
 D PRINTX("TEXT1")
 Q
 ;
 ;
 ;----------
TEXT2 ;EP
 ;;This action will display a List of the patients who were WITHIN
 ;;the recommended guidelines for immunizations and therefore were
 ;;INCLUDED in the tallies for the "Approp. for Age" row of the
 ;;report.
 ;;
 ;;
 D PRINTX("TEXT2")
 Q
 ;
 ;
 ;----------
TEXT3 ;EP
 ;;This action will display a list of ALL the patients who were
 ;;considered in this report.
 ;;
 ;;
 D PRINTX("TEXT3")
 Q
 ;
 ;
 ;----------
PRINTX(BILINL,BITAB) ;EP
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
