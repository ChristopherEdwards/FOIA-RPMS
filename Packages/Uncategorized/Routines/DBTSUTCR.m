DBTSUTCR ;utility routine to have several calls for diff functions [ 02/08/1999  2:09 PM ]
 ;
IMM ;to save the auttimm table out to a tab delimited text file
 ;
 O 51:("/usr/spool/uucppublic/dbts.imm":"W")
 S N=0
 S DBTSCT=0
 F  S N=$O(^AUTTIMM(N)) Q:+N=0  D
 .I '$D(^AUTTIMM(N,0)) Q
 .S DBTSREC=^AUTTIMM(N,0)
 .S DBTSN=$P(DBTSREC,"^",1)
 .S DBTSCO=$P(DBTSREC,"^",3)
 .S OUTREC=DBTSN_$C(9)_DBTSCO
 .U 51 W OUTREC,!
 .S DBTSCT=DBTSCT+1
 C 51
 U 0 W "TOTAL IMM RECORDS: ",DBTSCT
 K DBTSREC,DBTSN,DBTSCO,OUTREC,DBTSCT,N
 Q
EXAM ;
 ;
 O 51:("/usr/spool/uucppublic/dbts.ex":"W")
 S N=0
 S DBTSCT=0
 F  S N=$O(^AUTTEXAM(N)) Q:+N=0  D
 .I '$D(^AUTTEXAM(N,0)) Q
 .S DBTSREC=^AUTTEXAM(N,0)
 .S DBTSN=$P(DBTSREC,"^",1)
 .S DBTSCO=$P(DBTSREC,"^",2)
 .S OUTREC=DBTSN_$C(9)_DBTSCO
 .U 51 W OUTREC,!
 .S DBTSCT=DBTSCT+1
 C 51
 U 0 W "TOTAL EXAM RECORDS: ",DBTSCT
 K DBTSREC,DBTSN,DBTSCO,OUTREC,DBTSCT,N
 Q
DD ;
DRUG ;
 O 51:("/usr/spool/uucppublic/dbtsdrug.txt":"W")
 F I=84534,5177,5176,84338,84339,84328,83870,84078,340,84093,84172,84359,338,551,84092,357,644,2980,84008,654,84174,83839,703,657,2977,84033 D
 .S NAME=$P(^PSDRUG(I,0),"^",1)
 .S NDC=$P($G(^PSDRUG(I,2)),"^",4)
 .S OUTREC=NAME_$C(9)_NDC
 .U 51 W OUTREC,!
 C 51
 Q
AMP ;create icd op/proc. amputation text file
 O 51:("/usr/spool/uucppublic/dbtsamp.txt":"W")
 F DFN=2117,2118,2120,2121,2123,3360 D
 .S REC=^ICD0(DFN,0)
 .S CODE=$P(REC,U,1)
 .S NAME=$P(REC,U,4)
 .S OUTREC=NAME_$C(9)_CODE
 .U 51 W OUTREC,!
 C 51
 Q
CARD ;create text file of all cardiac diagnosis put to the DBTS CARDIAC DIAGNOSIS
 O 51:("/usr/spool/uucppublic/dbtscard.txt":"W")
 S DFN=0
 F  S DFN=$O(^DBTSCARD(DFN)) Q:+DFN=0  D
 .S ICD=$P(^DBTSCARD(DFN,0),"^",1)
 .S ICDREC=^ICD9(ICD,0)
 .S CODE=$P(ICDREC,"^",1)
 .S DIAG=$P(ICDREC,"^",3)
 .S OUTREC=CODE_$C(9)_DIAG
 .U 51 W OUTREC,!
 C 51
 Q
DRUGCL ;create text file of all drug class entries in the va drug class file
 O 51:("/usr/spool/uucppublic/dbtsdrclass.txt":"W")
 S DFN=0
 F  S DFN=$O(^PS(50.605,DFN)) Q:+DFN=0  D
 .S REC=^PS(50.605,DFN,0)
 .S CODE=$P(REC,"^",1)
 .S DESC=$P(REC,"^",2)
 .S PARENT=$P(REC,"^",3)
 .I PARENT'="" S PARENT=$P(^PS(50.605,PARENT,0),"^",1)
 .S TYPE=$P(REC,"^",4)
 .I TYPE'="" S TYPE=$S(TYPE=0:"MAJOR",TYPE=1:"MINOR",TYPE=2:"SUB-CLASS")
 .S OUTREC=CODE_$C(9)_DESC_$C(9)_PARENT_$C(9)_TYPE
 .U 51 W OUTREC,!
 C 51
 Q
PSDRUG ;  create drug table  delimit with "^" because pulling into M and merge
 ;  all su drug file
 O 51:("/usr/spool/uucppublic/dbtsdrugcr.txt":"W")
 S DFN=0
 S CT=0
 F  S DFN=$O(^PSDRUG(DFN)) Q:+DFN=0  D
 .;Q:$D(^PSDRUG(DFN,"I"))
 .I $D(^PSDRUG(DFN,"I")) I $P(^PSDRUG(DFN,"I"),"^",1)<2960101
 .Q:'$D(^PSDRUG(DFN,"ND"))
 .Q:'$D(^PSDRUG(DFN,0))
 .S NAME=$P(^PSDRUG(DFN,0),"^",1)
 .S NDC=$P($G(^PSDRUG(DFN,2)),"^",4)
 .Q:NDC=""
 .S CLASS=$P(^PSDRUG(DFN,"ND"),"^",6)
 .I CLASS'="" S CLASS=$P($G(^PS(50.605,CLASS,0)),"^",1)
 .;S OUTREC=NDC_"^"_NAME_"^"_CLASS
 .S OUTREC=NDC_$C(9)_NAME_$C(9)_CLASS
 .U 51 W OUTREC,!
 .S CT=CT+1
 C 51
 U 0 W !!,"TOTAL DRUGS SET: ",CT
 Q
