BHLBCK ; cmi/flag/maw - BHL Check a background task ; 
 ;;3.01;BHL IHS Interfaces with GIS;**2,11,14**;OCT 15, 2002
 ;
 ;
 ;this routine will check to see if the task is active and shutdown and
 ;restart on the fly if not.
 ;
CHK(BP,SH) ;EP - check the task status     
 S BP=$O(^INTHPC("B",BP,0))
 I 'BP Q 1
 I $$VER^INHB(BP) Q 1
 D SHUT
 H 10
 D START
 Q 0
 ;
RES(BP,SH) ;EP - restart the link passed in, task man only    
 S BP=$O(^INTHPC("B",BP,0))
 I 'BP Q 1
 D SHUT
 H 120  ;maw 4/19/2006 increased hang time to 120 from 60
 D START
 Q 0
 ;
SHUT ;EP - shut down the process    
 Q:'$G(SH)  ;quits when shutdown flag is not present
 N X
 F X=1:1:100 K ^INRHB("RUN",BP)
 S X=$$SRVRHNG^INHB(BP)
 Q
 ;
START ;EP - restart the process
 S X=$$A^INHB(BP)
 Q
 ;
