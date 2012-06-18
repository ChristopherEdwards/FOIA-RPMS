DGVPTIB3 ;alb/mjk - IBCNSP2 for export with PIMS v5.3; 4/21/93
 ;;5.3;Registration;;Aug 13, 1993
 ;
IBCNSP2 ;ALB/AAS - PATIENT INSURANCE INTERFACE FOR REGISTRATION ; 12-APR-93
 ;;Version 1.5 ; INTEGRATED BILLING ;**14**; 29-JUL-92
 ;
REG ; -- Edit Insurance Type subfield of patient file by registration
 ; -- Input DFN
 ;
 N VALMQUIT,DIC,DIE,DA,DR,IBCNP
 S IBCNP=1
 I '$D(DFN) D  G:$D(VALMQUIT) REGQ
 .S DIC="^DPT(",DIC(0)="AEQMN" D ^DIC
 .S DFN=+Y
 I $G(DFN)<1 S VALMQUIT="" G REGQ
 ;
 ; -- ask if covered by insuracnce
 S DIE="^DPT(",DR=".3192",DA=DFN D ^DIE
 I $P($G(^DPT(DFN,.31)),"^",11)'="Y" G REGQ
 K DA,DR,DIE,DIC
 ;
R1 S DIC="^DPT("_DFN_",.312,",DIC(0)="AEQLM",DIC("A")="Select Insurance Policy: "
 I IBCNP=1 S X=$P($G(^DIC(36,+$G(^DPT(DFN,.312,+$P($G(^DPT(DFN,.312,0)),"^",3),0)),0)),"^") I X'="" S DIC("B")=X
 S DA(1)=DFN
 I $G(^DPT(DFN,.312,0))="" S ^DPT(DFN,.312,0)="^2.312PAI^^"
 D ^DIC K DIC I +Y<1 S VALMQUIT=""
 S IBCNP=IBCNP+1
 G:$D(VALMQUIT) REGQ
 ;
 S DA(1)=DFN,DA=+Y
 S DIE="^DPT("_DA(1)_",.312,"
 S DR="S IBAD="""";.01;1;2;15;8;3;6;S IBAD=X;I IBAD'=""v"" S Y=""@10"";17///^S X=""`""_DFN;16///^S X=""01"";S Y=""@20"";@10;17;16//^S X=$S(IBAD=""s"":""02"",1:"""");@20;"
 D ^DIE K DA,DR,DIE,DIC
 W !
 G R1
 ;
 ; -- old registration edit logic
 ;I DGDR["501," S DR(2,2.312)="S DGRPADI="""";.01;1;2;15;8;7;3;6;S DGRPADI=X;I DGRPADI'=""v"" S Y=""@2312"";17///^S X=""`""_DFN;16///^S X=""01"";S Y=""@23121"";@2312;17;16//^S X=$S(DGRPADI=""s"":""02"",1:"""");@23121;9:14;"
 ;
REGQ Q
 ;
DISP ; -- Display Patient insurance policy information for registrations
 Q:'$D(DFN)
 S X="IBCNS" X ^%ZOSF("TEST") I $T D DISP^IBCNS G DISPQ
 S X="DGCRNS" X ^%ZOSF("TEST") I $T D DISP^DGCRNS G DISPQ
DISPQ Q
