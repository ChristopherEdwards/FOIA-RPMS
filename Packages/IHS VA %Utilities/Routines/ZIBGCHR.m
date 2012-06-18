ZIBGCHR ; IHS/ADC/GTH - SEARCH FOR CONTROL CHAR. IN GLOBALS ; [ 10/29/2002   7:42 AM ]
 ;;3.0;IHS/VA UTILITIES;**9**;FEB 07, 1997
 ; XB*3*9 IHS/SET/GTH XB*3*9 10/29/2002 Cache' mods.
 ;
%GLCHR ;SEARCH FOR CONTROL CHAR. IN GLOBALS [ 04/15/85  9:13 AM ]
%ST ;
 S %DEF=0,%TRM=$I,%TMO=60      ;,$ZE="%ERR^%GL"
%STL ;
 I $D(%IOD) C:%IOD'=%TRM %IOD
 S %QTY=2
 D ^%ZIS
 G:'$D(IO) %END
 S %DEF=IO,%PAG=IOSL-4
 ;I "SC^LP^TRM"'[%DTY!(%DTY="") W !?5,"Improper device selection.",!?5,"Must choose a terminal, a printer, or the system console." G %ST
%SCR ;
 S %LN=132
 ;S:IOT="TRM" %LN=80 ;IHS/SET/GTH XB*3*9 10/29/2002
 S:IOT["TRM" %LN=80 ;IHS/SET/GTH XB*3*9 10/29/2002
 ;I IOT'="TRM" S %SC=0,%DCC=2 G %DO ;IHS/SET/GTH XB*3*9 10/29/2002
 I IOT'["TRM" S %SC=0,%DCC=2 G %DO ;IHS/SET/GTH XB*3*9 10/29/2002
IHS1 ;
 S %SC=0,%DCC=2,TGL=0
 G %DO
 ;
 ;  -- UNreachable code follows (?) GTH 07-06-95
 R !,"Scroll ? <N> ",%SC:%TMO
 G:%SC="?" %Q1
 G:%SC="^"!('$T) %STL
 G:%SC="^Q" %END
 S:%SC="" %SC="N"
 I "Y^N"'[$E(%SC) W "   'Y' or 'N'" G %SCR
 S %SC=($E(%SC)="Y"),%PAG=20
%PAG ;
 G:'%SC %ASKC
 W !,"Lines/Page <",%PAG R "> ",%X:%TMO
 G:%X="^"!('$T) %SCR
 G:%X="^Q" %END
 S:%X="" %X=%PAG
 I %X'?1N.N!(%X<1) G %Q2
 S %PAG=%X
%ASKC ;
 R !,"Do you want to display control characters ? <NO> ",%X:%TMO
 G:%X="?" %Q3
 G:%X="^Q" %END
 S:%X="" %X="NO"
 I %X="^"!('$T) G:%SC %PAG G:%DTY'="TRM" %STL G %SCR
 I "Y^N"'[$E(%X) W "   'Y' or 'N'" G %ASKC
 I $E(%X)="N" S %DCC=0 G %DO
%OPT ;
 W !,"Specify one of the following:",!?5,"1. Line display",!?5,"2. Block display (with ASCII codes)"
%OPT1 ;
 R !,"Display type <1> ",%X:%TMO
 G:%X="?" %HELP
 G:%X="^"!('$T) %ASKC
 G:%X="^Q" %END
 S:%X="" %X=1
 I %X'=1,%X'=2 G %OPT
 S %DCC=%X
%DO ;
 D %START
 C:IO'=%TRM IO
 G %END
 ;
%START ;
 S %NCR=%LN-5,%BAR="\"
 ;D ^%GSEL ;IHS/SET/GTH XB*3*9 10/29/2002
 I $ZV["MSM" D ^%GSEL ;IHS/SET/GTH XB*3*9 10/29/2002
 I $ZV["Cache" D ^%GSET ;IHS/SET/GTH XB*3*9 10/29/2002
 S (%GL,%GN)="",%LIN=0
 ;I $ZS(^UTILITY($J,%GL))="" Q ;IHS/SET/GTH XB*3*9 10/29/2002
 I $O(^UTILITY($J,%GL))="" Q  ;IHS/SET/GTH XB*3*9 10/29/2002
 U IO
 D %GET
 S %LC=1
 D %LIN
 W #
 U IO
 G %START
 ;
%GET ;
 KILL %DX,%CK,FLG
 ;S %GN=$ZS(^UTILITY($J,%GN)) ;IHS/SET/GTH XB*3*9 10/29/2002
 S %GN=$O(^UTILITY($J,%GN)) ;IHS/SET/GTH XB*3*9 10/29/2002
 Q:%GN=""
 S GLREF=^UTILITY($J,%GN)
 I GLREF="" S %CK="" G %WT
 D %START^%GL1
 Q
 ;
%WT ;
 S %GL="^"_%GN
 S %LC=2
 D %LIN
 W %GL
 I $D(@%GL)#2 S IN=@%GL I IN]"" W " = " D %OUT
 S %LC=1
 D %LIN
 S %GL=%GL_"("""")"
%NEXT ;
 ;S %GL=$ZN(@%GL) ;IHS/SET/GTH XB*3*9 10/29/2002
 S %GL=$Q(@%GL) ;IHS/SET/GTH XB*3*9 10/29/2002
 ;G:%GL=-1 IHS3 ;IHS/SET/GTH XB*3*9 10/29/2002
 G:%GL="" IHS3 ;IHS/SET/GTH XB*3*9 10/29/2002
 S IN=@%GL
 I IN?.E1C.E S TGL=TGL+1 W %GL," = " D %OUT
IHS2 ;
 G %NEXT
 ;
IHS3 ;
 U IO
 W !!,"TOTAL CORRUPT GLOBALS FOUND: ",TGL
 D PAUSE^XB
 S TGL=0
 G %GET
 ;
%OUT ;
 I '(IN?.E1C.E) G %OUT1
 D:%DCC=1 %DSP1
 D:%DCC=2 %DSP2
%OUT1 ;
 S %LC=1
 D %LIN
 Q
 ;
%DSP1 ;
 F I=1:1:$L(IN) S %CHR=$E(IN,I) D %WRT
 Q
 ;
%WRT ;
 I $A(%CHR)<32 W %BAR Q
 I $A(%CHR)=92 W "\\" Q
 W %CHR
 Q
 ;
%DSP2 ;
 F I=1:1:4 S A(I)=""
 F I=1:1:$L(IN) S %CHR=$E(IN,I) D:$A(%CHR)<32 %CTL D:$A(%CHR)'<32 %NML
 S %FCR=1,%NLN=($L(IN)-1)\%NCR+1
 F I=1:1:%NLN S %LCR=%FCR+%NCR-1 D %LST
 Q
 ;
%CTL ;
 S A(1)=A(1)_%BAR
 D %FIXO
 F K=2:1:4 S A(K)=A(K)_$E(%ASCII,K-1)
 Q
 ;
%NML ;
 S A(1)=A(1)_%CHR
 D %FIXO
 F K=2:1:4 S A(K)=A(K)_$E(%ASCII,K-1)
 Q
 ;
%FIXO ;
 S %ALN=3-$L($A(%CHR)),%ASCII=$A(%CHR)
 F M=1:1:%ALN S %ASCII="0"_%ASCII
 KILL %ALN
 Q
 ;
%LST ;
 I $D(%SC) D:%LIN+4>%PAG %SC
 F %J=1:1:4 S %LC=1 D %LIN W ?3,$E(A(%J),%FCR,%LCR)
 S %LC=1
 D %LIN
 S %FCR=%LCR+1
 Q
 ;
%LIN ;
 I $D(%SC) D:%LIN+%LC>%PAG %SC S %LIN=%LIN+%LC
 F %K=1:1:%LC W !
 Q
 ;
%SC ;
 U 0
 R !,"Type <CR> to continue",%X:60
 S:'$T %X="^"
 U IO
 S %LIN=0
 Q
 ;
%HELP ;
 W !!?5,"Enter '1' to display control characters as ""\""."
 W !?5,"Enter '2' to also display the ASCII code below each character."
 W !?8,"Example:  ^AA(""1"",""3"",""5"") ="
 W !?22,"AB\C\\DEF",!?22,"000000000",!?22,"661612667",!?22,"562773890"
 D %EX
 G %OPT1
 ;
%Q1 ;
 W !?5,"Enter Y(ES) to specify the number of lines to be displayed per page"
 W !?8,"or N(O) to have a continuous display."
 D %EX
 G %SCR
 ;
%Q2 ;
 W !?5,"Enter the number of lines to be displayed per page."
 W !?5,"(Should not exceed 20 lines per page for video terminals.)"
 D %EX
 G %PAG
 ;
%Q3 ;
 W !?5,"Enter Y(ES) for special treatment of control characters upon output.",!?5,"Otherwise enter N(O)."
 D %EX
 G %ASKC
 ;
%EX ;
 W !?5,"Enter  ^ to return to the previous question,",!?8,"or ^Q to exit the routine."
 Q
 ;
%ERR ;
 U 0
 I $ZE?1"<INRPT".E W !?5,"Unexpected interrupt",!
 E  W !,$ZE,!
%END ;
 I $D(IO) C:IO'=%TRM IO
 KILL %ASCII,%BAR,%CHR,%CK,%DCC,%DCF,%DEF,%DTY,%FCR,%GL,%GN,%GO,%IOD,%K,%LC,%LCR,%LIN,%LN,%NCR,%NLN,%PAG,%QTY,%SC,%ST,%TMO,%TRM,%UCIN,%X,A,GLREF,I,IN,K,M,TGL
 Q
 ;
