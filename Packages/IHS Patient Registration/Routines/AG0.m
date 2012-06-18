AG0 ; IHS/ASDS/EFG - Add a patient opening page ; MAR 19, 2010    
 ;;7.1;PATIENT REGISTRATION;**1,2,7,8,9,10**;AUG 25, 2005;Build 7
 ;
 K DOG,AGDOG
 ;
DOG ;PEP - From Other Systems.
 D ^AGVAR
 I $D(DOG) S AGDOG=DOG  ;renamespace external call variable
VAR ; 
 W:$D(AGDOG) @IOF,!,"ADD a new patient......"
 K AG,DFN
R1 ;
 G L0:$D(DFN)
 ;IHS/SD/TPF 4/12/2006 AG*7.1*2 ITEM 13 PAGE 11
 ;K DIR
 ;S DIR(0)="Y"
 ;S DIR("B")="YES"
 ;S DIR("A")="Do you wish to SCAN FOR SIMILAR NAMES or CHART NUMBERS? (Y/N) "
 ;S DIR("T")=DTIME
 ;D ^DIR
 ;Q:$D(DFOUT)!$D(DTOUT)!$D(DUOUT)
 ;G L0:Y=0
 ;G R2:Y=1!$D(DLOUT)
 ;G R1
 ;END IHS/SD/TPF 4/12/2006 AG*7.1*2 ITEM 13 PAGE 11
R2 ;
 W !!,"You must first SCAN FOR SIMILAR NAMES or CHART NUMBERS NOW..."  ;IHS/SD/TPF 4/12/2006 AG*7.1*2 ITEM 13 PAGE 11
 K DIC
 S DIC("W")="D ^AGSCANP"
 D SET^AUPNLKZ               ; Set DUZ(2) to 0
 D PTLK^AG                   ; Std pat lookup using DIC, returns DFN
 S AGPATDFN=$G(DFN)              ;PHASE OUT USE OF DFN TO AVOID CHANGES WHEN CALLING DIC
 D RESET^AUPNLKZ             ; Set DUZ(2) back to original value
 ;G R1  ;IHS/SD/TPF 4/12/2006 AG*7.1*2 ITEM 13 PAGE 11
L0 ;
 K AG
 G L1:'$D(DFN)
 S AGPATDFN=DFN              ;PHASE OUT USE OF DFN TO AVOID CHANGES WHEN CALLING DIC
 G L0A:'$D(^AUPNPAT(DFN,41,DUZ(2)))
 G L0C:$P(^AUPNPAT(DFN,41,DUZ(2),0),U,3)]""
 I $D(AGDOG) D  G VAR
 . W !!,"This patient is already registered at this facility!"
 . K DIR
 . S DIR(0)="E"
 . S DIR("T")=DTIME
 . D ^DIR
 . K DIR
 I AGOPT(14)'="N",$D(^AUPNPAT(DFN,11)),$P(^AUPNPAT(DFN,11),U,12)]"" D
 . D CALCELIG^AGBIC2
 . W !,"This patient's eligibility is ",$P(AG("NARR1"),":",2)
 K DIR
 S DIR(0)="Y"
 S DIR("B")="NO"
 S DIR("A")="Do you wish to edit "_$P(^DPT(DFN,0),U)_" (Y/N) "
 S DIR("T")=DTIME
 D ^DIR
 G VAR:Y="^"
 G END:$D(DTOUT)!(Y="/.,")!(Y="^^")
 G L0D:Y=0!(Y="")
 G:Y=1 ^AGED1
 G L0
L0A ;
 K DIR
 S DIR(0)="Y"
 S DIR("B")="YES"
 S DIR("A")="Do you wish to register "_$P(^DPT(DFN,0),U)_" at "_$P(^DIC(4,DUZ(2),0),U)_" (Y/N) "
 S DIR("T")=DTIME
 D ^DIR
 S AG("NEWREG")=""
 G R2:Y="^"
 G END:$D(DTOUT)!(Y="/.,")!(Y="^^")
 I Y=1!(Y="") D  G CHART1^AGMAN
 . S AGPTPG=0
 G VAR:Y=0
 G L0A
L0C ;
 I $D(AGDOG) W !!,"This patient is already registered at this facility but is inactive!" W !,"Refer to Medical Records for Reactivation" D READ^AG G VAR
 W !!,"""",$P(^DPT(DFN,0),U),""" is filed as """,$S($P(^AUPNPAT(DFN,41,DUZ(2),0),U,5)="D":"DELETED",1:"INACTIVE"),""".",!!,"Do you wish to RE-ACTIVATE this patient's file? (Y/N) NO// " D READ^AG
 G END:$D(DFOUT)!$D(DTOUT),VAR:$D(DUOUT)!(Y["N")!$D(DLOUT) S AG("EDIT")="" G C1^AGACT:Y["Y" D YN^AG G L0C
L0D ;
 K DFN,AG("EDIT")
L1 ;EP
 W !,"Enter the NEW PATIENT'S FULL NAME....."
 W !,"   (EXAMPLE:   MORGAN,JAMES PAUL,JR  (no space after commas))"
 W !!,"Entering NEW Patient for ",$P(^DIC(4,DUZ(2),0),U),!!
 W:$D(DFN) $P(^DPT(DFN,0),U),"// "
 W !!
 S DIC("A")="Enter the PATIENT'S NAME: "
 S DIC="^AUPNPAT("
 S DIC(0)="AEMLQ"
 S DIADD=1
 S DLAYGO=2
 D SET^AUPNLKZ
 D ^DIC
 D RESET^AUPNLKZ
 K DIADD,DLAYGO,DIC
 I $D(DUOUT)!($D(DTOUT))!(X="") G END
 G:Y=-1 L1
 S DFN=+Y
 S AGPATDFN=DFN              ;PHASE OUT USE OF DFN TO AVOID CHANGES WHEN CALLING DIC
 ;ADD LOCK SO PATIENT BEING EDITED CANNOT BE EDITED BY ANOTHER USER
 L +^AUPNPAT(DFN):5 I '$T W !,"Patient's record already in use! Try again later!" Q
 ;L +^DPT(DFN):5 I '$T W !,"Patient's record already in use! Try again later!" Q  ;AG*7.1*2
 D NOW^%DTC
 S AGDTS=%
 S ^AGPATCH(AGDTS,DUZ(2),DFN)="NEW"
 S $P(^AUPNPAT(DFN,0),U,11)=DUZ ; hard set is necessary as data item is uneditable per file definition
 K AG("EDIT")
 G ^AG2:AGOPT(14)="N"      ;ELIGIBILITY AND TRIBAL DATA
 G ^AGBIC2:AGOPT(14)="Y"   ;MANDATORY DATA
 G ^AGBIC2P:AGOPT(14)="C"  ;MANDATORY DATA 2
 ;
L11 ;EP
 I '$D(AGPAT) S AGPAT=$P(^DPT(DFN,0),U)
 S AG("NPPADD")=""
NPPLOOP ;
 D NPP^AGED11A
 D ACK^AGED11A
 D RHI^AGED11A
ETHNIC ;ENTER ETHNICITY
 D ETHNIC^AGED10B  ;AG*7.1*7/AG*7.1*8 - Changed to AGED10B
RACE ; ENTER RACE, NUMBER IN HOUSEHOLD, TOTAL HOUSEHOLD INCOME
 D RACE^AGED10B ;AG*7.1*10 - Moved Race outside of check below
 I AGOPT(22)="Y"  D
 . D NIH^AGED10B ;AG*7.1*8 - Changed to AGED10B
 . D THI^AGED10B ;AG*7.1*8 - Changed to AGED10B
 ;
 L -^AUPNPAT(DFN)
 ;L -^DPT(DFN)  ;AG*7.1*2
 W !!!,"This concludes the NEW PATIENT ENTRY PROCESS for this patient."
 H 2
 ;
 ;BEGIN **MPI** ADD PATIENT TO MPI AG*7.2 IHS/SD/TPF 5/6/2010  ;MAYBE USE THE VTQ AS A QUERY 'SEEDER'
 ;D CREATMSG^AGMPIHLO(DFN,"VTQ",,.SUCCESS)   ;IF SUCCESSFUL THEN MPI ICN HAS BEEN ADDED TO THE PATIENTS FILE
 ;I 'SUCCESS D
 ;.S AGERROR="MPI DFN="_DFN_" :: "_"ERROR WHEN CREATING VTQ EXACT MATCH QUERY"
 ;.D NOTIF^AGMPIHLO(DFN,AGERROR)
 N X,SUCCESS,DIC,INDA
 S X="AGMPIHLO" X ^%ZOSF("TEST") I $T D
 .D CREATMSG^AGMPIHLO(DFN,"A28",,.SUCCESS)
 .W !!,"A request to add this patient has been sent to the MPI" H 2
 .I 'SUCCESS D NOTIF^AGMPIHLO(DFN,"Unable to create A28 to add patient to MPI from AGMPHLVQ")
 .S X="AG REGISTER A PATIENT",DIC=101,INDA=DFN
 .D EN^XQOR
 ;END **MPI**
 ;
 ;BEGIN NEW CODE IHS/SD/TPF 5/2/2006 AG*7.1*2 PAGE 12 ITEM 3
 I $$AGE^AGUTILS(AGPATDFN)<3 D AUTOADD^BIPATE(AGPATDFN,DUZ(2),.AGERR,"")
 ;END NEW CODE
 ;HL7 INTERFACE -- PUT PATIENT DFN INTO TEMP ARRAY FOR HL7 CALL
 S ^XTMP("AGHL7",DUZ(2),DFN)=DFN  ;AG*7.1*9 - Added DUZ(2) subscript
 S ^XTMP("AGHL7AG",DUZ(2),DFN,"REGISTER")=""  ;AG*7.1*9 - Added DUZ(2) subscript
 Q
END ;
 G K:$D(AG("EDIT"))
 K AG,AGT,AGDTS
 Q
K ;EP
 W !!,*7,"The '",$P(^DPT(DFN,0),U),"' file is deleted."
 D Z1^AGKPAT
 D DFN^AGKPAT
 G END
