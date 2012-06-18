ACGSGET ;IHS/OIRM/DSD/THL,AEF - ROUTINE TO GET CIS FILES FROM AREA MACHINES;     [ 03/27/2000   2:22 PM ]
 ;;2.0t1;CONTRACT INFORMATION SYSTEM;;FEB 16, 2000
EN D EN1
EXIT K ACG,ACGI,ACGX
 Q
EN1 ;F ACGI=235,239,241:1:,249,285 S ACG=$P($T(@ACGI),";;",2) Q:ACG=""  S ACGX="getfrom "_$P(ACG,";")_" /usr/mumps/acg"_$P(ACG,";",2)_".asc > /dev/null",ACGX=$$JOBWAIT^%HOSTCMD(ACGX)
 F ACGI=235,239,245 S ACG=$P($T(@ACGI),";;",2) Q:ACG=""  S ACGX="getfrom "_$P(ACG,";")_" /usr/mumps/acg"_$P(ACG,";",2)_".asc > /dev/null",ACGX=$$JOBWAIT^%HOSTCMD(ACGX)
 Q
DATA ;;
161 ;;dallas;16192
102 ;;seattle;10292
235 ;;cao-as;235
239 ;;bji-ao;239
241 ;;abr-ab;241
242 ;;albaao;242
243 ;;akproc;243
244 ;;bilbao;244
245 ;;nav-aa;245
246 ;;okc-ao;246
247 ;;phx-ao;247
248 ;;pordps;248
249 ;;tucdev;24992
285 ;;nsaoa;285
Q ;;
