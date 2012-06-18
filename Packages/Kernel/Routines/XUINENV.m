XUINENV ;ISCSF/RWF - KERNEL ENVIRONMENT CHECK ROUTINE  ;09/15/97  15:59 [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1004,1005,1007**;APR 1, 2003
 ;;8.0;KERNEL;**59**;Jul 10, 1995
 Q:'$D(XPDNM)  ;Check that in a KIDS install.
 I XPDNM["XU*8.0*59" G ENV59
 Q
 ;
ENV59 ;Patch XU*8.0*59
 I $D(^DIC(8994,0))[0 D  Q
 . S XPDQUIT=2 D BMES^XPDUTL("BROKER 1.1 must be installed first to load the REMOTE PROCEDURE file.")
 D BMES^XPDUTL("Environment OK")
 Q
POST59 ;Do the post install work for patch 59
 Q:$G(^XTV(8989.3,1,0))=""
 I $P($G(^XTV(8989.3,1,"XUS")),U,18)="" S $P(^("XUS"),U,18)="d"
 Q
