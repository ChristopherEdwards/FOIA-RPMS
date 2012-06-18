BSDX36 ; IHS/OIT/HMW/MSC/SAT - WINDOWS SCHEDULING RPCS ;
 ;;3.0;IHS WINDOWS SCHEDULING;;DEC 09, 2010
 ;
 ;COLLECT WAITLIST FOR GIVEN RESOURCE - RPC
CW(BSDXY,BSDXRES) ;COLLECT WAITLIST DATA
 ;  .BSDXY   = returned pointer to list of waitlist data
 ;   BSDXRES = resource code - pointer to ^BSDXRES (BSDX RESOURCE)
 ; called by BSDX WAITLIST remote procedure
 N BSDXI,BSDXNOD,BSDXRESN,BSDXSC,BSDXTMP,BSDWL,BSDXWLD,BSDXWLN,CI,WL
 D ^XBKVAR S X="ERROR^BSDX36",@^%ZOSF("TRAP")
 S BSDXI=0
 K ^BSDXTMP($J)
 S BSDXY="^BSDXTMP("_$J_")"
 S ^BSDXTMP($J,0)="T00020ERRORID"_$C(30)
 ;check for valid resource
 I '+BSDXRES D ERR("BSDX36: Invalid Resource ID") Q
 I '$D(^BSDXRES(BSDXRES,0)) D ERR("BSDX36: Invalid Resource ID") Q
 S BSDXNOD=^BSDXRES(BSDXRES,0)
 S BSDXSC=$P(BSDXNOD,U,4)
 ;check that hospital location is defined for this resource
 I '+BSDXSC D ERR("BSDX36: Resource "_$P(BSDXNOD,U,1)_" does not have a Hospital Location defined") Q
 I '$D(^SC(BSDXSC,0)) D ERR("BSDX36: Resource "_$P(BSDXNOT,U,1)_" has an invalid Hospital Location defined") Q
 ;GET WL POINTER FROM ^BSDWL("B",SC,WL)
 S BSDWL=$O(^BSDWL("B",BSDXSC,""))
 S BSDXWLD=$G(^BSDWL(BSDWL,0))
 ;check if wait list is inactive
 I $P(BSDXWLD,U,2) D ERR("BSDX36: WaitList for "_$P(^SC(BSDXSC,0),U,1)_" is inactive") Q
 ;                1                      2                   3                 4                  5                
 S BSDXTMP="I00020HOSPITAL_LOC_IEN^I00020WAIT_LIST_IEN^I00020PATIENT_IEN^T00030PATIENT_NAME^T00030HOME_PHONE^"
 ;                        6                7           8                9            10             11             
 S BSDXTMP=BSDXTMP_"T00020WORK_PHONE^T00030CHART^D00020DATE_ADDED^T00030REASON^T00020PRIORITY^I00020PROVIDER^"
 ;                        12                13            
 S BSDXTMP=BSDXTMP_"D00020RECALL_DATE^T00250COMMENT"_$C(30)
 S ^BSDXTMP($J,0)=BSDXTMP
 ;loop through waitlist 
 ;RETURN LOOKS LIKE:
 ; BSDXTMP(<counter>,"C",<c counter>)=Comment text
 S WL=0
 F  S WL=$O(^BSDWL(BSDWL,1,WL)) Q:(WL="")||('WL)  D
 . S BSDXWLN=$G(^BSDWL(BSDWL,1,WL,0))
 . S DFN=$P(BSDXWLN,U,1)
 . S DPTN=$G(^DPT(DFN,.13))
 . S BSDXI=BSDXI+1
 . ;         1        2    3                 4                                 5              
 . S BSDXTMP=BSDXSC_U_WL_U_$P(BSDXWLN,U,1)_U_$P(^DPT($P(BSDXWLN,U,1),0),U,1)_U_$P(DPTN,U,1)_U
 . ;                 6              7                                       8                               
 . S BSDXTMP=BSDXTMP_$P(DPTN,U,2)_U_$$HRCN^BDGF2(DFN,+$$FAC^BSDU(BSDXSC))_U_$$FMTE^XLFDT($P(BSDXWLN,U,3))_U
 . ;                 9                                    10                                                                                     
 . S BSDXTMP=BSDXTMP_$P(^BSDWLR($P(BSDXWLN,U,9),0),U,1)_U_$S($P(BSDXWLN,U,2)=1:"HIGH",$P(BSDXWLN,U,2)=2:"MIDDLE",$P(BSDXWLN,U,2)=3:"LOW",1:"")_U
 . ;                 11                                   12                              13
 . S BSDXTMP=BSDXTMP_$P(^VA(200,$P(BSDXWLN,U,6),0),U,1)_U_$$FMTE^XLFDT($P(BSDXWLN,U,5))_U_$G(^BSDWL(BSDWL,1,WL,1,1,0))
 . S ^BSDXTMP($J,BSDXI)=BSDXTMP
 . S CI=""
 . F  S CI=$O(^BSDWL(BSDWL,1,WL,1,CI)) Q:'+CI  D
 . . S BSDWLN=$G(^BSDWL(BSDWL,1,WL,1,CI,0))
 . . S:$E(BSDWLN,$L(BSDWLN)-1,$L(BSDWLN))'=" " BSDWLN=BSDWLN_" "
 . . S BSDXI=BSDXI+1
 . . S ^BSDXTMP($J,BSDXI)=BSDWLN
 . S BSDXI=BSDXI+1
 . S ^BSDXTMP($J,BSDXI)=$C(30)
 S BSDXI=BSDXI+1
 S ^BSDXTMP($J,BSDXI)=$C(31)
 Q
 ;
ERROR ;
 D ERR("RPMS Error")
 Q
 ;
ERR(BSDXERR) ;Error processing
 I +BSDXERR S BSDXERR=ERRNO+134234112 ;vbObjectError
 S BSDXI=BSDXI+1
 S ^BSDXTMP($J,BSDXI)=BSDXERR_$C(30)
 S BSDXI=BSDXI+1
 S ^BSDXTMP($J,BSDXI)=$C(31)
 Q
