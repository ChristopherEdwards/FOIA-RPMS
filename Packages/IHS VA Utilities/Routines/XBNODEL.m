XBNODEL ; IHS/ADC/GTH - PREVENT USER FROM DELETING ENTRIES ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; This routine sets FileMan dictionaries so users cannot
 ; delete entries.  Protection is provided by SET'ing the
 ; "DEL" node of the .01 fields in the selected dd's to
 ; "I 1".
 ;
START ;
 I $G(DUZ(0))'="@" W !,*7,"  Insufficient FileMan access.  DUZ(0) is not ""@""." Q
 S U="^",IOP=$I
 D ^%ZIS
 W !!,"^XBNODEL - This program sets FileMan dictionaries so users cannot delete",!,"           entries."
 ;
 D ^XBDSET
 G:'$D(^UTILITY("XBDSET",$J)) EOJ
ASK ;
 S XBNDASK=$$DIR^XBDIR("Y","Do you want to be asked before setting each file","Y","","",2)
 W !
 S XBNDFILE=""
 F XBNDL=0:0 S XBNDFILE=$O(^UTILITY("XBDSET",$J,XBNDFILE)) Q:XBNDFILE=""  D PROCESS
 G EOJ
 ;
PROCESS ;
 S XBNDANS="Y"
 I $G(@("^DD("_XBNDFILE_",.01,""DEL"",.01,0)"))="I 1" W !,@("$P(^DIC("_XBNDFILE_",0),U,1)")," is already protected." Q
 W !,@("$P(^DIC("_XBNDFILE_",0),U,1)"),$S(XBNDASK:"..OK? Y// ",1:"")
P2 ;
 I XBNDASK R XBNDANS:$G(DTIME,999) S:XBNDANS="" XBNDANS="Y" I "YyNn"'[$E(XBNDANS) D P2ERR G P2
 I XBNDANS="Y" S @("^DD("_XBNDFILE_",.01,""DEL"",.01,0)")="I 1" W "  Done"
 Q
 ;
P2ERR ;
 W *7
 F XBNDI=1:1:$L(XBNDANS) W @IOBS," ",@IOBS
 Q
 ;
EOJ ;
 KILL ^UTILITY("XBDSET",$J)
 KILL XBNDANS,XBNDASK,XBNDFILE,XBNDI,XBNDL
 KILL BS,FF,RM,SL,SUB,XY
 Q
 ;
