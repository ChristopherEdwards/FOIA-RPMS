BKUCW2KV ;TASSC/MFD set variables for Cache Win2k backup [ 11/17/2002  9:07 PM ]
 ;;1.59;W2KCABACKUP;;
VARS ; 
 ;***** HOST OS PATH SECTION ********
 ;This is a freeze only version.
 ;NOTE the Cache install directory should be added to the system PATH
 ;***** PATH SECTION ********
 ;Define which paths contain database volumes in an array and your
 ;Journal directory
 S BKUPATH(0)="D:\Cache\TRG"   
 S BKUPATH(1)="D:\JRN"
 S BKUPATH(2)="D:\cachesys"
 S BKUPATH(3)="D:\Cache\CAL"
 S BKUPATH(4)="D:\Cache\TST"
 ;Define where you are copying to-array subscripts must match BKUPATH
 ;AND the "to" folders must already exist!
 S CPTODIR(0)="D:\cachebackup\TRG"
 S CPTODIR(1)="D:\jrnbackup"
 S CPTODIR(2)="D:\cachesysbackup"
 S CPTODIR(3)="D:\cachebackup\CAL"
 S CPTODIR(4)="D:\cachebackup\TST"
 ;
 S (BKUPDRV,I)="" F  S I=$O(CPTODIR(I)) Q:I=""  S BKUPDRV=BKUPDRV_CPTODIR(I)_" "
 ;Default is to backup what is in CPTODIR but you can backup entire
 ;drives by uncommenting and editing one of the lines below
 ;S BKUPDRV="C:\"
 ;S BKUPDRV="D:\"  ;to get entire C, E, F, D, and G drives- except for files inuse
 ;
 ;****** MISCELLANEOUS ******
 S SENDTOID=""     ;to ftp the results file
 S MAILTOID="HELPDESK@DOMAIN.NAME"     ;email results file
 S MAILFROMID="HELPDESK@DOMAIN.NAME"    ;address email is from- must be defined
 S MAILTOID="@c:\winnt\wsendmaillist.txt"   ;email results file to a list
 ;S PREVKILL="yes" D NOKILL ;prevent kill of glbs; Don't uncomment, doesn't work with Cache
 ;S NOVAL=1       ;uncomment to skip Validate- NOT RECOMMENDED!
 S NOSSD=1        ;to avoid SSD on error- FOR TESTING ONLY!
 ;S BKUHANG=300    ;uncomment to extend buffer flush hang, 60 is dflt
 ;
 ;S BKURTIME=2100    ; 9pm, set to military run time for Shadow server and no Taskman
 S BKUSITE="Phoenix Training System"      ; set to site name for addition to mail message subject
 ;
 ;The variable values below are standard and should not be changed
 S CDIR=$P($ZU(131,1),",",2),CDIR=$P(CDIR,"\mgr")
 S HOSTNAME="%COMPUTERNAME%"
 S:'$D(BKUSITE) BKUSITE=HOSTNAME
 S SENDFILE=CDIR_"\backup_cawin."_HOSTNAME
 S VALFILE=CDIR_"\backup_cawin.RESULTS"
 S INTFILE=CDIR_"\backup_cawin.INTEGRIT"     ; this is appended to Results file if an error
 S INTEGAPP=""      ;uncomment to get Integr check result appended to Results file every run
 S CUMFILE=CDIR_"\backup_cawin.CUM"
 S TMPCUM=CUMFILE_".tmp"
 ;S TRSHOOT="yes"   ;do not use, for test purposes only
 ;
 ;****** TAPE BACKUP SECTION ******
 ;S NOTAPE=1  ;uncomment to skip tape backup and do disk-to-disk only
 S TAPEDRV="""DLT""" D TLIB         ;set your tape drive type, e.g. DLT, 4mm, LTO Ultrium
 ;S TAPEDRV="""4mm DDS""" D TLIB         ;set your tape drive type, e.g. DLT, 4mm
 ;Define Windows-level tape backup command
 S TVERIFY="yes"  ;change to no to skip tape verify-NOT RECOMMENDED!
 S TBKUPCMD="ntbackup backup systemstate"    ;get system state (registry) also
 ;S TBKUPCMD="ntbackup backup"   ;don't backup system state (registry)
 S TBKUPJOB="""RPMS Backup on "_$ZD($P($H,","),5)_" at "_$H_""""
 S TBKUPOPT="/N "_TBKUPJOB_" /d """_$G(BKUPDRV)_" plus System State"" /v:yes /r:no /rs:no /hc:on /m normal /l:s /p "_TAPEDRV_" /um"
 S:TVERIFY="no" TBKUPOPT="/N "_TBKUPJOB_" /d """_$G(BKUPDRV)_"plus System State"" /v:no /r:no /rs:no /hc:on /m normal /l:s /p "_TAPEDRV_" /um"
 ;
 ;
 ;***** DEL/COPY SECTION ******
 ;Set Delete cmd to use
 S DELCMD="del /q /s "
 S DELCMDOP="\*.*"
 ;Set Copy cmd to use- 
 ;found xcopy to be slightly faster than copy
 ;and scopy won't copy an open file
 S NTCPCMD="xcopy"
 S NTCPOPT="/s /e /f"  ;xcopy options-copy any subdirs and data in them
 ;
 ;****** CACHE VARS SECTION ******
 D RPATH    ; add %SYS to routine search path
 S SYS=$ZU(110)
 S USR=$ZU(67,11,$J)
 ;
 K I Q     ;the end
 ;
 ;
TLIB ;get tape library name
 ;required to run rsm refresh command to activate a changed tape
 N X,Y S Y="tapelib.txt"
 S X=$ZF(-1,"rsm view /tlibrary|qgrep Drive >"_CDIR_"\tapelib.txt")
 O CDIR_"\"_Y:"R"
 U CDIR_"\"_Y R TAPELIB
 C CDIR_"\"_Y K X
 S TAPELIB=""_TAPELIB_""
 S TAPEREF="start /wait rsm.exe refresh /lf"""_TAPELIB_""""
 S X=$$DEL^%ZISH(CDIR,Y)
 Q
 ;
RPATH ; set the Namespace path to include %SYS
 S BKUNSP=$ZU(20,$ZU(20),"%SYS")   ;set routine search path to include %SYS
 Q
 ;
NOPATH ; set path back to just IHS or PRD
 S BKUNSP=$ZU(20,BKUNSP)
 Q
 ;
 ;
 ; Subs below not currently used for Cache backups
 ; Currently when a user logs in, a switch is set to disallow top level kills
 ; in LOGIN^%ZSTART, to allow kill for the process so I $ZU(68,28,0)
 ;
NOKILL ; set ^BKUVARS to prevent global kills
 K ^BKUVARS("PREVENTKILL"),^("ALLOWKILL")
 N BKUGL,BKUPROD
 S BKUPROD=^%ZOSF("PROD")
 S ^BKUVARS("PREVENTKILL")="PREVKILL=""yes""" D BKUGBL
 Q
BKUGBL ; set ^BKUVARS to allow kill of globals listed in GBLS
 N BKUI,BKUX,BKUGLB
 F BKUI=1:1 S BKUX=$T(GLBS+BKUI) Q:$E(BKUX)'=" "  S BKUGLB=$P(BKUX,";;",2) D 
 .I BKUGLB'["[" S BKUGLB="["""_^%ZOSF("PROD")_"""]"_BKUGLB
 .S BKUGLB="^"_BKUGLB
 .I $D(BKUGLB) S ^BKUVARS("ALLOWKILL",$P(BKUGLB,"^",2))=""
 Q
GLBS ;
 ;;ACHSPCC
 ;;ACHSBCBS
 ;;ACHSAOPD
 ;;ACHSAOVU
 ;;ACHSZOCT
 ;;ACHSPIG
 ;;ACHSSVR
 ;;ACHSEOBR
 ;;ACHSLOG
 ;;ACHSDATA
 ;;ACHSTXPT
 ;;ACHSTXVN
 ;;ACHSTXOB
 ;;ACHSTXPD
 ;;ACHSTXPG
 ;;ACHSUSE
 ;;BWOLD
 ;;AFSHCANP
 ;;AFSHCANR
 ;;AFSLARCX
 ;;AFSLEMSG
 ;;AFSLJCL
 ;;AFSLMSGX
 ;;AFSLODOC
 ;;AFSLREJT
 ;;AFSLTDOC
 ;;AFSLTPF
 ;;AFSLZEIN
 ;;AFSLZUM1
 ;;AFSLZUM2
 ;;AFSLVNDR
 ;;AFSNEXE
 ;;AFSNRCDS
 ;;AFSPRPTQ
 ;;AQAJEXP
 ;;AQAQX
 ;;AQAQP
 ;;AQAOX
 ;;AQAOXX
 ;;ADGX
 ;;AGTXER
 ;;AGCHDFN
 ;;HEPDL
 ;;FREEZE
