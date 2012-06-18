DBTSTE ;TEST [ 05/07/1999  10:24 AM ]
 S BT=$P($H,",",2)
 S N=0,CT=0
 O 51:("/usr/spool/uucppublic/refcpt.txt":"W")
 F  S N=$O(^ICPT(N)) Q:$E(N,1,2)="00"  D
 .S REC=^ICPT(N,0)
 .S C=$P(REC,"^",1)
 .S DE=$P(REC,"^",2)
 .S OUTREC=C_$C(9)_DE
 .U 51 W OUTREC,!
 .S CT=CT+1
 C 51
 S ET=$P($H,",",2)
 S TOTSEC=ET-BT
 U 0 W !,"TOTAL REC: ",CT,"   SECONDS: ",TOTSEC
 Q
