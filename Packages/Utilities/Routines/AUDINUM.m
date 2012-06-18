AUDINUM ; OHRD/EDE CONVERTS NON-DINUM FILE TO DINUM FILE [ 02/16/88  8:24 AM ]
 ; V1.1 ; 2-16-88
 ;
 S U="^"
 W !!,"This program sets the DFNs of a DINUM file appropriately."
 W ! S DIC="^DIC(",DIC(0)="QAZEM" D ^DIC Q:Y<0  S DIC=+Y
 I '$D(^DIC(DIC,0,"GL")) W !!,"Corrupted ^DIC!" Q
 S AUDIGBL=^("GL")
 X "S AUDIX=$D("_AUDIGBL_"0))"
 I 'AUDIX W !!,AUDIGBL,"0) does not exist." Q
 I '$P(^(0),U,4) W !!,"File ",DIC," has no entries." Q
 I '$D(^DD(DIC,.01,0)) W !!,"Corrupted ^DD!" Q
 I ^DD(DIC,.01,0)'["DINUM=X" W !!,"File ",DIC," is not a DINUM file." Q
 K ^UTILITY("AUDINUM",$J),^UTILITY("AUDIDUP",$J)
 S (AUDI3,AUDI4,AUDIDFN)=0
 X "S ^UTILITY(""AUDINUM"",$J,0)="_AUDIGBL_"0)"
 F AUDIL=0:0 X "S AUDIDFN=$O("_AUDIGBL_AUDIDFN_"))" Q:AUDIDFN'=+AUDIDFN  D X1
 S AUDIX=^UTILITY("AUDINUM",$J,0),$P(AUDIX,U,3)=AUDI3,$P(AUDIX,U,4)=AUDI4,^(0)=AUDIX
 W !!,"Global ",$E(AUDIGBL,1,$L(AUDIGBL)-1)," now renumbered and stored in ^UTILITY(""AUDINUM"",",$J,!,"  High DFN=",AUDI3,"  Number of entries=",AUDI4
 I $D(^UTILITY("AUDIDUP",$J)) W !!,"Duplicate entries found.  Stored in ^UTILITY(""AUDIDUP"",",$J,!,"  Eliminate duplicates and rerun this job!" G EOJ
 S AUDIX=$S($E(AUDIGBL,$L(AUDIGBL))="(":$E(AUDIGBL,1,$L(AUDIGBL)-1),1:$E(AUDIGBL,1,$L(AUDIGBL)-1)_")")
 K @(AUDIX)
 W !!,AUDIX," has been killed!  Now being recreated."
 S TO=AUDIGBL,FROM="^UTILITY(""AUDINUM"",$J,",TALK=1 D ^%AUGXFR
 W !!,"File now being RE-INDEXED!",!
 S DIK=AUDIGBL S AUDIX=0 F AUDIL=0:0 X "S AUDIX=$O("_AUDIGBL_AUDIX_"))" Q:AUDIX'=+AUDIX  W "." S DA=AUDIX D IX1^DIK
 D EOJ
 Q
 ;
X1 S FROM=AUDIGBL_AUDIDFN_"," X "S TO=+"_AUDIGBL_AUDIDFN_",0)" S:TO>AUDI3 AUDI3=TO
 S TO=$S('$D(^UTILITY("AUDINUM",$J,TO)):"^UTILITY(""AUDINUM"",$J,"_TO_",",1:"^UTILITY(""AUDIDUP"",$J,"_TO_",")
 S:TO'["AUDIDUP" AUDI4=AUDI4+1
 S TALK=1 D ^%AUGXFR
 Q
 ;
EOJ ;
 K ^UTILITY("AUDINUM",$J)
 K AUDIGBL,AUDIX,AUDI3,AUDI4,AUDIDFN,AUDIL
 Q
