BQITASK2 ;PRXM/HC/ALA-Separate tasks for post-installs ; 31 Jul 2007  11:24 AM
 ;;2.2;ICARE MANAGEMENT SYSTEM;;Jul 28, 2011;Build 37
 ;
DXC ;EP - Entry point to identify the diagnostic tags
 ; Variables
 ;   BQDEF  - Diag Cat Definition Name
 ;   BQEXEC - Diag Cat special executable program
 ;   BQPRG  - Diag Cat standard executable program
 ;   BQREF  - Taxonomy array reference
 ;   BQGLB  - Temporary global reference
 ;   BQORD  - Order that the category must be determined
 ;           (Some categories depend upon a patient not being
 ;            in another category)
 ;   BQTN   - Diag Cat internal entry number
 ;
 NEW UID
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 D DXC^BQITASK
 Q
 ;
GPR ;EP - Entry point to get GPRA values for all users
 ;
 NEW UID
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 D GPR^BQITASK
 Q
 ;
MU ;EP - Entry point to get MU
 ;
 NEW UID
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 D MU^BQITASK4
 Q
