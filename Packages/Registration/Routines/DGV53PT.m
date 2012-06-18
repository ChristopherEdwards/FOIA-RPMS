DGV53PT ;alb/mjk - DG Post-Init Driver for v5.3 ;3/26/93
 ;;5.3;Registration;;Aug 13, 1993
 ;
EN ; -- main entry point
 D LINE^DGVPP,^DGV53PT1   ; provider conversion (1-6)
 D LINE^DGVPP,^DGV53PTI   ; IRT post init
 D LINE^DGVPP,INCDATA     ; inconsistent data clean up
 D LINE^DGVPP,EN^DGV53PTB ; bene travel
 D LINE^DGVPP,EXPORT      ; install exported routines
 D LINE^DGVPP,IVM         ; list templates affect by IVM
 D LINE^DGVPP,^DGV53PTA   ; Alaska county codes
 D LINE^DGVPP,^DGV53PTE   ; EDR conversion (late)
 D UPEMB                  ; embossor DOB change (late)
 D REL                    ; update pentecostal (very late)
ENQ Q
 ;
 ;
INCDATA ; -- inconsistent data cleanup
 N DA,DFN,DIK
 D STTIME^DGYPREG("Inconsistent Data file clean up")
 W !!,">>> Deleting old inconsistencies from Inconsistent Data file"
 F DFN=0:0 S DFN=$O(^DGIN(38.5,DFN)) Q:'DFN  W:'(DFN#100) "." F DA=46,47 D:$D(^DGIN(38.5,DFN,"I",DA,0))
 .S DA(1)=DFN,DIK="^DGIN(38.5,"_DFN_",""I"","
 .D ^DIK Q:$O(^DGIN(38.5,DFN,"I",0))
 .S DIK="^DGIN(38.5,",DA=DFN
 .D ^DIK
 D ENDTIME^DGYPREG("Inconsistent Data file clean up")
 Q
 ;
EXPORT ; -- Conditionally installs other package routines
 N DIE,DIF,X,XCN,XCNP,DGTO,DGFR,DGI,DGX
 W !!,">>> Will now load in routines for other packages, if appropriate..."
 F DGI=1:1 S DGX=$T(ROU+DGI) Q:$P(DGX,";",3)="$END"  D
 .S DGTO=$P(DGX,";",3),DGFR=$P(DGX,";",4) D LOAD(DGTO) D
 ..S X=$G(^UTILITY("DGLOAD",$J,2,0)) X $P(DGX,";",5)
 ..I $T D INSTALL(DGTO,DGFR)
 K ^UTILITY("DGLOAD",$J)
EXPORTQ Q
 ;
LOAD(DGTO) ; -- load current routine
 K ^UTILITY("DGLOAD",$J)
 S X=DGTO X ^%ZOSF("TEST")
 I $T S XCNP=0,DIF="^UTILITY(""DGLOAD"",$J," X ^%ZOSF("LOAD")
 Q
 ;
INSTALL(DGTO,DGFR) ; -- install routine
 K ^UTILITY("DGLOAD",$J)
 W !!?10," o  Installing ",DGTO," routine from ",DGFR," routine..."
 S X=DGFR,XCNP=0,DIF="^UTILITY(""DGLOAD"",$J," X ^%ZOSF("LOAD")
 S X=DGTO,XCN=3,DIE="^UTILITY(""DGLOAD"",$J," X ^%ZOSF("SAVE")
 K ^UTILITY("DGLOAD",$J)
 W !?15,DGTO,"...filed"
 Q
 ;
ROU ; -- routines to export
 ;;IBACKIN;DGVPTIB1;I $S(X="":1,1:X["1.5"),X'["*14",X'[",14"
 ;;IBECEA3;DGVPTIB2;I $S(X="":1,1:X["1.5"),X'["*14",X'[",14"
 ;;IBCNSP2;DGVPTIB3;I $S(X="":1,1:X["1.5"),X'["*14",X'[",14"
 ;;IBCNSC;DGVPTIB4;I $S(X="":1,1:X["1.5"),X'["*14",X'[",14"
 ;;IBOVOP1;DGVPTIB5;I $S(X="":1,1:X["1.5"),X'["*14",X'[",14"
 ;;DGCRNS;DGVPTIB6;I $S(X="":1,1:X["1.5"),X'["*14",X'[",14"
 ;;DVBHS5;DGVPTDV1;I $S(X="":1,1:X["4.0"),X'["*11",X'[",11"
 ;;DVBHS1;DGVPTDV2;I $S(X="":1,1:X["4.0"),X'["*11",X'[",11"
 ;;DVBHS2;DGVPTDV3;I $S(X="":1,1:X["4.0"),X'["*11",X'[",11"
 ;;DVBHS6;DGVPTDV4;I $S(X="":1,1:X["4.0"),X'["*11",X'[",11"
 ;;$END
 ;
 ;    piece 3 --> routine to replace
 ;      "   4 --> post-init routine holding new verion
 ;      "   5 --> 'ok to replace' IF test
 ;                  - X will be defined to be the 2nd line of
 ;                    current version
 ;
IVM ; -- notice about IVM affected templates
 N I,J,X
 W !!,">>> You will need to recompile the following input templates on"
 W !,"    all CPU's using the routine ^DIEZ. These templates contain"
 W !,"    patient fields that have had cross references added for IVM."
 W !!,"    Please ensure that the same routine size is used on each system."
 W !!?14,"Template",?40,"Routine",!?14,"--------",?40,"-------"
 F I=1:1 S J=$P($T(TEMP+I),";;",2) Q:J="$END"  W !?14,$P(J,";",1),?40,$P(J,";",2)
 ; AMIE 2.5 being released renames this template...add to list in IVM 1.5
 S X="DVBA C ADD 2507 PAT" I $D(^DIE("B",X)) W !?14,X,?40,"DVBAXA"
 S X="DVBC ADD 2507 PAT" I $D(^DIE("B",X)) W !?14,X,?40,"DVBAXA"
 Q
 ;
TEMP ;
 ;;DVBHINQ UPDATE;DVBHCE
 ;;IB SCREEN1;IBXSC1
 ;;$END
 ;
UPEMB ; -- update DOB field entry in file 39.2
 I '$D(^DIC(39.2)) D  G QTEMB
 .W !,">>> EMBOSSING DATA File (#39.2) was not found."
 .W !?4,"PIMS Embosser software will not run properly without this file!"
 .W !?4,"Contact your support ISC before using Embosser software.",!
 N DGIFN
 S DGIFN=$O(^DIC(39.2,"B","DOB",0))
 I 'DGIFN!('$D(^DIC(39.2,+DGIFN,0)))!($G(^DIC(39.2,+DGIFN,1))="") D  G QTEMB
 .W !,">>> 'DOB' MUMPS CODE entry not found in EMBOSSING DATA File (#39.2)"
 .W !?4,"File was NOT updated...",!
 ;NO MESSAGE IF DGIFN IS FOUND
 S ^DIC(39.2,+DGIFN,1)="S (X,Y)="""" S:$D(^DPT(DFN,0)) X=$P(^(0),""^"",3) F I=4,6,2 S Z=$E(X,I,I+1) S:'Z Z=""00"" S Y=Y_Z"
QTEMB Q
 ;
REL ; -- update religion
 N DA,DIE,DR,DE,DQ
 S DA=+$O(^DIC(13,"B","PENTACOSTAL",0))
 I DA S DIE=13,DR=".01///PENTECOSTAL" D ^DIE
 Q
