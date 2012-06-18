XBDIR ; IHS/ADC/GTH - DIR INTERFACE ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; The purpose of routine XBDIR is to provide interface
 ; methodology for a call to ^DIR, to ensure correct handling
 ; of variables, and to provide for the expressiveness of an
 ; extrinsic function.
 ;
 ; There is no requirement to use the entry point, below.
 ;
 ; The format of the call is to SET a local variable to the
 ; output of the call to DIR^XBDIR(), which will be Y at the
 ; bottom of this routine, or, less likely, WRITE the value.
 ;
 ; An example of the call is:
 ;            S %=$$DIR^XBDIR(<actual_parameter_list>)
 ; where the <actual_parameter_list> is:
 ;(DIR(0),DIR("A"),DIR("B"),DIR("T"),DIR("?"),DIR("??"),<skip>)
 ; where <skip> is the number of lines to skip before the call
 ; to ^DIR.
 ;
 ; Examples:
 ;
 ; S %=$$DIR^XBDIR("N^1:2","Select report method",2,"","Produ
 ; ce report by FY or Dates","^D HELP^<your_routine>",300,2)
 ;
 ; S <namespace>FY=$$DIR^XBDIR("NO","Object Class Code Summar
 ; y for FISCAL YEAR ",FY,$G(DTIME,500),"Enter a FOUR DIGIT F
 ; ISCAL YEAR","^D SB1^<your_routine>")
 ;
 ;
DIR(O,A,B,T,Q,H,R) ;PEP - Extrinsic interface to ^DIR.
 I '$L($G(O)) Q -1
 NEW DA,DIR
 S DIR(0)=O
 I $D(A) D
 . I $L($G(A)) S DIR("A")=A
 . I $L($O(A(""))) S O="" F  S O=$O(A(O)) Q:'$L(O)  S DIR("A",O)=A(O)
 .Q
 I $L($G(B)) S DIR("B")=B
 I $G(T) S DIR("T")=T
 I $D(Q) D
 . I $L($G(Q)) S DIR("?")=Q
 . I $L($O(Q(""))) S O="" F  S O=$O(Q(O)) Q:'$L(O)  S DIR("?",O)=Q(O)
 .Q
 I $L($G(H)) S DIR("??")=H
 I $G(R) F A=1:1:R W !
 KILL O,A,B,T,Q,H,R,DTOUT,DUOUT,DIRUT,DIROUT
 D ^DIR
 Q Y
 ;
