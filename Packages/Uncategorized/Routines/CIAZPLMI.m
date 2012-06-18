CIAZPLMI ;CIA/PLS - PCC Hook for Lab- Micro Data - Results ;13-Sep-2004 14:20;PLS
 ;;1.1;VUECENTRIC RPMS SUPPORT;;Sep 14, 2004
 ;;Copyright 2000-2004, Clinical Informatics Associates, Inc.
 ;=================================================================
RE ; Result Message
 N EXEC,GBL,VAL0,LRDFN,LRIDT,CULT,RESETIEN
 ;
 S LRDFN=$$LRDFN^LR7OR1($G(DFN))
 Q:'LRDFN
 S LRIDT=$P(LABORDF,";",5)
 ; Determine MI Test Type
 S EXEC=$P($G(^LAB(60,TST,0)),U,14)  ; Edit Code
 ; First Field number in Execute Code entry
 S GBL=$P($P($P($G(^LAB(62.07,EXEC,.1)),"/"),"=",2),"""",2)
 ; Get MI subfield number subscript
 S GBL=$P($P($G(^DD(63.05,GBL,0)),U,4),";",1)
 S VAL0=$G(^LR(LRDFN,"MI",LRIDT,GBL))
 Q:$P(VAL0,U,2)'="F"  ; Only process FINAL results
 S CULT=TST,RESETIEN=0,VSTAT="R"
 S (ORG,ATB)=""
 S PTST=TST
 I TST D
 .I GBL=1 D BACT Q
 .I GBL=5 D PARA Q
 .I GBL=8 D MYCO Q
 .I GBL=11 D TB Q
 .I GBL=16 D VIROL Q
 Q
 ; Add to PCC array
ADD(X,Y) ;
 I +$G(Y) D
 .S PCC(Y)=X
 E  S PCC=$G(PCC)+1,PCC(PCC)=X
 Q
 ; Find a node in PCC array
FINDNODE(ARY,VAL) ;
 N LP
 S LP=0 F  S LP=$O(ARY(LP)) Q:'LP  Q:$E(ARY(LP),1,$L(VAL))=VAL
 Q $S(LP:LP,1:-1)
 ; Return specified segment, starting at line LP
SEG(TYP,LP) ;
 F  S LP=$O(MSG(LP)) Q:'LP  Q:$E(MSG(LP),1,$L(TYP))=TYP
 Q $S(LP:MSG(LP),1:"")
 ;
BACT ;
 N NOD3
 S RES="NEGATIVE"
 S NOD3=$G(^LR(LRDFN,"MI",LRIDT,3,0))
 I '$P(NOD3,U,3),'$P(NOD3,U,4) D  Q
 .D SETADD
 S RES="POSITIVE" D SETADD
 D ORG(3)
 Q
 ;
PARA ;
 N NOD6
 S RES="NEGATIVE"
 S NOD6=$G(^LR(LRDFN,"MI",LRIDT,6,0))
 I '$P(NOD6,U,3) D  Q
 .D SETADD
 S RES="POSITIVE" D SETADD
 D ORG(6)
 Q
 ;
MYCO ;
 N NOD9
 S RES="NEGATIVE"
 S NOD9=$G(^LR(LRDFN,"MI",LRIDT,9,0))
 I '$P(NOD9,U,3) D  Q
 .D SETADD
 S RES="POSITIVE" D SETADD
 D ORG(9)
 Q
 ;
TB ;
 N NOD12
 I $P(VAL0,U,3)'=""!($P(VAL0,U,4)'="") D AFSTN
 I CULT=TST,$L(RES) Q
 S TST=CULT
 S RES="NEGATIVE"
 S NOD12=$G(^LR(LRDFN,"MI",LRIDT,12,0))
 I '$P(NOD12,U,3) D  Q
 .D SETADD
 S RES="POSITIVE" D SETADD
 D ORG(12)
 Q
 ;
AFSTN ;
 N TST
 S TST=$O(^LAB(60,"B","ACID FAST STAIN","")) I 'TST S TST=$O(^LAB(60,"B","AFB SMEAR",""))
 Q:'TST
 S RES=$P(VAL0,U,3) S:$L(RES)&($L($P(VAL0,U,4))) RES=RES_";"_$P(VAL0,U,4)
 S:RES="" RES=$P(VAL0,U,4)
 D SETADD
 Q
VIROL ;
 N NOD17
 S RES="NEGATIVE"
 S NOD17=$G(^LR(LRDFN,"MI",LRIDT,17))
 I '$P(NOD9,U,3) D  Q
 .D SETADD
 S RES="POSITIVE" D SETADD
 D ORG(17)
 Q
 ;
ORG(LEVEL) ;
 N OLP
 S OLP=0 F  S OLP=$O(^LR(LRDFN,"MI",LRIDT,LEVEL,OLP)) Q:'OLP  D   ; Sets naked reference
 .S ORG=^(OLP,0),RES=$P(ORG,U,2),ORG=+ORG
 .S RESETIEN=1,ATB=""
 .D SETADD
 .S RESETIEN=0
 .I LEVEL=6 D
 ..D PSTG
 .E  I LEVEL'=17 D
 ..D ATB
 Q
 ;
ATB ;
 N ALP
 S ALP=1 F  S ALP=$O(^LR(LRDFN,"MI",LRIDT,LEVEL,OLP,ALP)) Q:'ALP  D   ; Sets naked reference
 .S RES=$P(^(ALP),U)
 .I LEVEL'=11 D
 ..S ATB=$O(^LAB(62.06,"AD",ALP,""))
 .E  D
 ..S ATB=$$TBATB(ALP)
 .D:ATB SETADD
 Q
 ; Return TB Antibiotic IEN
TBATB(ANTIB) ;
 S ATB=0
 S ATBN=$O(^DD(63.39,"GL",ANTIB,1,""))
 Q:'ATBN 0
 S ATBN=$P($G(^DD(63.39,ATBN,0)),U)
 S ATB=$$FIND1^DIC(62.06,,"MX",ATBN)
 Q $S(ATB>0:ATB,1:0)
 ;
PSTG ;
 N SLP,STG
 S SLP=$O(^LR(LRDFN,"MI",LRIDT,LEVEL,OLP,1,STG)) Q:'STG  D
 .S STG=^LR(LRDFN,"MI",LRIDT,LEVEL,OLP,1,STG)
 .S RES=$P(STG,U,2),STG=$P(STG,U)
 .D SETADD
 Q
SETADD ;
 D ADD(ACT_U_TST_U_FLN_U_VSTAT_U_ACC_U_LABORDF_U_ODT_U_CDT_U_PRV_U_TCST_U_SPEC_U_COLSPL_U_RES_U_CMPDT_U_AFLG_U_UNITS_U_RLOW_U_RHIGH_U_ORG_U_ATB_U_RESETIEN)
 Q
