BMXRPC6 ; IHS/OIT/HMW - BMX REMOTE PROCEDURE CALLS ;
 ;;4.0;BMX;;JUN 28, 2010
 ;
 ;
USRKEYRS(BMXY,BMXDUZ)        ;EP - Returns recordset of user's keys
 ;
 N BMXDPT,BMXZ,BMXDLIM,BMXXX,BMXRET,BMXAGE,BMXNEXT,BMXSEX,BMXERR
 S BMXDLIM="^",BMXERR=""
 S BMXRET="T00050KEY"_$C(30)
 I '$D(DUZ(2)) S BMXY=BMXRET_$C(31)_"No DUZ2" Q
 ;Strip CRLFs from parameter
 S BMXCRLF=$C(13)_$C(10)
 S BMXDUZ=$TR(BMXDUZ,BMXCRLF,"")
 I '$D(^VA(200,BMXDUZ)) S BMXY=BMXRET_$C(31)_"No such user" Q
 S BMXK=0 F  S BMXK=$O(^VA(200,BMXDUZ,51,BMXK)) Q:'+BMXK  D
 . S BMXKEY=$G(^VA(200,BMXDUZ,51,BMXK,0))
 . Q:BMXKEY=""
 . S BMXKEY=$P(BMXKEY,BMXDLIM)
 . Q:'+BMXKEY
 . Q:'$D(^DIC(19.1,BMXKEY,0))
 . S BMXKEY=$P(^DIC(19.1,BMXKEY,0),BMXDLIM)
 . Q:BMXKEY']""
 . S BMXRET=BMXRET_BMXKEY_$C(30)
 S BMXY=BMXRET_$C(30)_$C(31)_BMXERR
 Q
 ;
PDATA(BMXY,BMXP) ;-EP Returns patient demographics for pt with 
 ;health record number BMXP at the current DUZ(2)
 N BMXIEN,BMXDUZ2,BMXSQL
 ;Strip CR, LF, TAB, SPACE
 S BMXP=$TR(BMXP,$C(13),"")
 S BMXP=$TR(BMXP,$C(10),"")
 S BMXP=$TR(BMXP,$C(9),"")
 S BMXP=$TR(BMXP,$C(32),"")
 S BMXDUZ2=$G(DUZ(2)),BMXDUZ2=+BMXDUZ2
 S BMXIEN=0
 I +BMXDUZ2 F  S BMXIEN=$O(^AUPNPAT("D",BMXP,BMXIEN)) Q:'+BMXIEN  I $D(^AUPNPAT("D",BMXP,BMXIEN,BMXDUZ2)) Q
 S BMXSQL="SELECT NAME 'Name', DOB 'DateOfBirth', TRIBE_OF_MEMBERSHIP 'Tribe', MAILING_ADDRESS-STREET 'Street',"
 S BMXSQL=BMXSQL_" MAILING_ADDRESS-CITY 'City', MAILING_ADDRESS-STATE 'State', MAILING_ADDRESS-ZIP 'Zip', HOME_PHONE 'HomePhone', OFFICE_PHONE 'WorkPhone' FROM PATIENT WHERE BMXIEN='"_+BMXIEN_"'"
 D SQL^BMXSQL(.BMXY,BMXSQL)
 S @BMXY@(.5)="T00015Chart^"
 I $D(@BMXY@(10)) S @BMXY@(10)=BMXP_"^"_@BMXY@(10)
 ;
 Q
 ;
PDEMOD(BMXY,BMXPAT,BMXCOUNT) ;EP
 ;Entry point for Serenji debugging
 ;
 ;D DEBUG^%Serenji("PDEMOD^BMXRPC6(.BMXY,BMXPAT,BMXCOUNT)")
 Q
 ;
PDEMO(BMXY,BMXPAT,BMXCOUNT) ;EP
 ;This simple RPC demonstrates how to format data
 ;for the BMXNet ADO.NET data provider
 ;
 ;Returns a maximum of BMXCOUNT records from the
 ;VA PATIENT file whose names begin with BMXPAT
 ;
 N BMXI,BMXD,BMXC,BMXNODE,BMXDOB
 ;
 ;When the VA BROKER calls this routine, BMXY is passed by reference
 ;We set BMXY to the value of the variable in which we will return
 ;our data:
 ;S BMXY="^TMP(""BMX"","_$J_")"
 N BMXUID
 S BMXUID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S BMXY=$NA(^BMXTMP("BMXTEST",BMXUID))
 K ^BMXTMP("BMXTEST",BMXUID)
 ;
 ;The first subnode of the data global contains the column header information
 ;in the form "TxxxxxCOLUMN1NAME^txxxxxCOLUMN2NAME"_$C(30)
 ;where T is the column data type and can be either T for text, I for numeric or D for date/time.
 ;xxxxx is the length of the column in characters:
 ;
 S BMXI=0,BMXC=0
 S ^BMXTMP("BMXTEST",BMXUID,BMXI)="T00030NAME^T00010SEX^D00020DOB"_$C(30)
 ;
 ;You MUST set an error trap:
 S X="PDERR^BMXRPC6",@^%ZOSF("TRAP")
 ;
 ;Strip CR, LF, TAB, SPACE from BMXCOUNT parameter
 S BMXCOUNT=$TR(BMXCOUNT,$C(13),"")
 S BMXCOUNT=$TR(BMXCOUNT,$C(10),"")
 S BMXCOUNT=$TR(BMXCOUNT,$C(9),"")
 S BMXCOUNT=$TR(BMXCOUNT,$C(32),"")
 ;
 ;Iterate through the global and set the data nodes:
 S:BMXPAT="" BMXPAT="A"
 S BMXPAT=$O(^DPT("B",BMXPAT),-1)
 S BMXD=0
 F  S BMXPAT=$O(^DPT("B",BMXPAT)) Q:BMXPAT=""  S BMXD=$O(^DPT("B",BMXPAT,0)) I +BMXD  S BMXC=BMXC+1 Q:(BMXCOUNT)&(BMXC>BMXCOUNT)  D
 . Q:'$D(^DPT(BMXD,0))
 . S BMXI=BMXI+1
 . S BMXNODE=^DPT(BMXD,0)
 . ;Convert the DOB from FM date
 . S Y=$P(BMXNODE,U,3)
 . I +Y X ^DD("DD")
 . S BMXDOB=Y
 . ;The data node fields are in the same order as the column header, i.e. NAME^SEX^DOB
 . ;and terminated with a $C(30)
 . S ^BMXTMP("BMXTEST",BMXUID,BMXI)=$P(BMXNODE,U)_U_$P(BMXNODE,U,2)_U_BMXDOB_$C(30)
 ;
 ;After all the data nodes have been set, set the final node to $C(31) to indicate
 ;the end of the recordset
 S BMXI=BMXI+1
 S ^BMXTMP("BMXTEST",BMXUID,BMXI)=$C(31)
 Q
 ;
PDERR ;Error trap for PDEMO
 ;
 S ^BMXTMP("BMXTEST",BMXUID,BMXI+1)=$C(31)
 Q
