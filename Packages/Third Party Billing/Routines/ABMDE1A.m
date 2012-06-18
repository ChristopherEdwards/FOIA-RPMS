ABMDE1A ; IHS/ASDST/DMJ - PAGE 1 - VIEW INFO ; 
 ;;2.6;IHS Third Party Billing;**1,8**;NOV 12, 2009
 ;
 ; IHS/SD/SDR - abm*2.6*1 - HEAT4158 - added mammograpy cert#
 ;
 ; *********************************************************************
 ;
V1 ; view
 S ABMZ("TITL")="IDENTIFIER - VIEW OPTION"
 S ABMZ("PG")=1
 D SUM^ABMDE1
 S ABMV=""
 S $P(ABMV,"-",80)=""
 W !,"Patient.: ",$P($P(ABMV("X2"),U),";",2)
 W ?48,"Sex.: ",$P(ABMV("X2"),U,2),?59,"DOB..: ",$P(ABMV("X2"),U,6)
 W !?10,$P(ABMV("X2"),U,3),?48,"Home Phone......: ",$P(ABMV("X2"),U,5)
 W !?10,$P(ABMV("X2"),U,4),?48,"Marital Status..: ",$P($P(ABMV("X2"),U,7),";",2)
 I $P(ABMV("X3"),U)="" G LOC
 W !!?3,"Employer...: ",$P(ABMV("X3"),U)
 W ?48,"Empl. Status..: ",$P($P(ABMV("X3"),U,5),";",2)
 W !?16,$P(ABMV("X3"),U,2)
 W ?48,"Work Phone....: ",$P(ABMV("X3"),U,4)
 W !?16,$P(ABMV("X3"),U,3)
 ;
LOC ;
 W !,ABMV
 W !,"Facility: ",$P($P(ABMV("X1"),U),";",2)
 W ?48,"Tax Number..: ",$P(ABMV("X1"),U,6)
 W !?10,$P(ABMV("X1"),U,2)
 W ?48,"Phone.......: ",$P(ABMV("X1"),U,5)
 W !?10,$P(ABMV("X1"),U,3)
 W ?48,"NPI.........: "
 ;start old code abm*2.6*8
 ;S ABMLNPI=$S($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,8)'="":$P(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1),U,8),$P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,12)'="":$P(^ABMDPARM(ABMP("LDFN"),1,2),U,12),1:ABMP("LDFN"))
 ;W $S($P($$NPI^XUSNPI("Organization_ID",+ABMLNPI),U)>0:$P($$NPI^XUSNPI("Organization_ID",+ABMLNPI),U),1:"")
 ;end old start new code
 I $G(ABMP("INS"))'="" D
 .S ABMLNPI=$S($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,8)'="":$P(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1),U,8),$P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,12)'="":$P(^ABMDPARM(ABMP("LDFN"),1,2),U,12),1:ABMP("LDFN"))
 .W $S($P($$NPI^XUSNPI("Organization_ID",+ABMLNPI),U)>0:$P($$NPI^XUSNPI("Organization_ID",+ABMLNPI),U),1:"")
 ;end new code abm*2.6*8
 W !?10,$P(ABMV("X1"),U,4)
 W ?48,"ASUFAC......: ",$$ASUFAC^ABMUCUTL($P(ABMV("X1"),";"),ABMP("VDT"))
 W !?48,"Mammo Cert#.: ",$P($G(^ABMDPARM(ABMP("LDFN"),1,5)),U,4)  ;abm*2.6*1 HEAT4158
 D ^ABMDERR
 W !
 S ABM("Y")=+Y
 ;
XIT ;
 Q
