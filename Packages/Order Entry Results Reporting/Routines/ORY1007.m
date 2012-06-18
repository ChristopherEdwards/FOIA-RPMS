ORY1007 ;IHS/MSC/MSC - Export Package Level Parameters and install Expert System rule for OR*3*1007 ;05-Nov-2010 14:42;DU
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**128**;Dec 17, 1997;Build 3
MAIN ; main (initial) parameter transport routine
 K ^TMP($J,"XPARRSTR")
 N ENT,IDX,ROOT,REF,VAL,I
 S ROOT=$NAME(^TMP($J,"XPARRSTR")),ROOT=$E(ROOT,1,$L(ROOT)-1)_","
 D LOAD
XX2 S IDX=0,ENT="PKG."_"ORDER ENTRY/RESULTS REPORTING"
 F  S IDX=$O(^TMP($J,"XPARRSTR",IDX)) Q:'IDX  D
 . N PAR,INST,VAL,ERR
 . S PAR=$P(^TMP($J,"XPARRSTR",IDX,"KEY"),U),INST=$P(^("KEY"),U,2)
 . M VAL=^TMP($J,"XPARRSTR",IDX,"VAL")
 . D EN^XPAR(ENT,PAR,INST,.VAL,.ERR)
 K ^TMP($J,"XPARRSTR")
 ;
 D S^ORY007ES  ; expert system rule post install
 Q
LOAD ; load data into ^TMP (expects ROOT to be defined)
 S I=1 F  S REF=$T(DATA+I) Q:REF=""  S VAL=$T(DATA+I+1) D
 . S I=I+2,REF=$P(REF,";",3,999),VAL=$P(VAL,";",3,999)
 . S @(ROOT_REF)=VAL
 Q
DATA ; parameter data
 ;;9417,"KEY")
 ;;ORK CLINICAL DANGER LEVEL^ALLERGIES UNASSESSIBLE
 ;;9417,"VAL")
 ;;Moderate
 ;;9418,"KEY")
 ;;ORK PROCESSING FLAG^ALLERGIES UNASSESSIBLE
 ;;9418,"VAL")
 ;;Disabled
