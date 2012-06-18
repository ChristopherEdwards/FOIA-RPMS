BEHOARMU ;MSC/IND/MGH - ART Enhancements for meaningful use ;14-Mar-2011 18:23;DU
 ;;1.1;BEH COMPONENTS;**045004**;Sep 18, 2007;Build 1
 ;=================================================================
 ;Return the values that can be selected for the chosen field
 ;Inp=file^field
 ;Return= Array of values that can be used for this field in this file
REASONS(RET,FLG) ;EP List of reasons
 N IEN,CNT,X,Y
 S RET=$$TMPGBL()
 S CNT=0
 S IEN=0 F  S IEN=$O(^BEHOAR(90460.05,IEN)) Q:'+IEN  D
 .I $P($G(^BEHOAR(90460.05,IEN,0)),U,2)=FLG D
 ..S CNT=CNT+1
 ..S X=$P($G(^BEHOAR(90460.05,IEN,0)),U,3)
 ..S @RET@(CNT,0)=IEN_U_$P($G(^BEHOAR(90460.05,IEN,0)),U,1)_U_$S(X="Y":1,X="N":0,1:0)
 Q
SNOMED(RET) ;EP List of snomed codes
 N IEN,CNT,NAME
 S RET=$$TMPGBL()
 S CNT=0
 S NAME="" F  S NAME=$O(^BEHOAR(90460.06,"B",NAME)) Q:NAME=""  D
 .S IEN=0 F  S IEN=$O(^BEHOAR(90460.06,"B",NAME,IEN)) Q:IEN=""  D
 ..Q:+$P($G(^BEHOAR(90460.06,IEN,0)),U,4)
 ..S CNT=CNT+1
 ..S @RET@(CNT,0)=IEN_U_$P($G(^BEHOAR(90460.06,IEN,0)),U,1)_U_$P($G(^BEHOAR(90460.06,IEN,0)),U,2)
 Q
 ;Mark an allergy as entered in error
 ;Input
 ;  IEN=Entry number in the 120.8 file
 ;  DFN=Patient's internal entry number
 ;  VAL=Array of values to be stored
 ;    ("GMRAERR")=Indicates this entry is to be marked EIE
 ;    ("GMRAERRBY")=User marking it (optional,will set to DUZ)
 ;    ("GMRAERRDT")=Date/time EIE (option,will set to NOW)
 ;    ("GMRAERCMTS")=N  Comment lines for entering in error
 ;    ("GMRAERRCMTS",n)
 ;  OUPUT = error message or IEN of entry marked in error
EIE(DATA,IEN,DFN,VAL) ;entered in error
 N NOW,ORNODE,GMR0
 S GMR0=$P($G(^GMR(120.8,IEN,0)),U),DATA=""
 I '$L(GMR0) S DATA="-1^Entry not found" Q
 D CKIN(DFN)
 S NOW=$$NOW^XLFDT
 I $G(VAL("GMRAERRBY"))="" S VAL("GMRAERRBY")=DUZ
 I $G(VAL("GMRAERRDT"))="" S VAL("GMRAERRDT")=NOW
 S ORNODE=$NAME(^TMP("GMRA",$J))
 K @ORNODE M @ORNODE=VAL
 D EIE^GMRAGUI1(IEN,DFN,ORNODE)
 S DATA=IEN
 D FIREEVT^BEHOART(DFN,2,IEN)
 Q
 ;Mark an allergy as inactivated
 ;Input
 ;  IEN=Entry number in the 120.8 file
 ;  DFN=Patient's internal entry number
 ;  VAL=Array of values to be stored
 ;    ("GMRAINACT")=Date entry marked inactive (required)
 ;    ("GMRAINACBY")=User marking it (optional,will set to DUZ)
 ;    ("GMRAINWHY")=Reason marked inactive^comment if OTHER
 ;  OUPUT = error message or IEN of entry marked inactive
INACT(DATA,IEN,DFN,VAL) ;inactive allergies
 N X,Y,STOP,FNUM,AIEN,ERR,WHY,WHYIEN
 I IEN="" S DATA="-1^Missing entry to inactivate" Q
 D CKIN(DFN)
 S STOP=0,FNUM=120.899999912
 S AIEN="+1,"_IEN_","
 S FDA(120.899999912,AIEN,.01)=$G(VAL("GMRAINACT"))
 S WHY=$G(VAL("GMRAINWHY"))
 S WHYIEN=$$REASON(WHY)
 I WHYIEN S FDA(120.899999912,AIEN,1)=$P(WHYIEN,U,1)
 I $G(VAL("GMRAINACBY"))="" S VAL("GMRAINACBY")=DUZ
 S FDA(120.899999912,AIEN,2)=$G(VAL("GMRAINACBY"))
 I $D(VAL("GMRACMTS")) D GMRACMTS^BEHOART
 D UPDATE^DIE(,"FDA","IEN","ERR")
 S DATA=+IEN
 D FIREEVT^BEHOART(DFN,1,IEN)
 K FDA,ERR
 Q
 ;Input
 ;  IEN=Entry number in the 120.8 file
 ;  DFN=Patient's internal entry number
 ;  VAL=Array of values to be stored
 ;    ("GMRAINRE")=Date/Time to reactivate (required to reactivate)
 ;    ("GMRAINREBY")=User reactivating (optional,will set to DUZ)
 ;  OUPUT = error message or IEN of entry marked inactive
REACT(DATA,IEN,DFN,VAL) ;reactivate allergy
 N X,Y,STOP,FNUM,AIEN,BIEN,ERR,SIEN,SIEN,MIEN,CANVER
 I IEN="" S DATA="-1^Missing entry to reactivate" Q
 D CKIN(DFN)
 S STOP=0,FNUM=120.899999912,BIEN=IEN
 S SIEN=$O(^GMR(120.8,IEN,9999999.12,$C(0)),-1)
 I STOP!'SIEN S DATA="-1^Unable to find entry to reactivate" Q
 S AIEN=SIEN_","_IEN_","
 I $G(VAL("GMRAINREBY"))="" S VAL("GMRAINREBY")=DUZ
 I $G(VAL("GMRAINRE"))="" S VAL("GMRAINRE")=$$NOW^XLFDT
 ;S FDA(120.899999912,AIEN,.01)=$G(VAL("GMRAINACT"))
 S FDA(120.899999912,AIEN,3)=$G(VAL("GMRAINRE"))
 S FDA(120.899999912,AIEN,4)=$G(VAL("GMRAINREBY"))
 D UPDATE^DIE(,"FDA","IEN","ERR")
 K FDA,ERR
 ;Remove the verification, must be redone
 S AIEN=BIEN_","
 S FDA(120.8,AIEN,15)="@"
 S FDA(120.8,AIEN,19)="@"
 S FDA(120.8,AIEN,20)="@"
 S FDA(120.8,AIEN,21)="@"
 D FILE^DIE("","FDA","ERR")
 S DATA=IEN
 D FIREEVT^BEHOART(DFN,1,IEN)
 D SNDALR^BEHOART(DATA,1)
 K FDA,ERR
 Q
 ;
 ;Add or release an allergy assessment of unassessable
 ;Input
 ; IEN=Entry in the 120.86 file (Blank if pt not in file)
 ; DFN=Patient's internal entry number
 ; VAL=array of values to be stored
 ;  ("GMRAACC")=Date entry marked unassessable
 ;  ("GMRAACRE")=Reason marked unassessable
 ;  ("GMRAACCBY")=User marking record as unassessable
 ; OUPUT = error messagte or IEN of entry marked unassessable
ASSESS(DATA,IEN,DFN,VAL) ;mark unassessible
 N FNUM,NEW,X,ATIME,FDA,BIEN,AIEN,FDA2,AIEN2,WHY,WHYIEN,IEN,ACTION
 S FNUM=120.869999911
 I '$D(^GMR(120.86,DFN,0)) D
 .S AIEN="+1,",FDA(120.86,AIEN,.01)=DFN
 .S IEN(1)=DFN
 .D UPDATE^DIE(,"FDA","IEN","ERR")
 .I 'IEN(1) S DATA="-1^Unable to update allergy assessment"
 ;See if there are any earlier unable to assess nodes not closed out
 S ACTION=1
 K FDA,IEN,ERR,AIEN
 D CKIN(DFN)
 S WHY=$G(VAL("GMRAACRE"))
 S WHYIEN=$$REASON(WHY)
 I 'WHYIEN D  Q
 .S DATA="-1^A valid reason was not submitted"
 S AIEN="+1,"_DFN_","
 S FDA(120.869999911,AIEN,.01)=VAL("GMRAACC")
 S FDA(120.869999911,AIEN,1)=$P(WHYIEN,U,1)
 I $P(WHYIEN,U,2)'="" S FDA(120.869999911,AIEN,5)=$P(WHYIEN,U,2)
 I $G(VAL("GMRAACCBY"))="" S VAL("GMRAACBY")=DUZ
 S FDA(120.869999911,AIEN,2)=VAL("GMRAACCBY")
 D UPDATE^DIE(,"FDA","IEN","ERR")
 S DATA=+$G(IEN(1))
 D QUEUE^CIANBEVT("GMRA."_DFN,ACTION)
 Q
 ;Input
 ; IEN=Entry in the 120.86 file (Blank if pt not in file)
 ; DFN=Patient's internal entry number
 ; VAL=array of values to be stored
 ;  ("GMRAACC")=Date entry marked unassessable
 ;  ("GMRAACCRE")="Date unassessible resolved"
 ;  ("GMRAACCBY")="User unmarking the unacessable"
 ; OUPUT = error messagte or IEN of entry marked unassessable
REASSESS(DATA,IEN,DFN,VAL) ;reactivate
 ;Find node to close out
 N AIEN,STOP,BIEN,ATIME
 S STOP=0
 S ATIME=9999999 F  S ATIME=$O(^GMR(120.86,DFN,9999999.11,"B",ATIME),-1) Q:'ATIME!(STOP=1)  D
 .S AIEN="" F  S AIEN=$O(^GMR(120.86,DFN,9999999.11,"B",ATIME,AIEN)) Q:'+AIEN!(STOP=1)  D
 ..I ATIME=VAL("GMRAACC") S STOP=1
 ..S BIEN=AIEN_","_DFN_","
 ..I $G(VAL("GMRAACRE"))="" S VAL("GMRAACRE")=$$NOW^XLFDT
 ..S FDA(120.869999911,BIEN,3)=VAL("GMRAACRE")
 ..I $G(VAL("GMRAACCBY"))="" S VAL("GMRAACCBY")=DUZ
 ..S FDA(120.869999911,BIEN,4)=VAL("GMRAACCBY")
 ..D UPDATE^DIE(,"FDA","IEN","ERR")
 ..I '$D(ERR) S DATA=IEN
 ..K FDA,IEN,ERR
 ..D FIREEVT^BEHOART(DFN,2,"")
 Q
 ;See if there are any earlier unable to assess nodes not closed out
 ;If so, close them out
CKIN(DFN) ;
 N ATIME,AIEN,BIEN,FDA2,IEN,ERR
 S ATIME=9999999 F  S ATIME=$O(^GMR(120.86,DFN,9999999.11,"B",ATIME),-1) Q:ATIME=""  D
 .S BIEN="" F  S BIEN=$O(^GMR(120.86,DFN,9999999.11,"B",ATIME,BIEN)) Q:BIEN=""  D
 ..I $P($G(^GMR(120.86,DFN,9999999.11,BIEN,0)),U,4)=""  D
 ...S AIEN=BIEN_","_DFN_","
 ...S FDA2(120.869999911,AIEN,3)=$$NOW^XLFDT
 ...S FDA2(120.869999911,AIEN,4)=DUZ
 ...D UPDATE^DIE(,"FDA2","IEN","ERR")
 ...K FDA2,IEN,ERR
 Q
 ; Return IEN to BEH ALLERGY VALUES file
REASON(VAL) ; EP -
 N X,RET,COM
 I +VAL>0 S RET=+VAL
 E  S X=$P(VAL,U,2) S RET=$O(^BEHOAR(90460.05,"B",X,""))
 S COM=$P(VAL,U,4)
 I COM'="" S RET=RET_U_COM
 Q RET
 ;
TMPGBL() K ^TMP("BEHOART",$J) Q $NA(^($J))
