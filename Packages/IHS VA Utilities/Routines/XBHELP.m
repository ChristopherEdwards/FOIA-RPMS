XBHELP ; IHS/ADC/GTH - DISPLAY HELP TEXT FROM ROUTINE ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ;  Display text from the named routine, beginning at the
 ;  named label.  The fourth semi-colon piece is displayed.
 ;  If the third semi-colon piece is "@", the indirection
 ;  of the fourth semi-colon piece is written.  The display
 ;  ends if null or "###" is returned.
 ;
 ;  E.g:
 ;
 ;  D HELP^XBHELP("LABEL","ROUTINE",0) will print the text
 ;  after LABEL:
 ;
 ;       ROUTINE ;
 ;       LABEL ;
 ;             ;;Please enter what I think you should enter.
 ;             ;;@;*7
 ;             ;;@;!
 ;             ;;###
 ;
HELP(L,R,T) ;PEP - Display text at label L, routine R, tab T spaces (default 4).
 Q:$D(ZTQUEUED)
 S:$G(T)'?1.N T=4
 NEW X
 W !
 F %=1:1 S X=$T(@L+%^@R) Q:($P(X,";",3)="###")!(X="")  D
 . I $P(X,";",3)="@" W @($P(X,";",4)) Q
 . W !?T,$P(X,";",3)
 .Q
 Q
 ;
