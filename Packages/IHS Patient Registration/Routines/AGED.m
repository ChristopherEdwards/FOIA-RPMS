AGED ; IHS/ASDS/EFG - EDITOR MAIN ROUTINE ; MAR 19, 2010   
 ;;7.1;PATIENT REGISTRATION;**2,4,7,9**;AUG 25, 2005
 ;
 I '$D(IOF) D HOME^%ZIS
 W $$S^AGVDF("IOF"),!
 D PROGVIEW^AGUTILS(DUZ)
 W "IHS REGISTRATION ",$S($D(AGSEENLY):"VIEW SCREEN",1:"EDITOR")
 ;ONLY SHOW PAGE# IF NOT DISPLAYING INS CATEGORY SCREEN
 I '$D(SEQHD) W "  (page ",+AG("PG"),")"
 W ?78-$L($P($G(^DIC(4,DUZ(2),0)),U)),$P($G(^DIC(4,DUZ(2),0)),U)
 S $P(AGLINE("-"),"-",81)=""
 S $P(AGLINE("EQ"),"=",81)=""
 W !,AGLINE("EQ")
 I '$D(AGPAT) S AGPAT=$P($G(^DPT(DFN,0)),U)
 D CHKNPP^AG,CHKRHI^AG
 I '$D(RHIFLAG) W !,AGPAT
 I $D(RHIFLAG)  D
 . I RHIFLAG'="A" W !,AGPAT
 . I $D(RHIFLAG)  D
 . I RHIFLAG="A" W !,$$S^AGVDF("RVN"),AGPAT,$$S^AGVDF("BLN")," (RHI)",$$S^AGVDF("BLF"),$$S^AGVDF("RVF")
 ;W ?36,$$DTEST^AGUTILS(DFN)
 W ?27,$$DTEST^AGUTILS(DFN)  ;AG*7.1*4
 I $D(AGCHRT) W ?55,"HRN:",AGCHRT
 I AG("PG")>1 D
 . ; GET ELIGIBILITY STATUS
 . S AGELSTS=$P($G(^AUPNPAT(DFN,11)),U,12)
 . W ?66,$S(AGELSTS="C":"CHS & DIRECT",AGELSTS="I":"INELIGIBLE",AGELSTS="D":"DIRECT ONLY",AGELSTS="P":"PEND. VERIF",1:"NONE")
 W !,AGLINE("EQ")
 G:AG("PG")="5BEB"!(AG("PG")="5BEC")!(AG("PG")="5BEA")!(AG("PG")="5BED")!(AG("PG")="5BEF")!(AG("PG")="5BEE")!(AG("PG")="4TPLA")!(AG("PG")="4GUARA")!(AG("PG")="4WCA")!(AG("PG")="4RRA") END
 I AG("PG")'=4 D
 . W !?$P($T(@AG("PG")),";",3),$P($T(@AG("PG")),";",4)
 I AG("PG")=4&('$D(CATHD))  D
 . ;W !?30,"MEDICAL COVERAGE"
 . W !?30,"SUMMARY COVERAGE"  ;IHS/SD/TPF 4/12/2006 AG*7.1*2 ITEM 9 PAGE 11
 I AG("PG")=4&($D(CATHD))  D
 . W !?78-$L(CATHD)/2,CATHD
END ;
 K DR,DIE,AG("ED"),AGDTS
 Q
UPDATE ;PEP - CALLED FROM PCC TO UPDATE AGPATCH FILE
 I $D(AG("NOUPDATE")) G END
 D UPDATE1^AGED(DUZ(2),DFN,"","")
 Q  ;generate extrinsic from general call to update
UPDATE1(AGSITE,AGZDFN,AGPTPG,AGGDA)    ;EP - extrinsic here
 I '$D(DIU(0)),DUZ'=.5,'$D(APMFVAR) ;test re-index,filegram,mfi
 E  K AGPTPG,AGZDFN G END
 D NOW^%DTC
 S AGDTS=%
 D ^XBNEW("XBDIE^AGED:AG*") ;call XBDIE fpr nested DIE call
 Q
XBDIE ;NESTED DIE
 S:'$D(^AGPATCH(AGDTS,AGSITE,AGZDFN)) ^AGPATCH(AGDTS,AGSITE,AGZDFN)=""
ZMFI ;
 ;set zmfi node in ^AGPATCH(agdts,site,dfn,zmfi,pg)=da
 I $G(AGPTPG)]"",("N"'[($P($G(^AUTTSITE(1,0)),U,16))) D
 . S ^AGPATCH(AGDTS,AGSITE,AGZDFN,"ZMFI",AGPTPG)=AGGDA
 . K AGPTPG ;add mfi pgs with ien
 S DIE="^AUPNPAT("
 S DR=".03///TODAY"
 S $P(^AUPNPAT(AGZDFN,0),U,12)=DUZ
 S DA=AGZDFN
 D ^DIE
 S DIE="^AUPNPAT("
 S DR=".16///TODAY"
 S DA=AGZDFN
 D ^DIE
 S Y=DT
 D DD^%DT
 S AGUPDT="(upd:"_Y_")"
 ;HL7 INTERFACE -- PUT PATIENT DFN INTO TEMP ARRAY FOR HL7 CALL
 S ^XTMP("AGHL7",DUZ(2),DA)=DA  ;AG*7.1*9 - Added DUZ(2) subscript
 S ^XTMP("AGHL7AG",DUZ(2),DA,"UPDATE")=""  ;AG*7.1*9 - Added DUZ(2) subscript
 K AGZDFN,AGPTPG
 G END
 Q
 ;
1 ;;0;
2 ;;21;Religion/Tribal Data/Employment
3 ;;24;Emergency Contact/Next of Kin
4 ;;30;Medical Sequencing
5 ;;0;
6 ;;28;Veteran's Information
7 ;;26;Death Info/Other Names
8 ;;0;
9 ;;23;CHS Eligibility & Document Summary
10 ;;30;Other Patient Data
11 ;;0;
BICFLDS ;;35;BIC Fields
SCRN ;;Label DY^Label DX^File Number^Field;;Data Format for drawing EDIT screens.
 ;
 Q
