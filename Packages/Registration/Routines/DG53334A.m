DG53334A ;ALB/MRY - ALS EXTRACT; ; 11/16/00 1:15pm
 ;;5.3;Registration;**334**;Aug 13, 1993
 ;
 ;Description:
 ;Patient data will be extracted from the Patient file (#2) for all 
 ;hospital sites.  Station numbers and SSN's have been provided and 
 ;stored in file^XTMP.
 ;
 ;
EN ; -- Entry point for manually running extract.
 D EN^DG53334D
 Q
 ;
 ;
START ; -- Called from POSTINST^DG53334C and EN^DG53334D
 I $D(DUZ)'=11 D  Q
 . D BMES^XPDUTL("     Please set DUZ variables.")
 . S DGARY(1)=("     To set up the DUZ variables, type the command D ^XUP.")
 . S DGARY(2)=("     At prompt Select OPTION NAME: press the return key.")
 . S DGARY(3)=("     To restart the ALS Extract type D EN^DG53334A.")
 . D MES^XPDUTL(.DGARY)
 ;
 D BMES^XPDUTL()
 S DGARY(1)=("                 >>> ALS Extract <<< ")
 S DGARY(2)=("   This extract will generate 2 mail messages to you.")
 S DGARY(3)=("   One of the messsages will contain the data extracted")
 S DGARY(4)=("   and the second message will contain any errors that")
 S DGARY(5)=("   may have occurred during the ALS extract.")
 D MES^XPDUTL(.DGARY)
 ;
 N DGARY
 S DGTATION=+$P($$SITE^VASITE(),U,3)
 S DGSTART=$$FMTE^XLFDT($$NOW^XLFDT)
 I '$D(^XTMP("DGALS","S",DGTATION))!$D(^XTMP("DGALS","S",DGTATION,"ERROR","NO DATA REQUESTED")) D  Q
 . D BMES^XPDUTL("  ")
 . S DGARY(1)=("  Data was not requested from this site.")
 . S DGARY(2)=("  No mail messages will be generated.")
 . S DGARY(3)=("  No error has occurred.")
 . D MES^XPDUTL(.DGARY)
 . D BMES^XPDUTL(">>>...all done.")
 . D FMAIL^DG53334B(0)
 ;
 ;
 K ^XTMP("DGALS",$J,"DATA")
 K ^XTMP("DGALS",$J,"ERROR")
 K ^XTMP("DGALS","S",DGTATION,"DFN")
 ;
 I '$D(ZTQUEUED) D
 .D BMES^XPDUTL(">>> Looking up patients DFNs from SSNs <<<")
 D GETDFN(DGTATION)
 ;
 I '$D(ZTQUEUED) D
 .D BMES^XPDUTL(">>> Looking up patients data from DFNs <<<")
 D DIQLOOK(DGTATION)
 ;
 I '$D(ZTQUEUED) D
 .D BMES^XPDUTL(">>> Creating Mail message of patients data <<<")
 D SENDATA(DGTATION)
 ;
 ;mail summary
 D FMAIL^DG53334B(1)
 ;
 I '$D(ZTQUEUED) D
 .D BMES^XPDUTL(">>> ....ALS Extract has completed")
 ;
 ;
 K DGFIELD,DGN,DGP,DGPECE,DGSTART
 K DGZ,DGFLDS,DGDFN,DGTATION,DGSSN,DGLINE
 Q
GETDFN(DGTATION) ;
 ;From array of SSNs get DFN's from DPT
 ; go down station array
 S DGSSN=0
 F  S DGSSN=$O(^XTMP("DGALS","S",DGTATION,DGSSN)) Q:'DGSSN  DO
 . S DGDFN=$$DFN(DGSSN)
 . I DGDFN S ^XTMP("DGALS","S",DGTATION,"DFN",DGDFN)=DGSSN
 . E  S ^XTMP("DGALS",$J,"ERROR","SSN",DGSSN)=DGDFN
 .;
 . I (($P($H,",",2))#20) Q
 . I '$D(ZTQUEUED) W "."
 Q
DIQLOOK(DGTATION) ;
 ;
 ; get array of fields to lookup
 D INIFLDS
 ; for each dfn call gets^diq
 S DGDFN=0
 F  S DGDFN=$O(^XTMP("DGALS","S",DGTATION,"DFN",DGDFN)) Q:'DGDFN  DO
 . D GETDGIQ(DGDFN)
 .;
 . I (($P($H,",",2))#3) Q
 . I '$D(ZTQUEUED) W "."
 .;
 Q
GETDGIQ(DGDFN) ;
 K DGDATA,DGERR
 ;
 F DGFLDS=1:1:2 D
 . D GETS^DIQ(2,DGDFN,DGFLDS(DGFLDS),"E","DGDATA","DGERR")
 .;
 .; merge will set ,2,dfn_",",field,"E")=external value
 .;
 . M ^XTMP("DGALS",$J,"DATA")=DGDATA
 . K DGDATA
 . I $D(DGERR) D  K DGERR
 . .;if a field has err whatodo
 . .;
 . .; check to see if each field was set in returned array 
 . . F DGP=1:1 S DGFIELD=$P(DGFLDS(DGFLDS),";",DGP) Q:'DGFIELD  D
 . . .;
 . . .;  indicates fileman returned error
 . . . I '$D(^XTMP("DGALS",$J,"DATA",2,DGDFN_",",DGFIELD,"E")) D
 . . . .;
 . . . .; set it to null to keep the piece position in mail
 . . . . S ^XTMP("DGALS",$J,"DATA",2,DGDFN_",",DGFIELD,"E")=""
 . . . .;
 . . . .;the dgerr array is set by fm in order of missing fields
 . . . . S DGERR=$O(DGERR("DIERR",0)) I 'DGERR K DGERR Q
 . . . . M ^XTMP("DGALS",$J,"ERROR",DGDFN,DGFIELD)=DGERR("DIERR",DGERR)
 . . . . S ^XTMP("DGALS",$J,"ERROR",DGDFN,"SSN")=$P($G(^DPT(DGDFN,0)),"^",9)
 . . . .;pop the array
 . . . . K DGERR("DIERR",DGERR)
 . . .;
 ;
 Q
DFN(SSN) ;function to lookup DFN from SSN x-ref
 ; input SSN
 ; output DFN or error code
 N DFN
 ; make sure dfn is numeric and not null
 I $O(^DPT("SSN",SSN,0))
 E  Q "No SSN Index for "_SSN
 ;
 I $O(^DPT("SSN",SSN,0))=$O(^DPT("SSN",SSN,""),-1)
 E  Q "Duplicate SSN in cross-ref "_SSN
 ;
 S DFN=$O(^DPT("SSN",SSN,0))
 ;
 I $G(^DPT(DFN,0))]""
 E  Q "No Zero node in DPT for SSN "_SSN
 ;
 I $P($G(^DPT(DFN,0)),"^",9)=SSN
 E  Q "Bad SSN cross-ref "_SSN
 Q DFN
 ;
INIFLDS ; set up array of fields to be used in fm getsdiq call
 S DGFLDS(1)=$P($T(FLDS1),";;",2)
 S DGFLDS(2)=$P($T(FLDS2),";;",2)
 Q
 ;Retrieve:
 ;         Name, Provider,Street Address [Line 1], Zip+4,
 ;         Street Address [Line 2]
 ;         Street Address [Line 3],City, State, Zip Code County,
 ;         Temporary Address Active?,Temporary Street [Line 1],
 ;         Temporary Address County, Temporary Zip+4,
 ;         Temporary Street [Line 2], Temporary Street Address [Line 3], Temporary
 ;         City, Temporary State, Temporary Zip Code, Temporary Address Start Date,
 ;         Temporary Address End Date, Phone Number [Residence], Phone Number [Work]
FLDS1 ;;.01;.104;.111;.1112;.112;.113;.114;.115;.116;.117;.12105;.1211;.12111;.12112;.1212;.1213
FLDS2 ;;.1214;.1215;.1216;.1217;.1218;.1219;.131;.132;
 Q
SENDATA(DGTATION) ;
 ; dgline is the message line
 S DGLINE=0
 S DGDFN=""
 ; (2,dfn, field  set up from fileman data merge, dfn is dfn_"," 
 F  S DGDFN=$O(^XTMP("DGALS",$J,"DATA",2,DGDFN)) Q:'DGDFN  DO 
 . D SETMAIL^DG53334B(DGTATION,DGDFN)
 .;
 . I (($P($H,",",2))#10) Q
 . I '$D(ZTQUEUED) W " ."
 .;
 ;final mailman set
 Q:'DGLINE
 D SMAIL^DG53334B(DGLINE)
 ;
 Q
