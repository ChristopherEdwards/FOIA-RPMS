ATXTXI ;IHS/OHPRD/TMJ-CREATED BY ^ATXSTX ON FEB 04, 1997;
 ;;5.0;TAXONOMY;;FEB 04, 1997
 ;;ATX ADR NOTIFICATION
 ;
 ; This routine loads Taxonomy ATX ADR NOTIFICATION
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
 ;;3.6,144,.01)
 ;;ATX ADR NOTIFICATION
 ;;3.6,144,2)
 ;;PATIENT SEEN FOR AN ENTRY WITHIN A TAXONOMY
 ;;3.63,144,1,0)
 ;;9^^11^11^2950629^
 ;;3.63,144,1,1,0)
 ;;Patient Name: |2|      Chart No.: |99|
 ;;3.63,144,1,2,0)
 ;;Visit Date: |3|
 ;;3.63,144,1,3,0)
 ;;Location: |15|
 ;;3.63,144,1,4,0)
 ;;ICD9 Code: |1|
 ;;3.63,144,1,5,0)
 ;;ICD9 Description: |8|
 ;;3.63,144,1,6,0)
 ;;Provider Stated: |4|
 ;;3.63,144,1,7,0)
 ;;Taxonomy: |20|
 ;;3.63,144,1,8,0)
 ;; 
 ;;3.63,144,1,9,0)
 ;;This may be an adverse drug reaction which requires you investigation.
 ;;3.63,144,1,10,0)
 ;;Please review the client's medical record at your earliest convenience.
 ;;3.63,144,1,11,0)
 ;;for further information on this visit.
 ;;21,"960.0 ")
 ;;1
 ;;21,"995.0 ")
 ;;3
 ;;21,"V14.0 ")
 ;;2
 ;;9002226,108,.01)
 ;;ATX ADR NOTIFICATION
 ;;9002226,108,.02)
 ;;Adverse Drug Reaction Taxonomy
 ;;9002226,108,.04)
 ;;@
 ;;9002226,108,.06)
 ;;@
 ;;9002226,108,.08)
 ;;1
 ;;9002226,108,.09)
 ;;2950501
 ;;9002226,108,.11)
 ;;B
 ;;9002226,108,.12)
 ;;31
 ;;9002226,108,.13)
 ;;1
 ;;9002226,108,.14)
 ;;BA
 ;;9002226,108,.15)
 ;;80
 ;;9002226,108,.16)
 ;;1
 ;;9002226,108,.17)
 ;;@
 ;;9002226,108,3101)
 ;;@
 ;;9002226.02101,"108,960.0 ",.01)
 ;;960.0
 ;;9002226.02101,"108,960.0 ",.02)
 ;;979.9
 ;;9002226.02101,"108,995.0 ",.01)
 ;;995.0
 ;;9002226.02101,"108,995.0 ",.02)
 ;;995.4
 ;;9002226.02101,"108,V14.0 ",.01)
 ;;V14.0
 ;;9002226.02101,"108,V14.0 ",.02)
 ;;V14.9
 ;
OTHER ; OTHER ROUTINES
 Q
