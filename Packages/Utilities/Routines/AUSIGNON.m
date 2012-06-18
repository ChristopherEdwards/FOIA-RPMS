AUSIGNON ; IHS/ACC - KERNEL SIGNON AUDIT [ 09/08/85  5:53 PM ]
 F Q=0:0 R "DATE FOR WHICH TO DISPLAY SIGNONS: ",D,! Q:D=""  D SHODATE
 K D
 Q
 ;
SHODATE ;
 S T=D F Q=0:0 S T=$O(^XUSEC(0,T)) Q:T=""  Q:(T\1)>D  D SHOSESS
 Q
 ;
SHOSESS ;
 S SDESC=^XUSEC(0,T,0),WHONUM=$P(SDESC,"^",1),ON=$E($P(T,".",2),1,4),TERM=$P(SDESC,"^",2)
 S WHONAME=$P(^DIC(3,WHONUM,0),"^",1)
 S ENDSESS=$P(SDESC,"^",4),OFF=$E($P(ENDSESS,".",2),1,4)
 S:$F(WHONAME,",") WHONAME=$P(WHONAME,",",2)_" "_$P(WHONAME,",",1)
 W ON," ",WHONAME," on device ",TERM," ",$S(OFF="":"(escaped from kernel)",1:"logged off at "_OFF),!
 Q
