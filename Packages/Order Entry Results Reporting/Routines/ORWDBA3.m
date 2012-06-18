ORWDBA3 ; SLC/GSS Billing Awareness; OUTPATIENT ORDERS. [8/20/03 9:19am]
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**190**;Dec 17, 1997
 ;
 ; Subroutines to get V POV pointers at order entry and result
 ; verification for outpatient.
 ;
 ; Reference to EN^DDIOL supported by IA #10142
 ; Reference to ^DIC supported by IA #10006
 ; Reference to $$GET1^DIQ supported by IA #2056
 ; Reference to ^DIR supported by IA #10026
 ; Reference to ^ICD9 supported by IA #10082
 ; Reference to ^DIC(9.4 supported by IA #10048
 ;
 ; Outpatient Order Entry - called from INOUTPT^ORWDBA1
 ;
 ; Input:
 ;  PTIEN                        = Patient's DFN (#2)
 ;  ORDGX                        = Pointer to Diagnosis (#80)
 ;  ORAR(ORDFN,"DOS")            = Date Of Service (FM format)
 ;  ORAR(ORDFN,"PAT")            = Patient's IEN (file# 2)
 ;  ORAR(ORDFN,"POS")            = Place of Service
 ;  ORAR(ORDFN,"POV IEN")        = Pointer to V POV (file# 9000010.07)
 ;  ORAR(ORDFN,"USR")            = Ordering Provider
 ;  ORAR(ORDFN,"DGX",ORDGX)
 ;     $P  Description
 ;      1  Diagnosis (ICD9 #)
 ;      2  Diagnosis description
 ;      3  Service Connected (Y/N)
 ;      4  Agent Orange (Y/N)
 ;      5  Ionizing Radiation (Y/N)
 ;      6  Environmental Contaminants (Y/N)
 ;      7  Military Sexual Trauma (Y/N)
 ;      8  Head & Neck Cancer (Y/N)
 ;
 ; Output:
 ;   ORAR1(VISIT,ORTST,POV)=ORDGX
 ;   VISIT      -  Visit Number
 ;   ORTST      -  Ordered Test
 ;   POV        -  Pointer to V POV (#9000010.07) file
 ;   ORDGX      -  Pointer to Diagnosis (#80)
 ;
OP N ODATA,ODGX,ONUM,ORDGX,INROOT,PKG,SRC,USR,ERRDIS
 N ORDIEN,LVL3,VISIT
 ; ??? DELETE NEXT LINE POST TEST
 ;S U="^"
 F I=1:1:5 S LVL3(I)=$P("DX/PL^ENCOUNTER^^PROVIDER^STOP",U,I)
 S INROOT="^TMP(""ORXAPI"",$J)"
 ;S X="LAB PACKAGE",DIC="^DIC(9.4,",DIC(0)="Z" D ^DIC
 ;S PKG=+Y
 S SRC="CPRS-",ONUM=0,USR=DUZ,ERRDIS=0,ORDFN="",JOB=$J
 ;
 F  S ORDIEN=$O(ORAR(ORDIEN)) Q:ORDIEN=""  K ^TMP("ORXAPI",JOB) D
 . D ORINFO^ORWDBA1(ORDIEN)
 . ; file manager internal formated date.time
 . S ^TMP("ORXAPI",JOB,LVL3(2),1,"ENC D/T")=ORAR(ORDIEN,"DOS")
 . ; pointer to hospital location file# 44
 . S ^TMP("ORXAPI",JOB,LVL3(2),1,"HOS LOC")=ORAR(ORDIEN,"POS")
 . ; pointer to patient file# 9000001
 . S ^TMP("ORXAPI",JOB,LVL3(2),1,"PATIENT")=ORAR(ORDIEN,"PAT")
 . ; ambulatory svc category, may be later changed to I by Visit Tracking
 . S ^TMP("ORXAPI",JOB,LVL3(2),1,"SERVICE CATEGORY")="A"
 . ; primary encounter associated with appt or is stand alone
 . S ^TMP("ORXAPI",JOB,LVL3(2),1,"ENCOUNTER TYPE")="P"
 . ; provider's IEN
 . S ^TMP("ORXAPI",JOB,LVL3(4),1,"NAME")=ORAR(ORDIEN,"POV IEN")
 . S ORDGX=""
 . F  S ORDGX=$O(^OR(100,ORDIEN,5.1,"ICD9",ORDGX)) Q:ORDGX=""  D
 .. S OREC=$G(^OR(100,ORDIEN,5.1,"ICD9",ORDGX,0))
 .. S ODATA=$G(ORAR(ORDIEN,"DGX",ORTST,ORDGX))
 .. S ONUM=$G(ONUM)+1
 .. S ^TMP("ORXAPI",$J,LVL3(1),ONUM,"DIAGNOSIS")=ORDGX
 .. S:ONUM=1 ^TMP("ORXAPI",$J,LVL3(1),ONUM,"PRIMARY")=1
 .. F OX=1:1:6 D
 ... I $P($G(TDATA),U,OX+3)'="" D
 .... S ^TMP("ORXAPI",$J,LVL3(1),ONUM,"CPRS-LAB")=$P(TDATA,U,OX+3)
 . S X=$$DATA2PCE^PXAPI(INROOT,PKG,SRC,.VISIT,USR,ERRDIS)
 . ;I VISIT<0 D ERRMSG(VISIT) Q
 . D ENC(VISIT)
 Q
 ;
ENC(VISIT) ; Get the VISIT and POV
 N POV,TDATA,VDGX
 D ENCEVENT^PXKENC(VISIT)
 S POV=""
 F  S POV=$O(^TMP("PXKENC",$J,VISIT,"POV",POV)) Q:POV=""  D
 . S ODATA=$G(^TMP("PXKENC",$J,VISIT,"POV",POV,0)),VDGX=$P(ODATA,U,1)
 . Q:'$D(ORAR(DFN,"DGX",VDGX))
 . S ORAR1(VISIT,ORTST,POV)=VDGX
 Q
 ;
ERRMSG(VISIT) ; Error handling and message
 ; to be determined
 Q
