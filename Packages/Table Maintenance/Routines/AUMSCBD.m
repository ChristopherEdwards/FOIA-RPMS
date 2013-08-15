AUMSCBD ;IHS/OIT/NKD - SCB UPDATE - DRIVER 08/24/2012 ;
 ;;12.0;TABLE MAINTENANCE;**4**;SEP 27,2011;Build 1
 Q
 ;Called at POST by KIDS for AUM updates
POST ; EP -- MAIN EP
 N AUMCNT,HDR,ONE,AT,AUMDT,AUMT,AUMA,CNT
 S AUMCNT=0,HDR="",ONE=1,AT="@",AUMDT=$P($$NOW^XLFDT(),".")
 F  S AUMCNT=$O(^AUMDATA(AUMCNT)) Q:'AUMCNT  D
 . N AUMT,AUMA,CNT
 . S AUMT=$P(^AUMDATA(AUMCNT,0),U,2),AUMA=""
 . F CNT="ADD","ACT","INA","DEL" Q:$L(AUMA)>0  S:$E(AUMT,$L(AUMT)-2,$L(AUMT))=CNT AUMA=$E(AUMT,$L(AUMT)-2,$L(AUMT)),AUMT=$E(AUMT,1,$L(AUMT)-3)
 . D ENTRY(AUMT,AUMA,$P(^AUMDATA(AUMCNT,0),U,3,8))
 I HDR["EDT" D PKLST^AUMSCBU
 Q
ENTRY(AUMT,AUMA,L) ; MAIN UPDATE DRIVER
 N P1,P2,P3,P4,P5,P6,P1A,P2A,P3A,P4A,P5A,P6A,L1,F1,F2,F3
 N FDA,NEWIEN,ERR,CNT,CNT2,TEXT,INA
 ; D=DATA,E=ERROR,I=IEN,L=LIST,M=MODIFY,P=PRINT,R=RESULT,S=STRING
 N AUMD,AUME,AUMI,AUML,AUMM,AUMP,AUMR,AUMS
 S (AUMI,AUMM,AUML)="",AUMP=0,INA=$S(AUMA="INA":1,AUMA="DEL":1,1:0)
 F CNT=1:1:6 S @("P"_CNT)=$P(L,U,CNT),@("P"_CNT_"A")=""
 F CNT=1:1 S TEXT=$P($T(@(AUMT)+CNT^AUMSCBM),";;",2) Q:TEXT="END"  D
 . S AUMD(TEXT)=$P($T(@(AUMT)+CNT^AUMSCBM),";;",3)
 ; PRE-UPDATE
 I $D(AUMD("PRE")) D @(AUMD("PRE"))
 Q:$D(AUME)
 ; SEARCH
 S:'AUMI&$D(AUMD("SEA")) AUMI=$$SEARCH(AUMD("SEA"))
 ; INACTIVATE
 I INA,$D(AUMD("INA")) D INACT Q
 Q:INA
 ; NEW
 I 'AUMI,$D(AUMD("NEW")) D NEW
 Q:'AUMI
 ; UPDATE
 I $D(AUMD("UPD")) D UPDATE
 ; ACTIVATE
 I AUMA="ACT",$D(AUMD("ACT")) D ACT
 ; WP
 I $D(AUMD("WP")) D WP
 ; POST-UPDATE
 I $D(AUMD("POS")) D @(AUMD("POS")) Q
 ; DISPLAY
 I $D(AUMD("DSP")) D DISP Q
 D RSLT(AUMT_": "_L)
 Q
SEARCH(AUMD) ; EP - GENERIC SEARCH DRIVER - PICKS HIGHEST IEN IF MULTIPLE RESULTS FOUND
 N F1,F2,F3,CNT,CNT2,AUMR,AUMI
 S F1=$P(AUMD,U,1),F2=$P(AUMD,U,2),AUMI=""
 F CNT=1:1:$L(F2,";") Q:AUMI]""  D
 . S F3=$P(F2,";",CNT)
 . I '$D(@$P(F3,"|",1)) D ERR("SYSTEM ERROR - Unassigned local variable: "_$P(F3,"|",1)) Q
 . D FIND^DIC(F1,"","@;.01","PX",@$P(F3,"|",1),,$P(F3,"|",2),,,"AUMR")
 . S CNT2=$P($G(AUMR("DILIST",0)),U,1)
 . S AUMI=$S(CNT2=1:$P($G(AUMR("DILIST",1,0)),U,1),CNT2>1:$P($G(AUMR("DILIST",$P($G(AUMR("DILIST",0)),U,1),0)),U,1),1:"")
 Q AUMI
INACT ; GENERIC INACTIVATE DRIVER
 N FDA,ERR,F1,F2,F3,CNT
 S AUMM=AUMA_" :"
 I 'AUMI D ERR("Entry not found to INACTIVATE (ok)") Q
 ; CUSTOM INACTIVATE CHECK
 I AUMD("INA")'["|" D @(AUMD("INA")) Q
 S F1=$P(AUMD("INA"),U,1),F2=$P(AUMD("INA"),U,2)
 F CNT=1:1:$L(F2,";") D
 . S F3=$P(F2,";",CNT)
 . I '$D(@$P(F3,"|",2)) D ERR("SYSTEM ERROR - Unassigned local variable: "_$P(F3,"|",2)) Q
 . S FDA(F1,AUMI_",",$P(F3,"|",1))=@$P(F3,"|",2)
 D UPDATE^DIE(,"FDA",,"ERR")
 I $D(ERR) D ERR("SYSTEM ERROR - Inactivate failed") Q
 D DISP
 Q
NEW ; GENERIC NEW ENTRY DRIVER
 N FDA,NEWIEN,ERR,F1,F2,F3,CNT
 S AUMM="NEW :"
 ; CUSTOM NEW ENTRY CHECK
 I AUMD("NEW")'["|" D @(AUMD("NEW")) Q
 S F1=$P(AUMD("NEW"),U,1),F2=$P(AUMD("NEW"),U,2)
 F CNT=1:1:$L(F2,";") D
 . S F3=$P(F2,";",CNT)
 . I '$D(@$P(F3,"|",2)) D ERR("SYSTEM ERROR - Unassigned local variable: "_$P(F3,"|",2)) Q
 . Q:(@$P(F3,"|",2))']""
 . S FDA(F1,"+1,",$P(F3,"|",1))=@$P(F3,"|",2)
 D UPDATE^DIE($S($L($P(AUMD("NEW"),U,3))<1:"E",1:""),"FDA","NEWIEN","ERR")
 I $D(ERR) D ERR("SYSTEM ERROR - New entry failed") Q
 S AUMI=NEWIEN(1)
 Q
UPDATE ; GENERIC UPDATE DRIVER
 N FDA,ERR,F1,F2,F3,CNT,AUMR
 S F1=$P(AUMD("UPD"),U,1),F2=$P(AUMD("UPD"),U,2),AUMR=""
 F CNT=1:1:$L(F2,";") D
 . S F3=$P(F2,";",CNT)
 . I '$D(@$P(F3,"|",2)) D ERR("SYSTEM ERROR - Unassigned local variable: "_$P(F3,"|",2)) Q
 . Q:(@$P(F3,"|",2))']""
 . S FDA(F1,AUMI_",",$P(F3,"|",1))=@$P(F3,"|",2)
 . S AUMR=AUMR_$P(F3,"|",1)_"|"_$TR($$GET1^DIQ(F1,AUMI,$P(F3,"|",1),"I"),U,";;")_"|"_$P(F3,"|",2)_U
 D UPDATE^DIE($S($L($P(AUMD("UPD"),U,3))<1:"E",1:""),"FDA",,"ERR")
 I $D(ERR) D ERR("SYSTEM ERROR - Update failed") Q
 I AUMM']"" D
 . I AUMA="ADD" S AUMM=AUMA_" :" Q
 . F CNT=1:1:$L(AUMR,U) Q:$P(AUMR,U,CNT)']""  D
 . . Q:$$GET1^DIQ(F1,AUMI,$P($P(AUMR,U,CNT),"|",1),"I")=$TR($P($P(AUMR,U,CNT),"|",2),";;",U)
 . . S AUML=AUML_$P($P(AUMR,U,CNT),"|",1)_"|"_$P($P(AUMR,U,CNT),"|",2)_"|"_$P($P(AUMR,U,CNT),"|",3)_U
 . . S AUMM="MOD :"
 Q
ACT ; GENERIC ACTIVATE DRIVER
 N FDA,ERR,F1,F2,F3,CNT ;,AUMR
 S:AUMM']"" AUMM=AUMA_" :"
 S F1=$P(AUMD("ACT"),U,1),F2=$P(AUMD("ACT"),U,2) ;,AUMR=""
 F CNT=1:1:$L(F2,";") D
 . S F3=$P(F2,";",CNT)
 . I '$D(@$P(F3,"|",2)) D ERR("SYSTEM ERROR - Unassigned local variable: "_$P(F3,"|",2)) Q
 . Q:(@$P(F3,"|",2))']""
 . S FDA(F1,AUMI_",",$P(F3,"|",1))=@$P(F3,"|",2)
 . ;S AUMR=AUMR_$P(F3,"|",1)_"|"_$TR($$GET1^DIQ(F1,AUMI,$P(F3,"|",1),"I"),U,";;")_U
 D UPDATE^DIE($S($L($P(AUMD("ACT"),U,3))<1:"E",1:""),"FDA",,"ERR")
 I $D(ERR) D ERR("SYSTEM ERROR - Activate failed") Q
 Q
WP ; GENERIC WORD-PROCESSING DRIVER
 N FDA,ERR,F1,F2,F3,CNT
 S F1=$P(AUMD("WP"),U,1),F2=$P(AUMD("WP"),U,2)
 F CNT=1:1:$L(F2,";") D
 . S F3=$P(F2,";",CNT)
 . I '$D(@$P(F3,"|",2)) D ERR("SYSTEM ERROR - Unassigned local variable: "_$P(F3,"|",2)) Q
 . D TEXT(.@($P(F3,"|",2)))
 . D WP^DIE(F1,AUMI_",",$P(F3,"|",1),,$P(F3,"|",2))
 Q
DISP ; EP - GENERIC DISPLAY DRIVER
 N F1,F2,CNT,AUMS
 Q:AUMP
 I $D(AUMD("DSP")) D
 . S AUMS=""
 . F CNT=1:1:$L(AUMD("DSP"),";") D
 . . S F1=$P($P(AUMD("DSP"),";",CNT),"|",1),F2=$P($P(AUMD("DSP"),";",CNT),"|",2)
 . . S AUMS=AUMS_$E(@F1,1,F2)_$J("",F2+1-$L($E(@F1,1,F2)))
 . ; CHECK IF TABLE HEADER NEEDS TO BE DISPLAYED
 . I $D(AUMD("HDR")) D
 . . S F1=$P(AUMD("HDR"),U,1),F2=$P(AUMD("HDR"),U,2)
 . . Q:$P(HDR,U,$L(HDR,U)-1)=@F1
 . . D RSLT("")
 . . F CNT=1:1:$L(F2,"|") D RSLT($P(F2,"|",CNT))
 . . D RSLT($TR($P(F2,"|",CNT),"ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",$$REPEAT^XLFSTR("=",36)))
 . . S HDR=HDR_@F1_U
 . D RSLT(AUMS)
 . S AUMP=1
 Q
ERR(%) ; EP - ERROR MESSAGES
 S:'INA AUME="",AUMM="ERR :"
 D DISP,RSLT($J("",2)_%)
 Q
RSLT(%) ; EP - ISSUE MESSAGES DURING INSTALL
 D MES^XPDUTL(%)
 Q
 ;
CLEAN(X) ; EP - STRING CLEANING UTILITY
 N CNT,AUMS
 S AUMS=X
 S CNT=0 F  S CNT=$F(X," -") Q:'CNT  S $E(X,CNT-2,CNT-1)="-"
 S CNT=0 F  S CNT=$F(X,"- ") Q:'CNT  S $E(X,CNT-2,CNT-1)="-"
 S CNT=0 F  S CNT=$F(X,"  ") Q:'CNT  S $E(X,CNT-2,CNT-1)=" "
 I $E(X,1)=" " S X=$E(X,2,$L(X))
 I $E(X,$L(X))=" " S X=$E(X,1,$L(X)-1)
 Q X
TEXT(X) ; EP - STRING TO WP ARRAY USING '|' AS A DELIMITER
 N AUMS,I,J
 S AUMS=X,I=1,J=1
 K X
 F I=1:1:$L(AUMS,"|")  D
 . Q:$L($P(AUMS,"|",I))=0
 . S X(J)=$P(AUMS,"|",I),J=J+1
 Q
