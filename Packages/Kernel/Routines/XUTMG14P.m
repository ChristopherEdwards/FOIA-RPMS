XUTMG14P ;SEA/RDS - TaskMan: Globals: X-Refs For Files 14.5 & .7 ;07/14/99  11:58 [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1002,1003,1004,1005,1007**;APR 1, 2003
 ;;8.0;KERNEL;**118**;Jul 10, 1995
 ;
UPDATE ;Set Logic For MUMPS X-Refs: Tell Managers To Update Site Parameters
 N X,ZTI,ZTM,ZTN,ZTV,$ESTACK,$ETRAP
 S $ETRAP="S $ECODE="""" Q  " ;Trap down links when telling managers to update
 S ZTV=0
U0 F ZTI=0:0 S ZTV=$O(^%ZIS(14.5,ZTV)) Q:'ZTV  S X=$G(^%ZIS(14.5,ZTV,0)) D
 . S ZTN=$P(X,U),ZTM=$P(X,U,6) Q:ZTN=""
 . I ZTN'=^%ZOSF("VOL") L +^[ZTM,ZTN]%ZTSCH("UPDATE") K ^[ZTM,ZTN]%ZTSCH("UPDATE") L -^[ZTM,ZTN]%ZTSCH("UPDATE")
 . Q
 L +^%ZTSCH("UPDATE") K ^%ZTSCH("UPDATE") L -^%ZTSCH("UPDATE") Q
 ;
