ABMDE8CA ; IHS/ASDST/DMJ - Page 8 - ROOM/BOARD VIEW OPTION ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 S ABMZ("TITL")="PAGE 8C - VIEW OPTION" D SUM^ABMDE1
 W !,"Admission Date: " S ABM=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),6)),U) D DT W ABM
 W ?40,"Bill From Date: " S ABM=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),6)),U) D DT W ABM
 W !,"Discharge Date: " S ABM=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),6)),U,3) D DT W ABM
 W ?40,"Bill Thru Date: " S ABM=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),6)),U,3) D DT W ABM
 W !!?10,"Covered Days..: ",$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,3)
 W ?35,"Non-Cvd Days..: ",$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),6)),U,6)
 D ^ABMDERR
 ;
XIT K ABM
 Q
 ;
DT ;date conversion
 I ABM]"" S ABM=$$HDT^ABMDUTL(ABM)
 Q
