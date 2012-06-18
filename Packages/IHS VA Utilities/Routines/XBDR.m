XBDR ; IHS/ADC/GTH - BUILDS DIR STRING ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; This routine builds a string which sets variable DIR, and
 ; it's descendants, for use in a routine.  The string is
 ; stored in the variable "%", and in the "Temp" storage
 ; area for the screen editor for the current device.
 ;
START ;
 NEW XBDRQUIT,DIR,XBDRMIN,XBDRMAX,XBDRSPEC,X,Y,V,XBDRCODE,XBDRDIR,XBDRDIRA,XBDRDIRB,XBDRRUN,XBDRTYPE,I,Z,DIROUT,DUOUT,DTOUT,DIRUT,XBDRDQ,XBDRDQQ,XBDROUT
RUN ;
 F XBDRRUN=1:1:8 D @$P("LOC,NAR,DFLT,^XBDR1,HELP,SET,TEST,SAVE",",",XBDRRUN) I $D(XBDRQUIT) Q
EXIT ;
 Q
 ;
LOC ;
 S V="|",U="^"
 S XBDROUT="I $D(DTOUT)!($D(DUOUT))!($D(DIROUT))"
 I '$D(DT) S X="T" D ^%DT S DT=Y KILL %DT
 I '$D(DTIME) S DTIME=9999
 I $D(IOM),$D(IOF),$D(IOST),$D(IOSL) Q
 D HOME^%ZIS
 KILL IOPAR,IOT,IOBS,POP
 Q
 ;
HELP ;
 W !!,"The current HELP text is:  "
 S X=$E(XBDRTYPE)_1,X=$T(@X^DIR2),X=$P(X,";",4)
 W """",X,""""
 S DIR("A")="Additional HELP text",DIR(0)="FO^1:199"
 D ^DIR
 KILL DIR
 X XBDROUT
 I  S XBDRQUIT="" Q
 S XBDRDQ=X
 W !
 I '$D(^DIC(9.2)) Q
QQ ;
 S DIC("A")="Enter HELP FRAME name: ",DIC(0)="AEQ",DIC=9.2
 D ^DIC
 KILL DIC
 X XBDROUT
 I  S XBDRQUIT="" Q
 I Y=-1 Q
 S XBDRDQQ=$P(Y,U,2)
 Q
 ;
SET ;
 S XBDRDIR=XBDRTYPE,Y=""
 F I=1:1:3 S X="XBDR"_$P("MIN,MAX,SPEC",",",I) I $D(@X) S $P(Y,":",I)=@X
 I Y]"" S XBDRDIR=XBDRDIR_U_Y
S1 ;
 S XBDRCODE="S DIR(0)="""_XBDRDIR_""""
 I $D(XBDRDIRA) S:XBDRTYPE["F"!($E(XBDRTYPE)) XBDRDIRA=XBDRDIRA S XBDRCODE=XBDRCODE_",DIR(""A"")="""_XBDRDIRA_""""
 I $D(XBDRDIRB) S XBDRCODE=XBDRCODE_",DIR(""B"")="""_XBDRDIRB_""""
 I $D(XBDRDQ),XBDRDQ]"" S XBDRCODE=XBDRCODE_",DIR(""?"")="""_XBDRDQ_""""
 I $D(XBDRDQQ),XBDRDQQ]"" S XBDRCODE=XBDRCODE_",DIR(""??"")="""_XBDRDQQ_""""
 S XBDRCODE=XBDRCODE_" KILL DA D ^DIR KILL DIR"
 Q
 ;
NAR ;
 S DIR("A")="Enter query narrative",DIR(0)="FO"
 D ^DIR
 KILL DIR
 I X="" Q
 X XBDROUT
 I  S XBDRQUIT="" Q
 S XBDRDIRA=X
 Q
 ;
DFLT ;
 S DIR("A")="Enter default value",DIR(0)="FO"
 D ^DIR
 KILL DIR
 I X="" Q
 X XBDROUT
 I  S XBDRQUIT="" Q
 S XBDRDIRB=X
 Q
 ;
TEST ;
 W !!!!!?30,"*****  TEST  *****"
TQ ;
 X XBDRCODE
 I X=U Q
 G TQ
 ;
SAVE ;
 S %=" "_XBDRCODE
 W !!!,"Saving the following line of code in the '%' variable:",!,%,!!
 D SV(%)
 Q
 ;
SV(%) ;
 NEW (%)
 D SAVE^ZIBDR(%)
 Q
 ;
