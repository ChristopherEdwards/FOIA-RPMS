BHSASM ;IHS/CIA/MGH - Health Summary for Asthma Registry ;06-May-2010 10:25;MGH
 ;;1.0;HEALTH SUMMARY COMPONENTS;**3,4**;March 17, 2006;Build 13
 ;===================================================================
 ;Taken from APCHS9
 ;Health summary for asthma registry
 ;
REG ;asthma dx even or asthma on pl or ast
 NEW D,P,A,BHSPAT
 S BHSPAT=DFN
 S A=$O(^AUPNVAST("AA",BHSPAT,0)) I A G AST1
 S A=$$PLAST^BHSAST(BHSPAT) I A]"" G AST1
 S A=$$DXAST^BHSAST(BHSPAT) I A G AST1
 Q
AST1 ;
 D EP^BHSAST(BHSPAT)
 Q
CP ;EP
 NEW X S X="BCPSHSS" X ^%ZOSF("TEST") I '$T Q
 Q:'$D(^BCPP(DFN,0))  ;patient not in chronic patient file
 Q:'$D(^BCPA("AC",DFN))  ;no agreements
 D EP^BCPSHSS(DFN)
 Q
ANTICOAG ;EP - called from supplement
 ;has a diagnosis and a prescription for warfarin
 NEW D,P,A,B,BHSPAT
 S BHSPAT=DFN
 S B=$$ACTWARF^APCHSTP1(BHSPAT,$$FMADD^XLFDT(DT,-45),DT)
 I B G ANTICO1
 Q
ANTICO1 ;
 D EP^BHSACG(BHSPAT)
 Q
