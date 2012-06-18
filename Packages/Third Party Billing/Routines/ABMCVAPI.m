ABMCVAPI ; IHS/SD/SDR - 3PB CPT/ICD/MODIFIER API   
 ;;2.6;IHS 3P BILLING SYSTEM;**4**;NOV 12, 2009
 ;
 ; New routine - v2.6
 ;
CPT(CODE,CDT,SRC,DFN) ;PEP - returns info about requested CPT entry
 I $$VERSION^XPDUTL("BCSV")>0 S A=$$CPT^ICPTCOD(CODE,CDT,"","") Q A
 E  S A=$$PRCSVCPT(CODE,CDT) Q A
 ;****************************************************************
PRCSVCPT(CODE,CDT) ;EP - build Pre-CSV IHS CPT string
 N ABMZCPT,ABMCPT
 D GETS^DIQ(81,CODE,"*","IE","ABMZCPT")
 S ABMCPT=CODE
 S ABMCPT=ABMCPT_"^"_$G(ABMZCPT(81,CODE_",",.01,"E"))  ;IEN and code
 S ABMCPT=ABMCPT_"^"_$G(ABMZCPT(81,CODE_",",2,"E"))  ;Short desc.
 S ABMCPT=ABMCPT_"^"_$G(ABMZCPT(81,CODE_",",3,"I"))  ;CPT category IEN
 S ABMCPT=ABMCPT_"^^"_$G(ABMZCPT(81,CODE_",",7,"I"))  ;Source (null) and Eff. date
 S ABMCPT=ABMCPT_"^^"_$G(ABMZCPT(81,CODE_",",8,"I"))  ;Status (null) and inact. date
 S ABMCPT=ABMCPT_"^"_$G(ABMZCPT(81,CODE_",",7,"I"))  ;Activation date
 Q ABMCPT
IHSCPT(CODE,CDT) ;EP - return IHS-numberspaced fields in string
 N ABMCPT
 I CDT="" S CDT=DT
 D GETS^DIQ(81,CODE,"9999999.01:9999999.04","IE","ABMZCPT")
 S ABMCPT=CODE  ;CPT code (p1)
 S ABMCPT=ABMCPT_"^"_$G(ABMZCPT(81,CODE_",",9999999.01,"E"))  ;starred procedure (p2)
 S ABMCPT=ABMCPT_"^"_$G(ABMZCPT(81,CODE_",",9999999.02,"E"))  ;default revenue code (p3)
 S ABMCPT=ABMCPT_"^"_$G(ABMZCPT(81,CODE_",",9999999.03,"E"))  ;relative value (p4)
 S ABMCPT=ABMCPT_"^"_$G(ABMZCPT(81,CODE_",",9999999.04,"E"))  ;global surgical procedure (p5)
 ;
 I $$VERSION^XPDUTL("BCSV")>0 D  Q ABMCPT
 .S ABMCPT=ABMCPT_"^"_$$GET1^DIQ(81,CODE_",",9999999.05,"E")  ;ASC payment group (p6)
 .S ABMCPT=ABMCPT_"^"_$$GET1^DIQ(81,CODE_",",9999999.06,"E")  ;date added (p7)
 .S ABMCPT=ABMCPT_"^"_$$GET1^DIQ(81,CODE_",",9999999.07,"E")  ;date deleted (p8)
 I $$VERSION^XPDUTL("BCSV")'>0 D
 .S ABMCPT=ABMCPT_"^"_$$GET1^DIQ(81,CODE_",",6,"E")  ;ASC payment group (p6)
 .S ABMCPT=ABMCPT_"^"_$$GET1^DIQ(81,CODE_",",7,"E")  ;date added (p7)
 .S ABMCPT=ABMCPT_"^"_$$GET1^DIQ(81,CODE_",",8,"E")  ;date deleted (p8)
 Q ABMCPT
IHSCPTD(CODE,OUTARR,DFN,CDT) ;PEP - returns info about requested ICD entry
 I $$VERSION^XPDUTL("BCSV")>0 D CPTD^ICPTCOD(CODE,OUTARR,DFN,CDT) Q OUTARR
 E  D  Q OUTARR
 .D GET1^DIQ(81,CODE,50,"IE",OUTARR,"ABMZE")
 ;****************************************************************
 ;
DX(CODE,CDT,SRC,DFN) ;PEP - returns info about requested ICD DX entry
 I $$VERSION^XPDUTL("BCSV")>0 S A=$$ICDDX^ICDCODE(CODE,CDT,"","") Q A
 E  S A=$$PRCSVDX(CODE,CDT) Q A
 ;
PRCSVDX(CODE,CDT) ;EP - build Pre-CSV IHS ICD DX string
 N ABMZDX,ABMDX
 D GETS^DIQ(80,CODE,"*","IE","ABMZDX")
 S ABMDX=CODE
 S ABMDX=ABMDX_"^"_$G(ABMZDX(80,CODE_",",.01,"E"))  ;IEN and DX code
 S ABMDX=ABMDX_"^"_$G(ABMZDX(80,CODE_",",2,"E"))  ;Identifier
 S ABMDX=ABMDX_"^"_$G(ABMZDX(80,CODE_",",3,"I"))  ;Diagnosis (short desc.)
 S ABMDX=ABMDX_"^"_$G(ABMZDX(80,CODE_",",101,"I"))  ;Unacceptable as Principal DX
 S ABMDX=ABMDX_"^"_$G(ABMZDX(80,CODE_",",5,"I"))  ;MDC
 S ABMDX=ABMDX_"^"_$G(ABMZDX(80,CODE_",",5.5,"I"))  ;MDC13
 S ABMDX=ABMDX_"^"_$G(ABMZDX(80,CODE_",",70,"I"))  ;Compl/Comorb
 S ABMDX=ABMDX_"^"_$G(ABMZDX(80,CODE_",",5.5,"I"))  ;MDC13
 S ABMDX=ABMDX_"^"_$G(ABMZDX(80,CODE_",",8,"I"))  ;ICD expanded
 S ABMDX=ABMDX_"^"_$G(ABMZDX(80,CODE_",",100,"I"))  ;Inactive flag
 S ABMDX=ABMDX_"^"_$G(ABMZDX(80,CODE_",",9.5,"I"))  ;Sex
 S ABMDX=ABMDX_"^"_$G(ABMZDX(80,CODE_",",102,"I"))  ;Inactive Date
 S ABMDX=ABMDX_"^"_$G(ABMZDX(80,CODE_",",5.7,"I"))  ;MDC24
 S ABMDX=ABMDX_"^"_$G(ABMZDX(80,CODE_",",5.9,"I"))  ;MDC25
 S ABMDX=ABMDX_"^"_$G(ABMZDX(80,CODE_",",9999999.01,"I"))  ;Lower Age
 S ABMDX=ABMDX_"^"_$G(ABMZDX(80,CODE_",",9999999.02,"I"))  ;Upper Age
 S ABMDX=ABMDX_"^"_$G(ABMZDX(80,CODE_",",9999999.04,"I"))  ;Date Added
 Q ABMDX
ICDDX(IEN,CODE,CDT,SRC,DFN) ;PEP - returns info about requested ICD entry
 ;I $$VERSION^XPDUTL("BCSV")>0 S A=$$ICDD^ICDCODE(CODE,CDT) Q A  ;abm*2.6*4 HEAT19688
 I $$VERSION^XPDUTL("BCSV")>0 S A=$$ICDD^ICDCODE(CODE,"ABMZCPTD",CDT) Q A  ;abm*2.6*4 HEAT19688
 E  D  Q A
 .S A=$$GET1^DIQ(80,IEN,10,"IE","","ABMZDX")
 ;************************************************************************
ICDOP(CODE,CDT,SRC,DFN) ;PEP - returns info about requested ICD PX entry
 I $$VERSION^XPDUTL("BCSV")>0 S A=$$ICDOP^ICDCODE(CODE,CDT,"","") Q A
 E  S A=$$PRCSVOP(CODE,CDT) Q A
 ;****************************************************************
PRCSVOP(CODE,CDT) ;EP - build Pre-CSV IHS ICD PX string
 N ABMZOP,ABMOP
 D GETS^DIQ(80.1,CODE,"*","IE","ABMZOP")
 S ABMOP=CODE
 S ABMOP=ABMOP_"^"_$G(ABMZOP(80.1,CODE_",",.01,"E"))  ;IEN and PX code
 S ABMOP=ABMOP_"^"_$G(ABMZOP(80.1,CODE_",",2,"E"))  ;Identifier
 S ABMOP=ABMOP_"^"_$G(ABMZOP(80.1,CODE_",",5,"I"))  ;MDC24
 S ABMOP=ABMOP_"^"_$G(ABMZOP(80.1,CODE_",",4,"I"))  ;Oper/Proc. (short desc.)
 Q ABMOP
ICDDOP(CODE,CDT,SRC,DFN) ;PEP - returns info about requested ICD entry
 I $$VERSION^XPDUTL("BCSV")>0 S A=$$ICDD^ICDCODE(CODE,CDT) Q A
 E  D  Q A
 .S A=$$GET1^DIQ(80.1,CODE,10,"IE","","ABMZDX")
 ;*********************************************************************
CAT(CAT,DFN) ;PEP - returns CPT Category info
 I $$VERSION^XPDUTL("BCSV")>0 S A=$$CAT^ICPTAPIU(CAT,DFN) Q A
 E  S A=$$PRCSVCAT(CAT,DFN) Q A
PRCSVCAT(CAT,DFN) ;EP - build pre-CSV IHS CPT Category string
 N ABMZCAT,ABMCAT
 D GETS^DIQ(81.1,CODE,"*","IE","ABMZCAT")
 S ABMCAT=$G(ABMZCAT(81.1,CODE_",",.01,"E"))  ;CAT name
 S ABMCAT=ABMCAT_"^^"_$G(ABMZCAT(81.1,CODE_",",3,"I"))  ;Source and Major IEN
 S ABMCAT=ABMCAT_"^^"_$G(ABMZCAT(81.1,CODE_",",3,"E"))  ;Major Category Name
 Q ABMCAT
IHSCAT(CAT,DFN) ;PEP - returns IHS specific CPT Category fields
 N ABMCAT
 D GETS^DIQ(81.1,CAT,"9999999.01:9999999.03","IE","ABMZCAT")
 S ABMCAT=$G(ABMZCAT(81,CAT_",",9999999.01,"E"))  ;default rev code (p1)
 S ABMCAT=ABMCAT_"^"_$G(ABMZCAT(81,CAT_",",9999999.02,"E"))  ;previous modifier prompt (p2)
 S ABMCAT=ABMCAT_"^"_$G(ABMZCAT(81,CAT_",",9999999.03,"E"))  ;first CPT code (p3)
 Q ABMCAT
 ;*********************************************************************
MOD(MOD,MFT,MDT,SRC,DFN) ;PEP - returns Modifier array
 I $$VERSION^XPDUTL("BCSV")>0 S A=$$MOD^ICPTMOD(MOD,MFT,MDT,"","") Q A
 E  S A=$$PRCSVMOD(MOD) Q A
PRCSVMOD(MOD) ;EP - build pre-CSV Modifer array
 N ABMZMOD,ABMMOD
 D GETS^DIQ(9999999.88,MOD,"*","IE","ABMZMOD")
 Q:'$D(ABMZMOD) 0
 S ABMMOD=MOD
 S ABMMOD=ABMMOD_"^"_$G(ABMZMOD(9999999.88,MOD_",",.01,"E"))  ;MOD code
 S ABMMOD=ABMMOD_"^"_$G(ABMZMOD(9999999.88,MOD_",",.02,"E"))  ;MOD name
 Q ABMMOD
