ATXXA101 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON APR 29, 2014;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"873,S72.125C ",.03)
 ;;30
 ;;9002226.02101,"873,S72.126A ",.01)
 ;;S72.126A
 ;;9002226.02101,"873,S72.126A ",.02)
 ;;S72.126A
 ;;9002226.02101,"873,S72.126A ",.03)
 ;;30
 ;;9002226.02101,"873,S72.126B ",.01)
 ;;S72.126B
 ;;9002226.02101,"873,S72.126B ",.02)
 ;;S72.126B
 ;;9002226.02101,"873,S72.126B ",.03)
 ;;30
 ;;9002226.02101,"873,S72.126C ",.01)
 ;;S72.126C
 ;;9002226.02101,"873,S72.126C ",.02)
 ;;S72.126C
 ;;9002226.02101,"873,S72.126C ",.03)
 ;;30
 ;;9002226.02101,"873,S72.131A ",.01)
 ;;S72.131A
 ;;9002226.02101,"873,S72.131A ",.02)
 ;;S72.131A
 ;;9002226.02101,"873,S72.131A ",.03)
 ;;30
 ;;9002226.02101,"873,S72.131B ",.01)
 ;;S72.131B
 ;;9002226.02101,"873,S72.131B ",.02)
 ;;S72.131B
 ;;9002226.02101,"873,S72.131B ",.03)
 ;;30
 ;;9002226.02101,"873,S72.131C ",.01)
 ;;S72.131C
 ;;9002226.02101,"873,S72.131C ",.02)
 ;;S72.131C
 ;;9002226.02101,"873,S72.131C ",.03)
 ;;30
 ;;9002226.02101,"873,S72.132A ",.01)
 ;;S72.132A
 ;;9002226.02101,"873,S72.132A ",.02)
 ;;S72.132A
 ;;9002226.02101,"873,S72.132A ",.03)
 ;;30
 ;;9002226.02101,"873,S72.132B ",.01)
 ;;S72.132B
 ;;9002226.02101,"873,S72.132B ",.02)
 ;;S72.132B
 ;;9002226.02101,"873,S72.132B ",.03)
 ;;30
 ;;9002226.02101,"873,S72.132C ",.01)
 ;;S72.132C
 ;;9002226.02101,"873,S72.132C ",.02)
 ;;S72.132C
 ;;9002226.02101,"873,S72.132C ",.03)
 ;;30
 ;;9002226.02101,"873,S72.133A ",.01)
 ;;S72.133A
 ;;9002226.02101,"873,S72.133A ",.02)
 ;;S72.133A
 ;;9002226.02101,"873,S72.133A ",.03)
 ;;30
 ;;9002226.02101,"873,S72.133B ",.01)
 ;;S72.133B
 ;;9002226.02101,"873,S72.133B ",.02)
 ;;S72.133B
 ;;9002226.02101,"873,S72.133B ",.03)
 ;;30
 ;;9002226.02101,"873,S72.133C ",.01)
 ;;S72.133C
 ;;9002226.02101,"873,S72.133C ",.02)
 ;;S72.133C
 ;;9002226.02101,"873,S72.133C ",.03)
 ;;30
 ;;9002226.02101,"873,S72.134A ",.01)
 ;;S72.134A
 ;;9002226.02101,"873,S72.134A ",.02)
 ;;S72.134A
 ;;9002226.02101,"873,S72.134A ",.03)
 ;;30
 ;;9002226.02101,"873,S72.134B ",.01)
 ;;S72.134B
 ;;9002226.02101,"873,S72.134B ",.02)
 ;;S72.134B
 ;;9002226.02101,"873,S72.134B ",.03)
 ;;30
 ;;9002226.02101,"873,S72.134C ",.01)
 ;;S72.134C
 ;;9002226.02101,"873,S72.134C ",.02)
 ;;S72.134C
 ;;9002226.02101,"873,S72.134C ",.03)
 ;;30
 ;;9002226.02101,"873,S72.135A ",.01)
 ;;S72.135A
 ;;9002226.02101,"873,S72.135A ",.02)
 ;;S72.135A
 ;;9002226.02101,"873,S72.135A ",.03)
 ;;30
 ;;9002226.02101,"873,S72.135B ",.01)
 ;;S72.135B
 ;;9002226.02101,"873,S72.135B ",.02)
 ;;S72.135B
 ;;9002226.02101,"873,S72.135B ",.03)
 ;;30
 ;;9002226.02101,"873,S72.135C ",.01)
 ;;S72.135C
 ;;9002226.02101,"873,S72.135C ",.02)
 ;;S72.135C
 ;;9002226.02101,"873,S72.135C ",.03)
 ;;30
 ;;9002226.02101,"873,S72.136A ",.01)
 ;;S72.136A
 ;;9002226.02101,"873,S72.136A ",.02)
 ;;S72.136A
 ;;9002226.02101,"873,S72.136A ",.03)
 ;;30
 ;;9002226.02101,"873,S72.136B ",.01)
 ;;S72.136B
 ;;9002226.02101,"873,S72.136B ",.02)
 ;;S72.136B
 ;;9002226.02101,"873,S72.136B ",.03)
 ;;30
 ;;9002226.02101,"873,S72.136C ",.01)
 ;;S72.136C
 ;;9002226.02101,"873,S72.136C ",.02)
 ;;S72.136C
 ;;9002226.02101,"873,S72.136C ",.03)
 ;;30
 ;;9002226.02101,"873,S72.141A ",.01)
 ;;S72.141A
 ;;9002226.02101,"873,S72.141A ",.02)
 ;;S72.141A
 ;;9002226.02101,"873,S72.141A ",.03)
 ;;30
 ;;9002226.02101,"873,S72.141B ",.01)
 ;;S72.141B
 ;;9002226.02101,"873,S72.141B ",.02)
 ;;S72.141B
 ;;9002226.02101,"873,S72.141B ",.03)
 ;;30
 ;;9002226.02101,"873,S72.141C ",.01)
 ;;S72.141C
 ;;9002226.02101,"873,S72.141C ",.02)
 ;;S72.141C
 ;;9002226.02101,"873,S72.141C ",.03)
 ;;30
 ;;9002226.02101,"873,S72.142A ",.01)
 ;;S72.142A
 ;;9002226.02101,"873,S72.142A ",.02)
 ;;S72.142A
 ;;9002226.02101,"873,S72.142A ",.03)
 ;;30
 ;;9002226.02101,"873,S72.142B ",.01)
 ;;S72.142B
 ;;9002226.02101,"873,S72.142B ",.02)
 ;;S72.142B
 ;;9002226.02101,"873,S72.142B ",.03)
 ;;30
 ;;9002226.02101,"873,S72.142C ",.01)
 ;;S72.142C
 ;;9002226.02101,"873,S72.142C ",.02)
 ;;S72.142C
 ;;9002226.02101,"873,S72.142C ",.03)
 ;;30
 ;;9002226.02101,"873,S72.143A ",.01)
 ;;S72.143A
 ;;9002226.02101,"873,S72.143A ",.02)
 ;;S72.143A
 ;;9002226.02101,"873,S72.143A ",.03)
 ;;30
 ;;9002226.02101,"873,S72.143B ",.01)
 ;;S72.143B
 ;;9002226.02101,"873,S72.143B ",.02)
 ;;S72.143B
 ;;9002226.02101,"873,S72.143B ",.03)
 ;;30
 ;;9002226.02101,"873,S72.143C ",.01)
 ;;S72.143C
 ;;9002226.02101,"873,S72.143C ",.02)
 ;;S72.143C
 ;;9002226.02101,"873,S72.143C ",.03)
 ;;30
 ;;9002226.02101,"873,S72.144A ",.01)
 ;;S72.144A
 ;;9002226.02101,"873,S72.144A ",.02)
 ;;S72.144A
 ;;9002226.02101,"873,S72.144A ",.03)
 ;;30
 ;;9002226.02101,"873,S72.144B ",.01)
 ;;S72.144B
 ;;9002226.02101,"873,S72.144B ",.02)
 ;;S72.144B
 ;;9002226.02101,"873,S72.144B ",.03)
 ;;30
 ;;9002226.02101,"873,S72.144C ",.01)
 ;;S72.144C
 ;;9002226.02101,"873,S72.144C ",.02)
 ;;S72.144C
 ;;9002226.02101,"873,S72.144C ",.03)
 ;;30
 ;;9002226.02101,"873,S72.145A ",.01)
 ;;S72.145A
 ;;9002226.02101,"873,S72.145A ",.02)
 ;;S72.145A
 ;;9002226.02101,"873,S72.145A ",.03)
 ;;30
 ;;9002226.02101,"873,S72.145B ",.01)
 ;;S72.145B
 ;;9002226.02101,"873,S72.145B ",.02)
 ;;S72.145B
 ;;9002226.02101,"873,S72.145B ",.03)
 ;;30
 ;;9002226.02101,"873,S72.145C ",.01)
 ;;S72.145C
 ;;9002226.02101,"873,S72.145C ",.02)
 ;;S72.145C
 ;;9002226.02101,"873,S72.145C ",.03)
 ;;30
 ;;9002226.02101,"873,S72.146A ",.01)
 ;;S72.146A
 ;;9002226.02101,"873,S72.146A ",.02)
 ;;S72.146A
 ;;9002226.02101,"873,S72.146A ",.03)
 ;;30
 ;;9002226.02101,"873,S72.146B ",.01)
 ;;S72.146B
 ;;9002226.02101,"873,S72.146B ",.02)
 ;;S72.146B
 ;;9002226.02101,"873,S72.146B ",.03)
 ;;30
 ;;9002226.02101,"873,S72.146C ",.01)
 ;;S72.146C
 ;;9002226.02101,"873,S72.146C ",.02)
 ;;S72.146C
 ;;9002226.02101,"873,S72.146C ",.03)
 ;;30
 ;;9002226.02101,"873,S72.21XA ",.01)
 ;;S72.21XA
 ;;9002226.02101,"873,S72.21XA ",.02)
 ;;S72.21XA
 ;;9002226.02101,"873,S72.21XA ",.03)
 ;;30
 ;;9002226.02101,"873,S72.21XB ",.01)
 ;;S72.21XB
 ;;9002226.02101,"873,S72.21XB ",.02)
 ;;S72.21XB
 ;;9002226.02101,"873,S72.21XB ",.03)
 ;;30
 ;;9002226.02101,"873,S72.21XC ",.01)
 ;;S72.21XC
 ;;9002226.02101,"873,S72.21XC ",.02)
 ;;S72.21XC
 ;;9002226.02101,"873,S72.21XC ",.03)
 ;;30
 ;;9002226.02101,"873,S72.22XA ",.01)
 ;;S72.22XA
 ;;9002226.02101,"873,S72.22XA ",.02)
 ;;S72.22XA
 ;;9002226.02101,"873,S72.22XA ",.03)
 ;;30
 ;;9002226.02101,"873,S72.22XB ",.01)
 ;;S72.22XB
 ;;9002226.02101,"873,S72.22XB ",.02)
 ;;S72.22XB
 ;;9002226.02101,"873,S72.22XB ",.03)
 ;;30
 ;;9002226.02101,"873,S72.22XC ",.01)
 ;;S72.22XC
 ;;9002226.02101,"873,S72.22XC ",.02)
 ;;S72.22XC
 ;;9002226.02101,"873,S72.22XC ",.03)
 ;;30
 ;;9002226.02101,"873,S72.23XA ",.01)
 ;;S72.23XA
 ;;9002226.02101,"873,S72.23XA ",.02)
 ;;S72.23XA
 ;;9002226.02101,"873,S72.23XA ",.03)
 ;;30
 ;;9002226.02101,"873,S72.23XB ",.01)
 ;;S72.23XB
 ;;9002226.02101,"873,S72.23XB ",.02)
 ;;S72.23XB
 ;;9002226.02101,"873,S72.23XB ",.03)
 ;;30
 ;;9002226.02101,"873,S72.23XC ",.01)
 ;;S72.23XC
 ;;9002226.02101,"873,S72.23XC ",.02)
 ;;S72.23XC
 ;;9002226.02101,"873,S72.23XC ",.03)
 ;;30
 ;;9002226.02101,"873,S72.24XA ",.01)
 ;;S72.24XA
 ;;9002226.02101,"873,S72.24XA ",.02)
 ;;S72.24XA
 ;;9002226.02101,"873,S72.24XA ",.03)
 ;;30
 ;;9002226.02101,"873,S72.24XB ",.01)
 ;;S72.24XB
 ;;9002226.02101,"873,S72.24XB ",.02)
 ;;S72.24XB
 ;;9002226.02101,"873,S72.24XB ",.03)
 ;;30
 ;;9002226.02101,"873,S72.24XC ",.01)
 ;;S72.24XC
 ;;9002226.02101,"873,S72.24XC ",.02)
 ;;S72.24XC
 ;;9002226.02101,"873,S72.24XC ",.03)
 ;;30
 ;;9002226.02101,"873,S72.25XA ",.01)
 ;;S72.25XA
 ;;9002226.02101,"873,S72.25XA ",.02)
 ;;S72.25XA
 ;;9002226.02101,"873,S72.25XA ",.03)
 ;;30
 ;;9002226.02101,"873,S72.25XB ",.01)
 ;;S72.25XB
 ;;9002226.02101,"873,S72.25XB ",.02)
 ;;S72.25XB
 ;;9002226.02101,"873,S72.25XB ",.03)
 ;;30
 ;;9002226.02101,"873,S72.25XC ",.01)
 ;;S72.25XC
 ;;9002226.02101,"873,S72.25XC ",.02)
 ;;S72.25XC
 ;;9002226.02101,"873,S72.25XC ",.03)
 ;;30
 ;;9002226.02101,"873,S72.26XA ",.01)
 ;;S72.26XA
 ;;9002226.02101,"873,S72.26XA ",.02)
 ;;S72.26XA
 ;;9002226.02101,"873,S72.26XA ",.03)
 ;;30
 ;;9002226.02101,"873,S72.26XB ",.01)
 ;;S72.26XB
 ;;9002226.02101,"873,S72.26XB ",.02)
 ;;S72.26XB
 ;;9002226.02101,"873,S72.26XB ",.03)
 ;;30
 ;;9002226.02101,"873,S72.26XC ",.01)
 ;;S72.26XC
 ;;9002226.02101,"873,S72.26XC ",.02)
 ;;S72.26XC
 ;;9002226.02101,"873,S72.26XC ",.03)
 ;;30
 ;;9002226.02101,"873,S72.301A ",.01)
 ;;S72.301A
 ;;9002226.02101,"873,S72.301A ",.02)
 ;;S72.301A
 ;;9002226.02101,"873,S72.301A ",.03)
 ;;30
 ;;9002226.02101,"873,S72.301B ",.01)
 ;;S72.301B
 ;;9002226.02101,"873,S72.301B ",.02)
 ;;S72.301B
 ;;9002226.02101,"873,S72.301B ",.03)
 ;;30
 ;;9002226.02101,"873,S72.301C ",.01)
 ;;S72.301C
 ;;9002226.02101,"873,S72.301C ",.02)
 ;;S72.301C
 ;;9002226.02101,"873,S72.301C ",.03)
 ;;30
 ;;9002226.02101,"873,S72.302A ",.01)
 ;;S72.302A
 ;;9002226.02101,"873,S72.302A ",.02)
 ;;S72.302A
 ;;9002226.02101,"873,S72.302A ",.03)
 ;;30
 ;;9002226.02101,"873,S72.302B ",.01)
 ;;S72.302B
 ;;9002226.02101,"873,S72.302B ",.02)
 ;;S72.302B
 ;;9002226.02101,"873,S72.302B ",.03)
 ;;30
 ;;9002226.02101,"873,S72.302C ",.01)
 ;;S72.302C
 ;;9002226.02101,"873,S72.302C ",.02)
 ;;S72.302C
 ;;9002226.02101,"873,S72.302C ",.03)
 ;;30
 ;;9002226.02101,"873,S72.309A ",.01)
 ;;S72.309A
 ;;9002226.02101,"873,S72.309A ",.02)
 ;;S72.309A
 ;;9002226.02101,"873,S72.309A ",.03)
 ;;30
 ;;9002226.02101,"873,S72.309B ",.01)
 ;;S72.309B
 ;;9002226.02101,"873,S72.309B ",.02)
 ;;S72.309B
 ;;9002226.02101,"873,S72.309B ",.03)
 ;;30
 ;;9002226.02101,"873,S72.309C ",.01)
 ;;S72.309C
 ;;9002226.02101,"873,S72.309C ",.02)
 ;;S72.309C
 ;;9002226.02101,"873,S72.309C ",.03)
 ;;30
 ;;9002226.02101,"873,S72.321A ",.01)
 ;;S72.321A
 ;;9002226.02101,"873,S72.321A ",.02)
 ;;S72.321A
 ;;9002226.02101,"873,S72.321A ",.03)
 ;;30
 ;;9002226.02101,"873,S72.321B ",.01)
 ;;S72.321B
 ;;9002226.02101,"873,S72.321B ",.02)
 ;;S72.321B
 ;;9002226.02101,"873,S72.321B ",.03)
 ;;30
 ;;9002226.02101,"873,S72.321C ",.01)
 ;;S72.321C
 ;;9002226.02101,"873,S72.321C ",.02)
 ;;S72.321C
 ;;9002226.02101,"873,S72.321C ",.03)
 ;;30
 ;;9002226.02101,"873,S72.322A ",.01)
 ;;S72.322A
 ;;9002226.02101,"873,S72.322A ",.02)
 ;;S72.322A
 ;;9002226.02101,"873,S72.322A ",.03)
 ;;30
 ;;9002226.02101,"873,S72.322B ",.01)
 ;;S72.322B
 ;;9002226.02101,"873,S72.322B ",.02)
 ;;S72.322B
 ;;9002226.02101,"873,S72.322B ",.03)
 ;;30
 ;;9002226.02101,"873,S72.322C ",.01)
 ;;S72.322C
 ;;9002226.02101,"873,S72.322C ",.02)
 ;;S72.322C
 ;;9002226.02101,"873,S72.322C ",.03)
 ;;30
 ;;9002226.02101,"873,S72.323A ",.01)
 ;;S72.323A
 ;;9002226.02101,"873,S72.323A ",.02)
 ;;S72.323A
 ;;9002226.02101,"873,S72.323A ",.03)
 ;;30
 ;;9002226.02101,"873,S72.323B ",.01)
 ;;S72.323B
 ;;9002226.02101,"873,S72.323B ",.02)
 ;;S72.323B
 ;;9002226.02101,"873,S72.323B ",.03)
 ;;30
 ;;9002226.02101,"873,S72.323C ",.01)
 ;;S72.323C
 ;;9002226.02101,"873,S72.323C ",.02)
 ;;S72.323C
 ;;9002226.02101,"873,S72.323C ",.03)
 ;;30
 ;;9002226.02101,"873,S72.324A ",.01)
 ;;S72.324A
 ;;9002226.02101,"873,S72.324A ",.02)
 ;;S72.324A
 ;;9002226.02101,"873,S72.324A ",.03)
 ;;30
 ;;9002226.02101,"873,S72.324B ",.01)
 ;;S72.324B
 ;;9002226.02101,"873,S72.324B ",.02)
 ;;S72.324B
 ;;9002226.02101,"873,S72.324B ",.03)
 ;;30
 ;;9002226.02101,"873,S72.324C ",.01)
 ;;S72.324C
 ;;9002226.02101,"873,S72.324C ",.02)
 ;;S72.324C
 ;;9002226.02101,"873,S72.324C ",.03)
 ;;30