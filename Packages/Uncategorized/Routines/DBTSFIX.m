DBTSFIX ;DMH/BAO/utility routine for fixing data [ 03/18/1999  2:29 PM ]
 ;
EYE ;
 U 0 W !!,*7,"DON'T RUN UNTIL GLOB. SAVE ^DBTSPAT TO UNIX " H 2 Q
OK ;
 K ^DBTSTMP("EYE")
 S N=0
 F  S N=$O(^DBTSPAT(N)) Q:+N=0  D
 .Q:'$D(^DBTSPAT(N,"EYE"))
 .S ^DBTSTMP("EYE",N)=^DBTSPAT(N,"EYE")
 .K ^DBTSPAT(N,"EYE")
 .Q
 Q
