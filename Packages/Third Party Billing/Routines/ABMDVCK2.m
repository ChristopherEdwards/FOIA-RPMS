ABMDVCK2 ; IHS/ASDST/DMJ - PCC Visit Edits ;      
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;08/19/96 4:49 PM
 ;Split off from ABMDVCK0
 ;
 ;IHS/DSD/MRS - 9/13/1999 - NOIS BXX-0999-150023 Patch 3 #14
 ;       Increased default lag time from 5 to 45 days
 ; IHS/ASDS/LSL - 05/19/00 - V2.4 Patch 1 - NOIS NCA-0500-180018
 ;     Modified to do proper checking of POV and orphan lag time
 ;     for children visits where a parent claim already exists and
 ;     has proper POV.
 ;
 ;IHS/ASDS/DMJ - 03/20/01 - V2.4 P5 - NOIS NHA-0201-180052
 ;        Modified to correct "Visit location not found in 3P
 ;        site parameters" error
 ;
 ; IHS/ASDS/LSL - 06/27/01 - V2.4 Patch 9 - NOIS HQW-0798-100082
 ;     Modified to expand No Eligibility Found. Routine created as
 ;     ABMDVCK0 became too large
 ;
 ; *********************************************************************
 ;
 Q
 ;
 ;ABML - eligibility array
INS ; EP ;Go thru insurers in eligibility array
 ;This involves a lot of repeat checking thru stuffing rtns with little
 ;or no use of info in ABML.
 N COVB
 S ABMP("INS")=""
 F  S ABMP("INS")=$O(ABML(ABMP("PRI"),ABMP("INS"))) Q:'ABMP("INS")  D  Q:$D(ABMP("NOKILLABILL"))!$D(ABMP("LOCKFAIL"))
 .S ABM("INS")=ABMP("INS")
 .S COVB=""
 .I $P(ABML(ABMP("PRI"),ABMP("INS")),U,3)?1(1"M",1"R") D
 ..Q:"AS"'[SERVCAT
 ..S I=""
 ..S COVB="M"
 ..S:$$PARTB^ABMDSPLB(ABMP("PDFN"),ABMP("VDT")) COVB=1
 .I COVB="M",ABMPRIM?1(1"M",1"R") D  Q
 ..S DIE="^AUPNVSIT("
 ..S DA=ABMVDFN
 ..S DR=".04////28"
 ..D ^DIE
 .I ABMPRIM="W",ABMP("PRI")=1 D VC Q   ;Workmans comp 
 .D VC2
 ;ABML is the eligibility array.  It is set up in ^ABMDLCK & ^ABMDLCK2
 Q
 ;
 ; *********************************************************************
VC ; Only executed for workman's comp
 ;If only dental is billable and not dental clinic quit
 I $P($G(^AUTNINS(ABMP("INS"),2)),U,5)="O",$P(^DIC(40.7,ABMP("CLN"),0),U,2)'=56 Q
 ;If dental not billable and dental clinic quit
 I $P(^DIC(40.7,ABMP("CLN"),0),U,2)=56,$P($G(^AUTNINS(ABMP("INS"),2)),U,5)="U" Q
 ;If clinic pharmacy and its unbillable quit
 I $P(^DIC(40.7,ABMP("CLN"),0),U,2)=39,$P($G(^AUTNINS(ABMP("INS"),2)),U,3)="U" Q
 ;Quit if status unbillable
 S ABM("INS2")=$G(^AUTNINS(ABMP("INS"),2)) Q:$P($G(^(1)),U,7)=4
 ;Check back billing limit
 I $P(ABM("INS2"),U,4)>0 S X1=DT,X2=0-($P(ABM("INS2"),U,4)*30.417) D C^%DTC Q:ABMP("VDT")<X
VC2 ; for all types of insurance
 S ABM("PRI")=ABMP("PRI")
 D ^ABMDVST
 I $D(ABMP("CDFN")) L -^ABMDCLM(DUZ(2),ABMP("CDFN"))
 Q
 ;
 ; *********************************************************************
ORPHAN(VIS)        ;EP
 ;-Potential orphan - allow claim with missing Provider
 N OK,PROV,L,BP,VFILE,V0
 S OK=""
 F VFILE="^AUPNVLAB","^AUPNVPTH","^AUPNVMIC","^AUPNVBB","^AUPNVCYT","^AUPNVMED","^AUPNVRAD" D  Q:OK
 .I $D(@VFILE@("AD",VIS)) D
 ..S L=0
 ..F  S L=$O(@VFILE@("AD",VIS,L)) Q:'L  D  Q:OK
 ...S PROV=$P($G(@VFILE@(L,12)),U,2)
 ...I PROV S OK=1
 Q:OK OK
 S V0=$S($D(ABMP("V0")):ABMP("V0"),1:^AUPNVSIT(VIS,0))
 S BP=$P(V0,U,28)
 I BP D
 .Q:'$D(^AUPNVPRV("AD",BP))
 .S OK=1
 Q OK
 ;
 ; *********************************************************************
MISSPOV(VIS)       ; EP ;Allow claim if POV missing
 I $D(^AUPNVIMM("AD",VIS)) Q 1
 I $D(^AUPNVSK("AD",VIS)) Q 1
 I $D(^AUPNVMED("AD",VIS)) Q 1
 I $D(^AUPNVPT("AD",VIS)) Q 1
 I $D(^AUPNVCPT("AD",VIS)) Q 1
 I $D(^AUPNVDXP("AD",VIS)) Q 1
 I $D(^AUPNVRAD("AD",VIS)) Q 1
 I $D(^AUPNVLAB("AD",VIS)) Q 1
 I $D(^AUPNVPTH("AD",VIS)) Q 1
 I $D(^AUPNVMIC("AD",VIS)) Q 1
 I $D(^AUPNVBB("AD",VIS)) Q 1
 Q 0
 ;
 ; *********************************************************************
PCFL(X) ; EP ; file .04 field in VISIT file 
 S DIE="^AUPNVSIT("
 S DA=ABMVDFN
 S DR=".04////"_X
 D ^DIE
 Q
