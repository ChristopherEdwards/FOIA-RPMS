PXRMRPCC ;SLC/PJH - PXRM REMINDER DIALOG ;04/12/2002
 ;;1.5;CLINICAL REMINDERS;**2,7,10**;Jun 19, 2000
 ;
ACTIVE(ORY,ORREM) ;Check if active dialog exist for reminders
 ;
 ; input parameter ORREM is array of reminder ien [.01#811.9]
 N DDIS,DIEN,OCNT,RIEN,RSTA
 S OCNT=0,RIEN=0
 ;Get reminder ien from array
 F  S RIEN=$O(ORREM(RIEN)) Q:'RIEN  D
 .;Dialog ien for reminder
 .S DIEN=$P($G(^PXD(811.9,RIEN,51)),U),RSTA=0
 .;Dialog status
 .I DIEN S DDIS=$P($G(^PXRMD(801.41,DIEN,0)),U,3)
 .;If dialog and dialog not disabled
 .I DIEN,DDIS="" S RSTA=1
 .;Return reminder and if active dialog exists
 .S OCNT=OCNT+1,ORY(OCNT)=RIEN_U_RSTA
 Q
 ;
 ;
DIALOG(ORY,ORREM) ;Load reminder dialog associated with the reminder
 ;
 ; input parameter ORREM - reminder ien [.01,#811.9]
 ;
 N DATA,DIEN
 S DIEN=$G(^PXD(811.9,ORREM,51))
 ;
 ;Quit if no dialog for this reminder
 I 'DIEN S ORY(1)="-1^no dialog for this reminder" Q
 ;
 ;Check if a reminder dialog and enabled
 S DATA=$G(^PXRMD(801.41,DIEN,0))
 ;
 I $P(DATA,U,4)'="R" S ORY(1)="-1^reminder dialog invalid" Q
 ;
 I $P(DATA,U,3) S ORY(1)="-1^reminder dialog disabled" Q
 ;
 ;Load dialog lines into local array
 D LOAD^PXRMDLL(DIEN)
 Q
 ;
HDR(ORY,ORLOC) ;Progress Note Header by location/service/user
 N ORSRV,PASS
 S ORSRV=$G(^VA(200,DUZ,5)) I +ORSRV>0 S ORSRV=$P(ORSRV,U)
 S PASS=DUZ_";VA(200,"
 I +$G(ORLOC) S PASS=PASS_"^LOC.`"_ORLOC
 I ORSRV S PASS=PASS_"^SRV.`"_+$G(ORSRV)
 S ORY=$$GET^XPAR(PASS_"^DIV^SYS^PKG","PXRM PROGRESS NOTE HEADERS",1,"Q")
 Q
 ;
PROMPT(ORY,ORDLG,ORDCUR,ORFTYP) ;Load additional prompts for a dialog element
 ;
 ; input parameters
 ;
 ; ORDLG  - dialog element ien [.01,#801.41]
 ; ORDCUR - 0 = current, 1 = Historical for taxonomies only
 ; ORFTYP - finding type (CPT/POV) for taxonomies only
 ;
 ; These fields can be found in the output array of DIALOG^PXRMRPCC
 ;
 D LOAD^PXRMDLLA(ORDLG,ORDCUR,$G(ORFTYP))
 Q
 ;
RES(ORY,ORREM) ; Reminder Resources/Inquiry
 ;
 ; input parameter ORREM - reminder ien [.01,#811.9]
 ;
 D REMVAR^PXRMINQ(.ORY,ORREM)
 Q
 ;
MH(ORY,OTEST) ; Mental Health dialog
 ;
 ; Input mental health instrument NAME
 ;
 N YS,ARRAY S YS("CODE")=OTEST D SHOWALL^YTAPI3(.ARRAY,.YS) ; DBIA 2895
 ;
 N FNODE,FSUB,IC,NODE,OCNT,SUB
 S SUB="ARRAY",OCNT=0
 F  S SUB=$Q(@SUB) Q:SUB=""  D
 .S FSUB=$P($P(SUB,"(",2),")"),FNODE=""
 .F IC=1:1 S NODE=$P(FSUB,",",IC) Q:NODE=""  D
 ..I $E(NODE)="""" S NODE=$P(NODE,"""",2)
 ..S $P(FNODE,";",IC)=NODE
 .Q:FNODE=""
 .S OCNT=OCNT+1,ORY(OCNT)=FNODE_U_@SUB
 Q
 ;
MHR(ORY,RESULT,ORES) ; Mental Health score and P/N text
 ;
 ; Input MH result IEN and mental health instrument response
 ;
 D ^PXRMDLR
 ;
 Q
 ;
MHS(ORY,YS) ; Mental Health save response
 ;
 ; Input mental health instrument response
 N ARRAY
 D SAVEIT^YTAPI1(.ARRAY,.YS) ; DBIA 2893
 I ARRAY(1)'="[DATA]" S ORY(1)="-1^"_ARRAY(1)_ARRAY(2)
 I ARRAY(1)="[DATA]" S ORY(1)=ARRAY(1)_ARRAY(2)
 Q
 ;
MST(ORY,DFN,DGMSTDT,DGMSTSC,DGMSTPR,FTYP,FIEN,RESULT) ; File MST status
 ;This is obsolete and can be removed when the GUI is changed not
 ;to use it.
 Q
 ;
