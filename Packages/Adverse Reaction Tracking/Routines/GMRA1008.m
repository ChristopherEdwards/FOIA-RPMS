GMRA1008 ;IHS/MSC/PLS - Patch support;19-Sep-2014 10:02;DU
 ;;4.0;Adverse Reaction Tracking;**1008**;Mar 29, 1996;Build 8
 ;
ENV ;EP -
 N PATCH
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 ;Check for the installation of other patches
 S PATCH="GMRA*4.0*1007"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDQUIT=2
 Q
 ;
PATCH(X) ;return 1 if patch X was installed, X=aaaa*nn.nn*nnnn
 ;copy of code from XPDUTL but modified to handle 4 digit IHS patch numb
 Q:X'?1.4UN1"*"1.2N1"."1.2N.1(1"V",1"T").2N1"*"1.4N 0
 NEW NUM,I,J
 S I=$O(^DIC(9.4,"C",$P(X,"*"),0)) Q:'I 0
 S J=$O(^DIC(9.4,I,22,"B",$P(X,"*",2),0)),X=$P(X,"*",3) Q:'J 0
 ;check if patch is just a number
 Q:$O(^DIC(9.4,I,22,J,"PAH","B",X,0)) 1
 S NUM=$O(^DIC(9.4,I,22,J,"PAH","B",X_" SEQ"))
 Q (X=+NUM)
PRE ;EP -
 ;Loop through the allergy file and remove any bad cross-references to
 ;the drug file that are found there
 N IEN,AIEN,FDA,X,X1,X2
 S IEN=0 F  S IEN=$O(^GMR(120.8,IEN)) Q:'+IEN  D
 .S X=$P($G(^GMR(120.8,IEN,0)),U,3)
 .I X[$C(34) D
 ..S X1=$P(X,$C(34))
 ..S X2=X1_","
 ..S AIEN=IEN_","
 ..S FDA(120.8,AIEN,1)=X2
 ..D UPDATE^DIE(,"FDA","DIEN","ERR")
 Q
POST ;EP -
 D DATA,SIGNS
 D INACT
 ;D TOP10^GMRAUTL2
 Q
INACT ;EP Remove duplicate caterpillar entries
 N IEN,X,SAVE
 S SAVE=0
 S IEN="" F  S IEN=$O(^GMRD(120.82,"B","CATERPILLER STING",IEN)) Q:IEN=""  D
 .S X=$$CHECK^ORWDAL32(IEN)
 .I X=0  D INAC(IEN)
 Q
INAC(IEN) ;Inactivate this entry
 K ERR,FDA,NIEN,FNUM
 S FNUM=120.8299
 S AIEN="+1,"_IEN_","
 S FDA(120.8299,AIEN,.01)=$$NOW^XLFDT
 S FDA(120.8299,AIEN,.02)=0
 D UPDATE^DIE(,"FDA","NIEN","ERR")
 I $D(ERR) W !,IENS W ERR("DIERR",1,"TEXT",1) W !
 Q
 ;
SIGNS ;EP-
 N F,LP,NAM
 S F=120.83
 D DATAIN^DIFROMS(F,"","",XPDGREF),DIERR("** ERROR IN DATA FOR FILE # "_F_" **"):$D(DIERR)
 Q
 ;
DATA ; Import Data
 N LP,NAM,F,LNAARY,XUMF
 ; Build array of local national allergies
 S LP=0 F  S LP=$O(^GMRD(120.82,LP)) Q:'LP  D
 .Q:'$P(^GMRD(120.82,LP,0),U,3)  ;Must be a National Allergy
 .S LNAARY($P(^GMRD(120.82,LP,0),U),LP)=""
 S F=120.82,XUMF=1
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
 S IENS=IEN_",",X=IEN
 S CNT=0
 I X=+X D  ;EXISTING ENTRY
 .S FDA(F,IENS,1)=$P(ARY(0),U,2)
 .S FDA(F,IENS,2)=$P(ARY(0),U,3)
 .S FDA(F,IENS,99.99)=$P($G(ARY("VUID")),U,1)
 .S FDA(F,IENS,99.98)=$P($G(ARY("VUID")),U,2)
 .D FILE^DIE("K","FDA","ERR")
 .Q:$D(ERR)
 .D SUBDATA(IEN)
 E  D  ;New entry
 .S FDA(F,IENS,.01)=$P(ARY(0),U)
 .S FDA(F,IENS,1)=$P(ARY(0),U,2)
 .S FDA(F,IENS,2)=$P(ARY(0),U,3)
 .S FDA(F,IENS,99.99)=$P($G(ARY("VUID")),U,1)
 .S FDA(F,IENS,99.98)=$P($G(ARY("VUID")),U,2)
 .D UPDATE^DIE("","FDA","IENS","ERR")
 .I $D(ERR) W !,IENS W ERR W !! Q
 .D SUBDATA(IENS(1))
 Q
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
 I $D(ERR) W !,IENS W ERR("DIERR",1,"TEXT",1) W !! Q
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
 D PRELOOP(120.82,"GMR ALLERGIES",""),PRELOOP(120.83,"SIGN/SYMPTOMS","")
 Q
PRELOOP(FILE,FNAM,SCRN) ;EP-
 D FIA^DIFROMSU(FILE,"",FNAM,XPDGREF,"n^n^f^^n^^y^m^n","",SCRN,4.0)
 D DATAOUT^DIFROMS("","","",XPDGREF)
 Q
