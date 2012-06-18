ZIBRSEL ; IHS/ADC/GTH - NONINTERACTIVE ROUTINE SELECT ; [ 10/29/2002   7:42 AM ]
 ;;3.0;IHS/VA UTILITIES;**4,9**;FEB 07, 1997
 ; XB*3*4 IHS/ADC/GTH 05-22-97 Prevent <INDER> err.
 ; XB*3*9 IHS/SET/GTH XB*3*9 10/29/2002 Cache' mods.
 ;
 ; Return the number of selected routines set into the
 ; indicated variable.
 ;
 ; E.g.:
 ; I '$$RSEL^ZIBRSEL("B-BZZZZZZZ","ARRAY(") W "NONE SELECTED" Q
 ;
 ; If routines exists in the list or range, their name will
 ; be returned as the last subscript of indicated variable in
 ; the 2nd parameter.  The default is ^TMP("ZIBRSEL",$J,
 ;
 ; If routine B exists, then node ^TMP("ZIBRSEL",$J,"B") will
 ; be null.
 ;
 ; It is the programmer's responsibility to ensure the name
 ; of the array is correctly formed.
 ;
 ;        Variables used:
 ; X = String indicating list or range of routines.
 ; Y = String indicating variable into which to set the
 ;     selected routines.  Default = ^TMP("ZIBRSEL",$J,
 ; F = First routine, if range.
 ; L = Last routine, if range.
 ; N = Number of routines returned.
 ; Q = Quote character.
 ;
 Q
 ;
RSEL(X,Y) ;PEP - Select a list or range of routines, return in Y, # sel in N.
 I '$L($G(X)) Q "NO ROUTINES SPECIFIED IN PARAMETER"
 NEW F,L,N,O,Q
 ; S O=$P(^%ZOSF("OS"),"-",1) ; XB*3*4 IHS/ADC/GTH 05-22-97 Prevent <INDER> err.
 ;S O=$P(^%ZOSF("OS"),"^",1) ; XB*3*4 IHS/ADC/GTH 05-22-97 Prevent <INDER> err. ;IHS/SET/GTH XB*3*9 10/29/2002
 ;I O["MSM" S O="MSM" ; XB*3*4 IHS/ADC/GTH 05-22-97 Prevent <INDER> err. ;IHS/SET/GTH XB*3*9 10/29/2002
 ;E  S O="unknown" ; XB*3*4 IHS/ADC/GTH 05-22-97 Prevent <INDER> err. ;IHS/SET/GTH XB*3*9 10/29/2002
 ;I '$L($T(@O)) Q "OPERATING SYSTEM '"_O_"' NOT SUPPORTED." ;IHS/SET/GTH XB*3*9 10/29/2002
 S O=$$VERSION^%ZOSV(1),O=$P(O," ") ;IHS/SET/GTH XB*3*9 10/29/2002
 I '(O["Cache"),'(O["MSM") Q "OPERATING SYSTEM '"_O_"' NOT SUPPORTED."  ;IHS/SET/GTH XB*3*9 10/29/2002
 I '$L($G(Y)) KILL ^TMP("ZIBRSEL",$J) S Y="^TMP(""ZIBRSEL"","_$J_","
 S F=$P(X,"-"),L=$P(X,"-",2),N=0,Q=""""
 I '(F]"") Q 0
 I F["*" S F=$P(F,"*"),L="*",X=$P(X,"*")
 ;D @O ;IHS/SET/GTH XB*3*9 10/29/2002
 D DIR ;IHS/SET/GTH XB*3*9 10/29/2002
 Q N
 ;
DIR ; Check the directory ;IHS/SET/GTH XB*3*9 10/29/2002
MSM ; Micronetics Standard MUMPS.
 ;I F]"",$D(^ (F)) S N=N+1,@(Y_Q_F_Q_")")="" ;IHS/SET/GTH XB*3*9 10/29/2002
 I F]"",$D(^$R(F)) S N=N+1,@(Y_Q_F_Q_")")="" ;IHS/SET/GTH XB*3*9 10/29/2002
 I L="*" D  Q
 . ; F  S F=$O(^ (F)) Q:F=""!('(X=$E(F,1,$L(X))))  S N=N+1,@(Y_Q_F_Q_")")="" ;IHS/SET/GTH XB*3*9 10/29/2002
 . F  S F=$O(^$R(F)) Q:F=""!('(X=$E(F,1,$L(X))))  S N=N+1,@(Y_Q_F_Q_")")="" ;IHS/SET/GTH XB*3*9 10/29/2002
 .Q
 ; F  S F=$O(^ (F)) Q:F=""!(F]L)  S N=N+1,@(Y_Q_F_Q_")")="" Q:L="" ;IHS/SET/GTH XB*3*9 10/29/2002
 F  S F=$O(^$R(F)) Q:F=""!(F]L)  S N=N+1,@(Y_Q_F_Q_")")="" Q:L=""  ;IHS/SET/GTH XB*3*9 10/29/2002
 Q
 ;
