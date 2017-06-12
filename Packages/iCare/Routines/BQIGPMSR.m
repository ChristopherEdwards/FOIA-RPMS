BQIGPMSR ;GDHD/HS/ALA-GPRA Patient Demographic Measures ; 20 Apr 2016  2:55 PM
 ;;2.5;ICARE MANAGEMENT SYSTEM;**1**;May 24, 2016;Build 17
 ;
EN ; EP
 D INP^BQINIGHT
 S BQIROU=$E(BQIROU,1,$L(BQIROU)-1)
 F I=1:1:6 S TEXT=$P($T(MSR+I),";;",2) Q:TEXT=""  D
 . F BJ=1:1:$L(TEXT,"~") D
 .. S NDATA=$P(TEXT,"~",BJ)
 .. S ND=$P(NDATA,"|",1),VAL=$P(NDATA,"|",2)
 .. I ND=0 D
 ... NEW DIC,X,Y
 ... S DIC(0)="LQZ",DIC="^BQI(90506.1,",X=$P(VAL,U,1)
 ... D ^DIC
 ... S IEN=+Y
 ... I IEN=-1 K DO,DD D FILE^DICN S IEN=+Y
 .. I ND=0 S ^BQI(90506.1,IEN,0)=VAL
 .. I ND=1 S BQIUPD(90506.1,IEN_",",1)="S VAL="_$P(VAL,"^",1)_"^"_BQIROU_$P(VAL,"^",2,99) Q
 .. I ND=3 S ^BQI(90506.1,IEN,3)=VAL Q
 .. I ND=4 S ^BQI(90506.1,IEN,4,0)="^^1^1^"_DT,^BQI(90506.1,IEN,4,1,0)=VAL
 ;
 D FILE^DIE("","BQIUPD","ERROR")
 Q
 ;
MSR ;EP - Measures
 ;;0|GPACTCL^^CRS Active Clinical^D^^^^T00003GPACTCL~1|$$ACTCL^(DFN,$$DATE^BQIUL1("T-12M"),DT)~3|1^^CRS Flag^O^58~4|Patient considered Active Clinical by CRS.
 ;;0|GPDMEV^^CRS DM DX Ever^D^^^^T00003GPDMEV~1|$$DM^(DFN,,END)~3|1^^CRS Flag^O^59~4|Did patient have a DM Diagnosis ever recorded in RPMS.
 ;;0|GPDMVYR^^CRS DM DX Report Period^D^^^^T00003GPDMVYR~1|$$DM^(DFN,$$DATE^BQIUL1("T-12M"),DT)~3|1^^CRS Flag^O^60~4|Patient had a DM Diagnosis in the Report Period.
 ;;0|GPDMFD^^CRS First DM Dx^D^^^^T00003GPDMFD~1|$$FIRSTDM^(DFN,$$DATE^BQIUL1("T-12M"))~3|1^^CRS Flag^O^61~4|Patient's First DM Diagnosis was before Report Period.
 ;;0|GPDMYV^^CRS One DM Visit^D^^^^T00003GPDMYV~1|$$V1DM^(DFN,$$DATE^BQIUL1("T-12M"),DT)~3|1^^CRS Flag^O^62~4|Patient had 1 DM Visit in Report Period.
 ;;0|GPDM2V^^CRS Two DM Visits^D^^^^T00003GPDM2V~1|$$V2DM^(DFN,$$DOB^AUPNPAT(DFN),DT)~3|1^^CRS Flag^O^63~4|Patient had 2 DM Visits Ever.
 ;;0|GP2V^^CRS Two Visits^D^^^T0003GP2V~1|$$V2^(DFN,$$DATE^BQIUL1("T-12M"),DT)~3|1^^CRS Flag^O^64~4|Patient had 2 Visits in Report Period.
