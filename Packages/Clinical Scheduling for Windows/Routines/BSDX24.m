BSDX24 ; IHS/OIT/HMW/MSC/SAT - WINDOWS SCHEDULING RPCS ;
 ;;3.0;IHS WINDOWS SCHEDULING;;DEC 09, 2010
 ;
 ;
 Q
CRCONTXT(RESULT,OPTION) ;EP
 ;Entry point for debugging XWBSEC
 ;
 ;D DEBUG^%Serenji("CRCONTXT^XWBSEC(.RESULT,OPTION)")
 ;;H .5
 ;;D CRCONTXT^XWBSEC(.RESULT,OPTION)
 ;;S BSDX="^BSDXTMP($J,"
 ;;S ^BSDXTMP($J,0)=RESULT
 ;;S RESULT=1
 Q
TEST0(BSDX) ;EP Delete user from 200
 S DIK="^VA(200,"
 S DA=BSDX
 D ^DIK
 ;
 Q
KILLM ;EP Delete BMXMENU entry
 S DIK="^DIC(19,"
 S DA=$O(^DIC(19,"B","BMXMENU",0))
 Q:'+DA
 D ^DIK
 Q
 ;
TEST1 ;EP Adding an entry to 200
 ;
 S BSDXFDA(200,"+1,",.01)="BMXNET,APPLICATION"
 K BSDXIEN,BSDXMSG
 S DIC(0)=""
 D UPDATE^DIE("","BSDXFDA","BSDXIEN","BSDXMSG")
 ;
 Q
TEST2 ;EP
 ;How to change the ACCESS CODE, VERIFY CODE, DATE VERIFY CODE LAST CHANGED field
 ;ACCESS CODE BSDXXX1^1_(a>yr}:3x3ja9\8vbH
 ;VERIFY CODE BSDXXX2^$;HOSs|:3w25lLD}Be=
 N BSDXFDA
 S BSDXFDA(200,"36,",2)="1_(a>yr}:3x3ja9\8vbH"
 S BSDXFDA(200,"36,",11)="$;HOSs|:3w25lLD}Be="
 S BSDXFDA(200,"36,",11.2)="88888,88888"
 S BSDXFDA(200,"36,",201)="BMXRPC"
 D FILE^DIE("","BSDXFDA","BSDXMSG")
 Q
 ;
 ;
SEARCHD(BSDXY,BSDXRES,BSDXSTRT,BSDXEND,BSDXTYPES,BSDXAMPM,BSDXWKDY) ;EP
 ;Entry point for debugging
 ;
 ;D DEBUG^%Serenji("SEARCH^BSDX24(.RES,""ROGERS,BUCK|FUNAKOSHI,GICHIN"","""","""","""","""","""")")
 ;D DEBUG^%Serenji("SEARCH^BSDX24(.BSDXY,BSDXRES,BSDXSTRT,BSDXEND,BSDXTYPES,BSDXAMPM,BSDXWKDY)")
 Q
 ;
SEARCH(BSDXY,BSDXRES,BSDXSTRT,BSDXEND,BSDXTYPES,BSDXAMPM,BSDXWKDY) ;EP
 ;Searches availability database for availability blocks between
 ;BSDXSTRT and BSDXEND for each of the resources in BSDXRES.
 ;The av blocks must be one of the types in BSDXTYPES, must be
 ;AM or PM depending on value in BSDXAMPM and
 ;must be on one of the weekdays listed in BSDXWKDY.
 ;
 ;Return recordset containing the start times of availability blocks
 ;meeting the search criteria.
 ;
 ;Variables:
 ;BSDXRES |-Delimited list of resource names
 ;BSDXSTRT FM-formatted beginning date of search
 ;BSDXEND FM-Formatted ending date of search
 ;BSDXTYPES |-Delimited list of access type IENs
 ;BSDXAMPM "AM" for am-only, "PM" for pm-only, "BOTH" for both
 ;BSDXWKDY "" if any weekday, else |-delimited list of weekdays
 ;
 ;NOTE: If BSDXEND="" Then:
 ; either ONE record is returned matching the first available block
 ; -or- NO record is returned indicating no available block exists
 ;
 ;Called by BSDX SEARCH AVAILABILITY
 ;Test Line:
 ;D SEARCH^BSDX24(.RES,"ROGERS,BUCK|FUNAKOSHI,GICHIN","","","","","") ZW RES
 ;
 ;
 S X=BSDXSTRT,%DT="X" D ^%DT S BSDXSTRT=$P(Y,".")
 S:+BSDXSTRT<0 BSDXSTRT=DT
 S X=BSDXEND,%DT="X" D ^%DT S BSDXEND=$P(Y,".")
 S:+BSDXEND<0 BSDXEND=9990101
 S BSDXEND=BSDXEND_".99"
 N BSDXRESN,BSDXRESD,BSDXDATE,BSDXI,BSDXABD,BSDXNOD,BSDXATD,BSDXATN
 N BSDXTYPE
 ;
 ;Set up access types array
 F BSDX=1:1:$L(BSDXTYPES,"|") D
 . S BSDXATD=$P(BSDXTYPES,"|",BSDX)
 . S:+BSDXATD BSDXTYPE(BSDXTYPD)=""
 ;
 S BSDXI=0
 S BSDXY="^BSDXTMP("_$J_")"
 S ^BSDXTMP($J,0)="T00030RESOURCENAME^D00030DATE^T00030ACCESSTYPE^T00030COMMENT"_$C(30)
 F BSDX=1:1:$L(BSDXRES,"|") S BSDXRESN=$P(BSDXRES,"|",BSDX) D
 . Q:'$D(^BSDXRES("B",BSDXRESN))
 . S BSDXRESD=$O(^BSDXRES("B",BSDXRESN,0))
 . Q:'+BSDXRESD
 . Q:'$D(^BSDXRES(BSDXRESD,0))
 . Q:'$D(^BSDXAB("ARSCT",BSDXRESD))
 . S BSDXDATE=$O(^BSDXAB("ARSCT",BSDXRESD,BSDXSTRT))
 . Q:BSDXDATE=""
 . Q:BSDXDATE>BSDXEND
 . ;TODO: Screen for AMPM
 . ;TODO: Screen for Weekday
 . ;
 . S BSDXI=BSDXI+1
 . S BSDXABD=$O(^BSDXAB("ARSCT",BSDXRESD,BSDXDATE,0))
 . S BSDXNOD=$G(^BSDXAB(BSDXABD,0))
 . Q:BSDXNOD=""
 . S Y=$P(BSDXDATE,".")
 . D DD^%DT
 . S BSDXATD=$P(BSDXNOD,U,5) ;ACCESS TYPE POINTER
 . S BSDXATD=$G(^BSDXTYPE(+BSDXATD,0))
 . S BSDXATN=$P(BSDXATD,U)
 . I +BSDXATD,BSDXTYPES]"" Q:'$D(BSDXTYPES(BSDXATD))
 . ;TODO: Screen for TYPE ----DONE!
 . ;TODO: Comment
 . S ^BSDXTMP($J,BSDXI)=BSDXRESN_U_Y_U_BSDXATN_U_$C(30)
 S BSDXI=BSDXI+1
 S ^BSDXTMP($J,BSDXI)=$C(31)
 Q
