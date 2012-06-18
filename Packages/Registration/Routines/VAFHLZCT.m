VAFHLZCT ;ALB/ESD - Creation of ZCT segment ; 17 February 93
 ;;5.3;Registration;**68**;Aug 13, 1993
 ;
 ; This generic extrinsic function transfers information pertaining to
 ; a patient's next of kin through the Emergency Contact (ZCT) segment.
 ;
 ;
EN(DFN,VAFSTR,VAFNUM,VAFTYPE) ;function returns ZCT segment containing emergency contact info.
 ;
 ;  Input:
 ;            DFN -- Internal entry number of the PATIENT file.
 ;         VAFSTR -- String of fields requested separated by commas
 ;         VAFNUM -- Set Id (sequential number-if not passed, set to 1).
 ;        VAFTYPE -- Contact type to determine type of data returned
 ;                   (1=NOK, 2=2nd NOK, 3=Emer Cont, 4=2nd Emer Cont,
 ;                    5=Designee).
 ;
 ;  Output:          String of components forming ZCT segment.
 ;
 ;      ****Also assumes all HL7 variables returned from****
 ;          INIT^HLTRANS are defined.
 ;
 N VAFNODE,VAFCNODE,X,X1,VAFY
 I '$G(DFN)!($G(VAFSTR)']"") G QUIT
 S $P(VAFY,HLFS,9)="",VAFSTR=","_VAFSTR_","
 I "^1^2^3^4^5^"'[("^"_$G(VAFTYPE)_"^") S VAFTYPE=1
 S VAFNODE=$P($T(TYPE+VAFTYPE),";;",2),VAFCNODE=$G(^DPT(DFN,VAFNODE))
 S $P(VAFY,HLFS,1)=$S($G(VAFNUM):+VAFNUM\1,1:1) ; If Set Id not passed in, set to 1
 S $P(VAFY,HLFS,2)=VAFTYPE ; Contact Type
 I VAFSTR[",3," S X=$P(VAFCNODE,"^",1),$P(VAFY,HLFS,3)=$S(X]"":X,1:HLQ) ; Name of Next of Kin
 I VAFSTR[",4," S X=$P(VAFCNODE,"^",2),$P(VAFY,HLFS,4)=$S(X]"":X,1:HLQ) ; Relationship to Patient
 I VAFSTR[",5," D
 . S X1=$G(^DPT(DFN,.22))
 . S X=$$ADDR^VAFHLFNC($P(VAFCNODE,"^",3,7)_"^"_$P(X1,"^",$P($T(TYPE+VAFTYPE),";;",3)))
 . S $P(VAFY,HLFS,5)=$S(X]"":$P(X,HLFS,1),1:HLQ) ; Next of Kin address
 ;
 I VAFSTR[",6," S X=$$HLPHONE^HLFNC($P(VAFCNODE,"^",9)),$P(VAFY,HLFS,6)=$S(X]"":X,1:HLQ) ; Home Phone
 I VAFSTR[",7," S X=$$HLPHONE^HLFNC($P(VAFCNODE,"^",11)),$P(VAFY,HLFS,7)=$S(X]"":X,1:HLQ) ; Work Phone
 S X=$P(VAFCNODE,"^",10) ;Get this piece for next two fields
 I VAFSTR[",8," S $P(VAFY,HLFS,8)=$S(VAFTYPE=1!(VAFTYPE=2):$$YN^VAFHLFNC(X),1:HLQ) ; Contact Address Same as NOK?
 I VAFSTR[",9," S $P(VAFY,HLFS,9)=$S(VAFTYPE=3!(VAFTYPE=5):$$YN^VAFHLFNC(X),1:HLQ) ; Contact Person Same as NOK?
QUIT Q "ZCT"_HLFS_$G(VAFY)
TYPE ; Corresponding nodes for emergency contact type and ZIP+4 field piece.
 ;;.21;;7
 ;;.211;;3
 ;;.33;;1
 ;;.331;;4
 ;;.34;;2
