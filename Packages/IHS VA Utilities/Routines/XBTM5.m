XBTM5 ; IHS/ADC/GTH - TECH MANUAL : FIELDS IN THE FILES ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 NEW A,B,C,I,J
 F A=1:1 S X=$P($T(PR+A),";;",2) Q:X="###"  D PR(X) Q:$D(DUOUT)
 Q:$D(DUOUT)
 D ^DIWW
 KILL ^TMP("XBTM-FIF",$J)
 S DIWF="WN"
 D PR($J("",5)_"These are the files in the package:")
 Q:$D(DUOUT)
 D ALPHA
 D PR($J("",5)),PR($J("",5)),PR($J("",5)_"These are the alphabetized fields in the files :")
 Q:$D(DUOUT)
 S DIWF="W",(A,B,I,J)=""
 F  S A=$O(^TMP("XBTM-FIF",$J,A)) Q:A=""  S B=$O(^(A,0)),I=$O(^(B,0)) D  Q:$D(DUOUT)
 . D PR(A_$E($J("",40),1,(40-$L(A)))_B_$E($J("",12),1,(12-$L(B)))_I),^DIWW
 . S J=J+1
 .Q
 Q:$D(DUOUT)
 D PR($J("",5)),PR($J("",5)),PR($J("",3)_"There are "_+J_" fields in the package files.")
 Q:$D(DUOUT)
 D ^DIWW
 Q
 ;
PR(X) NEW %,A,B,C,I,J D PR^XBTM(X) Q
 ;;No files are distributed with this package.  Any fields listed,
 ;;below, will have been created locally.  The list will be
 ;;an alphabetical list of fields in the package's files.
 ;;|SETTAB("C")||TAB| 
 ;;|SETTAB("C")||TAB| 
 ;;###
 ;
ALPHA ;
 NEW XBFLD,XBPIEN
 S XBPIEN=$O(^DIC(9.4,"C","XB",0))
 S %=0
 F  S %=$O(^DIC(9.4,XBPIEN,4,"B",%)) Q:'%   D PR(%_$E("     ",1,(12-$L(%)))_$O(^DD(%,0,"NM",""))) Q:$D(DUOUT)  D FLD
 Q
 ;
FLD ;
 S XBFLD=0
 F  S XBFLD=$O(^DD(%,XBFLD)) Q:'XBFLD  D
 .I +$P(^DD(%,XBFLD,0),U,2) S XB=+$P(^(0),U,2) D  Q
 ..NEW %,XBFLD
 ..S %=XB
 ..D FLD
 ..Q
 .S ^TMP("XBTM-FIF",$J,$P(^DD(%,XBFLD,0),U),%,XBFLD)=""
 .Q
 Q
 ;
