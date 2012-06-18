XBDICV ; IHS/ADC/GTH - SET DICTIONARY VERSION NUMBERS ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; This routine sets FileMan dictionary version numbers.
 ;
START ;
 I $G(DUZ(0))'="@" W !,*7,"  Insufficient FileMan access.  DUZ(0) is not ""@""." Q
 S U="^",IOP=$I
 D ^%ZIS
 W !!,"^XBDICV - This program sets FileMan dictionary version numbers."
 ;
 S (XBDICVHI,XBDICVQF)=0
 D GETDICS ;             Get set of dictionaries
 I XBDICVQF D EOJ Q
 D SHOW ;                Show current versions
 D ASK ;                 See if user wants control
 I XBDICVQF D EOJ Q
 D VER ;                 Get new version number
 I XBDICVQF D EOJ Q
 D CHANGE ;              Change version numbers
 D EOJ ;                 Clean up
 Q
 ;
GETDICS ; GET SET OF DICTIONARIES
 D ^XBDSET
 S:'$D(^UTILITY("XBDSET",$J)) XBDICVQF=1
 Q
 ;
SHOW ; SHOW CURRENT VERSION NUMBERS
 W !
 S XBDICVFL=""
 F XBDICVL=0:0 S XBDICVFL=$O(^UTILITY("XBDSET",$J,XBDICVFL)) Q:XBDICVFL=""   W !,$P(^DIC(XBDICVFL,0),U,1),$S($D(^DD(XBDICVFL,0,"VR")):"..Current version is "_^("VR"),1:"..No version") D HIGH
 Q
 ;
HIGH ; SAVE HIGH VERSION NUMBER
 I $D(^DD(XBDICVFL,0,"VR")),+^("VR")>+XBDICVHI S XBDICVHI=^("VR")
 Q
 ;
ASK ;
 W !!,"Do you want to be asked before setting each file? (Y/N) Y// "
 R XBDICASK:$G(DTIME,300)
 S:XBDICASK="" XBDICASK="Y"
 I "^YyNn"'[XBDICASK W *7 G ASK
 I XBDICASK["^" S XBDICVQF=1 Q
 S XBDICASK=$S("Yy"[$E(XBDICASK):1,1:0)
 Q
 ;
VER ;
 R !!,"New version number: ",XBDICVVR:$G(DTIME,300)
 I XBDICVVR["^" S XBDICVQF=1 Q
 I XBDICVVR'?1.3N.1".".2N.1A.2N W *7 G VER
 I +XBDICVVR<+XBDICVHI W !,"One or more selected files already has a version number greater than ",XBDICVVR,*7 G VER
 Q
 ;
CHANGE ; CHANGE VERSION NUMBERS
 W !
 S XBDICVFL=""
 F XBDICVL=0:0 S XBDICVFL=$O(^UTILITY("XBDSET",$J,XBDICVFL)) Q:XBDICVFL=""  D PROCESS
 Q
 ;
PROCESS ;
 S XBDICANS="Y"
 W !,$P(^DIC(XBDICVFL,0),U,1),$S($D(^DD(XBDICVFL,0,"VR")):"..Current version is "_^("VR"),1:"..No version"),$S(XBDICASK:"..OK? Y// ",1:"")
P2 ;
 I XBDICASK R XBDICANS:$G(DTIME,300) S:XBDICANS="" XBDICANS="Y" I "YyNn"'[$E(XBDICANS) D P2ERR G P2
 I XBDICANS="Y" S ^DD(XBDICVFL,0,"VR")=XBDICVVR W "  Changed to ",XBDICVVR
 Q
 ;
P2ERR ;
 W *7
 F XBDICVI=1:1:$L(XBDICANS) W @IOBS," ",@IOBS
 Q
 ;
EOJ ;
 KILL ^UTILITY("XBDSET",$J)
 KILL XBDICANS,XBDICASK,XBDICVFL,XBDICVHI,XBDICVI,XBDICVL,XBDICVQF,XBDICVVR
 KILL BS,FF,RM,SL,SUB,XY
 Q
 ;
