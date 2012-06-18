BPXRMRAD ; IHS/CIA/MGH - Use V Rad in reminder resolution. ;18-Jun-2007 09:53;MGH
 ;;1.5;CLINICAL REMINDERS;**1003,1004,1005**;Jun 18, 2000
 ;===================================================================
VRAD(DFN,PROC) ; EP  Find a patients RADIOLOGY in the V RAD file
 ;Check each procedure to see if it matches the procedure being
 ;search for.
 ;If it is a match, look it up in the RADPT file to see it it is already there
 ;If not, add it to the array to be used in the reminder
 ;The list is kept in
 ;^TMP($J,"RADPROC",RADPTIEN,RADPROC,ORDER)=DATE_U_STATUS_U_PROVIDER
 ;Patch 1005 added change to include procedures only in V RAD file
 ;===================================================================
 N ORDER,RADPROC,VRIEN,RADNUM,SEARCH,RPROC
 Q:'$D(^AUPNVRAD("AC",DFN))
 S (VRIEN,RADNUM)=0 F  S VRIEN=$O(^AUPNVRAD("AC",DFN,VRIEN)) Q:VRIEN=""  D
 .S RADPROC=$P($G(^AUPNVRAD(VRIEN,0)),U,1)
 .I RADPROC=PROC D
 ..S RADNUM=$$RAD(DFN,VRIEN,PROC)
 ..I RADNUM="" D STORE
 Q
RAD(DFN,VIEN,PROC) ;Search the Radiology file for this patient and the date time to see if this
 ;entry is already storedin the radiolog file. If its not there, this procedure will need to be
 ;added to the list for the reminder
 N EDATE,INDATE,CHECK,RADNUM
 S RADNUM=""
 S EDATE=$P($G(^AUPNVRAD(VIEN,12)),U,1)
 I EDATE'="" D
 .S INDATE="" S INDATE=$O(^RADPT(DFN,"DT","B",EDATE,INDATE)) Q:INDATE=""  D
 ..S RPROC=0  F  S RPROC=$O(^RADPT(DFN,"DT",INDATE,"P",RPROC)) Q:RPROC=""  D
 ...S CHECK=$P($G(^RADPT(DFN,"DT",INDATE,"P",RPROC,0)),U,2)
 ...I CHECK=PROC D              ;found the same procedure, check for PCC
 ....S TEMP=$G(^RADPT(DFN,"DT",INDATE,"P",RPROC,"PCC"))
 ....I $P(TEMP,U,2)=VIEN S RADNUM=VIEN
 Q RADNUM
STORE ;Store the needed data into XTMP for use in reminders
 N TEMP,TEMP1,TEMP2,ORDER,VIS,VDATE,STATUS,Y
 S TEMP=$G(^AUPNVRAD(VRIEN,0)),TEMP1=$G(^AUPNVRAD(VRIEN,11))
 S TEMP2=$G(^AUPNVRAD(VRIEN,12))
 I TEMP1'="" S ORDER="COMPLETE",STATUS="COMPLETE"
 I TEMP1="" S ORDER="IN PROGRESS",STATUS="IN PROGRESS"
 I $P(TEMP2,U,1)="" D
 .S VIS=$P($G(^AUPNVRAD(VRIEN,0)),U,3)
 .Q:VIS=""
 .S VDATE=$P($G(^AUPNVSIT(VIS,0)),U,1)
 .S Y=VDATE
 E  S Y=$P(TEMP2,U,1)
 S ^TMP($J,"RADPROC",DFN,RADPROC,ORDER)=Y_U_STATUS
 ;IHS/MSC/MGH Change added patch 1005
 S ^TMP($J,"RADPROC")="valid"
 Q
