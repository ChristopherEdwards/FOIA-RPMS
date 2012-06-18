ACDPCCL2 ;IHS/ADC/EDE/KML - PCC LINK;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
 ;
GENEVENT ; EP - GENERATE CDMIS EVENT ARRAY FOR ONE PATIENT VISIT
 ;//^ACDPCCL
 K ACDEV
 I '$D(^ACDVIS(ACDVIEN,0)) S ACDQ=1 D ERROR^ACDPCCL("Specified visit doesn't exist",3) Q
 D SETPVARS
 Q:ACDQ
 D SETVVARS
 Q:ACDQ
 S X=ACDEV("TC")
 D @("SET"_$S(X="CS":"CS",X="TD":"TDC",1:"IIF")_"^ACDPCCL3")
 Q:ACDQ
 I ACDEV("TC")'="CS" D  Q:ACDQ
 . S ACDQ=1
 . S W=$O(^ICD9("AB","V70.8",0))
 . I 'W D ERROR^ACDPCCL("Cannot find ICD9 code V70.8 - notify programmer",3) Q
 . S ACDEV("POV",1)=W_":V70.8:CHEMICAL DEPENDENCY-"_$S(ACDEV("TC")="IN":"NEW PATIENT ",1:"")_"EVALUATION & MANAGEMENT"
 . S ACDQ=0
 . Q
 Q
 ;
SETPVARS ; SET PROGRAM VARIABLES
 S ACDQ=1
 I '$G(ACDPGM) D ERROR^ACDPCCL("CDMIS Program variable not set-notify programmer",3) Q
 S X=$P($G(^ACDF5PI(ACDPGM,11)),U,2)
 S:X="" X="?"
 I ACDFPCC,X="?" D ERROR^ACDPCCL("No site type in CDMIS PROGRAM file",3) Q
 S ACDEV("SITE TYPE")=X
 S X=$O(^DIC(40.7,"C",43,0))
 I X="" D ERROR^ACDPCCL("No clinic stop entry for alcoholism program",3) Q
 S ACDEV("CLINIC")=X
 S ACDEV("LOCATION")=ACDPGM
 I $G(ACDMODE)="" D ERROR^ACDPCCL("No mode-notify programmer",3) Q
 S ACDEV("TYPE")=$G(ACDMODE)
 I "AED"'[ACDEV("TYPE") D ERROR^ACDPCCL("Invalid mode-notify programmer",3) Q
 S ACDQ=0
 Q
 ;
SETVVARS ; SET VISIT VARIABLES
 S ACDQ=1
 S X=^ACDVIS(ACDVIEN,0)
 Q:$P(X,U,5)=""  ;                     no patient
 Q:$P(X,U,4)="IR"!($P(X,U,4)="OT")  ;  not patient related
 ; neither of the above should ever happen
 S ACDEV("VISIT")=ACDVIEN
 S ACDEV("PAT")=ACDDFNP
 S ACDEV("V DATE")=$P(X,U)
 S ACDEV("COMP CODE")=$P(X,U,2)
 S ACDEV("COMP TYPE")=$P(X,U,7)
 S ACDEV("PRI PROV")=$S($P(X,U,3):$P(X,U,3),1:"NOT ENTERED")
 S ACDEV("TC")=$P(X,U,4)
 S X=$P($G(^ACDVIS(ACDVIEN,11)),U)
 S ACDEV("SVC CAT")=$S(X]"":X,1:"A") ;   default to ambulatory
 S ACDQ=0
 Q
