ATXXB83 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON APR 29, 2014;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1804,0JBQ3ZX ",.02)
 ;;0JBQ3ZX 
 ;;9002226.02101,"1804,0JBQ3ZX ",.03)
 ;;31
 ;;9002226.02101,"1804,0JBR0ZX ",.01)
 ;;0JBR0ZX 
 ;;9002226.02101,"1804,0JBR0ZX ",.02)
 ;;0JBR0ZX 
 ;;9002226.02101,"1804,0JBR0ZX ",.03)
 ;;31
 ;;9002226.02101,"1804,0JBR0ZZ ",.01)
 ;;0JBR0ZZ 
 ;;9002226.02101,"1804,0JBR0ZZ ",.02)
 ;;0JBR0ZZ 
 ;;9002226.02101,"1804,0JBR0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JBR3ZX ",.01)
 ;;0JBR3ZX 
 ;;9002226.02101,"1804,0JBR3ZX ",.02)
 ;;0JBR3ZX 
 ;;9002226.02101,"1804,0JBR3ZX ",.03)
 ;;31
 ;;9002226.02101,"1804,0JC00ZZ ",.01)
 ;;0JC00ZZ 
 ;;9002226.02101,"1804,0JC00ZZ ",.02)
 ;;0JC00ZZ 
 ;;9002226.02101,"1804,0JC00ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JC03ZZ ",.01)
 ;;0JC03ZZ 
 ;;9002226.02101,"1804,0JC03ZZ ",.02)
 ;;0JC03ZZ 
 ;;9002226.02101,"1804,0JC03ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JC10ZZ ",.01)
 ;;0JC10ZZ 
 ;;9002226.02101,"1804,0JC10ZZ ",.02)
 ;;0JC10ZZ 
 ;;9002226.02101,"1804,0JC10ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JC13ZZ ",.01)
 ;;0JC13ZZ 
 ;;9002226.02101,"1804,0JC13ZZ ",.02)
 ;;0JC13ZZ 
 ;;9002226.02101,"1804,0JC13ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JC40ZZ ",.01)
 ;;0JC40ZZ 
 ;;9002226.02101,"1804,0JC40ZZ ",.02)
 ;;0JC40ZZ 
 ;;9002226.02101,"1804,0JC40ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JC43ZZ ",.01)
 ;;0JC43ZZ 
 ;;9002226.02101,"1804,0JC43ZZ ",.02)
 ;;0JC43ZZ 
 ;;9002226.02101,"1804,0JC43ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JC50ZZ ",.01)
 ;;0JC50ZZ 
 ;;9002226.02101,"1804,0JC50ZZ ",.02)
 ;;0JC50ZZ 
 ;;9002226.02101,"1804,0JC50ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JC53ZZ ",.01)
 ;;0JC53ZZ 
 ;;9002226.02101,"1804,0JC53ZZ ",.02)
 ;;0JC53ZZ 
 ;;9002226.02101,"1804,0JC53ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JC60ZZ ",.01)
 ;;0JC60ZZ 
 ;;9002226.02101,"1804,0JC60ZZ ",.02)
 ;;0JC60ZZ 
 ;;9002226.02101,"1804,0JC60ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JC63ZZ ",.01)
 ;;0JC63ZZ 
 ;;9002226.02101,"1804,0JC63ZZ ",.02)
 ;;0JC63ZZ 
 ;;9002226.02101,"1804,0JC63ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JC70ZZ ",.01)
 ;;0JC70ZZ 
 ;;9002226.02101,"1804,0JC70ZZ ",.02)
 ;;0JC70ZZ 
 ;;9002226.02101,"1804,0JC70ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JC73ZZ ",.01)
 ;;0JC73ZZ 
 ;;9002226.02101,"1804,0JC73ZZ ",.02)
 ;;0JC73ZZ 
 ;;9002226.02101,"1804,0JC73ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JC80ZZ ",.01)
 ;;0JC80ZZ 
 ;;9002226.02101,"1804,0JC80ZZ ",.02)
 ;;0JC80ZZ 
 ;;9002226.02101,"1804,0JC80ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JC83ZZ ",.01)
 ;;0JC83ZZ 
 ;;9002226.02101,"1804,0JC83ZZ ",.02)
 ;;0JC83ZZ 
 ;;9002226.02101,"1804,0JC83ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JC90ZZ ",.01)
 ;;0JC90ZZ 
 ;;9002226.02101,"1804,0JC90ZZ ",.02)
 ;;0JC90ZZ 
 ;;9002226.02101,"1804,0JC90ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JC93ZZ ",.01)
 ;;0JC93ZZ 
 ;;9002226.02101,"1804,0JC93ZZ ",.02)
 ;;0JC93ZZ 
 ;;9002226.02101,"1804,0JC93ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JCB0ZZ ",.01)
 ;;0JCB0ZZ 
 ;;9002226.02101,"1804,0JCB0ZZ ",.02)
 ;;0JCB0ZZ 
 ;;9002226.02101,"1804,0JCB0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JCB3ZZ ",.01)
 ;;0JCB3ZZ 
 ;;9002226.02101,"1804,0JCB3ZZ ",.02)
 ;;0JCB3ZZ 
 ;;9002226.02101,"1804,0JCB3ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JCC0ZZ ",.01)
 ;;0JCC0ZZ 
 ;;9002226.02101,"1804,0JCC0ZZ ",.02)
 ;;0JCC0ZZ 
 ;;9002226.02101,"1804,0JCC0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JCC3ZZ ",.01)
 ;;0JCC3ZZ 
 ;;9002226.02101,"1804,0JCC3ZZ ",.02)
 ;;0JCC3ZZ 
 ;;9002226.02101,"1804,0JCC3ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JCD0ZZ ",.01)
 ;;0JCD0ZZ 
 ;;9002226.02101,"1804,0JCD0ZZ ",.02)
 ;;0JCD0ZZ 
 ;;9002226.02101,"1804,0JCD0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JCD3ZZ ",.01)
 ;;0JCD3ZZ 
 ;;9002226.02101,"1804,0JCD3ZZ ",.02)
 ;;0JCD3ZZ 
 ;;9002226.02101,"1804,0JCD3ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JCF0ZZ ",.01)
 ;;0JCF0ZZ 
 ;;9002226.02101,"1804,0JCF0ZZ ",.02)
 ;;0JCF0ZZ 
 ;;9002226.02101,"1804,0JCF0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JCF3ZZ ",.01)
 ;;0JCF3ZZ 
 ;;9002226.02101,"1804,0JCF3ZZ ",.02)
 ;;0JCF3ZZ 
 ;;9002226.02101,"1804,0JCF3ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JCG0ZZ ",.01)
 ;;0JCG0ZZ 
 ;;9002226.02101,"1804,0JCG0ZZ ",.02)
 ;;0JCG0ZZ 
 ;;9002226.02101,"1804,0JCG0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JCG3ZZ ",.01)
 ;;0JCG3ZZ 
 ;;9002226.02101,"1804,0JCG3ZZ ",.02)
 ;;0JCG3ZZ 
 ;;9002226.02101,"1804,0JCG3ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JCH0ZZ ",.01)
 ;;0JCH0ZZ 
 ;;9002226.02101,"1804,0JCH0ZZ ",.02)
 ;;0JCH0ZZ 
 ;;9002226.02101,"1804,0JCH0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JCH3ZZ ",.01)
 ;;0JCH3ZZ 
 ;;9002226.02101,"1804,0JCH3ZZ ",.02)
 ;;0JCH3ZZ 
 ;;9002226.02101,"1804,0JCH3ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JCJ0ZZ ",.01)
 ;;0JCJ0ZZ 
 ;;9002226.02101,"1804,0JCJ0ZZ ",.02)
 ;;0JCJ0ZZ 
 ;;9002226.02101,"1804,0JCJ0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JCJ3ZZ ",.01)
 ;;0JCJ3ZZ 
 ;;9002226.02101,"1804,0JCJ3ZZ ",.02)
 ;;0JCJ3ZZ 
 ;;9002226.02101,"1804,0JCJ3ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JCK0ZZ ",.01)
 ;;0JCK0ZZ 
 ;;9002226.02101,"1804,0JCK0ZZ ",.02)
 ;;0JCK0ZZ 
 ;;9002226.02101,"1804,0JCK0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JCK3ZZ ",.01)
 ;;0JCK3ZZ 
 ;;9002226.02101,"1804,0JCK3ZZ ",.02)
 ;;0JCK3ZZ 
 ;;9002226.02101,"1804,0JCK3ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JCL0ZZ ",.01)
 ;;0JCL0ZZ 
 ;;9002226.02101,"1804,0JCL0ZZ ",.02)
 ;;0JCL0ZZ 
 ;;9002226.02101,"1804,0JCL0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JCL3ZZ ",.01)
 ;;0JCL3ZZ 
 ;;9002226.02101,"1804,0JCL3ZZ ",.02)
 ;;0JCL3ZZ 
 ;;9002226.02101,"1804,0JCL3ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JCM0ZZ ",.01)
 ;;0JCM0ZZ 
 ;;9002226.02101,"1804,0JCM0ZZ ",.02)
 ;;0JCM0ZZ 
 ;;9002226.02101,"1804,0JCM0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JCM3ZZ ",.01)
 ;;0JCM3ZZ 
 ;;9002226.02101,"1804,0JCM3ZZ ",.02)
 ;;0JCM3ZZ 
 ;;9002226.02101,"1804,0JCM3ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JCN0ZZ ",.01)
 ;;0JCN0ZZ 
 ;;9002226.02101,"1804,0JCN0ZZ ",.02)
 ;;0JCN0ZZ 
 ;;9002226.02101,"1804,0JCN0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JCN3ZZ ",.01)
 ;;0JCN3ZZ 
 ;;9002226.02101,"1804,0JCN3ZZ ",.02)
 ;;0JCN3ZZ 
 ;;9002226.02101,"1804,0JCN3ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JCP0ZZ ",.01)
 ;;0JCP0ZZ 
 ;;9002226.02101,"1804,0JCP0ZZ ",.02)
 ;;0JCP0ZZ 
 ;;9002226.02101,"1804,0JCP0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JCP3ZZ ",.01)
 ;;0JCP3ZZ 
 ;;9002226.02101,"1804,0JCP3ZZ ",.02)
 ;;0JCP3ZZ 
 ;;9002226.02101,"1804,0JCP3ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JCQ0ZZ ",.01)
 ;;0JCQ0ZZ 
 ;;9002226.02101,"1804,0JCQ0ZZ ",.02)
 ;;0JCQ0ZZ 
 ;;9002226.02101,"1804,0JCQ0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JCQ3ZZ ",.01)
 ;;0JCQ3ZZ 
 ;;9002226.02101,"1804,0JCQ3ZZ ",.02)
 ;;0JCQ3ZZ 
 ;;9002226.02101,"1804,0JCQ3ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JCR0ZZ ",.01)
 ;;0JCR0ZZ 
 ;;9002226.02101,"1804,0JCR0ZZ ",.02)
 ;;0JCR0ZZ 
 ;;9002226.02101,"1804,0JCR0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JCR3ZZ ",.01)
 ;;0JCR3ZZ 
 ;;9002226.02101,"1804,0JCR3ZZ ",.02)
 ;;0JCR3ZZ 
 ;;9002226.02101,"1804,0JCR3ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JD00ZZ ",.01)
 ;;0JD00ZZ 
 ;;9002226.02101,"1804,0JD00ZZ ",.02)
 ;;0JD00ZZ 
 ;;9002226.02101,"1804,0JD00ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JD10ZZ ",.01)
 ;;0JD10ZZ 
 ;;9002226.02101,"1804,0JD10ZZ ",.02)
 ;;0JD10ZZ 
 ;;9002226.02101,"1804,0JD10ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JD40ZZ ",.01)
 ;;0JD40ZZ 
 ;;9002226.02101,"1804,0JD40ZZ ",.02)
 ;;0JD40ZZ 
 ;;9002226.02101,"1804,0JD40ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JD50ZZ ",.01)
 ;;0JD50ZZ 
 ;;9002226.02101,"1804,0JD50ZZ ",.02)
 ;;0JD50ZZ 
 ;;9002226.02101,"1804,0JD50ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JD60ZZ ",.01)
 ;;0JD60ZZ 
 ;;9002226.02101,"1804,0JD60ZZ ",.02)
 ;;0JD60ZZ 
 ;;9002226.02101,"1804,0JD60ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JD70ZZ ",.01)
 ;;0JD70ZZ 
 ;;9002226.02101,"1804,0JD70ZZ ",.02)
 ;;0JD70ZZ 
 ;;9002226.02101,"1804,0JD70ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JD80ZZ ",.01)
 ;;0JD80ZZ 
 ;;9002226.02101,"1804,0JD80ZZ ",.02)
 ;;0JD80ZZ 
 ;;9002226.02101,"1804,0JD80ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JD90ZZ ",.01)
 ;;0JD90ZZ 
 ;;9002226.02101,"1804,0JD90ZZ ",.02)
 ;;0JD90ZZ 
 ;;9002226.02101,"1804,0JD90ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JDB0ZZ ",.01)
 ;;0JDB0ZZ 
 ;;9002226.02101,"1804,0JDB0ZZ ",.02)
 ;;0JDB0ZZ 
 ;;9002226.02101,"1804,0JDB0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JDC0ZZ ",.01)
 ;;0JDC0ZZ 
 ;;9002226.02101,"1804,0JDC0ZZ ",.02)
 ;;0JDC0ZZ 
 ;;9002226.02101,"1804,0JDC0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JDD0ZZ ",.01)
 ;;0JDD0ZZ 
 ;;9002226.02101,"1804,0JDD0ZZ ",.02)
 ;;0JDD0ZZ 
 ;;9002226.02101,"1804,0JDD0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JDF0ZZ ",.01)
 ;;0JDF0ZZ 
 ;;9002226.02101,"1804,0JDF0ZZ ",.02)
 ;;0JDF0ZZ 
 ;;9002226.02101,"1804,0JDF0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JDG0ZZ ",.01)
 ;;0JDG0ZZ 
 ;;9002226.02101,"1804,0JDG0ZZ ",.02)
 ;;0JDG0ZZ 
 ;;9002226.02101,"1804,0JDG0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JDH0ZZ ",.01)
 ;;0JDH0ZZ 
 ;;9002226.02101,"1804,0JDH0ZZ ",.02)
 ;;0JDH0ZZ 
 ;;9002226.02101,"1804,0JDH0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JDJ0ZZ ",.01)
 ;;0JDJ0ZZ 
 ;;9002226.02101,"1804,0JDJ0ZZ ",.02)
 ;;0JDJ0ZZ 
 ;;9002226.02101,"1804,0JDJ0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JDK0ZZ ",.01)
 ;;0JDK0ZZ 
 ;;9002226.02101,"1804,0JDK0ZZ ",.02)
 ;;0JDK0ZZ 
 ;;9002226.02101,"1804,0JDK0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JDL0ZZ ",.01)
 ;;0JDL0ZZ 
 ;;9002226.02101,"1804,0JDL0ZZ ",.02)
 ;;0JDL0ZZ 
 ;;9002226.02101,"1804,0JDL0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JDM0ZZ ",.01)
 ;;0JDM0ZZ 
 ;;9002226.02101,"1804,0JDM0ZZ ",.02)
 ;;0JDM0ZZ 
 ;;9002226.02101,"1804,0JDM0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JDN0ZZ ",.01)
 ;;0JDN0ZZ 
 ;;9002226.02101,"1804,0JDN0ZZ ",.02)
 ;;0JDN0ZZ 
 ;;9002226.02101,"1804,0JDN0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JDP0ZZ ",.01)
 ;;0JDP0ZZ 
 ;;9002226.02101,"1804,0JDP0ZZ ",.02)
 ;;0JDP0ZZ 
 ;;9002226.02101,"1804,0JDP0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JDQ0ZZ ",.01)
 ;;0JDQ0ZZ 
 ;;9002226.02101,"1804,0JDQ0ZZ ",.02)
 ;;0JDQ0ZZ 
 ;;9002226.02101,"1804,0JDQ0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JDR0ZZ ",.01)
 ;;0JDR0ZZ 
 ;;9002226.02101,"1804,0JDR0ZZ ",.02)
 ;;0JDR0ZZ 
 ;;9002226.02101,"1804,0JDR0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JH00NZ ",.01)
 ;;0JH00NZ 
 ;;9002226.02101,"1804,0JH00NZ ",.02)
 ;;0JH00NZ 
 ;;9002226.02101,"1804,0JH00NZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JH03NZ ",.01)
 ;;0JH03NZ 
 ;;9002226.02101,"1804,0JH03NZ ",.02)
 ;;0JH03NZ 
 ;;9002226.02101,"1804,0JH03NZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JH10NZ ",.01)
 ;;0JH10NZ 
 ;;9002226.02101,"1804,0JH10NZ ",.02)
 ;;0JH10NZ 
 ;;9002226.02101,"1804,0JH10NZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JH13NZ ",.01)
 ;;0JH13NZ 
 ;;9002226.02101,"1804,0JH13NZ ",.02)
 ;;0JH13NZ 
 ;;9002226.02101,"1804,0JH13NZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JH40NZ ",.01)
 ;;0JH40NZ 
 ;;9002226.02101,"1804,0JH40NZ ",.02)
 ;;0JH40NZ 
 ;;9002226.02101,"1804,0JH40NZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JH43NZ ",.01)
 ;;0JH43NZ 
 ;;9002226.02101,"1804,0JH43NZ ",.02)
 ;;0JH43NZ 
 ;;9002226.02101,"1804,0JH43NZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JH50NZ ",.01)
 ;;0JH50NZ 
 ;;9002226.02101,"1804,0JH50NZ ",.02)
 ;;0JH50NZ 
 ;;9002226.02101,"1804,0JH50NZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JH53NZ ",.01)
 ;;0JH53NZ 
 ;;9002226.02101,"1804,0JH53NZ ",.02)
 ;;0JH53NZ 
 ;;9002226.02101,"1804,0JH53NZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0JH602Z ",.01)
 ;;0JH602Z 
 ;;9002226.02101,"1804,0JH602Z ",.02)
 ;;0JH602Z 