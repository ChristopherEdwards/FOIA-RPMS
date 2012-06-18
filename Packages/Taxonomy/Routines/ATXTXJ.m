ATXTXJ ;IHS/OHPRD/TMJ-CREATED BY ^ATXSTX ON FEB 04, 1997;
 ;;5.0;TAXONOMY;;FEB 04, 1997
 ;;ATX INJURY CONTROL
 ;
 ; This routine loads Taxonomy ATX INJURY CONTROL
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 D OTHER
 I $O(^TMP("ATX",$J,3.6,0)) D BULL^ATXSTX2
 I $O(^TMP("ATX",$J,9002226,0)) D TAX^ATXSTX2
 D KILL^ATXSTX2
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;3.6,104,.01)
 ;;ATX INJURY CONTROL NOTIF.
 ;;3.6,104,2)
 ;;COMMUNITY INJURY CONTROL NOTIFICATION
 ;;3.63,104,1,0)
 ;;^^22^22^2940609^^^^
 ;;3.63,104,1,1,0)
 ;;|NOWRAP|
 ;;3.63,104,1,2,0)
 ;;On |3| an injury related purpose of visit was recorded for:
 ;;3.63,104,1,3,0)
 ;; 
 ;;3.63,104,1,4,0)
 ;;  PATIENT NAME:  |2|
 ;;3.63,104,1,5,0)
 ;;     CHART NO.:  |99|
 ;;3.63,104,1,6,0)
 ;;    VISIT DATE:  |3|
 ;;3.63,104,1,7,0)
 ;;      LOCATION:  |15|
 ;;3.63,104,1,8,0)
 ;; ICD9 Code was:  |1|   ICD Description:  |8|
 ;;3.63,104,1,9,0)
 ;; Provider Narr:  |4|
 ;;3.63,104,1,10,0)
 ;; 
 ;;3.63,104,1,11,0)
 ;;For injuries the following information may have been noted:
 ;;3.63,104,1,12,0)
 ;; 
 ;;3.63,104,1,13,0)
 ;;CAUSE OF INJURY:  |9|
 ;;3.63,104,1,14,0)
 ;;    DESCRIPTION:  |9.1|
 ;;3.63,104,1,15,0)
 ;;          PLACE:  |11|
 ;;3.63,104,1,16,0)
 ;;  ACCIDENT DATE:  |13|
 ;;3.63,104,1,17,0)
 ;;     RELATED TO:  |7|
 ;;3.63,104,1,18,0)
 ;;  FIRST/REVISIT:  |14|
 ;;3.63,104,1,19,0)
 ;; 
 ;;3.63,104,1,20,0)
 ;;This visit may require your follow-up.  Please review the patient's
 ;;3.63,104,1,21,0)
 ;;medical record at your earliest convenience for further information
 ;;3.63,104,1,22,0)
 ;;on this visit.
 ;;3.63,104,3,0)
 ;;^^2^2^2940609^^^^
 ;;3.63,104,3,1,0)
 ;;Whenever a purpose of visit occurs that involves an accident/injury
 ;;3.63,104,3,2,0)
 ;;code, a bulletin will be sent to the indicated mail group(s).
 ;;3.64,"104,1",.01)
 ;;1
 ;;3.64,"104,1",1,0)
 ;;^^1^1^2940419^
 ;;3.64,"104,1",1,1,0)
 ;;ICD code for POV (should be injury-related).
 ;;3.64,"104,10",.01)
 ;;10
 ;;3.64,"104,11",.01)
 ;;11
 ;;3.64,"104,11",1,0)
 ;;^^1^1^2940419^
 ;;3.64,"104,11",1,1,0)
 ;;Place of injury.
 ;;3.64,"104,13",.01)
 ;;13
 ;;3.64,"104,13",1,0)
 ;;^^1^1^2940419^
 ;;3.64,"104,13",1,1,0)
 ;;Date of accident (may be different than date of visit).
 ;;3.64,"104,14",.01)
 ;;14
 ;;3.64,"104,14",1,0)
 ;;^^1^1^2940419^
 ;;3.64,"104,14",1,1,0)
 ;;First or revisit code (may not be entered at many sites).
 ;;3.64,"104,15",.01)
 ;;15
 ;;3.64,"104,15",1,0)
 ;;^^1^1^2940510^^^^
 ;;3.64,"104,15",1,1,0)
 ;;Location of encounter
 ;;3.64,"104,2",.01)
 ;;2
 ;;3.64,"104,2",1,0)
 ;;^^1^1^2940518^^
 ;;3.64,"104,2",1,1,0)
 ;;Patient name.
 ;;3.64,"104,3",.01)
 ;;3
 ;;3.64,"104,3",1,0)
 ;;^^1^1^2940419^^^^
 ;;3.64,"104,3",1,1,0)
 ;;Date of visit.
 ;;3.64,"104,4",.01)
 ;;4
 ;;3.64,"104,4",1,0)
 ;;^^1^1^2940419^
 ;;3.64,"104,4",1,1,0)
 ;;Provider narrative (should relate to ICD code).
 ;;3.64,"104,7",.01)
 ;;7
 ;;3.64,"104,7",1,0)
 ;;^^1^1^2940419^
 ;;3.64,"104,7",1,1,0)
 ;;Causal factor.
 ;;3.64,"104,8",.01)
 ;;8
 ;;3.64,"104,8",1,0)
 ;;^^1^1^2940518^^^^
 ;;3.64,"104,8",1,1,0)
 ;;ICD narrative corresponding to ICD code.
 ;;3.64,"104,9",.01)
 ;;9
 ;;3.64,"104,9",1,0)
 ;;^^1^1^2940419^
 ;;3.64,"104,9",1,1,0)
 ;;Cause of injury.
 ;;21,"798.0 ")
 ;;1
 ;;9002226,5,.01)
 ;;ATX INJURY CONTROL
 ;;9002226,5,.02)
 ;;COMMUNITY INJURY CONTROL
 ;;9002226,5,.04)
 ;;@
 ;;9002226,5,.06)
 ;;@
 ;;9002226,5,.08)
 ;;1
 ;;9002226,5,.09)
 ;;2910319.114953
 ;;9002226,5,.11)
 ;;B
 ;;9002226,5,.12)
 ;;31
 ;;9002226,5,.13)
 ;;1
 ;;9002226,5,.14)
 ;;BA
 ;;9002226,5,.15)
 ;;80
 ;;9002226,5,.16)
 ;;1
 ;;9002226,5,.17)
 ;;@
 ;;9002226,5,3101)
 ;;@
 ;;9002226.02101,"5,798.0 ",.01)
 ;;798.0
 ;;9002226.02101,"5,798.0 ",.02)
 ;;999.9
 ;
OTHER ; OTHER ROUTINES
 Q
