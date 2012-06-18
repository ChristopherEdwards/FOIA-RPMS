GMRA1001 ;IHS/MSC/PLS - Patch support;04-May-2011 09:45;MGH
 ;;4.0;;;;Build 5
ENV ;EP -
 Q
PRE ;EP -
 ;Loop through the allergy file and remove any bad cross-references to
 ;the drug file that are found there
 N IEN,FIELD,ALL,AIEN,FDA,X,Y
 S X="PSDRUG(""B""),"
 S Y="PSDRUG(""C""),"
 S IEN=0 F  S IEN=$O(^GMR(120.8,IEN)) Q:'+IEN  D
 .S FIELD=$P($G(^GMR(120.8,IEN,0)),U,3)
 .I $P(FIELD,";",2)=X!($P(FIELD,";",2)=Y) D
 ..S NUM=$P(FIELD,";",1)_";"_"PSDRUG("
 ..S AIEN=IEN_","
 ..S FDA(120.8,AIEN,1)=NUM
 ..D UPDATE^DIE(,"FDA","DIEN","ERR")
 Q
POST ;EP -
 D DATA
 Q
 ;
DATA ; Import Data
 N LP,NAM,F
 S F=120.82
 F LP=0:0 S LP=$O(@XPDGREF@("DATA",F,LP)) Q:'LP  D
 .S NAM=$P($G(@XPDGREF@("DATA",F,LP,0)),U)
 .I $$EXISTS(NAM) D
 ..K @XPDGREF@("DATA",F,LP)
 D DATAIN^DIFROMS(F,"","",XPDGREF),DIERR("** ERROR IN DATA FOR FILE # "_F_" **"):$D(DIERR)
 Q
DIERR(XPDI) N XPD
 D MSG^DIALOG("AE",.XPD) Q:'$D(XPD)
 D BMES^XPDUTL(XPDI),MES^XPDUTL(.XPD)
 Q
 ; Check existence of entry
EXISTS(NAM) ;EP -
 Q $O(^GMRD(120.82,"B",NAM,0))>0
 ;
PRETRAN ;EP -
 N FNAM,FILE
 S FILE=120.82
 S FNAM="GMR ALLERGIES"
 D FIA^DIFROMSU(FILE,"",FNAM,XPDGREF,"n^y^f^^y^^y^m^n","","",4.0)
 D DATAOUT^DIFROMS("","","",XPDGREF)
 Q
