XBDATE ; IHS/ADC/GTH - ADAPTATION OF %RS TO SELECT ROUTINES EDITED AFTER SPECIFIED DATE ; [ 10/29/2002   7:42 AM ]
 ;;3.0;IHS/VA UTILITIES;**9**;FEB 07, 1997
 ;XB*3*9 IHS/SET/GTH XB*3*9 10/29/2002 Cache' mods.
 ;
 ; Thanks to Tom Love, DSD, for providing the original routine.
 ;
 ; This routine limits routines selected by RSEL to routines
 ; edited after some date.
 ;
START ;
 I '$D(DT) D NOW^%DTC S DT=X
 S DIR(0)="D^::EX" ;2800101:"_DT_":EX"
 S DIR("A")="Date of last edit"
 S Y=DT
 X ^DD("DD")
 S DIR("B")=Y
 W !!,XBTYPE," ROUTINES edited on or after the following date:",!
 D DIR
 Q:$D(QUIT)
 S XBDAT=Y
 W !!,"One moment please, checking selected routines for last edit date.",!
 ;Begin mod/add 2 lines;IHS/SET/GTH XB*3*9 10/29/2002
 I $$VERSION^%ZOSV(1)["MSM" D
 . S XB="S RTN="""" F  S RTN=$O(^UTILITY($J,RTN)) Q:RTN=""""  ZL @RTN S X=$T(@RTN),X=$P($P(X,""[ "",2),"" "") D ^%DT K:Y<1!(Y<XBDAT) ^UTILITY($J,RTN) I Y>0,((XBDAT=Y)!(Y>XBDAT)) X ^DD(""DD"") W !,RTN,?10,""last edited on "",Y"
 I $$VERSION^%ZOSV(1)["Cache" D
 . S XB="S RTN=0 F  S RTN=$O(^UTILITY($J,RTN)) Q:RTN=""""  S X=$P($$DATE^%R(RTN_"".INT"",1),"" "") D ^%DT K:Y<1!(Y<XBDAT) ^UTILITY($J,RTN) I Y>0,((XBDAT=Y)!(Y>XBDAT)) X ^DD(""DD"") W !,RTN,?10,""last edited on "",Y"
 ;S XB="S RTN="""" F  S RTN=$O(^UTILITY($J,RTN)) Q:RTN=""""  ZL @RTN S X=$T(@RTN),X=$P($P(X,""[ "",2),"" "") D ^%DT K:Y<1!(Y<XBDAT) ^UTILITY($J,RTN) I Y>0,((XBDAT=Y)!(Y>XBDAT)) X ^DD(""DD"") W !,RTN,?10,""last edited on "",Y"
 ;End mod/add 2 lines;IHS/SET/GTH XB*3*9 10/29/2002
 X XB
 I $O(^UTILITY($J,""))="" S Y=XBDAT X ^DD("DD") S XBDAT=Y,QUIT="" Q
 S DIR(0)="YO",DIR("A")="Proceed with "_XBTYPE,DIR("B")="NO"
 W !
 D DIR
 S:Y'=1 QUIT=""
 KILL XBDAT
 Q
 ;
DIR ;
 D ^DIR
 S:$D(DIRUT) QUIT=""
 KILL DIR,DIRUT,DUOUT,DTOUT
 Q
 ;
