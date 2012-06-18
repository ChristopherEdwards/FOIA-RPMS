BLRALAU ;DAOU/ALA-Set Lab Audit [ 11/18/2002  1:31 PM ]
 ;;5.2;LR;**1013,1015**;NOV 18, 2002
 ;
 ;**PROGRAM DESCRIPTION**
 ;  This program sets an audit trail of users who
 ;  are accessing certain patients' records in the
 ;  Lab module.
 ;
 ;  Input Parameters
 ;    DUZ = User IEN
 ;    XQY = Menu IEN
 ;    DFN = Patient IEN
 ;
EN NEW DIC,DLAYGO
 ;
 ;  Check if Auditing is turned ON
 I $$GET1^DIQ(9009027.2,1,.02,"I")<1 Q
 ;
 ;  Create a new record
 S DIC="^BLRALAB(9009027,",DIC(0)="LZX",DLAYGO=9009027
 S X=$$NOW^XLFDT()
 D FILE^DICN Q:+Y<1
 S BLRALDA=+Y
 ;
 ;  Get accession number
 I $G(LRSS)="MI" S BLRAACN=$G(LRACC)
 I $G(LRSS)="CH" S BLRAACN=$P($G(LR0),U,6)
 ;
 ;  Set up record
 S BLRALY(9009027,BLRALDA_",",.02)=DUZ
 S BLRALY(9009027,BLRALDA_",",.03)=XQY
 S BLRALY(9009027,BLRALDA_",",.04)=DFN
 S BLRALY(9009027,BLRALDA_",",.05)=$G(BLRAACN)
 ;
 D FILE^DIE("","BLRALY")
 ;
 K BLRALDA,BLRAACN
 Q
