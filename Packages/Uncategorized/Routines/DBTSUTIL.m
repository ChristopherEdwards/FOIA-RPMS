DBTSUTIL ; ;[ 09/10/1998  3:24 PM ]
 ;
 Q
DRUG ;
 O 51:("/usr/spool/uucppublic/dbtsdrug.txt":"W")
 F I=5177,5176,83870,84298,84294,657,84084,84085,83839,2977 D
 .S NAME=$P(^PSDRUG(I,0),"^",1)
 .S NDC=$P(^PSDRUG(I,2),"^",4)
 .S OUTREC=NAME_$C(9)_NDC
 .U 51 W OUTREC,!
 C 51
 Q
AMP ;create icd op/proc. amputation text file
 O 51:("/usr/spool/uucppublic/dbtsamp.txt":"W")
 F DFN=10,300 D
 .S REC=^ICD0(DFN,0)
 .S CODE=$P(REC,U,2)
 .S NAME=$P(REC,U,1)
 .S OUTREC=NAME_$C(9)_CODE
 .U 51 W OUTREC,!
 C 51
 Q
