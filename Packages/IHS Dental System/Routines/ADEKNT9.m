ADEKNT9 ; IHS/HQT/MJL - COMPILE DENTAL REPORTS ;  [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;;APRIL 1999
 ;
 ;This routine contains code for procedures which the IHS Dental Program
 ;decided should not be included in the reports package.
 ;However, since the Dental Program has changed its mind several
 ;times regarding what it wants on these reports, I want to
 ;keep this code intact.  They may want to use it later.
 ;
EMER(ADELIM) ;EP
 ;PATIENTS WITH EMERGENCY EXAM THIS QUARTER
 ;BUT NO ROUTINE EXAM PAST 12 MONTHS
 ;QUIT IF NO EMERGENCY DURING CURRENT QUARTER
 ;NOT CALLED NOW, BUT KEEP CODE
 I ADELIM Q:'(ADELIM=ADEIND)
 N ADEQBD1,ADE1BD1
 S ADEQBD1=ADEQBD-.0001
 S ADE1BD1=ADE1BD-.0001
 Q:'$D(ADEHXC("0130"))
 Q:'$O(ADEHXC("0130",ADEQBD1))
 Q:$O(ADEHXC("0130",ADEQBD1))>ADEED
 I $O(ADEHXC("0110",ADE1BD1)) Q:$O(ADEHXC("0110",ADE1BD1))<ADEED
 I $O(ADEHXC("0120",ADE1BD1)) Q:$O(ADEHXC("0120",ADE1BD1))<ADEED
 I $O(ADEHXC("0150",ADE1BD1)) Q:$O(ADEHXC("0150",ADE1BD1))<ADEED
 I $O(ADEHXC("0160",ADE1BD1)) Q:$O(ADEHXC("0160",ADE1BD1))<ADEED
 S $P(^TMP($J,"CTR",ADEIEN,ADEOBJ(ADEIEN)),U,1)=$P(^TMP($J,"CTR",ADEIEN,ADEOBJ(ADEIEN)),U,1)+1
 Q
 ;
PTC(ADELIM) ;EP
 ;Patients receiving PTC this quarter but no PTC in past
 ;12 months
 ;NOT CALLED NOW, BUT KEEP CODE
 I ADELIM Q:'(ADELIM=ADEIND)
 N ADEQBD1,ADE1BD1,ADEPTC
 S ADEQBD1=ADEQBD-.0001
 S ADE1BD1=ADE1BD-.0001
 Q:'$D(ADEHXC("9990"))  ;no ptc at all
 Q:'$D(ADEHXC("9990",ADEQBD1))  ;No ptc this qtr
 Q:$O(ADEHXC("9990",ADEQBD1))>ADEED  ;ptc was after end date
 S ADEPTC=$O(ADEHXC("9990",ADEQBD1)) ;ADEPTC is date of
 ;the first ptc this quarter
 Q:$O(ADEHXC("9990",ADEPTC,-1))>ADE1BD1  ;previous ptc<1 yr ago
 ;Increment - this measure only valid for current quarter
 S $P(^TMP($J,"CTR",ADEIEN,ADEOBJ(ADEIEN)),U,1)=$P(^TMP($J,"CTR",ADEIEN,ADEOBJ(ADEIEN)),U,1)+1
 ;S $P(^TMP($J,"CTR",ADEIEN,ADEOBJ(ADEIEN)),U,2,3)=0
 Q
