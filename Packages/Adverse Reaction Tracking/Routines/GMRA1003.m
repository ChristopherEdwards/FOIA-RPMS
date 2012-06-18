GMRA1003 ;IHS/MSC/PLS - Patch support;29-Aug-2011 18:20;PLS
 ;;4.0;Adverse Reaction Tracking;**1003**;Mar 29, 1996;Build 18
 ;
ENV ;EP -
 Q
PRE ;EP -
 Q
POST ;EP -
 D DATA
 Q
 ;
DATA ; Import Data
 N LP,NAM,F,LNAARY
 ; Build array of local national allergies
 S LP=0 F  S LP=$O(^GMRD(120.82,LP)) Q:'LP  D
 .Q:'$P(^GMRD(120.82,LP,0),U,3)  ;Must be a National Allergy
 .S LNAARY($P(^GMRD(120.82,LP,0),U),LP)=""
 S F=120.82
 S LP=0 F  S LP=$O(@XPDGREF@("DATA",F,LP)) Q:'LP  D
 .Q:'$P(@XPDGREF@("DATA",F,LP,0),U,3)  ; Must be marked as National Allergy
 .S NAM=$P($G(@XPDGREF@("DATA",F,LP,0)),U)
 .D STOREALG(LP)
 Q
 ;
STOREALG(DATAIEN) ;
 N FDA,FDAIEN,ERR,IENS,ARY,LP2,CNT,IEN
 Q:'$L(DATAIEN)
 M ARY=@XPDGREF@("DATA",120.82,DATAIEN)
 S IEN=$$ALGIEN(NAM)
 S:'IEN IEN="+1"
 S IENS=IEN_","
 S CNT=0
 I IEN D  ;EXISTING ENTRY
 .S FDA(F,IENS,1)=$P(ARY(0),U,2)
 .S FDA(F,IENS,2)=$P(ARY(0),U,3)
 .D FILE^DIE("K","FDA","ERR")
 .Q:$D(ERR)
 .D SUBDATA(IEN)
 E  D  ;New entry
 .S FDA(F,IENS,.01)=$P(ARY(0),U)
 .S FDA(F,IENS,1)=$P(ARY(0),U,2)
 .S FDA(F,IENS,2)=$P(ARY(0),U,3)
 .D UPDATE^DIE("","FDA","IENS","ERR")
 .I $D(ERR) W !,IENS W ERR W !! Q
 .D SUBDATA(IENS(1))
 ; Add subfile data
SUBDATA(DIEN) ;EP-
 N IENS
 S IENS=DIEN_","
 ; KILL EXISTING SUBFILE DATA
 ;Synonyms
 K ^GMRD(120.82,DIEN,3)
 S LP2=0 F  S LP2=$O(ARY(3,LP2)) Q:'LP2  D
 .S FDA(120.823,"+"_$$INC()_","_IENS,.01)=$P(ARY(3,LP2,0),U)
 ;Drug Class
 K ^GMRD(120.82,DIEN,"CLASS")
 S LP2=0 F  S LP2=$O(ARY("CLASS",LP2)) Q:'LP2  D
 .S FDA(120.8205,"+"_$$INC()_","_IENS,.01)=$P(ARY("CLASS",LP2,0),U)
 ;Drug Ingredient
 K ^GMRD(120.82,DIEN,"ING")
 S LP2=0 F  S LP2=$O(ARY("ING",LP2)) Q:'LP2  D
 .S FDA(120.824,"+"_$$INC()_","_IENS,.01)=$P(ARY("ING",LP2,0),U)
 ;Effective Date
 K ^GMRD(120.82,DIEN,"TERMSTATUS")
 S LP2=0 F  S LP2=$O(ARY("TERMSTATUS",LP2)) Q:'LP2  D
 .S FDA(120.8299,"+"_$$INC()_","_IENS,.01)=$P(ARY("TERMSTATUS",LP2,0),U)
 .S FDA(120.8299,"+"_$$INC(0)_","_IENS,.02)=$P(ARY("TERMSTATUS",LP2,0),U,2)
 K ERR
 D UPDATE^DIE("","FDA","","ERR")
 I $D(ERR) W !,IENS W ERR W !! Q
 Q
 ; Increment counter
INC(VAL) ;EP-
 S VAL=$G(VAL,1)
 S CNT=$G(CNT)+VAL
 Q CNT
DIERR(XPDI) N XPD
 D MSG^DIALOG("AE",.XPD) Q:'$D(XPD)
 D BMES^XPDUTL(XPDI),MES^XPDUTL(.XPD)
 Q
 ; Check existence of entry
EXISTS(NAM) ;EP -
 Q $O(LNAARY(NAM,0))>0
 ; Get Allergy IEN from Local National Allergies
ALGIEN(NAM) ;EP-
 Q $O(LNAARY(NAM,0))
 ; Check for Drug Allergy
DRUG(IEN) ;EP-
 Q $P($G(^GMRD(120.82,IEN,0)),U,2)["D"
 ;
PRETRAN ;EP -
 N FNAM,FILE
 S FILE=120.82
 S FNAM="GMR ALLERGIES"
 D FIA^DIFROMSU(FILE,"",FNAM,XPDGREF,"n^n^f^^n^^y^m^n","","I $P(^(0),U,3)=1",4.0)
 D DATAOUT^DIFROMS("","","",XPDGREF)
 Q
