BSDX39 ; IHS/OIT/HMW/MSC/SAT - WINDOWS SCHEDULING RPCS ;
 ;;3.0;IHS WINDOWS SCHEDULING;;DEC 09, 2010
 ;
 ;  PWH = return list of active Health Summary PWH Types - RPC
 ;
 ;return list of active Health Summary PWH Types - RPC
PWH(BSDXY) ;EP
 ; RPC Name is BSDX PWH TYPES
 ;  .BSDXY   = returned pointer to list of active Health Summary PWH Types from file 9001026 ^APCHPWHT
 ;   no input
 ; called by BSDX HS PWH TYPES
 N BSDXI,PWH,PWHNAME
 D ^XBKVAR S X="ERROR^BSDXERR",@^%ZOSF("TRAP")
 S BSDXI=0
 K ^BSDXTMP($J)
 S BSDXY="^BSDXTMP("_$J_")"
 ; data header
 S ^BSDXTMP($J,0)="T00020PWH_TYPE_IEN^T00020PWH_TYPE_NAME"_$C(30)
 ;loop thru PWH Types
 S PWH=0 F  S PWH=$O(^APCHPWHT(PWH)) Q:PWH'>0  D
 . S PWHNAME=$$GET1^DIQ(9001026,PWH_",",.01)
 . S BSDXI=BSDXI+1
 . S ^BSDXTMP($J,BSDXI)=PWH_U_PWHNAME_$C(30)
 ;
 S BSDXI=BSDXI+1
 S ^BSDXTMP($J,BSDXI)=$C(31)
 Q
