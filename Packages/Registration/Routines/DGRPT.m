DGRPT ;ALB/RMO-10-10T Registration ; 2/20/03 12:05pm
 ;;5.3;Registration;**108,149,425**;Aug 13, 1993
 ;
EN ;Entry point for 10-10T registration option
 ; Input  -- None
 ; Output -- None
 N DFN,DGNEWPF,DGRPTOUT
 ;
 ;Get Patient file (#2) IEN - DFN
 D GETPAT^DGRPTU(1,1,.DFN,.DGNEWPF) G Q:DFN<0
 ;
 ;MPI Query
 ;check to see if CIRN PD/MPI is installed
 N X S X="MPIFAPI" X ^%ZOSF("TEST") G:'$T SKIP
 K MPIFRTN
 D MPIQ^MPIFAPI(DFN)
 K MPIFRTN
 ;
 I $G(DGNEWPF) D
 . ; query CMOR for Patient Record Flag Assignments if NEW patient and
 . ; display results.
 . I $$PRFQRY^DGPFAPI(DFN) D DISPPRF^DGPFAPI(DFN)
 ;
SKIP ;
 ;If new patient invoke 10-10T interview
 I $G(DGNEWPF) D
 . D INT^DGRPTI(DFN,DGNEWPF,.DGRPTOUT)
 ELSE  D
 . ;Load 10-10T registration screen
 . D EN^DGRPTL(DFN,.DGRPTOUT)
 ;I VAFCFLDS IS DEFINED IT MEANS USER DIDN'T COMPLETE A 10-10
 ;REGISTRATION BUT DID EDIT SOME FIELDS FROM THAT OPTION
 I $D(VAFCFLDS) D HL7A08^VAFCDD01
Q Q
 ;
