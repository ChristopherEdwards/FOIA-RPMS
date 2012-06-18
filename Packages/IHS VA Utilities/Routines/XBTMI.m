XBTMI ; IHS/ADC/GTH - TECH MANUAL : INDEXED WORDS; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 KILL ^TMP("XBTM-I",$J)
 NEW A,I
 D ALPHA
 F %=19,19.1 S A="XAz" F  S A=$O(^DIC(%,"B",A)) Q:'($E(A,1,2)="XB")  S ^TMP("XBTM-I",$J,A)=""
 F %=19,19.1 S A="ZIAz" F  S A=$O(^DIC(%,"B",A)) Q:'($E(A,1,3)="ZIB")  S ^TMP("XBTM-I",$J,A)=""
 F %=1:1 S A=$P($T(1+%),";;",2) Q:A=""  S ^TMP("XBTM-I",$J,A)=""
 KILL ^TMP("XBTMI",$J)
 S %=$$RSEL^ZIBRSEL("XB*","^TMP(""XBTMI"",$J,"),%=$$RSEL^ZIBRSEL("ZIB*","^TMP(""XBTMI"",$J,")
 S %=""
 F  S %=$O(^TMP("XBTMI",$J,%)) Q:%=""  S ^TMP("XBTM-I",$J,%)="" F I=3:1 S A=$T(+I^@%) Q:A=""  I $L($P(A," ")),A[";EP"!(A["ENTRY POINT")!(A[";PEP") S ^TMP("XBTM-I",$J,$P(A," ")_U_%)=""
 KILL ^TMP("XBTMI",$J)
 Q
 ;
ALPHA ;
 NEW XBFLD,XBPIEN
 S XBPIEN=$O(^DIC(9.4,"C","XB",0))
 S %=0
 F  S %=$O(^DIC(9.4,XBPIEN,4,"B",%)) Q:'%  D FLD
 Q
 ;
FLD ;
 S XBFLD=0
 F  S XBFLD=$O(^DD(%,XBFLD)) Q:'XBFLD  D
 .I +$P(^DD(%,XBFLD,0),U,2) S XB=+$P(^(0),U,2) D  Q
 ..NEW %,XBFLD S %=XB D FLD
 ..Q
 .S ^TMP("XBTM-I",$J,$P(^DD(%,XBFLD,0),U))=""
 .Q
 Q
 ;
1 ;; 
 ;;CONTROL
 ;;GUI
 ;;LIST
 ;;STANDARDS
 ;;VIDEO
