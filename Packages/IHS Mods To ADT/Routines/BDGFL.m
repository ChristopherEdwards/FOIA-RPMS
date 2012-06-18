BDGFL ; IHS/ANMC/LJF - GENERAL LIST MGR FUNCTIONS ; [ 02/20/2003  8:43 AM ]
 ;;5.3;PIMS;;APR 26, 2002
 ;
GETITEM(SUB,MODE) ; -- select item from list
 NEW X,Y,Z,RESULT
 S RESULT=""
 D EN^VALM2(XQORNOD(0),MODE)
 I '$D(VALMY) Q 0  ;IHS/ITSC/WAR 2/19/03 added the zero '0' WAR11 P52
 S X=0 F  S X=$O(VALMY(X)) Q:X=""  D
 . S Y=0 F  S Y=$O(^TMP(SUB,$J,"IDX",Y)) Q:Y=""  D
 .. S Z=$O(^TMP(SUB,$J,"IDX",Y,0))
 .. Q:^TMP(SUB,$J,"IDX",Y,Z)=""
 .. I Z=X S RESULT=RESULT_^TMP(SUB,$J,"IDX",Y,Z)_","
 Q RESULT
 ;
RETURN ;EP; -- reset listman
 D TERM^VALM0 S VALMBCK="R" Q
 ;
LMKILL ;EP; -- kills IO and VALM variables used by List Manager
 D KILL^%ZISS,EN^XBVK("VALM"),EN^XBVK("XQOR")
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
