AGACT ; IHS/ASDS/EFG - INACTIVATE/ACTIVATE A PATIENT'S FILE (BY FACILITY) ; 
 ;;7.1;PATIENT REGISTRATION;**1,2,5,9**;AUG 25, 2005
A1 S AG("LINE")="=" D LINE^AG W !?25,"1... INACTIVATE a file",!!?25,"2... ACTIVATE  a file",!!?25,"Select 1 or 2 : " D READ^AG G END:$D(DTOUT)!$D(DFOUT)!$D(DUOUT)!$D(DLOUT),A1:+Y<1!(+Y>2)
 S AG("CH")=+Y W !!,$S(+Y=1:"IN",1:""),"ACTIVATE..."
 W !! K DIC S AUPNLK("INAC")="" D PTLK^AG K AUPNLK("INAC")
 W !! G A1:$D(DUOUT),END:'$D(DFN),C1:AG("CH")=2
B ;Lookup Patient and Inactivate.
B2 W !!,"You wish to inactivate ",$P(^DPT(DFN,0),U),!!,"CORRECT? (Y/N)  " D READ^AG G A1:$D(DTOUT)!$D(DFOUT)!$D(DUOUT)!(Y["N"),B2A:Y["Y" D YN^AG G B2
B2A I $P(^AUPNPAT(DFN,41,DUZ(2),0),U,5)="D" W !!,*7,"This patient has been deleted - no action taken." H 3 G END
 ;K DIC,DR,DA S DA(1)=DFN,DA=DUZ(2),DIE="^AUPNPAT("_DFN_",41,",DR=".03///"_DT D ^DIE ;new FM data sets
 ;BEGIN NEW CODE IHS/SD/TPF AG*7.1*1 ITEM 9
 K DIC,DIE,DA,DR
 S DA(1)=DFN,DA=DUZ(2)
 S DIE="^AUPNPAT("_DFN_",41,"
 S DR=".03R",DIE("NO^")=""
 D ^DIE
 ;END NEW CODE
 D HELP
 I Y]"" K DIC,DR,DA S DA(1)=DFN,DA=DUZ(2),DIE="^AUPNPAT("_DFN_",41,",DR=".04///"_Y D ^DIE ; new FM data sets
 W !!,"The file is now inactive." H 2
 ;HL7 INTERFACE -- PUT PATIENT DFN INTO TEMP ARRAY FOR HL7 CALL
 ;S ^XTMP("AGHL7",DA)=DA
 S ^XTMP("AGHL7AG",DUZ(2),DFN,"UPDATE")=""  ;fje062909 AG*7.1*5 EDR ;AG*7.1*9 - Added DUZ(2) subscript
 ;BEGIN NEW CODE IHS/SD/TPF 5/2/2006 AG*7.1*2 PAGE 12 ITEM 3
 I $$AGE^AGUTILS(DFN)<3 D AUTOADD^BIPATE(DFN,DUZ(2),.AGERR,DT)
 ;END NEW CODE
 I '$D(AG("DELETE")) K DIC,DR,DA S DA(1)=DFN,DA=DUZ(2),DIE="^AUPNPAT("_DFN_",41,",DR=".05///"_"I" D ^DIE G A1 ;new FM data sets
 G END
C1 ;EP - From ^AG0 to Activate a Pre-REG Patient.
 W !,"RECORD DISPOSITION is:",!?5,"DATE INACTIVATED/DELETED :  " S Y=$P(^AUPNPAT(DFN,41,DUZ(2),0),U,3) D DD^%DT W Y I $P(^AUPNPAT(DFN,41,DUZ(2),0),U,4)]"" W !?5,$P(^AUTTDIS($P(^(0),U,4),0),U),!,$P(^(0),U,2),!
 W !!,"You wish to activate ",$P(^DPT(DFN,0),U),!!,"CORRECT? (Y/N)  " D READ^AG G C1A:$D(AG("EDIT")),A1:$D(DTOUT)!$D(DFOUT)!$D(DUOUT)!(Y["N"),C2:Y["Y" D YN^AG G C1
C1A I $D(AG("EDIT")) G END:$D(DUOUT)!$D(DFOUT)!$D(DTOUT)!(Y["N"),C2:Y["Y" D YN^AG G C1
C2 ;
 S $P(^AUPNPAT(DFN,41,DUZ(2),0),U,3)="",$P(^(0),U,4)="",$P(^(0),U,5)=""
 K DIC,DR,DA S DA(1)=DFN,DA=DUZ(2),DIE="^AUPNPAT("_DFN_",41,",DR=".03///@;.04///@;.05///@" D ^DIE ; new FM data sets
 W !!,"The file is now active." H 2 S ^XTMP("AGHL7AG",DUZ(2),DFN,"UPDATE")="" G A1:'$D(AG("EDIT")) K AG Q  ;fje062909 AG*7.1*5 EDR ;AG*7.1*9 - Added DUZ(2) subscript
END K AG,DFN
 Q
HELP W !!!,"Select the record disposition from among the following:",! S (AG("DIS"),AG("I"))=0
 F AG("I")=1:1 S AG("DIS")=$O(^AUTTDIS(AG("DIS"))) Q:+AG("DIS")<1  S AG(AG("I"))=AG("DIS") W !,AG("I"),".",?5,$P(^AUTTDIS(AG("DIS"),0),U),!,$P(^(0),U,2),!
 W !,"Enter 1 - ",AG("I")-1," " D READ^AG Q:$D(DTOUT)!$D(DFOUT)!$D(DUOUT)!$D(DQOUT)!$D(DLOUT)  I $D(AG(+Y)) S Y=AG(+Y) Q
 W *7,"??" G HELP
