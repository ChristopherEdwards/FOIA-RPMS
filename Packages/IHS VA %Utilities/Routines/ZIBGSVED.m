ZIBGSVED ; IHS/ADC/GTH - SAVE GLOBAL TO TAPE, DSM SPECIFIC ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 I $G(XBFLT) S XBFLG=-1,XBFLG(0)="DSM flat filer has not been tested." Q
 G:$D(XBMED) NOSELT
ASK ;
 R !!,"Copy transaction file to ('^' To Exit Without Saving)",!!?10,"[T]ape, [C]artridge  C// ",XBMED:DTIME
 S XBMED=$$UP^XLFSTR($E(XBMED_"C"))
 I U[XBMED S XBFLG(1)="Job Terminated by Operator at Device Select",XBFLG=-1 G END
 G HELP:"?"[XBMED,ASK:'("CT"[XBMED)
NOSELT ;
 S IO=XBIO
 D TAPE:"T"[XBMED,CART:"C"[XBMED
 Q
 ;
HELP ;
 W !!,"This option saves the ' ",XBNAR," ",XBGL,"' transaction file to either a Cartridge",!,"or 9-Track Tape.  The default is to a 9-Track Tape."
 W !,"Enter either a ""C"" for Cartridge Tape or a ""T"" for 9-Track Tape."
 G ASK
 ;
CART ;
 S XBIO=47,XBMSG="Cartridge"
 G PROCESS
TAPE ;
 S XBIO=48,XBMSG="9-Track"
PROCESS ;
 S IOP=XBIO
 D ^%ZIS
 KILL IOP
 S:'$D(XBPAR) XBPAR=IOPAR
 I POP S XBFLG(1)=XBMSG_" Drive Not Available",XBFLG=-1 U IO(0) W !,XBFLG(1) G END
 U IO
 X ^%ZOSF("MAGTAPE")
 W @%MT("REW")
 U IO(0)
 W !!,"Mount The ",XBMSG," Tape 'WRITE ENABLED' And "
RETRY ;
 R !?10,"Press RETURN When Ready  - ""^"" to Exit ",X:DTIME
 I X=U!('$T) S XBFLG(1)="Job Aborted by Operator During Tape Mount",XBFLG=-1 G CLOSE
 U IO
 X ^%ZOSF("MTONLINE")
 I 'Y U IO(0) W !!,"WAITING FOR TAPE"
 F I=1:1:75 U IO X ^%ZOSF("MTONLINE") G S9:Y U IO(0) W "." H 5
 U IO(0)
 W !!,XBFLG(1)," After 6 Minutes"
 S XBFLG(1)="Job Aborted, Tape not Ready",XBFLG=-1
 G END
 ;
S9 ;
 U IO
 X ^%ZOSF("MTWPROT")
 G WRITPROT:Y
 U IO(0)
 W !,"Please Standby - Copying Data to ",XBMSG
 U IO
 D SAVEDSM
 G CLOSE:$D(XBFLG),EXIT
 ;
WRITPROT ;
 U IO(0)
 W *7,!!,"  The Tape Is WRITE PROTECTED. Please Remove The Tape,"
 W !,"  And Re-position The Write Protect/Enable Switch.",!,"  "
 G RETRY
 ;
EXIT ;
 X ^%ZOSF("MAGTAPE")
 U IO
 W @%MT("WTM"),@%MT("REW")
 U IO(0)
 W !!,"Rewinding tape. <WAIT>"
 F L=1:1:150 U IO X ^%ZOSF("MTBOT") G:Y GOODREW  U IO(0) W "." H 2
 S XBFLG=-1,XBFLG(1)="Tape not rewound"
 U IO(0)
 W !!,XBFLG(1),*7
 G CLOSE
 ;
GOODREW ;
 U IO(0)
 W !!,"Remove the tape... Press RETURN when Ready:"
 R X:DTIME
CLOSE ;
 D ^%ZISC
 U IO(0)
END ;
 KILL XBMSG,%MT
 Q
 ;
SAVEDSM ;
 W XBDT
 W:XBPAR'["V" !
 W XBTLE
 W:XBPAR'["V" !
 S X=XBGL_XBF_")"
 F  S X=$Q(@X) Q:X=""  Q:(XBE]"")&($P($P(X,"(",2),",")>XBE)  S Y=X S:$E(Y,2)="[" Y=U_$P(Y,"]",2,999) W Y W:XBPAR'["V" ! W @X W:XBPAR'["V" !
 W "**END**" W:XBPAR'["V" !
 W "**END**" W:XBPAR'["V" !
 Q
 ;
