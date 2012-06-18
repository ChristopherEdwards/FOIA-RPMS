RA2IPST ;HIRMFO/GJC - Post-init Driver patch two ;10/20/98  08:04
VERSION ;;5.0;Radiology/Nuclear Medicine;**2**;Mar 16, 1998
 ;
 ; Post-init for patch two.  Re-index the Ask 'Imaging Location'
 ; and the Detailed Procedure Required fields in the Rad/Nuc Med
 ; Division file.  Executes the set logic only.  Invoked as a
 ; post-init for RA*5*2.  This routine can be deleted after patch
 ; two has been installed.
 Q:'$D(XPDNM)  ; no-op, only run during KIDS install
 K DA,DIC,DIK,X
 S DIK="^RA(79,",DIK(1)=".17" D ENALL^DIK ; Ask 'Imaging Location'
 K DA,DIC,DIK,X
 S DIK="^RA(79,",DIK(1)=".121" D ENALL^DIK ; Detailed Procedure Req'd
 K DA,DIC,DIK,X
 Q
