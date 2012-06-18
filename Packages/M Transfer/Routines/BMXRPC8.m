BMXRPC8 ; IHS/OIT/HMW - BMX REMOTE PROCEDURE CALLS ;
 ;;4.0;BMX;;JUN 28, 2010
 ;
 ;
BMXLOCKD(BMXY,BMXVAR,BMXINC,BMXTIME) ;EP
 ;Entry point for debugging
 ;
 ;D DEBUG^%Serenji("BMXLOCKD^BMXRPC8(.BMXY,BMXVAR,BMXINC,BMXTIME)")
 Q
 ;
BMXLOCK(BMXY,BMXVAR,BMXINC,BMXTIME) ;EP
 ;Called by BMX LOCK rpc to lock variable BMXVAR
 ;If BMXVAR = "", argumentless lock is performed to release all locks
 ;BMXINC = increment lock if "+", decrement if "-"
 ;BMXTIME = lock timeout
 ;Returns 1 if lock successful, otherwise 0;
 ;
 S X="ERR^BMXRPC8",@^%ZOSF("TRAP")
 ;
 N BMXC
 S:$E(BMXVAR,1,1)="~" BMXVAR="^"_$E(BMXVAR,2,$L(BMXVAR))
 S:BMXTIME="" BMXTIME=0
 I BMXVAR="" X "L"  S BMXY=1 Q
 S BMXC="L "
 S BMXC=BMXC_$S(BMXINC="+":"+",BMXINC="-":"-",1:"")
 S BMXC=BMXC_BMXVAR_":"_+BMXTIME
 X BMXC
 S BMXY=$T
 Q
 ;
ERR ;Error processing
 S BMXY=0
 Q
 ;
BMXVERD(BMXY,BMXNS,BMXLOC) ;EP
 ;Entry point for debugging
 ;
 ;D DEBUG^%Serenji("BMXVERD^BMXRPC8(.BMXY,BMXNS,BMXLOC)")
 Q
 ;
BMXVER(BMXY,BMXNS,BMXLOC) ;EP
 ;
 ;Called by BMX VERSION INFO rpc
 ;Returns recordset of version info for server components in namespace BMXNS.
 ;If BMXLOC is "", then the version info is assumed to be stored in piece 1-3 of
 ;^<BMXNS>APPL(1,0)
 ;
 ;TODO:
 ;BMXLOC, if not null, is either a global reference such that $P(@BMXLOC,U,1,3) returns
 ;MAJOR^MINOR^BUILD
 ;Or BMXLOC can be an extrinsic function call that returns MAJOR^MINOR^BUILD.
 ;
 ;The returned error field is either "" or contains a text error message.
 ;
 N X,BMXI,BMXNOD,BMXDAT
 ;
 S X="VETRAP^BMXRPC8",@^%ZOSF("TRAP")
 S BMXI=0
 K ^BMXTMP($J)
 S BMXY="^BMXTMP("_$J_")"
 S ^BMXTMP($J,BMXI)="T00030ERROR^T00030MAJOR_VERSION^T00030MINOR_VERSION^T00030BUILD"_$C(30)
 S BMXI=BMXI+1
 I BMXNS="" D VERR(BMXI,"BMXRPC8: Invalid Null Application Namespace") Q
 S BMXNOD="^"_BMXNS_"APPL(1,0)"
 S BMXDAT=$G(@BMXNOD)
 I BMXNS="" D VERR(BMXI,"BMXRPC8: No version info for Application Namespace") Q
 S ^BMXTMP($J,BMXI)="^"_$P(BMXDAT,U,1,3)_$C(30)
 Q
 ;
 ;
VERR(BMXI,BMXERR) ;Error processing
 S BMXI=BMXI+1
 S ^BMXTMP($J,BMXI)=BMXERR_"^^^"_$C(30)
 S BMXI=BMXI+1
 S ^BMXTMP($J,BMXI)=$C(31)
 Q
 ;
VETRAP ;EP Error trap entry
 D ^%ZTER
 I '$D(BMXI) N BMXI S BMXI=999999
 S BMXI=BMXI+1
 D VERR(BMXI,"BMXRPC8 Error: "_$G(%ZTERROR))
 Q
 ;
IMHERE(BMXRES) ;EP
 ;Entry point for BMX IM HERE remote procedure
 S BMXRES=1
 Q
 ;
