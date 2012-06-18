AKUUCMD1 ;IHS/MFD  CALL UNIX COMMANDS, PART 2 [ 04/29/96  12:01 PM ]
 ;;1.61;UNIX/VA KERNEL SYS ADMIN;;JAN 16, 1990
 ; This routine contains multiple sub-routines called by options
 ; in the VA Kernel. This routine can only be used by MSM mumps
 ; version 2.1 or greater on an Altos 3068 or Altos 2000
 ;
LMUMPS ;list files in /usr/mumps
 W !! S X=$$TERMINAL^%HOSTCMD("ls -l /usr/mumps | more")
 R !,"< Press RETURN to continue >",Y:DTIME
 K X,Y Q
LTPFLP ;list files on tape or floppy
 W !! R "List files from Tape or Floppy? (T/F): ",AKUUTF:DTIME
 G:'$T!(U[AKUUTF) LTPFLP1 I AKUUTF["?"!(AKUUTF'="T"&(AKUUTF'="F")) W !!,*7,"Enter T to get a listing of files on cartridge tape or ",!,"Enter F to get list from floppy" G LTPFLP
 I AKUUTF="T" R !!,"Insert tape < Press RETURN when ready >...",X:DTIME G:'$T!(X=U) LTPFLP1 W !! S X=$$TERMINAL^%HOSTCMD("tar vtf /dev/rct")
 I AKUUTF="F" R !!,"Insert floppy < Press RETURN when ready >...",X:DTIME G:'$T!(X=U) LTPFLP1 W !! S X=$$TERMINAL^%HOSTCMD("tar vt")
LTPFLP1 K AKUUTF,X Q
BKUPRST ;backup/restore from tape or floppy
 R !!,"Choose one",!!,?10,"1) Backup Files to Floppy",!,?10,"2) Restore Files from Floppy",!,?10,"3) Backup Files to Tape",!,?10,"4) Restore Files from Tape",!!,"Please select backup type (1,2,3, or 4): ",AKUUTYPE:DTIME
 W ! G:'$T!("1234"'[$E(AKUUTYPE)!(AKUUTYPE="")) BKUPRST1
 I AKUUTYPE=1!(AKUUTYPE=3) R !,"Enter files to save separated by spaces: ",AKUUFILES:DTIME G:'$T!(U[AKUUFILES) BKUPRST1
 I AKUUTYPE=2!(AKUUTYPE=4) S AKUUFILES="" R !,"Enter files to restore separated by spaces: ALL//",AKUUFILES:DTIME G:'$T!(AKUUFILES=U) BKUPRST1
 I AKUUTYPE=1!(AKUUTYPE=2) R !,"Insert floppy < Press RETURN when ready >...",X:DTIME G:'$T!(X=U) BKUPRST1
 I AKUUTYPE=3!(AKUUTYPE=4) R !,"Insert tape cartridge < Press RETURN when ready >...",X:DTIME G:'$T!(X=U) BKUPRST1
 I AKUUTYPE=1 W !! S X=$$TERMINAL^%HOSTCMD("tar cv "_AKUUFILES) G BKUPRST1
 I AKUUTYPE=2 W !! S:AKUUFILES="" X=$$TERMINAL^%HOSTCMD("tar xv") S:AKUUFILES]"" X=$$TERMINAL^%HOSTCMD("tar xv "_AKUUFILES) G BKUPRST1
 I AKUUTYPE=3 W !! S X=$$TERMINAL^%HOSTCMD("tar cvf /dev/rct "_AKUUFILES) G BKUPRST1
 W !! S:AKUUFILES="" X=$$TERMINAL^%HOSTCMD("tar xvf /dev/rct") S:AKUUFILES]"" X=$$TERMINAL^%HOSTCMD("tar xvf /dev/rct "_AKUUFILES) G BKUPRST1
BKUPRST1 K X,AKUUTYPE,AKUUFILES Q
VPUBLIC ;view uucppublic directory
 W !,"Current files in Public uucp directory....",!
 S X=$$TERMINAL^%HOSTCMD("ls -lL /usr/spool/uucppublic | more")
 R !,"< Press RETURN to continue >",Y:DTIME
 K X,Y Q
RESET ;reset azhxssdbk exabyte file image tracking
 W ! S X=$$TERMINAL^%HOSTCMD("/usr/mumps/azhxreset")
 K X Q
SSD ;shutdown mumps from Kernel menu in production environment
 S AKUUUCI=$P($ZU(0),","),AKUUVG=$P($ZU(0),",",2)
 S AKUUUI=$P($ZU(AKUUUCI,AKUUVG),","),AKUUVGI=$P($ZU(AKUUUCI,AKUUVG),",",2)
 W !,"Switching to MGR UCI....",!
 V 2:$J:1:2
 D ^SSD
 V 2:$J:AKUUVGI*32+AKUUUI:2 W !!,"Switching back to ",AKUUUCI," UCI....",!
SSD1 K AKUU,AKUUCPU,AKUUUCI,AKUUVG,AKUUUI,AKUUVGI    
 H 2 Q
UNIXKIL D ^%AUKVAR W ! S X=$$TERMINAL^%HOSTCMD("who -uTH")
 W !,"Enter tty DEVICE NUMBER to free up: "
 R AKUUTTY:DTIME W !!
 I AKUUTTY?1.2N S AKUUKILLIT="sync;sync;fuser -k /dev/tty"_AKUUTTY ZF  S X=$$TERMINAL^%HOSTCMD(AKUUKILLIT)
 I AKUUTTY="console" S AKUUKILLIT="sync;sync;fuser -k /dev/"_AKUUTTY ZF  S X=$$TERMINAL^%HOSTCMD(AKUUKILLIT)
 K AKUUTTY,AKUUKILLIT
 Q
CRBKUP ;Toggle cron backup on and off using /usr/mumps/cronbuon and off
 S DIR(0)="S^1:on;2:off",DIR("A")="Set backup on/off" D ^DIR
 W !
 I Y=1 S X=$$TERMINAL^%HOSTCMD("/usr/mumps/cronbuon")
 I Y=2 S X=$$TERMINAL^%HOSTCMD("/usr/mumps/cronbuoff")
 K X,Y,DIR Q
