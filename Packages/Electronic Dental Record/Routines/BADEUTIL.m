BADEUTIL ;IHS/MSC/PLS - Dentrix HL7 inbound interface  ;12-Feb-2010 09:35;PLS
 ;;1.0;DENTAL/EDR INTERFACE;;Oct 13, 2009
 ; Returns patient corresponding to 12 digit facility/hrn code
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
