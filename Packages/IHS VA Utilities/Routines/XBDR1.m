XBDR1 ; IHS/ADC/GTH - XBDR SUBROUTINE; [ 10/29/2002   7:42 AM ]
 ;;3.0;IHS/VA UTILITIES;**9**;FEB 07, 1997
 ; XB*3*9 IHS/SET/GTH XB*3*9 10/29/2002 Prevent <LINER>
 ;
 ; Part of XBDR
 ;
TYPE ;
 S DIR("A")="Input data type"
 S DIR(0)="S^D:DATE;E:END-OF-PAGE;F:FREE TEXT;L:LIST OR RANGE;N:NUMERIC;S:SET;Y:YES/NO;Z:FILEMAN"
 D ^DIR KILL DIR
 I $D(DIRUT) S XBDRQUIT="" Q
 ;S XBDRTYPE=X;IHS/SET/GTH XB*3*9 10/29/2002
 S (XBDRTYPE,X)=$$UP^XLFSTR(X) ;IHS/SET/GTH XB*3*9 10/29/2002
 D @X
 I $D(XBDRQUIT) Q
 I XBDRTYPE'?1.4U Q
 S DIR("A")="Is this query mandatory",DIR("B")="NO",DIR(0)="Y"
 D ^DIR KILL DIR
 X XBDROUT
 I  S XBDRQUIT="" Q
 I "yY"'[$E(X) S XBDRTYPE=XBDRTYPE_"O"
 Q
 ;
E ;
Y ;
 Q
 ;
MINMAX ;
 S DIR("A")="Minimum "_Z_" allowed",DIR(0)="NO^::7"
 D ^DIR
 KILL DIR
 X XBDROUT
 I  S XBDRQUIT="" Q
 S XBDRMIN=X,DIR("A")="Maximum "_Z_" allowed",DIR(0)="NO^::7"
 D ^DIR
 KILL DIR
 X XBDROUT
 I  S XBDRQUIT="" Q
 S XBDRMAX=X
 Q
 ;
F ;
 S Z="length"
 D MINMAX
 Q
 ;
L ;
 S Z="value"
 D MINMAX
 Q
 ;
N ;
 S Z="value"
 D MINMAX
 S DIR("A")="Maximum number of decimal places",DIR(0)="NO^0:9"
 D ^DIR
 KILL DIR
 X XBDROUT
 I  S XBDRQUIT="" Q
 S XBDRSPEC=X
 Q
 ;
S ;
 S XBDRMIN=""
 F L=0:0 D S1 Q:X=""
 I XBDRMIN="" S XBDRQUIT="" Q
 I '$D(XBDRQUIT) D S2
 Q
 ;
S1 ;
 W !
 S DIR("A")="Code",DIR(0)="FO"
 D ^DIR
 KILL DIR
 X XBDROUT
 I  S XBDRQUIT="",X="" Q
 I X="" Q
 S Z=X,DIR("A")="Stands for",DIR(0)="F"
 D ^DIR
 KILL DIR
 X XBDROUT
 I  S XBDRQUIT="",X="" Q
 S:XBDRMIN]"" XBDRMIN=XBDRMIN_";"
 S XBDRMIN=XBDRMIN_Z_":"_X
 I $L(XBDRMIN)>240 W *7,"  DIR STRING TOO LONG...SESSION ABORTED" S XBDRQUIT="",X=""
 Q
 ;
S2 ;
 S DIR("A")="Possible choices should be listed which format"
 S DIR("B")="VERTICAL"
 S DIR(0)="SB^H:HORIZONTAL;V:VERTICAL;"
 W !
 D ^DIR
 KILL DIR
 X XBDROUT
 I  S XBDRQUIT=""
 I $E(X)="H" S XBDRTYPE=XBDRTYPE_"B"
 Q
 ;
D ;
 S DIR("A")="Enter earliest date",DIR(0)="DO^::ETS"
 D ^DIR
 KILL DIR
 X XBDROUT
 I  S XBDRQUIT="" Q
 S XBDRMIN=Y
 S DIR("A")="Enter maximum date",DIR(0)="DO^"_XBDRMIN_"::ETS"
 D ^DIR
 KILL DIR
 X XBDROUT
 I  S XBDRQUIT="" Q
 S XBDRMAX=Y
DTS ;
 W !!!,"Enter the %DT string using as many of the following as you wish:",!!
 S X="F;Future dates assumed^N;Numeric input not allowed^P;Past dates assumed^R;Time required^T;Time allowed^X;Exact time required^S;Seconds allowed"
 F I=1:1 S Y=$P(X,U,I) Q:Y=""  W $P(Y,";"),"   ",$P(Y,";",2),!
ADTS ;
 S DIR("A")="%DT String",DIR(0)="FO"
 D ^DIR
 KILL DIR
 X XBDROUT
 I  S XBDRQUIT="" Q
 I X="" S XBDRSPEC="E" Q
 I X'?1.9U W *7,"  ??" G ADTS
 S XBDRSPEC="E"_X
 Q
 ;
Z ;
 S DIC=1,DIC(0)="AEQ",DIC("A")="Enter FILE name: "
 W !
 D ^DIC
 KILL DIC
 I Y=-1 S XBDRQUIT="" Q
 S Z=+Y,DIC="^DD("_+Y_",",DIC(0)="AEQ",DIC("A")="Enter FIELD name: "
 D ^DIC
 KILL DIC
 I Y=-1 S XBDRQUIT="" Q
 S XBDRTYPE=Z_","_+Y,XBDRRUN=5
 Q
 ;
