BDGPOST ; IHS/ANMC/LJF - PIMS POSTINIT ;  [ 04/09/2004  11:11 AM ]
 ;;5.3;PIMS;;APR 26, 2002
 ; post init code for ADT data
 ;
 NEW X
 S X(1)="IHS Postinit: Warning! These may take a long time to run."
 S X(2)="If this process should error out, it can be restarted AFTER"
 S X(3)="the cause of the error has been found and corrected.  At that"
 S X(4)="point, go into KIDS and select 'Installation...',then select"
 S X(5)="'Restart Install of Package(s)'."
 D MES^XPDUTL(.X)
 ;
 ;IHS/ITSC/WAR 8/20/03 - This next call was commented out because of too
 ;       many past entries. The entries are now created by the new rec.
 ; fire new cross-references
 ;D AIHSDAM^BSDPOST       ;set new AIHSDAM xref
 ;
 ; copy data to new parameter and table files
1 D PARAM^BSDPOST1,LOG(1)         ;copy scheduling parameters to new file
2 D CLINIC^BSDPOST,LOG(2)         ;copy clinic parameters to new file
3 D PCCLINK^BDGPOST1,LOG(3)       ;add PIMS to PCC Master Control file
4 D PARAM^BDGPOST1,LOG(4)         ;copy ADT parameters to new file
5 D WARD^BDGPOST2,LOG(5)          ;copy IHS ward items to new file
6 D TRSPEC^BDGPOST1,LOG(6)        ;new observation specialties
7 D CHRTDEF^BDGPOST1,LOG(7)       ;copy chart deficiencies to new file
8 D EVENT^BDGPOST2,LOG(8)         ;add non-PIMS items to event driver
9 D LETTER^BSDPOST,LOG(9)         ;add Appointment Slip letter
 ;
 ; copy patient data to new file structures
10 D EN^BDGPOST3,LOG(10)           ;build transfer facility file
11 D DGPM^BDGPOST2,LOG(11)         ;move fields in file 405
12 D SIDNR^BDGPOST2,LOG(12)        ;clean out old SI/DNR data
13 D SCHVST^BDGPOST2,LOG(13)       ;copy Scheduled Visit data to new file
14 D WAIT^BSDPOST1,LOG(14)         ;copy waiting list to new file
15 D IC^BDGPOST4,LOG(15)           ;copy data to new Incomplete Chart file
 ;
16 I '$D(^BDGX(16)),$G(^DG(43,1,9999999))]"" S $P(^(9999999),U)=0 D LOG(16)  ;stuff "track all patients in SPT" to NO
 ;
 ; clean up from last version
17 D OLDFILES^BDGPOST1,LOG(17)     ;change name of old files      
18 D ADTTMPL^BDGPOST1,LOG(18)      ;stuff 2 ADT Template entries      
19 D FACMOV^BDGPOST1,LOG(19)       ;add new fac mov type      
20 D MERG^BSDPOST,LOG(20)          ;change Scheduling Merge routine
 ;
 ; set up new functions
21 D PCMM^BSDPOST1,LOG(21)         ;set up server side files for PCMM
22 D POST^BSDLINK,LOG(22)          ;set Sched entry for PCC merges
 ;IHS/ITSC/WAR 8/20/03 added this next call per the EHR project needs         
23 D ASTOP^BSDPOST,LOG(23)         ;index existing recs for EHR visit History
 ;IHS/ITSC/LJF 10/10/2003 added call to VA pre-init for patch 526
24 D EN^DG53P526,LOG(24)           ;adds Resource & Device entries
 ;IHS/ITSC/WAR 10/17/03 added next two calls
25 D PKGFILE^BSDPOST,LOG(25)       ;update "SD" version in pkg file
26 D PKGFILE^BDGPOST1,LOG(26)      ;update "DG" version in pkg file
27 K ^DD(10,0,"SCR") D LOG(27)     ;remove file screen from Race file;IHS/ITSC/LJF 1/9/2004
28 D CANCEL^BSDPOST1,LOG(28)       ;inactivate SHERI cancellation reason;IHS/ITSC/LJF 4/9/2004
 Q
 ;
LOG(N) ; keep track of where post init is  
 ; Can use this info if restart is needed
 S ^BDGX(N)=$$NOW^XLFDT
 Q
 ;
RESTART ; if post init bombs, can be restarted here AFTER problem is fixed
 ; will start after last log entry
 I '$D(U) W !!,"Please set up your user variables!" Q
 S Y=$O(^BDGX(999),-1) I Y D @Y
 Q
