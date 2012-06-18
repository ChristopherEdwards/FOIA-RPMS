PXBAPI21 ;ISL/DCM - API for Classification check out ;7/25/96  15:04
 ;;1.0;PCE PATIENT CARE ENCOUNTER;;Aug 12, 1996
CLASS(ENCOWNTR,DFN,APTDT,LOC,VISIT) ;Edit classification fields
 ; Input  - ENCOWNTR - ien of ^SCE(ien (409.68 Outpatient Encounter file)
 ;          ENCOWNTR optional if DFN,LOC,APTDT params used
 ;          DFN - ien of ^DPT(DFN, (only used if no ENCOWNTR)
 ;          LOC - ien of ^SC(LOC,  (only used if no ENCOWNTR)
 ;          APTDT - Appointment Date/time (only used if no ENCOWNTR)
 ;          VISIT - optional if no ENCOWNTR look for main encounter that
 ;                  points to this visit
 ; Output - PXBDATA(Classification type)=OutPT Class ien^Value
 ;          PXBDATA("ERR",Class type)=1 Bad ptr to 409.41
 ;                                    =2 DATA entry not applicable
 ;                                    =3 DATA entry uneditable
 ;                                    =4 User ^ out of prompt
 ;            Classification type 1 - Agent Orange
 ;                                2 - Ionizing Radiation
 ;                                3 - Service Connected
 ;                                4 - Environmental Contaminants
 ; Ext References: ^SCE(DA,0)              INP^SDAM2
 ;                 REQ^SDM1A               CLINIC^SDAMU
 ;                 EXOE^SDCOU2             CLOE^SDCO21
 ;                 SEQ^SDCO21              CL^SDCO21
 ;   In ^PXBAPI22
 ;                 ^DG(43,1,"SCLR")  piece 24
 ;                 ^SD(409.41,DA,0)        ^SD(409.41,DA,2)
 ;                 VAL^SDCODD              SC^SDCO23
 I $G(ENCOWNTR)'>0,$G(VISIT)>0 D
 . S ENCOWNTR=$O(^SCE("AVSIT",VISIT,0))
 . I ENCOWNTR,$P(^SCE(ENCOWNTR,0),"^",6) S ENCOWNTR=$P(^SCE(ENCOWNTR,0),"^",6)
 N IEN,IFN,SDCLOEY,ORG,END,DA,X,SQUIT
 I $G(ENCOWNTR) Q:'$D(^SCE(+ENCOWNTR,0))  N APTDT,DFN,LOC S END=0,X0=^(0) D ENCHK(ENCOWNTR,X0) Q:END  G ON
 Q:'$G(DFN)!'$G(LOC)!'$G(APTDT)
 S X=$G(^DPT(DFN,"S",APTDT,0))
 I +X,+X=LOC,$P(X,"^",20),$D(^SCE($P(X,"^",20),0)) S ENCOWNTR=$P(X,"^",20),END=0,X0=^(0) D ENCHK(ENCOWNTR,X0) Q:END  G ON
ON D ASKCL($G(ENCOWNTR),.SDCLOEY,DFN,APTDT)
 I '$D(SDCLOEY) Q
 I $D(SDCLOEY) D ASK($G(ENCOWNTR),.SDCLOEY,.SQUIT) Q:$D(SQUIT)
 Q
ASKCL(ENCOWNTR,SDCLOEY,DFN,APTDT) ;Ask classifications on check out
 I $G(ENCOWNTR) D CLOE^SDCO21(ENCOWNTR,.SDCLOEY) Q
 D CL^SDCO21(DFN,APTDT,"",.SDCLOEY)
 Q
ASK(ENCOWNTR,SDCLOEY,SQUIT) ;Ask classifications
 N I,IOINHI,IOINORM,TYPI,TYPSEQ,CTS,X
 S X="IOINHI;IOINORM" D ENDR^%ZISS
 I '$D(SDCLOEY) Q
 W !!,"--- ",IOINHI,"Classification",IOINORM," --- [",IOINHI,"Required",IOINORM,"]"
 W ! S TYPSEQ=$$SEQ^SDCO21 ;Get classification type sequence (3,1,2,4)
 F CTS=1:1 S TYPI=+$P(TYPSEQ,",",CTS) Q:'TYPI!($D(SQUIT))  D
 .I $D(SDCLOEY(TYPI)) D
 ..D ONE^PXBAPI22(TYPI,SDCLOEY(TYPI),ENCOWNTR,.SQUIT)
 ..I TYPI=3 F I=1,2,4 S:$D(SDCLOEY(I))&($P($G(PXBDATA(3)),"^",2)=1) $P(SDCLOEY(I),"^",3)=1 S:$P($G(PXBDATA(3)),"^",2)=0&('$D(SDCLOEY(I))) SDCLOEY(I)=""
 Q
ENCHK(ENCOWNTR,X0) ;Do outpatient encounter checks
 S APTDT=+X0,DFN=$P(X0,"^",2),LOC=$P(X0,"^",4),ORG=$P(X0,"^",8),DA=$P(X0,"^",9)
 I $$REQ^SDM1A(+X0)'="CO" S END=1 Q  ;Check MAS Check out date parameter
 I ORG=1,'$$CLINIC^SDAMU(+LOC) S END=1 Q  ;Screen for valid clinic
 I "^1^2^"[("^"_ORG_"^"),$$INP^SDAM2(+DFN,+X0)="I" S END=1 Q  ;Inpat chk
 I $$EXOE^SDCOU2(ENCOWNTR) S END=1 Q  ;Chk exempt Outpt classifications
 Q
TEST ;Test call to CLASS
 N PXIFN S PXIFN=63
 F  S PXIFN=$O(^SCE(PXIFN)) Q:PXIFN<1  S DFN=$P(^(PXIFN,0),"^",2) K PXBDATA W !!,PXIFN_"   "_$P(^DPT(DFN,0),"^") D  S %=1 W !,"Continue " D YN^DICN Q:%'=1
 . D CLASS(PXIFN)
 . ;W ! ZW PXBDATA
 Q
