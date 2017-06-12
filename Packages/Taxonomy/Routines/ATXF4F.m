ATXF4F ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 15, 2016;
 ;;5.1;TAXONOMY;**15**;FEB 04, 1997;Build 20
 ;;BQI ALZHEIMER/DEMENTIA DXS
 ;
 ; This routine loads Taxonomy BQI ALZHEIMER/DEMENTIA DXS
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
 ;;21,"046.1 ")
 ;;1
 ;;21,"046.3 ")
 ;;2
 ;;21,"290.0 ")
 ;;3
 ;;21,"291.20 ")
 ;;4
 ;;21,"292.82 ")
 ;;5
 ;;21,"294.10 ")
 ;;6
 ;;21,"294.8 ")
 ;;7
 ;;21,"331.0 ")
 ;;8
 ;;21,"331.11 ")
 ;;9
 ;;21,"331.7 ")
 ;;10
 ;;21,"331.82 ")
 ;;11
 ;;21,"331.89 ")
 ;;12
 ;;21,"333.0 ")
 ;;13
 ;;21,"333.4 ")
 ;;14
 ;;21,"A81.00 ")
 ;;15
 ;;21,"A81.2 ")
 ;;16
 ;;21,"F01.50 ")
 ;;17
 ;;21,"F02.80 ")
 ;;18
 ;;21,"F02.81 ")
 ;;19
 ;;21,"F06.8 ")
 ;;20
 ;;21,"F10.27 ")
 ;;21
 ;;21,"F19.97 ")
 ;;22
 ;;21,"G10. ")
 ;;23
 ;;21,"G23.8 ")
 ;;24
 ;;21,"G30.9 ")
 ;;25
 ;;21,"G31.83 ")
 ;;26
 ;;21,"G31.89 ")
 ;;27
 ;;21,"G31.9 ")
 ;;28
 ;;21,"G94. ")
 ;;29
 ;;9002226,2110,.01)
 ;;BQI ALZHEIMER/DEMENTIA DXS
 ;;9002226,2110,.02)
 ;;@
 ;;9002226,2110,.04)
 ;;n
 ;;9002226,2110,.06)
 ;;@
 ;;9002226,2110,.08)
 ;;0
 ;;9002226,2110,.09)
 ;;3160315
 ;;9002226,2110,.11)
 ;;@
 ;;9002226,2110,.12)
 ;;31
 ;;9002226,2110,.13)
 ;;1
 ;;9002226,2110,.14)
 ;;@
 ;;9002226,2110,.15)
 ;;80
 ;;9002226,2110,.16)
 ;;@
 ;;9002226,2110,.17)
 ;;@
 ;;9002226,2110,3101)
 ;;@
 ;;9002226.02101,"2110,046.1 ",.01)
 ;;046.1 
 ;;9002226.02101,"2110,046.1 ",.02)
 ;;046.19 
 ;;9002226.02101,"2110,046.1 ",.03)
 ;;1
 ;;9002226.02101,"2110,046.3 ",.01)
 ;;046.3 
 ;;9002226.02101,"2110,046.3 ",.02)
 ;;046.3 
 ;;9002226.02101,"2110,046.3 ",.03)
 ;;1
 ;;9002226.02101,"2110,290.0 ",.01)
 ;;290.0 
 ;;9002226.02101,"2110,290.0 ",.02)
 ;;290.43 
 ;;9002226.02101,"2110,290.0 ",.03)
 ;;1
 ;;9002226.02101,"2110,291.20 ",.01)
 ;;291.20 
 ;;9002226.02101,"2110,291.20 ",.02)
 ;;291.20 
 ;;9002226.02101,"2110,291.20 ",.03)
 ;;1
 ;;9002226.02101,"2110,292.82 ",.01)
 ;;292.82 
 ;;9002226.02101,"2110,292.82 ",.02)
 ;;292.82 
 ;;9002226.02101,"2110,292.82 ",.03)
 ;;1
 ;;9002226.02101,"2110,294.10 ",.01)
 ;;294.10 
 ;;9002226.02101,"2110,294.10 ",.02)
 ;;294.11 
 ;;9002226.02101,"2110,294.10 ",.03)
 ;;1
 ;;9002226.02101,"2110,294.8 ",.01)
 ;;294.8 
 ;;9002226.02101,"2110,294.8 ",.02)
 ;;294.8 
 ;;9002226.02101,"2110,294.8 ",.03)
 ;;1
 ;;9002226.02101,"2110,331.0 ",.01)
 ;;331.0 
 ;;9002226.02101,"2110,331.0 ",.02)
 ;;331.0 
 ;;9002226.02101,"2110,331.0 ",.03)
 ;;1
 ;;9002226.02101,"2110,331.11 ",.01)
 ;;331.11 
 ;;9002226.02101,"2110,331.11 ",.02)
 ;;331.2 
 ;;9002226.02101,"2110,331.11 ",.03)
 ;;1
 ;;9002226.02101,"2110,331.7 ",.01)
 ;;331.7 
 ;;9002226.02101,"2110,331.7 ",.02)
 ;;331.7 
 ;;9002226.02101,"2110,331.7 ",.03)
 ;;1
 ;;9002226.02101,"2110,331.82 ",.01)
 ;;331.82 
 ;;9002226.02101,"2110,331.82 ",.02)
 ;;331.82 
 ;;9002226.02101,"2110,331.82 ",.03)
 ;;1
 ;;9002226.02101,"2110,331.89 ",.01)
 ;;331.89 
 ;;9002226.02101,"2110,331.89 ",.02)
 ;;331.9 
 ;;9002226.02101,"2110,331.89 ",.03)
 ;;1
 ;;9002226.02101,"2110,333.0 ",.01)
 ;;333.0 
 ;;9002226.02101,"2110,333.0 ",.02)
 ;;333.0 
 ;;9002226.02101,"2110,333.0 ",.03)
 ;;1
 ;;9002226.02101,"2110,333.4 ",.01)
 ;;333.4 
 ;;9002226.02101,"2110,333.4 ",.02)
 ;;333.4 
 ;;9002226.02101,"2110,333.4 ",.03)
 ;;1
 ;;9002226.02101,"2110,A81.00 ",.01)
 ;;A81.00 
 ;;9002226.02101,"2110,A81.00 ",.02)
 ;;A81.09 
 ;;9002226.02101,"2110,A81.00 ",.03)
 ;;30
 ;;9002226.02101,"2110,A81.2 ",.01)
 ;;A81.2 
 ;;9002226.02101,"2110,A81.2 ",.02)
 ;;A81.2 
 ;;9002226.02101,"2110,A81.2 ",.03)
 ;;30
 ;;9002226.02101,"2110,F01.50 ",.01)
 ;;F01.50 
 ;;9002226.02101,"2110,F01.50 ",.02)
 ;;F01.51 
 ;;9002226.02101,"2110,F01.50 ",.03)
 ;;30
 ;;9002226.02101,"2110,F02.80 ",.01)
 ;;F02.80 
 ;;9002226.02101,"2110,F02.80 ",.02)
 ;;F02.80 
 ;;9002226.02101,"2110,F02.80 ",.03)
 ;;30
 ;;9002226.02101,"2110,F02.81 ",.01)
 ;;F02.81 
 ;;9002226.02101,"2110,F02.81 ",.02)
 ;;F03.90 
 ;;9002226.02101,"2110,F02.81 ",.03)
 ;;30
 ;;9002226.02101,"2110,F06.8 ",.01)
 ;;F06.8 
 ;;9002226.02101,"2110,F06.8 ",.02)
 ;;F06.8 
 ;;9002226.02101,"2110,F06.8 ",.03)
 ;;30
 ;;9002226.02101,"2110,F10.27 ",.01)
 ;;F10.27 
 ;;9002226.02101,"2110,F10.27 ",.02)
 ;;F10.27 
 ;;9002226.02101,"2110,F10.27 ",.03)
 ;;30
 ;;9002226.02101,"2110,F19.97 ",.01)
 ;;F19.97 
 ;;9002226.02101,"2110,F19.97 ",.02)
 ;;F19.97 
 ;;9002226.02101,"2110,F19.97 ",.03)
 ;;30
 ;;9002226.02101,"2110,G10. ",.01)
 ;;G10. 
 ;;9002226.02101,"2110,G10. ",.02)
 ;;G10. 
 ;;9002226.02101,"2110,G10. ",.03)
 ;;30
 ;;9002226.02101,"2110,G23.8 ",.01)
 ;;G23.8 
 ;;9002226.02101,"2110,G23.8 ",.02)
 ;;G23.8 
 ;;9002226.02101,"2110,G23.8 ",.03)
 ;;30
 ;;9002226.02101,"2110,G30.9 ",.01)
 ;;G30.9 
 ;;9002226.02101,"2110,G30.9 ",.02)
 ;;G31.1 
 ;;9002226.02101,"2110,G30.9 ",.03)
 ;;30
 ;;9002226.02101,"2110,G31.83 ",.01)
 ;;G31.83 
 ;;9002226.02101,"2110,G31.83 ",.02)
 ;;G31.83 
 ;;9002226.02101,"2110,G31.83 ",.03)
 ;;30
 ;;9002226.02101,"2110,G31.89 ",.01)
 ;;G31.89 
 ;;9002226.02101,"2110,G31.89 ",.02)
 ;;G31.89 
 ;;9002226.02101,"2110,G31.89 ",.03)
 ;;30
 ;;9002226.02101,"2110,G31.9 ",.01)
 ;;G31.9 
 ;;9002226.02101,"2110,G31.9 ",.02)
 ;;G31.9 
 ;;9002226.02101,"2110,G31.9 ",.03)
 ;;30
 ;;9002226.02101,"2110,G94. ",.01)
 ;;G94. 
 ;;9002226.02101,"2110,G94. ",.02)
 ;;G94. 
 ;;9002226.02101,"2110,G94. ",.03)
 ;;30
 ;
OTHER ; OTHER ROUTINES
 Q