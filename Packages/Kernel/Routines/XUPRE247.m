XUPRE247 ;ISC-SF.BP/BDT - DELETE "AF" X-REF; [ 01/14/2004  4:54 PM ]
 ;;8.0;KERNEL;**247,255,1010**;Jul 31, 2002
 ;
 Q
 ;
PRE ;Delete AF x-ref
 I $G(^DD(200,.01,1,3,0))="200^AF^MUMPS" D DELIX^DDMOD(200,.01,3,"K")
 ;
 Q
 ;end of PRE
POST255 ;Re-index "B" and "G" x-refs for the Person Class file
 D  ;JUST TO SET TOP LEVEL
 .D  ;KILL OFF B-XREF
 ..N DIK,DA
 ..S DIK="^USC(8932.1,"
 ..S DIK(1)=".01^B"
 ..D ENALL2^DIK
 .D  ;REINDEX THE B-XREF
 ..N DIK,DA
 ..S DIK="^USC(8932.1,"
 ..S DIK(1)=".01^B"
 ..D ENALL^DIK
 .D  ;INDEX THE G-XREF
 ..N DIK,DA
 ..S DIK="^USC(8932.1,"
 ..S DIK(1)="6^G"
 ..D ENALL^DIK
 ;
 Q
