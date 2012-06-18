AQAODIC ; IHS/ORDC/LJF - DIC AND DIE DRIVER FOR PKG ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn is called at entry point DIC and DIE to add or edit file
 ;entries after the proper variables have been set.  The entry point
 ;SETNUM is called by an input transform.
 ;Variables required for DIC call:   AQAODIC=DIC,AQAODIC(0)=DIC(0)
 ;Optional variables:  AQAODIC("A"),AQAODIC("B"),AQAODIC("S"),AQAODICR
 ;
 ;Variables required for DIE call:  AQAODIC,AQAODR,AQAODA
 ;Optional variables:   AQAODEL,AQAODA1
 ;
DIC ;ENTRY POINT >>> set variables and make dic call
 K AQAODA G END:'$D(AQAODIC),END:'$D(AQAODIC(0))
 W ! K DIC S DIC=AQAODIC,DIC(0)=AQAODIC(0)
 S:$D(AQAODIC("A")) DIC("A")=AQAODIC("A")
 S:$D(AQAODIC("B")) DIC("B")=AQAODIC("B")
 S:$D(AQAODIC("S")) DIC("S")=AQAODIC("S")
 S:$D(AQAODICR) DIC("DR")=AQAODICR
 S:AQAODIC(0)["L" X=DIC_"0)",DLAYGO=+$P((@X),U,2)
 I $D(DLAYGO) S AQAOLCK=DIC_"0)" L +(@AQAOLCK):1 I '$T D  G END
 .W !!,"FILE LOCKED; CANNOT ADD. TRY AGAIN",! S Y=-1 K AQAOLCK
 D ^DIC I $D(AQAOLCK) L -(@AQAOLCK) K AQAOLCK
 G END:$D(DTOUT),END:$D(DUOUT),END:X="",DIC:Y=-1 S AQAODA=+Y
 ;
 ;
DIE ;ENTRY POINT >>> set variables and make die call
 G END:'$D(AQAODIC),END:'$D(AQAODA),END:'$D(AQAODR)
 K DIE S DIE=AQAODIC,DA=AQAODA,DR=AQAODR S:$D(AQAODEL) DIDEL=AQAODEL
 S:$D(AQAODA1) DA(1)=AQAODA1
 S AQAOLCK=DIE_AQAODA_")" L +(@AQAOLCK):1 I '$T W !!,"CANNOT EDIT; ANOTHER USER EDITING THIS ENTRY. TRY AGAIN.",! G END
 D ^DIE  L -(@AQAOLCK) G END:$D(DTOUT),END:'$D(AQAODIC(0)) G DIC
 ;
 ;
END ; >>> end of utility
 K DIC,DIE,DLAYGO,DIDEL Q
 ;
 ;
SETNUM ;ENTRY POINT to set variables needed in input transform
 ;for field NUMBER under CRITERIA in QI OCCURRENCE file
 S AQAOLOW=$P(^AQAO1(6,AQAOCR,0),U,3) ;lowest number in range
 S AQAOHI=$P(^AQAO1(6,AQAOCR,0),U,4) ;highest number in range
 Q
