XBDINUM ; IHS/ADC/GTH - CONVERTS NON-DINUM FILE TO DINUM FILE ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
START ;
 S U="^"
 W !!,"This program sets the DFNs of a DINUM file appropriately.",!
 S DIC="^DIC(",DIC(0)="QAZEM"
 D ^DIC
 Q:Y<0
 S DIC=+Y
 I '$D(^DIC(DIC,0,"GL")) W !!,"Corrupted ^DIC!",!,"No ""GL"" node in zeroth node of file ",DIC,"." Q
 S XBDIGBL=^DIC(DIC,0,"GL")
 X "S XBDIX=$D("_XBDIGBL_"0))"
 I 'XBDIX W !!,XBDIGBL,"0) does not exist." Q
 I '$P(@(XBDIGBL_"0)"),U,4) W !!,"File ",DIC," has no entries." Q
 I '$D(^DD(DIC,.01,0)) W !!,"Corrupted ^DD!" Q
 I ^DD(DIC,.01,0)'["DINUM=X" W !!,"File ",DIC," is not a DINUM file." Q
 KILL ^UTILITY("XBDINUM",$J),^UTILITY("XBDIDUP",$J)
 S (XBDI3,XBDI4,XBDIDFN)=0
 X "S ^UTILITY(""XBDINUM"",$J,0)="_XBDIGBL_"0)"
 F XBDIL=0:0 X "S XBDIDFN=$O("_XBDIGBL_XBDIDFN_"))" Q:XBDIDFN'=+XBDIDFN  D X1
 S XBDIX=^UTILITY("XBDINUM",$J,0),$P(XBDIX,U,3)=XBDI3,$P(XBDIX,U,4)=XBDI4,^(0)=XBDIX
 W !!,"Global ",$E(XBDIGBL,1,$L(XBDIGBL)-1)," now renumbered and stored in ^UTILITY(""XBDINUM"",",$J,!,"  High DFN=",XBDI3,"  Number of entries=",XBDI4
 I $D(^UTILITY("XBDIDUP",$J)) W !!,"Duplicate entries found.  Stored in ^UTILITY(""XBDIDUP"",",$J,!,"  Eliminate duplicates and rerun this job!" G EOJ
 S XBDIX=$S($E(XBDIGBL,$L(XBDIGBL))="(":$E(XBDIGBL,1,$L(XBDIGBL)-1),1:$E(XBDIGBL,1,$L(XBDIGBL)-1)_")")
 KILL @(XBDIX)
 W !!,XBDIX," has been killed!  Now being recreated."
 S TO=XBDIGBL,FROM="^UTILITY(""XBDINUM"",$J,",TALK=1
 D ^XBGXFR
 W !!,"File now being RE-INDEXED!",!
 S DIK=XBDIGBL,XBDIX=0
 F XBDIL=0:0 X "S XBDIX=$O("_XBDIGBL_XBDIX_"))" Q:XBDIX'=+XBDIX  W "." S DA=XBDIX D IX1^DIK
 D EOJ
 Q
 ;
X1 ;
 S FROM=XBDIGBL_XBDIDFN_","
 X "S TO=+"_XBDIGBL_XBDIDFN_",0)"
 S:TO>XBDI3 XBDI3=TO
 S TO=$S('$D(^UTILITY("XBDINUM",$J,TO)):"^UTILITY(""XBDINUM"",$J,"_TO_",",1:"^UTILITY(""XBDIDUP"",$J,"_TO_",")
 S:TO'["XBDIDUP" XBDI4=XBDI4+1
 S TALK=1
 D ^XBGXFR
 Q
 ;
EOJ ;
 KILL ^UTILITY("XBDINUM",$J),XBDIGBL,XBDIX,XBDI3,XBDI4,XBDIDFN,XBDIL
 Q
 ;
