ATXXB59 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON APR 29, 2014;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1804,06H733Z ",.02)
 ;;06H733Z 
 ;;9002226.02101,"1804,06H733Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06H743Z ",.01)
 ;;06H743Z 
 ;;9002226.02101,"1804,06H743Z ",.02)
 ;;06H743Z 
 ;;9002226.02101,"1804,06H743Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06H803Z ",.01)
 ;;06H803Z 
 ;;9002226.02101,"1804,06H803Z ",.02)
 ;;06H803Z 
 ;;9002226.02101,"1804,06H803Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06H833Z ",.01)
 ;;06H833Z 
 ;;9002226.02101,"1804,06H833Z ",.02)
 ;;06H833Z 
 ;;9002226.02101,"1804,06H833Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06H843Z ",.01)
 ;;06H843Z 
 ;;9002226.02101,"1804,06H843Z ",.02)
 ;;06H843Z 
 ;;9002226.02101,"1804,06H843Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06H903Z ",.01)
 ;;06H903Z 
 ;;9002226.02101,"1804,06H903Z ",.02)
 ;;06H903Z 
 ;;9002226.02101,"1804,06H903Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06H933Z ",.01)
 ;;06H933Z 
 ;;9002226.02101,"1804,06H933Z ",.02)
 ;;06H933Z 
 ;;9002226.02101,"1804,06H933Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06H943Z ",.01)
 ;;06H943Z 
 ;;9002226.02101,"1804,06H943Z ",.02)
 ;;06H943Z 
 ;;9002226.02101,"1804,06H943Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HB03Z ",.01)
 ;;06HB03Z 
 ;;9002226.02101,"1804,06HB03Z ",.02)
 ;;06HB03Z 
 ;;9002226.02101,"1804,06HB03Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HB33Z ",.01)
 ;;06HB33Z 
 ;;9002226.02101,"1804,06HB33Z ",.02)
 ;;06HB33Z 
 ;;9002226.02101,"1804,06HB33Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HB43Z ",.01)
 ;;06HB43Z 
 ;;9002226.02101,"1804,06HB43Z ",.02)
 ;;06HB43Z 
 ;;9002226.02101,"1804,06HB43Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HC03Z ",.01)
 ;;06HC03Z 
 ;;9002226.02101,"1804,06HC03Z ",.02)
 ;;06HC03Z 
 ;;9002226.02101,"1804,06HC03Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HC33Z ",.01)
 ;;06HC33Z 
 ;;9002226.02101,"1804,06HC33Z ",.02)
 ;;06HC33Z 
 ;;9002226.02101,"1804,06HC33Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HC43Z ",.01)
 ;;06HC43Z 
 ;;9002226.02101,"1804,06HC43Z ",.02)
 ;;06HC43Z 
 ;;9002226.02101,"1804,06HC43Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HD03Z ",.01)
 ;;06HD03Z 
 ;;9002226.02101,"1804,06HD03Z ",.02)
 ;;06HD03Z 
 ;;9002226.02101,"1804,06HD03Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HD33Z ",.01)
 ;;06HD33Z 
 ;;9002226.02101,"1804,06HD33Z ",.02)
 ;;06HD33Z 
 ;;9002226.02101,"1804,06HD33Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HD43Z ",.01)
 ;;06HD43Z 
 ;;9002226.02101,"1804,06HD43Z ",.02)
 ;;06HD43Z 
 ;;9002226.02101,"1804,06HD43Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HF03Z ",.01)
 ;;06HF03Z 
 ;;9002226.02101,"1804,06HF03Z ",.02)
 ;;06HF03Z 
 ;;9002226.02101,"1804,06HF03Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HF33Z ",.01)
 ;;06HF33Z 
 ;;9002226.02101,"1804,06HF33Z ",.02)
 ;;06HF33Z 
 ;;9002226.02101,"1804,06HF33Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HF43Z ",.01)
 ;;06HF43Z 
 ;;9002226.02101,"1804,06HF43Z ",.02)
 ;;06HF43Z 
 ;;9002226.02101,"1804,06HF43Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HG03Z ",.01)
 ;;06HG03Z 
 ;;9002226.02101,"1804,06HG03Z ",.02)
 ;;06HG03Z 
 ;;9002226.02101,"1804,06HG03Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HG33Z ",.01)
 ;;06HG33Z 
 ;;9002226.02101,"1804,06HG33Z ",.02)
 ;;06HG33Z 
 ;;9002226.02101,"1804,06HG33Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HG43Z ",.01)
 ;;06HG43Z 
 ;;9002226.02101,"1804,06HG43Z ",.02)
 ;;06HG43Z 
 ;;9002226.02101,"1804,06HG43Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HH03Z ",.01)
 ;;06HH03Z 
 ;;9002226.02101,"1804,06HH03Z ",.02)
 ;;06HH03Z 
 ;;9002226.02101,"1804,06HH03Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HH33Z ",.01)
 ;;06HH33Z 
 ;;9002226.02101,"1804,06HH33Z ",.02)
 ;;06HH33Z 
 ;;9002226.02101,"1804,06HH33Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HH43Z ",.01)
 ;;06HH43Z 
 ;;9002226.02101,"1804,06HH43Z ",.02)
 ;;06HH43Z 
 ;;9002226.02101,"1804,06HH43Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HJ03Z ",.01)
 ;;06HJ03Z 
 ;;9002226.02101,"1804,06HJ03Z ",.02)
 ;;06HJ03Z 
 ;;9002226.02101,"1804,06HJ03Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HJ33Z ",.01)
 ;;06HJ33Z 
 ;;9002226.02101,"1804,06HJ33Z ",.02)
 ;;06HJ33Z 
 ;;9002226.02101,"1804,06HJ33Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HJ43Z ",.01)
 ;;06HJ43Z 
 ;;9002226.02101,"1804,06HJ43Z ",.02)
 ;;06HJ43Z 
 ;;9002226.02101,"1804,06HJ43Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HM03Z ",.01)
 ;;06HM03Z 
 ;;9002226.02101,"1804,06HM03Z ",.02)
 ;;06HM03Z 
 ;;9002226.02101,"1804,06HM03Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HM33Z ",.01)
 ;;06HM33Z 
 ;;9002226.02101,"1804,06HM33Z ",.02)
 ;;06HM33Z 
 ;;9002226.02101,"1804,06HM33Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HM43Z ",.01)
 ;;06HM43Z 
 ;;9002226.02101,"1804,06HM43Z ",.02)
 ;;06HM43Z 
 ;;9002226.02101,"1804,06HM43Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HN03Z ",.01)
 ;;06HN03Z 
 ;;9002226.02101,"1804,06HN03Z ",.02)
 ;;06HN03Z 
 ;;9002226.02101,"1804,06HN03Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HN33Z ",.01)
 ;;06HN33Z 
 ;;9002226.02101,"1804,06HN33Z ",.02)
 ;;06HN33Z 
 ;;9002226.02101,"1804,06HN33Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HN43Z ",.01)
 ;;06HN43Z 
 ;;9002226.02101,"1804,06HN43Z ",.02)
 ;;06HN43Z 
 ;;9002226.02101,"1804,06HN43Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HP03Z ",.01)
 ;;06HP03Z 
 ;;9002226.02101,"1804,06HP03Z ",.02)
 ;;06HP03Z 
 ;;9002226.02101,"1804,06HP03Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HP33Z ",.01)
 ;;06HP33Z 
 ;;9002226.02101,"1804,06HP33Z ",.02)
 ;;06HP33Z 
 ;;9002226.02101,"1804,06HP33Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HP43Z ",.01)
 ;;06HP43Z 
 ;;9002226.02101,"1804,06HP43Z ",.02)
 ;;06HP43Z 
 ;;9002226.02101,"1804,06HP43Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HQ03Z ",.01)
 ;;06HQ03Z 
 ;;9002226.02101,"1804,06HQ03Z ",.02)
 ;;06HQ03Z 
 ;;9002226.02101,"1804,06HQ03Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HQ33Z ",.01)
 ;;06HQ33Z 
 ;;9002226.02101,"1804,06HQ33Z ",.02)
 ;;06HQ33Z 
 ;;9002226.02101,"1804,06HQ33Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HQ43Z ",.01)
 ;;06HQ43Z 
 ;;9002226.02101,"1804,06HQ43Z ",.02)
 ;;06HQ43Z 
 ;;9002226.02101,"1804,06HQ43Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HR03Z ",.01)
 ;;06HR03Z 
 ;;9002226.02101,"1804,06HR03Z ",.02)
 ;;06HR03Z 
 ;;9002226.02101,"1804,06HR03Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HR33Z ",.01)
 ;;06HR33Z 
 ;;9002226.02101,"1804,06HR33Z ",.02)
 ;;06HR33Z 
 ;;9002226.02101,"1804,06HR33Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HR43Z ",.01)
 ;;06HR43Z 
 ;;9002226.02101,"1804,06HR43Z ",.02)
 ;;06HR43Z 
 ;;9002226.02101,"1804,06HR43Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HS03Z ",.01)
 ;;06HS03Z 
 ;;9002226.02101,"1804,06HS03Z ",.02)
 ;;06HS03Z 
 ;;9002226.02101,"1804,06HS03Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HS33Z ",.01)
 ;;06HS33Z 
 ;;9002226.02101,"1804,06HS33Z ",.02)
 ;;06HS33Z 
 ;;9002226.02101,"1804,06HS33Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HS43Z ",.01)
 ;;06HS43Z 
 ;;9002226.02101,"1804,06HS43Z ",.02)
 ;;06HS43Z 
 ;;9002226.02101,"1804,06HS43Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HT03Z ",.01)
 ;;06HT03Z 
 ;;9002226.02101,"1804,06HT03Z ",.02)
 ;;06HT03Z 
 ;;9002226.02101,"1804,06HT03Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HT33Z ",.01)
 ;;06HT33Z 
 ;;9002226.02101,"1804,06HT33Z ",.02)
 ;;06HT33Z 
 ;;9002226.02101,"1804,06HT33Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HT43Z ",.01)
 ;;06HT43Z 
 ;;9002226.02101,"1804,06HT43Z ",.02)
 ;;06HT43Z 
 ;;9002226.02101,"1804,06HT43Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HV03Z ",.01)
 ;;06HV03Z 
 ;;9002226.02101,"1804,06HV03Z ",.02)
 ;;06HV03Z 
 ;;9002226.02101,"1804,06HV03Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HV33Z ",.01)
 ;;06HV33Z 
 ;;9002226.02101,"1804,06HV33Z ",.02)
 ;;06HV33Z 
 ;;9002226.02101,"1804,06HV33Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HV43Z ",.01)
 ;;06HV43Z 
 ;;9002226.02101,"1804,06HV43Z ",.02)
 ;;06HV43Z 
 ;;9002226.02101,"1804,06HV43Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HY03Z ",.01)
 ;;06HY03Z 
 ;;9002226.02101,"1804,06HY03Z ",.02)
 ;;06HY03Z 
 ;;9002226.02101,"1804,06HY03Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HY33Z ",.01)
 ;;06HY33Z 
 ;;9002226.02101,"1804,06HY33Z ",.02)
 ;;06HY33Z 
 ;;9002226.02101,"1804,06HY33Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06HY43Z ",.01)
 ;;06HY43Z 
 ;;9002226.02101,"1804,06HY43Z ",.02)
 ;;06HY43Z 
 ;;9002226.02101,"1804,06HY43Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06JY0ZZ ",.01)
 ;;06JY0ZZ 
 ;;9002226.02101,"1804,06JY0ZZ ",.02)
 ;;06JY0ZZ 
 ;;9002226.02101,"1804,06JY0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,06JY3ZZ ",.01)
 ;;06JY3ZZ 
 ;;9002226.02101,"1804,06JY3ZZ ",.02)
 ;;06JY3ZZ 
 ;;9002226.02101,"1804,06JY3ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,06JY4ZZ ",.01)
 ;;06JY4ZZ 
 ;;9002226.02101,"1804,06JY4ZZ ",.02)
 ;;06JY4ZZ 
 ;;9002226.02101,"1804,06JY4ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,06JYXZZ ",.01)
 ;;06JYXZZ 
 ;;9002226.02101,"1804,06JYXZZ ",.02)
 ;;06JYXZZ 
 ;;9002226.02101,"1804,06JYXZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,06PYX0Z ",.01)
 ;;06PYX0Z 
 ;;9002226.02101,"1804,06PYX0Z ",.02)
 ;;06PYX0Z 
 ;;9002226.02101,"1804,06PYX0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06PYX2Z ",.01)
 ;;06PYX2Z 
 ;;9002226.02101,"1804,06PYX2Z ",.02)
 ;;06PYX2Z 
 ;;9002226.02101,"1804,06PYX2Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06PYX3Z ",.01)
 ;;06PYX3Z 
 ;;9002226.02101,"1804,06PYX3Z ",.02)
 ;;06PYX3Z 
 ;;9002226.02101,"1804,06PYX3Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06PYXDZ ",.01)
 ;;06PYXDZ 
 ;;9002226.02101,"1804,06PYXDZ ",.02)
 ;;06PYXDZ 
 ;;9002226.02101,"1804,06PYXDZ ",.03)
 ;;31
 ;;9002226.02101,"1804,06WYX0Z ",.01)
 ;;06WYX0Z 
 ;;9002226.02101,"1804,06WYX0Z ",.02)
 ;;06WYX0Z 
 ;;9002226.02101,"1804,06WYX0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06WYX2Z ",.01)
 ;;06WYX2Z 
 ;;9002226.02101,"1804,06WYX2Z ",.02)
 ;;06WYX2Z 
 ;;9002226.02101,"1804,06WYX2Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06WYX3Z ",.01)
 ;;06WYX3Z 
 ;;9002226.02101,"1804,06WYX3Z ",.02)
 ;;06WYX3Z 
 ;;9002226.02101,"1804,06WYX3Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06WYX7Z ",.01)
 ;;06WYX7Z 
 ;;9002226.02101,"1804,06WYX7Z ",.02)
 ;;06WYX7Z 
 ;;9002226.02101,"1804,06WYX7Z ",.03)
 ;;31
 ;;9002226.02101,"1804,06WYXCZ ",.01)
 ;;06WYXCZ 
 ;;9002226.02101,"1804,06WYXCZ ",.02)
 ;;06WYXCZ 
 ;;9002226.02101,"1804,06WYXCZ ",.03)
 ;;31
 ;;9002226.02101,"1804,06WYXDZ ",.01)
 ;;06WYXDZ 
 ;;9002226.02101,"1804,06WYXDZ ",.02)
 ;;06WYXDZ 
 ;;9002226.02101,"1804,06WYXDZ ",.03)
 ;;31
 ;;9002226.02101,"1804,06WYXJZ ",.01)
 ;;06WYXJZ 
 ;;9002226.02101,"1804,06WYXJZ ",.02)
 ;;06WYXJZ 
 ;;9002226.02101,"1804,06WYXJZ ",.03)
 ;;31
 ;;9002226.02101,"1804,06WYXKZ ",.01)
 ;;06WYXKZ 
 ;;9002226.02101,"1804,06WYXKZ ",.02)
 ;;06WYXKZ 
 ;;9002226.02101,"1804,06WYXKZ ",.03)
 ;;31
 ;;9002226.02101,"1804,072KX0Z ",.01)
 ;;072KX0Z 
 ;;9002226.02101,"1804,072KX0Z ",.02)
 ;;072KX0Z 
 ;;9002226.02101,"1804,072KX0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,072KXYZ ",.01)
 ;;072KXYZ 
 ;;9002226.02101,"1804,072KXYZ ",.02)
 ;;072KXYZ 
 ;;9002226.02101,"1804,072KXYZ ",.03)
 ;;31
 ;;9002226.02101,"1804,072LX0Z ",.01)
 ;;072LX0Z 
 ;;9002226.02101,"1804,072LX0Z ",.02)
 ;;072LX0Z 
 ;;9002226.02101,"1804,072LX0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,072LXYZ ",.01)
 ;;072LXYZ 
 ;;9002226.02101,"1804,072LXYZ ",.02)
 ;;072LXYZ 
 ;;9002226.02101,"1804,072LXYZ ",.03)
 ;;31
 ;;9002226.02101,"1804,072MX0Z ",.01)
 ;;072MX0Z 
 ;;9002226.02101,"1804,072MX0Z ",.02)
 ;;072MX0Z 
 ;;9002226.02101,"1804,072MX0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,072MXYZ ",.01)
 ;;072MXYZ 
 ;;9002226.02101,"1804,072MXYZ ",.02)
 ;;072MXYZ 
 ;;9002226.02101,"1804,072MXYZ ",.03)
 ;;31
 ;;9002226.02101,"1804,072NX0Z ",.01)
 ;;072NX0Z 
 ;;9002226.02101,"1804,072NX0Z ",.02)
 ;;072NX0Z 