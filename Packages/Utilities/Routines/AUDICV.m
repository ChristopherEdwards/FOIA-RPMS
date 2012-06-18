AUDICV ;SET DICTIONARY VERSION NUMBERS [ 03/11/88  10:12 AM ]
 ;
BEGIN S DUZ(0)="@",U="^" D CURRENT^%ZIS
 W !!,"This program sets FileMan dictionary version numbers."
 ;
 S (AUDICVHI,AUDICVQF)=0
 D GETDICS ;             Get set of dictionaries
 I AUDICVQF D EOJ Q
 D SHOW ;                Show current versions
 D ASK ;                 See if user wants control
 I AUDICVQF D EOJ Q
 D VER ;                 Get new version number
 I AUDICVQF D EOJ Q
 D CHANGE ;              Change version numbers
 D EOJ ;                 Clean up
 Q
 ;
GETDICS ; GET SET OF DICTIONARIES
 D ^%AUDSET
 S:'$D(^UTILITY("AUDSET",$J)) AUDICVQF=1
 Q
 ;
SHOW ; SHOW CURRENT VERSION NUMBERS
 W ! S AUDICVFL="" F AUDICVL=0:0 S AUDICVFL=$O(^UTILITY("AUDSET",$J,AUDICVFL)) Q:AUDICVFL=""   W !,$P(^DIC(AUDICVFL,0),U,1),$S($D(^DD(AUDICVFL,0,"VR")):"..Current version is "_^("VR"),1:"..No version") D HIGH
 Q
HIGH ; SAVE HIGH VERSION NUMBER
 I $D(^DD(AUDICVFL,0,"VR")),+^("VR")>+AUDICVHI S AUDICVHI=^("VR")
 Q
 ;
ASK W !!,"Do you want to be asked before setting each file? (Y/N) Y// " R AUDICVASK S:AUDICVASK="" AUDICVASK="Y" I "^YyNn"'[AUDICVASK W *7 G ASK
 I AUDICVASK["^" S AUDICVQF=1 Q
 S AUDICVASK=$S("Yy"[$E(AUDICVASK):1,1:0)
 Q
 ;
VER R !!,"New version number: ",AUDICVVR
 I AUDICVVR["^" S AUDICVQF=1 Q
 I AUDICVVR'?1N.N.".".N W *7 G VER
 I +AUDICVVR<+AUDICVHI W !,"One or more selected files already has a version number greater than ",AUDICVVR,*7 G VER
 Q
 ;
CHANGE ; CHANGE VERSION NUMBERS
 W !
 S AUDICVFL="" F AUDICVL=0:0 S AUDICVFL=$O(^UTILITY("AUDSET",$J,AUDICVFL)) Q:AUDICVFL=""  D PROCESS
 Q
 ;
PROCESS ;
 S AUDICVANS="Y"
 W !,$P(^DIC(AUDICVFL,0),U,1),$S($D(^DD(AUDICVFL,0,"VR")):"..Current version is "_^("VR"),1:"..No version"),$S(AUDICVASK:"..OK? Y// ",1:"")
P2 I AUDICVASK R AUDICVANS S:AUDICVANS="" AUDICVANS="Y" I "YyNn"'[$E(AUDICVANS) D P2ERR G P2
 I AUDICVANS="Y" S ^DD(AUDICVFL,0,"VR")=AUDICVVR W "  Changed to ",AUDICVVR
 Q
P2ERR W *7 F AUDICVI=1:1:$L(AUDICVANS) W @BS," ",@BS
 Q
 ;
EOJ ;
 K ^UTILITY("AUDSET",$J)
 K AUDICVANS,AUDICVASK,AUDICVFL,AUDICVHI,AUDICVI,AUDICVL,AUDICVQF,AUDICVVR
 K BS,FF,RM,SL,SUB,XY
 W !!,"Bye",!!
 Q
