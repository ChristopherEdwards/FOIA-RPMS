BQIDCEPL ;VNGT/HS/ALA-Patients from an EHR Personal List ; 06 Nov 2008  2:58 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
EPL(NDATA,PARMS,MPARMS) ;EP
 ;
 ;Description
 ;  Executable to retrieve those patients which are on a specified EHR personal list
 ;Input
 ;  PARMS = Array of parameters and their values
 ;  MPARMS = Multiple array of a parameter
 ;Expected to return DATA
 ;
 NEW UID,II,BQ,DFN,EHRPLIEN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J),II=0
 S NDATA=$NA(^TMP("BQIDCEPL",UID))
 K @NDATA
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIDCEPL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 S NM=""
 F  S NM=$O(PARMS(NM)) Q:NM=""  S @NM=PARMS(NM)
 ;
 ;Parameters
 ;  EHRPLIEN = EHR Personal List internal entry number
 ;
 I $D(MPARMS("EHRPLIEN"))>0 D
 . S EHRPLIEN=""
 . F  S EHRPLIEN=$O(MPARMS("EHRPLIEN",EHRPLIEN)) Q:EHRPLIEN=""  D FND
 I '$D(MPARMS("EHRPLIEN")) D FND
 ;
 Q
 ;
FND ;
 I $G(^XTV(8989.5,EHRPLIEN,0))="" D MSG Q
 D PLSTPTS^BEHOPTP2(.TDATA,EHRPLIEN)
 ;
 S BQ=0
 F  S BQ=$O(TDATA(BQ)) Q:BQ=""  D
 . S DFN=$P(TDATA(BQ),U,1) I DFN="" Q
 . S @NDATA@(DFN)=""
 K TDATA
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(II),$D(NDATA) S II=II+1,@NDATA@(II)=$C(31)
 Q
 ;
MSG ;
 NEW MSG,FLAG,MTEXT
 S MSG="EHR Personal List Problem"
 S FLAG="" I $G(ZTSK)'="" S FLAG=1
 S MTEXT(1,0)="One or more of the EHR Personal Lists used in panel "_$P(^BQICARE(OWNR,1,PLIEN,0),U,1)_" appears"
 S MTEXT(2,0)="to have been deleted from your server. The results of this panel may not be accurate."
 D ADD^BQINOTF("",OWNR,MSG,.MTEXT,FLAG)
 Q
