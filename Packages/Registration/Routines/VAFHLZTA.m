VAFHLZTA ;ALB/ESD - Creation of ZTA segment ; 10 February 93
 ;;5.3;Registration;**68**;Aug 13, 1993
 ;
 ; This generic extrinsic function returns the HL7 VA-Specific Temporary Address (ZTA) segment.
 ;
 ;
EN(DFN,VAFSTR,VAFNUM) ; Returns HL7 ZTA segment containing temporary address
 ;                 data.
 ;
 ;  Input - DFN as internal entry number of the PATIENT file
 ;          VAFSTR as string of fields requested separated by commas.
 ;          VAFNUM as SetId - set to 1.
 ;
 ; Output - string of components forming the ZTA segment.
 ;
 ; ******** Also assumes all HL7 variables returned from ********
 ;          INIT^HLTRANS are defined.
 ;
 ;
 N VAFNODE,VAFY,X,X1
 I '$G(DFN)!($G(VAFSTR)']"") G QUIT
 S VAFNODE=$G(^DPT(DFN,.121))
 S $P(VAFY,HLFS,7)="",VAFSTR=","_VAFSTR_","
 S $P(VAFY,HLFS,1)=1 ; SetId equal to 1
 I VAFSTR[",2," S X=$P(VAFNODE,"^",9),$P(VAFY,HLFS,2)=$$YN^VAFHLFNC(X) ; Temporary Address Enter/Edit?
 I VAFSTR[",3," S X=$$HLDATE^HLFNC($P(VAFNODE,"^",7)),$P(VAFY,HLFS,3)=$S(X]"":X,1:HLQ) ; Temporary Address Start Date
 I VAFSTR[",4," S X=$$HLDATE^HLFNC($P(VAFNODE,"^",8)),$P(VAFY,HLFS,4)=$S(X]"":X,1:HLQ) ; Temporary Address End Date
 I VAFSTR[",5,"!(VAFSTR[",6,") D
 . S X1=$$ADDR^VAFHLFNC($P(VAFNODE,"^",1,5)_"^"_$P(VAFNODE,"^",12),$P(VAFNODE,"^",11))
 . I VAFSTR[",5," S $P(VAFY,HLFS,5)=$S($P(X1,HLFS,1)]"":$P(X1,HLFS,1),1:HLQ) ; Temporary Address
 . I VAFSTR[",6," S $P(VAFY,HLFS,6)=$S($P(X1,HLFS,2)]"":$P(X1,HLFS,2),1:HLQ) ; Temporary Address County
 I VAFSTR[",7," S X=$$HLPHONE^HLFNC($P(VAFNODE,"^",10)),$P(VAFY,HLFS,7)=$S(X]"":X,1:HLQ) ; Temporary Address Phone
QUIT Q "ZTA"_HLFS_$G(VAFY)
