BADEUTIL ;IHS/MSC/PLS - Dentrix HL7 inbound interface  ;12-Feb-2010 09:35;PLS
 ;;1.0;DENTAL/EDR INTERFACE;**5**;FEB 22, 2010;Build 23
 ; Returns patient corresponding to 12 digit facility/hrn code
 ;; Modified - IHS/OIT/GAB 03/2016 **5** Check & Add POV's (ICD10 code) coming from Dentrix
HRCNF(HRCN12) ; EP
 N DFN,ASUFAC,HRN,Y
 S DFN=-1
 S ASUFAC=+$E(HRCN12,1,6),HRN=+$E(HRCN12,7,12)
 Q:'ASUFAC!'HRN DFN
 S ASUFAC=$$FIND1^DIC(9999999.06,,,ASUFAC,"C")
 Q:'ASUFAC DFN
 S Y=0 F  S Y=$O(^AUPNPAT("D",HRN,Y)) Q:'Y  Q:$D(^(Y,ASUFAC))
 S:Y DFN=Y
 Q DFN
 ;
 ; Enable/Disable a protocol
 ; Input: P-Protocol
 ;        T-Text - Null or not passed removes text.
EDPROT(P,T,ERR) ;EP
 N IENARY,PIEN,AIEN,FDA
 S T=$G(T,"")
 D
 .I '$L(P) S ERR="Missing input parameter" Q
 .S IENARY(1)=$$FIND1^DIC(101,"","",P)
 .I 'IENARY(1) S ERR="Unknown protocol name" Q
 .S FDA(101,IENARY(1)_",",2)=$S($L(T):T,1:"@")
 .D UPDATE^DIE("S","FDA","IENARY","ERR")
 Q
 ; Returns default user based on Location
DUSER(LOC) ;EP
 N RET
 S RET=$$GET^XPAR("DIV.`"_LOC_"^SYS","BADE EDR DEFAULT USER")
 Q RET
 ; Returns MERGED TO DFN, when present, traversing the chain
MRGTODFN(DFN) ;EP
 N RES
 S RES=DFN
 Q:'$D(^DPT(DFN,-9)) RES  ;DFN has not been merged
 F  S DFN=$P($G(^DPT(DFN,-9)),U) Q:'DFN  S RES=DFN Q:'$D(^DPT(DFN,-9))
 Q RES
GETPOV    ;IHS/OIT/GAB 03/2016 **5** ADDED THIS SEGMENT - GET THE POV FROM THE FT1 SEGMENT & ADD TO THE VISIT
 S CNT=1,NOPOV="",FIRST=""
 K CODE
 F CNT=1:1:4 D
 .Q:$G(SEGFT1(20,CNT,1,1))=""
 .S CODE(CNT)=(SEGFT1(20,CNT,1,1))
 .S POV=CODE(CNT)
 .I CNT=1 S FIRST=CODE(CNT)
 .Q:FIRST="V72.2"
 .D VALIDPOV^BADEUTIL(POV)
 .I YES=1 D
 ..I '$$HASPOV(APCDVSIT,POV) S APCDALVR("APCDATMP")="[APCDALVR 9000010.07 (ADD)]" D EN^APCDALVR
 I (FIRST="V72.2")&&('$$HASPOV(APCDVSIT,"ZZZ.999")) S APCDALVR("APCDTPOV")="ZZZ.999" S APCDALVR("APCDTEXK")=APCDTEXK S APCDALVR("APCDATMP")="[APCDALVR 9000010.07 (ADD)]" D EN^APCDALVR
 I FIRST="" S NOPOV=1
 Q
VALIDPOV(POV)    ; IHS/OIT/GAB **5** ADD A CHECK FOR A VALID POV COMING FROM DENTRIX
 N STR,IEN
 S YES=""
 S STR=$$ICDDATA^ICDXCODE(30,POV,VISDT,"E")
 S IEN=$P(STR,"^") S:IEN<0 IEN=""
 I IEN="" S YES="" Q   ;SET DEFAULT CODE IF IEN DOESN'T EXIST								; Not a valid code
 S YES=1
 S APCDALVR("APCDTPOV")=POV
 S APCDALVR("APCDTEXK")=APCDTEXK        ; add the EXKEY for the POV entry to associate with the procedure
 Q
HASPOV(V,Y)     ;EP  IHS/OIT/GAB **5** ADD A CHECK FOR DUPLICATE POV's
 ;V is visit ien
 ;Y is value of icd code, e.g. Z98.810
 I '$G(V) Q ""  ;not a valid visit ien
 I '$D(^AUPNVSIT(V,0)) Q ""  ;not a valid visit ien
 NEW X,G,I
 S (X,G)=0
 F  S X=$O(^AUPNVPOV("AD",V,X)) Q:X'=+X!(G)  D
 .S I=$$VAL^XBDIQ1(9000010.07,X,.01)  ;external value of .01 of V POV
 .I I=Y S G=X  ;if it equals Y quit on ien of the V POV, yes, we already have that V POV
 .Q
 Q G
