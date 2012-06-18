AQAOEDTP ; IHS/ORDC/LJF - SPECIAL SUBRTNS FOR DATA ENTRY ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn is called by ^AQAOEDTS to display PCC data for visit.
 ;If there is PCC data, it then calls ^AQAOEDTA to stuff data into 
 ;QI OCC files.
 ;
DX ;EP to display any PCC DX data for visit
 ;called by ^AQAOEDTS via indirection
 ;from PRE-DISPLAY CODE field in QI DATA ENTRY file
 S AQAOVSIT=$P($G(^AQAOC(AQAOIFN,0)),U,3) Q:AQAOVSIT=""  ;no visit
 ;
 I '$O(^AUPNVPOV("AD",AQAOVSIT,0)) W !?5,"No PCC data recorded for visit yet",! Q
 W !?5,"**Choose only RELEVANT Diagnoses for this Occurrence**"
 W !!?2,"DX Data in PCC:  "
 S (AQAODX,AQAOCNT)=0 K AQAOA ;find all v povs for visit
 F  S AQAODX=$O(^AUPNVPOV("AD",AQAOVSIT,AQAODX)) Q:AQAODX=""  D
 .Q:'$D(^AUPNVPOV(AQAODX,0))  S AQAODXS=^(0)
 .S AQAOCNT=AQAOCNT+1 W ?19,AQAOCNT,")"
 .S AQAODX1=$P(AQAODXS,U),AQAODX4=$P(AQAODXS,U,4) ;get pointers
 .W ?23,$P(^ICD9(AQAODX1,0),U),?33,$E($P(^AUTNPOV(AQAODX4,0),U),1,40),!
 .S AQAOA(AQAOCNT)=AQAODX1 ;set array with icd9 pointer
 ;
 D CHOOSE^AQAOEDTA:'$O(@AQAOXY) ;if none in for occ,ask to add pcc dx
 Q
 ;
 ;
PROC ;EP;to display any PCC procedure data for visit
 ;called by ^AQAOEDTS via indirection
 ;from PRE-DISPLAY CODE field in QI DATA ENTRY file
 S AQAOVSIT=$P($G(^AQAOC(AQAOIFN,0)),U,3) Q:AQAOVSIT=""  ;no visit
 ;
 I '$O(^AUPNVPRC("AD",AQAOVSIT,0)) W !?5,"No PCC data recorded for visit yet",! Q
 W !?5,"**Choose only RELEVANT Procedures for this Occurrence**"
 W !!?2,"PCC Data for Visit: "
 S (AQAODX,AQAOCNT)=0 K AQAOA ;find all procedures for visit
 F  S AQAODX=$O(^AUPNVPRC("AD",AQAOVSIT,AQAODX)) Q:AQAODX=""  D
 .Q:'$D(^AUPNVPRC(AQAODX,0))  S AQAODXS=^(0)
 .S AQAOCNT=AQAOCNT+1 W ?22,AQAOCNT,")"
 .S AQAODX1=$P(AQAODXS,U),AQAODX4=$P(AQAODXS,U,4)
 .S AQAODX6=$P(AQAODXS,U,6) ;procedure date
 .W ?26,$P(^ICD0(AQAODX1,0),U),?35,$E(AQAODX6,4,5)_"/"_$E(AQAODX6,6,7)
 .W ?42,$E($P(^AUTNPOV(AQAODX4,0),U),1,37),!
 .S AQAOA(AQAOCNT)=AQAODX1 ;set array with icd0 pointer
 ;
 D CHOOSE^AQAOEDTA:'$O(@AQAOXY) ;if none in for occ,ask to add pcc proc
 Q
 ;
DRUG ;EP; to display any PCC medication data for visit
 ;called by ^AQAOEDTS via indirection
 ;from PRE-DISPLAY CODE field in QI DATA ENTRY file
 S AQAOVSIT=$P($G(^AQAOC(AQAOIFN,0)),U,3) Q:AQAOVSIT=""  ;no visit
 ;
 I '$O(^AUPNVMED("AD",AQAOVSIT,0)) W !?5,"No PCC data recorded for visit yet",! Q
 W !?5,"**Choose only RELEVANT Medications for this Occurrence**"
 W !!?2,"Medication Data in PCC:  "
 S (AQAODX,AQAOCNT)=0 K AQAOA ;find all medications for visit
 F  S AQAODX=$O(^AUPNVMED("AD",AQAOVSIT,AQAODX)) Q:AQAODX=""  D
 .Q:'$D(^AUPNVMED(AQAODX,0))  S AQAODXS=^(0)
 .S AQAOCNT=AQAOCNT+1 W ?5,AQAOCNT,")"
 .S AQAODX1=$P(AQAODXS,U),AQAODX5=$P(AQAODXS,U,5) ;drug & sig
 .S AQAODX6=$P(AQAODXS,U,6),AQAODX9=$P(AQAODXS,U,9) ;quant & prov
 .W ?10,$E($P(^PSDRUG(AQAODX1,0),U),1,15)
 .W ?30,$E(AQAODX5,1,25),"  ",AQAODX6
 .S AQAODX9=$S($P(^DD(9000010.06,.01,0),U,3)="DIC(6,":^DIC(16,AQAODX9,"A3"),1:AQAODX9)
 .W ?62,$E($P(^VA(200,AQAODX9,0),U),1,20),!
 .S AQAOA(AQAOCNT)=AQAODX1 ;set array with psdrug pointer
 ;
 D CHOOSE^AQAOEDTA:'$O(@AQAOXY) ;if none in for occ,ask to add pcc proc
 Q
 ;
PROV ;EP; to display any PCC provider data for visit
 ;called by ^AQAOEDTS via indirection
 ;from PRE-DISPLAY CODE field in QI DATA ENTRY file
 S AQAOVSIT=$P($G(^AQAOC(AQAOIFN,0)),U,3) Q:AQAOVSIT=""  ;no visit
 ;
 I '$O(^AUPNVPRV("AD",AQAOVSIT,0)),'$O(^AUPNVCHS("AD",AQAOVSIT,0)) W !?5,"No PCC data recorded for visit yet",! Q  ;ENH1
 W !?5,"**Choose only Providers RELATED to this Occurrence**"
 W !!?2,"PCC Data for Visit:  "
 S (AQAODX,AQAOCNT)=0 K AQAOA ;find all providers for visit
 F  S AQAODX=$O(^AUPNVPRV("AD",AQAOVSIT,AQAODX)) Q:AQAODX=""  D
 .Q:'$D(^AUPNVPRV(AQAODX,0))  S AQAODXS=^(0)
 .S AQAOCNT=AQAOCNT+1 W ?23,AQAOCNT,")"
 .S AQAODX1=$P(AQAODXS,U),AQAODX4=$P(AQAODXS,U,4) ;get pointers
 .S (AQAODX1,AQAOA(AQAOCNT))=$S($P(^DD(9000010.06,.01,0),U,3)="DIC(6,":^DIC(16,AQAODX1,"A3"),1:AQAODX1)
 .W ?28,$E($P(^VA(200,AQAODX1,0),U),1,15),?45,$P(AQAODXS,U,4) ;name,p/s
 .W ?50,$P(AQAODXS,U,5) ;operating/attending
 .;                     ;provider class
 .S X=$P($G(^VA(200,AQAODX1,"PS")),U,5)
 .W:X]"" ?55,$E($P(^DIC(7,X,0),U),1,20)
 .W ! S AQAOA(AQAOCNT)=AQAODX1_";VA(200,"
 D PROV^AQAOEDTV
 ;
 D CHOOSE^AQAOEDTA:'$O(@AQAOXY) ;if none in for occ,ask for pcc prov
 Q
 ;
 ;
CRIT ;ENTRY POINT for code to stuff criteria linked file
 ;from PRE-DISPLAY CODE field in QI DATA ENTRY file
 I '$D(^AQAO1(6,"C",AQAOIND)) W !!,"* NO CRITERIA DEFINED FOR THIS INDICATOR",! S AQAOQUIT=1 Q
 S AQAOCRIT=0
 F  S AQAOCRIT=$O(^AQAO1(6,"C",AQAOIND,AQAOCRIT)) Q:AQAOCRIT=""  D
 .S X=$O(^AQAO1(6,"C",AQAOIND,AQAOCRIT,0)) Q:X="" 
 .Q:'$D(^AQAO1(6,AQAOCRIT,"IND",X))  ;bad xref
 .Q:$D(^AQAOCC(5,"AC",AQAOIFN,AQAOCRIT))  ;criteria already in for occ
 .K DIC,DR,DD,DO,DINUM S DIC(0)="L",DIC=AQAOGBL,DLAYGO=AQAOFL
 .S DIC("DR")=".02////"_AQAOIFN_";.03////"_AQAOPAT
 .S X=AQAOCRIT D FILE^DICN Q:Y=-1
 .K DIE,DA,DR S DIE=AQAOGBL,DA=+Y
 .S DR=AQAOFLD_" FIRST]"
 .D ^DIE
 Q
