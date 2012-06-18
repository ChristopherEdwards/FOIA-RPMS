BMXRPC2 ; IHS/OIT/HMW - FIELD LIST ;
 ;;4.0;BMX;;JUN 28, 2010
 ;
FLDLIST(BMXGBL,BMXFL,BMXATTR,BMXSCR)        ;EP
 ;TODO: Change all this to be a hard-coded $O thru ^DD
 ;Returns info in BMXATTR for all fields in file number BMXFL
 ;BMXSCR is executable code to set $T
 ; When BMXSCR is executed, the field number is in BMXFLD
 ;See FileMan documentation for FIELD^DD for description
 ;of Attributes
 ;
 ;---> Set variables, kill temp globals.
 ;S ^HW("F",BMXFL)=""
 ;S ^HW("F",BMXATTR)=""
 N BMX31,BMXERR,BMXG,BMXFLD,BMX,BMXC,BMXT
 S BMX31=$C(31)_$C(31)
 S BMXGBL="BMXTMP("_$J_")",BMXERR="",U="^"
 K BMXTMP($J)
 ;
 ;---> If file number not provided, return error.
 ;I '+BMXFL D ERROUT^BMXRPC("File number not provided.",1) Q
 ;---> If file number not provided check for file name.
 I +BMXFL'=BMXFL D
 . S BMXFL=$TR(BMXFL,"_"," ")
 . I '$D(^DIC("B",BMXFL)) S BMXFL="" Q
 . S BMXFL=$O(^DIC("B",BMXFL,0))
 I '$G(BMXFL) D ERROUT^BMXRPC("File number not provided.",1) Q
 ;
 ;---> If no such file, return error.
 I '$D(^DD(BMXFL,0)) D ERROUT^BMXRPC("File does not exist.",1) Q
 ;
 ;---> Validate screen code
 I $G(BMXSCR)="" S BMXSCR="I 1"
 S X=$G(BMXSCR)
 I X]"" D ^DIM
 I '$D(X) S BMXSCR="I 1" ;Default to no screen
 ;
 ;---> Set Target Global for output and errors.
 S BMXG="BMXTMP($J,""DID"")"
 ;
 ;---> Loop through ^DD(FileNumber,FieldNumber,0) to get field names
 K BMXTMP($J)
 I $G(BMXATTR)="" S BMXATTR="LABEL" ;Changed from NAME to LABEL
 ;---> Attribute Names
 F I=1:1:$L(BMXATTR,";") S BMXT($P(BMXATTR,";",I))=""
 S (BMX,BMXC)=0 F  S BMX=$O(BMXT(BMX)) Q:BMX=""  D
 . S BMXC=BMXC+1
 . S $P(BMXT,U,BMXC)="T00030"_BMX
 S BMXTMP($J,1)="T00030NUMBER"_U_BMXT_$C(30)
 ;
 ;S BMXFLD=0 F I=2:1 S BMXFLD=$O(^DD(BMXFL,BMXFLD)) Q:'+BMXFLD  D
 S BMXTMP($J,2)=".001^BMXIEN"_$C(30)
 S BMXFLDN=0 F I=3:1 S BMXFLDN=$O(^DD(BMXFL,"B",BMXFLDN)) Q:BMXFLDN=""  D
 . S BMXFLD=$O(^DD(BMXFL,"B",BMXFLDN,0)) Q:'+BMXFLD
 . X BMXSCR Q:'$T
 . D FIELD^DID(BMXFL,BMXFLD,,BMXATTR,BMXG,BMXG)
 . K BMXT S (BMXC,BMX)=0
 . F  S BMX=$O(BMXTMP($J,"DID",BMX)) Q:BMX=""  D
 . . S BMXC=BMXC+1
 . . S $P(BMXT,U,BMXC)=BMXTMP($J,"DID",BMX)
 . S BMXTMP($J,I)=BMXFLD_U_$TR(BMXT," ","_")_$C(30)
 ;S I=I+1,BMXTMP($J,I)=".001^BMXIEN"_$C(30)
 S I=I+1
 K BMXTMP($J,"DID")
 ;---> Tack on Error Delimiter and any error.
 S BMXTMP($J,I)=BMX31_BMXERR
 Q
 ;
MLTLIST(BMXGBL,BMXFL,BMXONEOK) ;EP
 ;Returns list of multiple fields in file BMXFL, returns only one field
 ;if BMXONEOK is TRUE
 ;S ^HW($H,"MLTLIST","FL")=BMXFL
 ;S ^HW($H,"MLTLIST","ONE")=BMXONEOK
 N BMX31,BMXERR,BMXG,BMXFLD,BMX,BMXC,BMXT,I
 S BMX31=$C(31)_$C(31)
 S BMXGBL="BMXTMP("_$J_")",BMXERR="",U="^"
 K BMXTMP($J)
 ;
 ;---> If file number not provided check for file name.
 I +BMXFL'=BMXFL D
 . S BMXFL=$TR(BMXFL,"_"," ")
 . I '$D(^DIC("B",BMXFL)) S BMXFL="" Q
 . S BMXFL=$O(^DIC("B",BMXFL,0))
 I '$G(BMXFL) D ERROUT^BMXRPC("File number not provided.",1) Q
 ;
 ;---> If no such file, return error.
 I '$D(^DD(BMXFL,0)) D ERROUT^BMXRPC("File does not exist.",1) Q
 ;
 ;---> Column Headers
 S BMXTMP($J,1)="T00030NUMBER"_U_"T00030NAME"_$C(30)
 ;
 ;---> $O thru ^DD(BMXFL,"SB" to get subfile numbers and names
 S I=2
 N BMXSB,BMXSBN,BMXSBF,BMXFOUND
 S BMXFOUND=0
 I $D(^DD(BMXFL,"SB")) D
 . S BMXSB=0
 . F  S BMXSB=$O(^DD(BMXFL,"SB",BMXSB)) Q:'+BMXSB  D  I BMXFOUND Q:BMXONEOK=1
 . . S BMXSBF=$O(^DD(BMXFL,"SB",BMXSB,0))
 . . Q:'+BMXSBF
 . . S BMXSBN=$G(^DD(BMXFL,BMXSBF,0))
 . . Q:BMXSBN=""
 . . S BMXZ=$G(^DD(BMXSB,.01,0))
 . . Q:$P(BMXZ,U,2)["W"
 . . S BMXFOUND=1
 . . S BMXSBN=$P(BMXSBN,U)
 . . S BMXTMP($J,I)=BMXSB_U_BMXSBN_$C(30)
 . . S I=I+1
 ;
 ;---> Tack on Error Delimiter and any error.
 S BMXTMP($J,I)=BMX31_BMXERR
 Q
