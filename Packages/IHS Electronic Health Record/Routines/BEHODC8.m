BEHODC8 ;MSC/IND/MGH -  TIU Dictation Support ;20-Mar-2007 13:48;DKM
 ;;1.1;BEH COMPONENTS;**001001**;Mar 20, 2007
 ;================================================================
 ;Routine generates an error message to be sent to a mail group and
 ;an acknowledgement message with the appropriate error
 ;==================================================================
BOTH(DFN,EVNDT,ERRTEXT) ;EP - Generate an error and the acknowledgement
 D GENACK,BULL(DFN,EVNDT,ERRTEXT)
 Q
BULL(DFN,EVNDT,ERRTEXT) ; Generate error message and send to the assigned mail group
 S XMB="DICT HL7 ERRORS"
 D NOW^%DTC S XMDT=X K X
 S XMB(1)=$S(+DFN:$P($G(^DPT(DFN,0)),"^"),1:"UNKNOWN")
 I XMB(1)="" S XMB(1)="UNKNOWN"
 S XMB(2)=ERRTEXT
 S XMDUZ=$S($D(DUZ):DUZ,1:.5)
 ;D ^XMB
 K XMB,XMDT,XMDUZ
 ;Send alert as well
 N XQAMSG,XQAID,GROUP,XQA
 S XQAMSG=ERRTEXT,XQAID="HL7"
 S XQA("G.DICT HL7 ERRORS")=""
 D SETUP^XQALERT
 K XMB,XMY,XMM,XMDT Q
GENACK ;EP - Generate an HL7 ACK message
 I $D(HLMG) D
 .S HLA("HLA",1)="MSA"_HL("FS")_"AA"_HL("FS")_HL("MID")_HL("FS")_HL("FS")_HL("FS")_HL("FS")_HL("FS")_HLMG
 E  D
 .S HLA("HLA",1)="MSA"_HL("FS")_$S($G(ERRTX)'="":"AE",1:"AA")_HL("FS")_HL("MID")_$S($D(ERRTX):HL("FS")_ERRTX,1:"")
 S HLEID=HL("EID"),HLEIDS=HL("EIDS"),HLARYTYP="LM",HLFORMAT=1,HLRESLTA=HL("MID")
 S HLTCP=1
 D GENACK^HLMA1(HLEID,HLMTIENS,HLEIDS,HLARYTYP,HLFORMAT,.HLRESTLA)
 Q
