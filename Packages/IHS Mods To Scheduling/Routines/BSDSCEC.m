BSDSCEC ; IHS/ANMC/LJF - PT ASSIGN DETAILS TEMPLATE ;
 ;;5.3;PIMS;;APR 26, 2002
 ;
EN ; -- main entry point
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDSC PT ASSIGNMENTS")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 K ^TMP("BSDSCEC",$J),^TMP("BSDSCEC1",$J)
 D GUIR^XBLM("IHS^SCRPEC","^TMP(""BSDSCEC1"",$J,")
 S X=0 F  S X=$O(^TMP("BSDSCEC1",$J,X)) Q:'X  D
 . S VALMCNT=X
 . S ^TMP("BSDSCEC",$J,X,0)=^TMP("BSDSCEC1",$J,X)
 K ^TMP("BSDSCEC1",$J)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BSDSCEC",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;
FORMAT(PTIEN,INS,TIEN,PDATA,CNAME,CIEN) ;EP; format data for report
 ; called by FORMAT^SCRPEC2
 ;PTIEN - patient ien
 ;INS - institution ien
 ;TIEN - team ien
 ;PDATA - pt name^pid^mt^pelig^pstat^statd^last^next^pc prov.^assoc. prov.
 ;CNAME - clinic name
 ;CIEN - clinic ien
 ;
 S @STORE@(INS,TIEN,CIEN,PTIEN)=$E($P(PDATA,"^"),1,20)  ;patient name
 S $E(@STORE@(INS,TIEN,CIEN,PTIEN),22)=$P(PDATA,"^",2)  ;primary id
 S $E(@STORE@(INS,TIEN,CIEN,PTIEN),32)=$P(PDATA,"^",7)  ;last appt
 S $E(@STORE@(INS,TIEN,CIEN,PTIEN),57)=$P(PDATA,"^",8)  ;next appt
 S $E(@STORE@(INS,TIEN,CIEN,PTIEN),77)=$E($P(PDATA,U,9),1,18)  ;PC prov.
 S $E(@STORE@(INS,TIEN,CIEN,PTIEN),95)=$E($P(PDATA,U,11),1,18)  ;PC prov.
 S $E(@STORE@(INS,TIEN,CIEN,PTIEN),115)=$E($P(PDATA,U,10),1,18)  ;Assoc. Prov.
 Q
 ;
HEADER ;EP; report column titles
 ; called by HEADER^SCRPEC2
 N HLD
 S HLD="H0"
 S $E(@STORE@("SUBHEADER",HLD),32)="Last Team"
 S $E(@STORE@("SUBHEADER",HLD),57)="Next Team"
 S $E(@STORE@("SUBHEADER",HLD),77)="Primary Care"
 S $E(@STORE@("SUBHEADER",HLD),95)="Non-PC"
 S $E(@STORE@("SUBHEADER",HLD),115)="Associate"
 S HLD="H1"
 S @STORE@("SUBHEADER",HLD)="Patient Name"
 S $E(@STORE@("SUBHEADER",HLD),22)="Pt ID"
 S $E(@STORE@("SUBHEADER",HLD),32)="Appt/Clinic"
 S $E(@STORE@("SUBHEADER",HLD),57)="Appt/Clinic"
 S $E(@STORE@("SUBHEADER",HLD),77)="Provider"
 S $E(@STORE@("SUBHEADER",HLD),95)="Provider"
 S $E(@STORE@("SUBHEADER",HLD),115)="Provider"
 S HLD="H2"
 S $P(@STORE@("SUBHEADER",HLD),"=",133)=""
 Q
 ;
GETAPPT(DFN,BSDTM,MODE) ;EP; find next/last appt for any clinic under team
 ; called by PDATE^SCRPEC
 ; BSDTM=team ien
 ; MODE="LAST" or "NEXT"
 ; BSDX1 will be set as array of providers on team
 ; BSDX2 will be set as array of clinics for provider
 ; returns ANS=appt date_"   "_clinic abbreviation
 ;
 NEW ANS,CLN,BSDATE,BSDX1,BSDX2
 ; find all providers on team during last year
 S BSDATE("BEGIN")=$$FMADD^XLFDT(DT,-365),BSDATE("END")=DT
 S BSDATE("INCL")=0    ;include providers on team anytine in date range
 S BSDX1=$$PROV^BSDU3(.BSDTM,.BSDATE,.ARRAY)
 ;
 ; for each provider, find all associated clinics
 S ANS=$S(MODE="LAST":0,1:9999999)
 S BSD=0 F  S BSD=$O(@BSDX1@(BSD)) Q:'BSD  D
 . S PRV=$P(@BSDX1@(BSD),U) Q:'PRV
 . K BSDX2 D CLINICS^BSDU3(PRV,.BSDX2)
 . ;
 . ; for each clinic, find last appt
 . S CLN=0 F  S CLN=$O(BSDX2(CLN)) Q:'CLN  D
 .. I MODE="LAST" D
 ... S APPT=$$GETLAST^SCRPU3(DFN,CLN)    ;find last appt for clinic
 ... I APPT>ANS S ANS=APPT_"   "_$$GET1^DIQ(44,CLN,1)
 .. I MODE="NEXT" D
 ... S APPT=$$GETNEXT^SCRPU3(DFN,CLN)    ;find next appt for clinic
 ... I APPT,APPT<ANS S ANS=APPT_"   "_$$GET1^DIQ(44,CLN,1)
 I ANS=9999999 S ANS=""
 Q ANS
