ABSPOSN7 ; IHS/FCS/DRS - NCPDP Fms F ILC A/R ;   [ 09/12/2002  10:17 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ;----------------------------------------------------------------------
WCENTER(TEXT,MARGIN) ;
 W ?MARGIN-$L(TEXT)/2,TEXT,!
 Q
 ;----------------------------------------------------------------------
 ;Display screen header
HEADER(TEXT) ;EP
 W @IOF
 W !
 D WCENTER(TEXT,80)
 D WCENTER($TR($J("",$L(TEXT))," ","-"),80)
 Q
 ;----------------------------------------------------------------------
 ;Device PROMPT (returns %ZIS variables eg: IOM, IOSL, IOF....)
DEVICE(PROMPT,EXIT) ;EP
 N %ZIS,POP
 W !!
 S %ZIS=""
 S %ZIS("A")=PROMPT
 S %ZIS("B")=""
 D ^%ZIS
 I POP S EXIT=1 Q
 U IO
 Q
 ;---------------------------------------------------------------------
YNPROMPT(PROMPT,DFLT) ;EP 
 N %,%Y,U
 S U="^"
 S %=$S(DFLT="Yes":1,DFLT="No":2,1:0)
 W PROMPT
 D YN^DICN
 Q $S(%=1:"Yes",%=2:"No",1:"")
 ;--------------------------------------------------------------------
CONTINUE(EXIT) ;EP
 N DIR,X,Y
 S DIR(0)="E" D ^DIR
 S:Y=0 EXIT=1
 Q
 ;--------------------------------------------------------------------
