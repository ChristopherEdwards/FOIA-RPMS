DBTSPULL ;routine to pull diab. pats from diabetic register [ 04/29/1999  1:23 PM ]
 ;from the case mgt. system
 ;2/1/99
 S CT=0
 O 51:("/usr/spool/uucppublic/diabeticspo.txt":"W")
 S N=0
 F  S N=$O(^ACM(41,N)) Q:+N=0  D
 .S REC=^ACM(41,N,0)
 .I $P(REC,"^",1)'=6 Q    ;6 is dfn for ihs diabetic case mgt. register
 .S PAT=$P(REC,"^",2)
 .Q:PAT=""
 .S S=$P($G(^ACM(41,N,"DT")),"^",1)
 .S STATUS=$S(S="D":5,S="A":1,S="I":2,S="U":0,S="N":4,S="T":3,1:"")
 .S ID=404510_"|2|"_PAT
 .S OUTREC=404510_$C(9)_PAT_$C(9)_ID_$C(9)_STATUS
 .U 51 W OUTREC,!
 .S CT=CT+1
 .Q
 C 51
 U 0 W "TOTAL: ",CT
 K CT
 Q
