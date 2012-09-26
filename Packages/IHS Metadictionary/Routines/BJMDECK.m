BJMDECK ;VNGT/HS/AM-Pre Install ENVIRONMENT CHECK; 18 Nov 2009  12:51 PM
 ;;1.0;CDA/C32;**1**;May 27, 2011
 ;
 ; Run pre-install checks
 ;W !,"Build Name XPDNM = ",XPDNM
 N EXEC,ROLES,FAC,STAT,NS,OBJ,C32DEST,DEFDEST,EDEST,DIR,METMS,METCS
 N METFS,METDFS,LIST,MET,TSC,DEFEDEST,OK,FS,ES,VERSION,CMSG,CMSGLN
 ;
 ; Verify that the BFMC job finished and did not error out.
 S CMSG=$O(^BJMDS(90607,"B","C32",""))
 I CMSG="" S CMSG=1
 ; Check if the BFMC job errored out. If it errored out and we're trying to install BJMD, quit.
 I $O(^BJMDS(90607,CMSG,2,0))'="" D  S XPDQUIT=2 Q:XPDENV
 . W !,"Cannot load the C Messaging (BJMD) software because the BFMC post-installation",!,"job terminated with the following error:"
 . S CMSGLN=0 F  S CMSGLN=$O(^BJMDS(90607,CMSG,2,CMSGLN)) Q:'CMSGLN  W !,$G(^BJMDS(90607,CMSG,2,CMSGLN,0))
 . W !!,"Please contact support before proceeding."
 ; Check if the BFMC job is still running. If it is still running and we're trying to install BJMD, quit.
 ; To avoid confusing the user, don't display this message if the BFMC job got an error.
 E  I '$P($G(^BJMDS(90607,CMSG,0)),U,10) W !,"Cannot load the C Messaging (BJMD) software until the BFMC post-installation",!,"job has finished running. Please try later." S XPDQUIT=2 I XPDENV Q
 ;
 ; Verify Version
 ;
 S VERSION=$$VERSION^%ZOSV
 I VERSION<2009!($E(VERSION,1,4)>2010)!(VERSION?1"2010.1.".E) D
 . W !,"Ensemble 2009.1 or 2010.2 is required!"
 . S XPDQUIT=2
 ;
 ; Verify that installer has proper roles
 ;
 S EXEC="S ROLES=$roles" X EXEC
 S ROLES=","_ROLES_",",U="^"
 I ROLES'[",%All," D
 . W !,"Your Ensemble account MUST have ""%All"" role to proceed!" S XPDQUIT=2
 ;
 ; Verify that station numbers are assigned
 ;
 S FAC=0
 F  D  Q:'FAC
 . S FAC=$O(^AGFAC(FAC)) Q:'FAC
 . I $P($G(^AGFAC(FAC,0)),U,21)'="Y" Q
 . S STAT=$P($G(^DIC(4,FAC,99)),U)
 . I STAT="" W !,"Station Number is not assigned for Facility ",FAC," ",$P($G(^DIC(4,FAC,0)),U) S XPDQUIT=2 Q
 . I STAT<8000!(STAT>9000) W !,"Station Number ",STAT," is not in the 8000-9000 range for Facility ",FAC," ",$P($G(^DIC(4,FAC,0)),U) S XPDQUIT=2
 ; 
 ; Verify the presence of two packages
 ;
 I '$D(^DD(52.0113)) W !,"The package that added Medication Instructions to Prescriptions" W !,"file is not installed" S XPDQUIT=2
 I '$D(^DD(50,9999999.145)) W !,"The package that added DISPENSE UNIT NCPDP CODE field to Drug" W !,"file is not installed" S XPDQUIT=2
 ;
 ; Check LIST of all namespaces for C32 partner for current namespace.  
 ;
 K LIST
 S EXEC="S NS=$SYSTEM.SYS.NameSpace()" X EXEC
 S EXEC="SET OBJ=##class(%ResultSet).%New(""%SYS.Namespace:List"") d OBJ.Execute()" X EXEC
 S EXEC="while (OBJ.Next()) { s LIST(OBJ.Data(""Nsp""))=1 }" X EXEC
 ;
 ; %Installer Change
 ; 
 I '$D(LIST("C32"_NS)),XPDENV=1 D  I $G(XPDQUIT) S EXEC="S:$G(MET)'="""" TSC=MET.Shutdown()" X EXEC G Q
 . K ARG
 . S ARG("NAMESPACE")=NS
 . S EXEC="S DIR=##class(%SYS.Namespace).GetGlobalDest(NS),DIR=$P(DIR,""^"",2,99)" X EXEC
 . S EXEC="Set MET=##class(%Monitor.System.Freespace).%New()" X EXEC
 . S EXEC="S TSC=MET.Initialize()" X EXEC
 . I $G(TSC)'=1 W !,"Space check monitor failed to initialize" S XPDQUIT=2 Q
 . S DBNAME=""
 . S EXEC="F  S TSC=MET.GetSample() Q:'TSC  I MET.Directory=DIR S DBNAME=MET.DBName" X EXEC
 . S EXEC="S TSC=MET.Shutdown()" X EXEC
 . K MET
 . I DBNAME="" W !,"Space check monitor failed to find Database" S XPDQUIT=2 Q
 . S ARG("DATABASE")=DBNAME
 . K DIR S DIR("A")="Specify Full Directory path for the database for new namespace C32"_NS,DIR(0)="F^1:200"
 . D ^DIR
 . I Y="^"!(Y="^^") S XPDQUIT=2 Q
 . S DIR=Y
 . S EXEC="S DIREX=##class(%File).DirectoryExists(DIR)" X EXEC
 . I 'DIREX S EXEC="S TSC=##class(%File).CreateDirectoryChain(DIR)" X EXEC I TSC'=1 W !,"Directory Creation Failed" S XPDQUIT=2 Q
 . I DIREX D  Q:$G(XPDQUIT)
 . . N DIR1,DELIM,FN,FILE
 . . S DIR1=DIR,DELIM=$S($$VERSION^%ZOSV(1)["Windows":"\",1:"/") I $E(DIR1,$L(DIR1))'=DELIM S DIR1=DIR1_DELIM
 . . S EXEC="S FILE=##class(%File).%New("""_DIR1_$J_""")" X EXEC
 . . S EXEC="S TSC=FILE.Open(""RWN"")" X EXEC
 . . I TSC'=1 W !,"Unable to write to directory" S XPDQUIT=2 Q
 . . S EXEC="S TSC=FILE.Write($ZH)" X EXEC
 . . S EXEC="S FN=FILE.Name D FILE.Close()" X EXEC
 . . I TSC'=1 W !,"Unable to write to file in directory" S XPDQUIT=2 Q
 . . S EXEC="S TSC=##class(%File).Delete(FN)" X EXEC
 . S EXEC="S TSC=##class(%File).GetDirectorySpace(DIR,.DIRFS)" X EXEC
 . I TSC'=1 W !,"Invalid Directory" S XPDQUIT=2 Q
 . I DIRFS<500 W !,"Not Enough Disk Space" S XPDQUIT=2 Q
 . S EXEC="S CONFILE=$P($ZU(86),""*"")" X EXEC
 . S EXEC="S FOK=0 O CONFILE:(""W""):1 I  S FOK=1" X EXEC
 . S EXEC="C CONFILE" X EXEC
 . I '$G(FOK) W !,"Unable to obtain permission to modify the Ensemble configuration file:",!,CONFILE S XPDQUIT=2 Q
 . S ARG("DB_LOCATION")=DIR
 . W !,"Creating C32",NS," namespace",!,!
 . S EXEC="S TSC=##class(BFMC.BJMD.Installer).setup(.ARG,1)" X EXEC
 . I 'TSC W !,"Error in Installer process" S XPDQUIT=2 Q
 . ; re-read the list of namespaces
 . K LIST
 . S EXEC="SET OBJ=##class(%ResultSet).%New(""%SYS.Namespace:List"") d OBJ.Execute()" X EXEC
 . S EXEC="while (OBJ.Next()) { s LIST(OBJ.Data(""Nsp""))=1 }" X EXEC
 ;
 ; Verify that installation has Long Strings enabled
 ;
 S EXEC="S OK=($SYSTEM.SYS.MaxLocalLength()>3600000)"
 X EXEC
 I 'OK D  S XPDQUIT=2
 . W !,"Long Strings are not enabled, Ensemble is not configured correctly."
 I XPDENV=1 D
 . I '$D(LIST("C32"_NS)) W !,"C32 Namespace does not exist" S XPDQUIT=2
 . ;
 . ; Check that C32 namespace has globals mapped properly
 . ;
 . S EXEC="S DEFDEST=##class(%SYS.Namespace).GetGlobalDest()" X EXEC
 . S EXEC="S C32DEST=##class(%SYS.Namespace).GetGlobalDest(""C32""_NS,""^BJMDS"")" X EXEC
 . I DEFDEST'=C32DEST W !,"Global mapping for ^BJMDS is not correct" S XPDQUIT=2
 . ;
 . ; Check that Ensemble globals are mapped to the default namespace of ENSLIB
 . ;
 . S EXEC="S DEFEDEST=##class(%SYS.Namespace).GetGlobalDest(""ENSLIB"")" X EXEC
 . S EXEC="S EDEST=##class(%SYS.Namespace).GetGlobalDest(NS,""^EnsDICOM.Dictionary"")" X EXEC
 . I EDEST'=DEFEDEST W !,"Ensemble is not properly mapped in ",NS S XPDQUIT=2
Q ;
 I $G(MET)'="" S EXEC="S TSC=MET.Shutdown()" X EXEC
 Q
DTCK(DT) ;
 S %DT="FT",X=DT
 D ^%DT
 I Y=-1 Q 0
 S ZTDTH=Y
 Q 1
SPACE(NS) ;
 ; check if enough space 
 ;
 N FS,PATFS,PATCT,NS,EXEC,DIR,TSC,METMS,METSC,METFS,METDS,FS,ES,PATCT,PATFS
 S FS=0,PATFS=0,PATCT=0
 I $G(NS)="" S EXEC="S NS=$SYSTEM.SYS.NameSpace()" X EXEC
 I NS'?1"C32".E S NS="C32"_NS
 S EXEC="S DIR=##class(%SYS.Namespace).GetGlobalDest(NS),DIR=$P(DIR,""^"",2,99)" X EXEC
 ; set up monitor
 S EXEC="Set MET=##class(%Monitor.System.Freespace).%New()" X EXEC
 S EXEC="S TSC=MET.Initialize()" X EXEC
 I $G(TSC)'=1 W !,"Space check monitor failed to initialize" G QS
 SET METMS=0,METCS=0,METFS=0,METDFS=0,METDS=0
 S EXEC="F  S TSC=MET.GetSample() Q:'TSC  I MET.Directory=DIR S METMS=MET.MaxSize,METCS=MET.CurSize,METFS=MET.FreeSpace,METDS=MET.DiskFreeSpace" X EXEC
 I METCS=0 W !,"Space check monitor failed to find Cache Namespace with directory ",DIR G QS
 ; if unlimited cache.dat, then expansion space is FreeDiskSpace
 I METMS=-1 S ES=METDS
 ; if limited cache.dat, then ExpansionSpace is smaller of FreeDiskSpace and (MaxSpace-CurrentSpace)
 I METMS'=-1 S ES=METMS-METCS S:METDS<ES ES=METDS
 ; then limit is Expansion Space+FreeSpaceInCurrentFile
 S FS=ES+METFS
 S PATCT=$P(^AUPNPAT(0),U,3) I PATCT=0 G QS
 S PATFS=FS/PATCT
QS ;
 S EXEC="S TSC=MET.Shutdown()" X EXEC
 K MET
 ; return space per person (in K), total space (in K), patient count, 
 ; current used space, current free space in database, maximum space, and disk space
 Q (PATFS*1024)_U_(FS*1024)_U_PATCT_U_(METCS*1024)_U_(METFS*1024)_U_(METMS*1024)_U_(METDS*1024)
