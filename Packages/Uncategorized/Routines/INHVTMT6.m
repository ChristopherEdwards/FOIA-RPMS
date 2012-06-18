INHVTMT6 ; DGH,FRW,CHEM,WAB,KAC ; 06 Aug 1999 15:34:58; Multi-threaded TCP/IP socket utilities 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 Q
 ;
INITPDTS ; PDTS-specific initialization of constants.
 ;
 ; Called by: INHVTMT after INIT^INHUVUT
 ;
 ;Input:
 ; INIP("SOM")    - (pbr) Start of msg
 ; INIP("SOD")    - (pbr) Start of data (End of ENP hdr)
 ; INIP("EOL")    - (pbr) End of line (End of segment)
 ; INIP("FS")     - (pbr) Field Separator
 ; INIP("EOM")    - (pbr) End of msg  (= End of data)
 ;
 ; PDTS-specific constants/defaults
 N INDELIM
 S INDELIM=$$FIELD^INHUT()
 S INIP("SOM")=$S('$L($G(INIP("SOM"))):$C(223)_$C(44)_$C(223),(INIP("SOM")=$C(11)):$C(223)_$C(44)_$C(223),1:INIP("SOM"))
 S INIP("EOM")=$S('$L($G(INIP("EOM"))):$C(225),(INIP("EOM")=$C(28)):$C(225),1:INIP("EOM"))
 S INIP("EOL")=$S('$L($G(INIP("EOL"))):$C(29),(INIP("EOL")=$C(13)):$C(29),1:INIP("EOL"))
 S INIP("SOD")=$C(224)
 S INIP("FS")=$C(28)
 ;
 I $L($G(INIP("INIT"))) S INIP("INIT")=$P($G(^INTHPC(INBPN,1)),U,8)
 E  D
 .; create dummy transaction
 . S INIP("INIT")="02DQDUMMYTRXSITEPDTSLENG"_INIP("SOD")_"6004263201DD 770306 7703609                    11111111111       01 0000000011000000000^C92^CAHAL         ^CBTEST           ^CP44087    "_INIP("EOL")
 . S INIP("INIT")=INIP("INIT")_"12345670000060030000173042800100000{000000000 199904290000000000{^E700060000"
 ;
 S INIP("INIT")=$TR(INIP("INIT"),INDELIM,INIP("FS"))
 ;Following logic is CHCS specific. Must be re-written if used by IHS
 ;S $E(INIP("INIT"),13,16)=$$DMISID^DAHPNU  ; update unique site id
 ;
 ; update length field (unencrypted dummy claim length)
 S $E(INIP("INIT"),21,24)=$TR($J($L(INIP("INIT"))-$F(INIP("INIT"),INIP("SOD"))+1,4)," ",0)
 Q
 ;
