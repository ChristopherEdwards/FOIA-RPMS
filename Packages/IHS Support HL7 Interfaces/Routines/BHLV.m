BHLV ; cmi/flag/maw - BHL IHS Variable Set ; [ 05/22/2002  2:51 PM ]
 ;;3.01;BHL IHS Interfaces with GIS;**1,12,14**;JUN 01, 2002
 ;
 ;setup global variables for IHS HL7 messages
 ;cmi/anch/maw 3/9/2005 added fix for PIMS 5.3 because visit file pointer was moved
 ;cmi/anch/maw 1/4/2006 added fix for visit ien and visit date/time in VST
 ;
MAIN ;EP - this is the main routine driver
 ;I $$BHLIS(BHLMIEN)="X12" D USE,X12 Q
 D USE,EN,OS,OTH
 Q
 ;
USE ;-- setup user variables
 D DUZ^XUP(DUZ)
 D SETDT^UTDT
 S BHLH=$H
 Q
 ;
EN ;-- setup encoding characters
 S FS=$$FIELD^INHUT()
 S CS=$$COMP^INHUT()
 S SCS=$$SUBCOMP^INHUT()
 S RS=$$REP^INHUT()
 S ESC=$E($$ESC^INHUT(),1,1)
 S INA("ENC")=CS_RS_ESC_SCS
 Q
 ;
OS ;-- setup operating system level stuff
 S BHLDOM=$$VAL^XBDIQ1(4.3,1,.01)
 Q
 ;
OTH ;-- setup other variables
 S BHL("IHST")="99IHS"
 Q
 ;
DW1 ;EP - entry point for DW1
 S BHLVIEN=$G(INDA(9000010,1))
 Q
 ;
VST ;EP - get visit date for other segments
 S INDA(2,1)=INDA,BHL("PAT")=INDA
 D ^XBKVAR
 S Y=$G(INDA) D ^AUPNPAT
 I $O(INDA(9000010,0)) S BHL("VIEN")=$G(INDA(9000010,$O(INDA(9000010,0))))  ;maw 3/10/2006
 I '$O(INDA(9000010,0)) D  Q
 . I '$G(INDA(405,1)) S BHL("VDT")=DT Q
 . I '$G(INA("DGPMCA")) S INA("DGPMCA")=$G(INDA(405,1))
 . S BHL("VDTM")=$$VALI^XBDIQ1(405,INA("DGPMCA"),.01)
 . S BHL("VIEN")=""
 . I $$PIMS53() D
 .. S INDA(9000010,1)=$$VALI^XBDIQ1(405,INA("DGPMCA"),.27)
 .. S BHL("VIEN")=$S($G(INDA(405,1)):$$VALI^XBDIQ1(405,INA("DGPMCA"),.27),1:$G(INDA(9000010,$O(INDA(9000010,0)))))
 . I '$$PIMS53() D
 .. S INDA(9000010,1)=$$VALI^XBDIQ1(405,INA("DGPMCA"),9999999.1)
 .. S BHL("VIEN")=$S($G(INDA(405,1)):$$VALI^XBDIQ1(405,INA("DGPMCA"),9999999.1),1:$G(INDA(9000010,$O(INDA(9000010,0)))))
 I '$G(BHL("VDTM")),$G(BHL("VIEN")) S BHL("VDTM")=$$VALI^XBDIQ1(9000010,BHL("VIEN"),.01)
 Q:'$G(BHL("VDTM"))
 S BHL("VDT")=$P(BHL("VDTM"),".")
 Q
 ;
VA200 ;-- check for va 200 conversion if so get provider from there
 I $$VAL^XBDIQ1(9999999.39,1,.22) D  Q
 . S BHLPRV=200
 . S BHLDEAF=.22
 S BHLPROVF=200
 S BHLDEAF=5
 Q
 ;
X12 ;-- X12 setup
 Q
 ;
TZ() ;-- get's time zone differential for current system
 S BHLTZ=$$VALI^XBDIQ1(4.3,1,1)
 I BHLTZ="" Q ""
 S BHLTZD=$$VALI^XBDIQ1(4.4,BHLTZ,2)
 S BHLTZP=$E(BHLTZD,1,1)
 S BHLTZN=$E(BHLTZD,2,999)
 I BHLTZN["." D
 . S BHLTZNA=$P(BHLTZN,".")
 . S BHLTZNB=$P(BHLTZN,".",2)
 . I BHLTZNB=5 S BHLTZNB="30"
 . S BHLTZN=BHLTZNA_BHLTZNB
 S BHLTZLZ=$S($L(BHLTZN)=1:"0",$L(BHLTZN)>2:"0",1:"")
 S BHLTZEZ=$S($L(BHLTZN)>2:"0",1:"00")
 S BHLTZD=BHLTZP_BHLTZLZ_BHLTZN_BHLTZEZ
 S BHLTZD=$E(BHLTZD,1,5)
 Q BHLTZD
 ;
BHLIS(BHLMSG)      ;-- get the interface standard
 S BHLSTD=$$VAL^XBDIQ1(4011,BHLMSG,.11)
 Q BHLSTD
 ;
PIMS53() ;-- check the PIMS version
 N BHLPM
 S BHLPM=$O(^DIC(9.4,"C","PIMS",0))
 I 'BHLPM Q 0
 I $G(^DIC(9.4,BHLPM,"VERSION"))>5.29 Q 1
 Q 0
 ;
