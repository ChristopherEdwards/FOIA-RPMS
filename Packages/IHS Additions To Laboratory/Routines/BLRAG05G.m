BLRAG05G ; IHS/MSC/SAT - LABORATORY ACCESSION GUI RPCS ;03 MAY 2013  1200;SAT
 ;;5.2;IHS LABORATORY;**1031**;NOV 01, 1997;Build 185
 ;
 Q
 ;
 ;RPC to return Ask at Order Entry questions for the lab tests that go with the passed in Lab Order Entry file pointers.
 ;  BLRAG05G AOE
 ;Input: 
 ; BLRTSTL   = (required) The "TEST POINTERS" portion of this data comes
 ;                   element 39 in the return from BLR ALL NON-ACCESSIONED.
 ;                       List of test pointers for each
 ;                       test/procedure being accessioned separated by ^.
 ;                       Each ^ piece is made up of these pipe pieces:
 ;                       TEST POINTERS | [ICD9_LIST_(not_used)] ^ ...
 ;                        Test pointers = pointers to the LAB ORDER ENTRY
 ;                        file 69 - DATE:SPECIMEN:TEST
 ;       Note that these are the same pointers that are passed into BLR ACCESSION
 ;Output: BLRAOE=Count of items in array
 ;             BLRAOE(<test ien>,<counter>)=Question prompt^Result Code^Lab Name
AOE(BLRAOE,BLRTSTL) ;EP-
 N BLRDT,BLRJ,BLRSP,BLRTST
 N CNT,IEN,X
 D ^XBKVAR  ;setup minimum KERNEL variables
 S X="ERROR^BLRAG05G",@^%ZOSF("TRAP")  ;setup error trap
 S BLRAOE=0
 S CNT=0
 I $G(BLRTSTL)'="" D
 .F BLRJ=1:1:$L(BLRTSTL,U) D
 ..S BLRDT=$P($P($P(BLRTSTL,U,BLRJ),"|",1),":",1)
 ..S BLRSP=$P($P($P(BLRTSTL,U,BLRJ),"|",1),":",2)
 ..S BLRTST=$P($P($P(BLRTSTL,U,BLRJ),"|",1),":",3)
 ..S BLRTST60=$P($G(^LRO(69,+$G(BLRDT),1,+$G(BLRSP),2,+$G(BLRTST),0)),U,1)  ;get test
 ..D GETPMT(BLRTST60)
 S BLRAOE=CNT
 Q
 ;
 ; Add prompts to return array for a given test
GETPMT(TST) ;EP-
 N RL,RC,RI,N0,PC,TI,SC,LN
 S RL=$P($G(^BLRSITE(DUZ(2),"RL")),U)
 Q:'RL
 S RI=$O(^BLRRL("ALP",TST,RL,0))
 Q:'RI
 S LN=$P($G(^LAB(60,+$G(TST),0)),U,1)
 S RC=0 F  S RC=$O(^BLRRL(RL,1,RI,1,RC)) Q:'RC  D
 .S PC=$G(^BLRRL(RL,1,RI,1,RC,0))
 .S TP=$O(^BLRRL("BRES",PC,RL,0))
 .Q:'TP
 .S N0=^BLRRL(RL,1,TP,0)
 .S TI=$P(N0,U,7)
 .S SC=$P(N0,U,4)
 .S CNT=CNT+1
 .S BLRAOE(TST,CNT)=TI_U_SC_U_LN
 Q
 ;
ERROR ;
 D ENTRYAUD^BLRUTIL("ERROR^BLRAG05G 0.0")   ; Store Error data
 NEW ERRORMSG
 S ERRORMSG="$"_"Z"_"E=""ERROR^BLRAG05G"""  ; BYPASS SAC Checker
 S @ERRORMSG  D ^%ZTER
 D ERR("RPMS Error")
 Q
 ;
ERR(BLRERR) ;Error processing
 ; BLRERR = Error text OR error code
 ; BLRAGI   = pointer into return global array
 I +BLRERR S BLRERR=BLRERR+134234112 ;vbObjectError
 S BLRAOE=-1
 Q
