INHSYS07 ;JPD; 13 Nov 98 13:35;gis sys con data installation utility 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;CHCS TOOLS_450; GEN 4; 26-SEP-1996
 ;COPYRIGHT 1995 SAIC
 Q
%GCMP ;Global file element compare
 N %FIL,%FILNM,%EL1,%EL2,DIC,Y,%THATVOL,%THATUCI,%THISVOL,%THISUCI,%GBL
 N %ROOT,%XIEN,%NIEN,%DONE,INY,GBL,%UTL,X,ND
 I ^%ZOSF("OS")'["VAX" W !,"Not implemented yet" Q
 D ENV^UTIL
 W @IOF
 Q:'$$GETFLE(.%FIL,.%NIEN,.%FILNM)
 S (%THATUCI,%THATVOL)="",%DONE=0
 F  D  Q:%DONE
 .U 0 R !,"Enter UCI you want to compare element from: ",%THATUCI:DTIME
 .I %THATUCI["?" W !,"Pick a valid UCI" Q
 .I %THATUCI="^"!'$L(%THATUCI) S %DONE=1 Q
 .I '$$UCICHECK^%ZTF(%THATUCI) W !,"Not a valid UCI" Q
 .I %THATUCI["," S %THATVOL=$P(%THATUCI,",",2),%THATUCI=$P(%THATUCI,","),%DONE=1 Q
 .U 0 R !,"Enter VOL you want to compare element from: ",%THATVOL:DTIME
 .I %THATVOL["?" W !,"Pick a valid volume set" Q
 .I %THATVOL="^"!'$L(%THATVOL) S %DONE=1 Q
 .I %THATVOL=^%ZOSF("VOL") W !,"You must pick a different Volume set" Q
 .I '$$UCICHECK^%ZTF(%THATUCI_","_%THATVOL) W !,"Not a valid UCI or Volume set" Q
 .S %DONE=1
 Q:'$L(%THATUCI)!'$L(%THATVOL)!(%THATVOL="^")!(%THATUCI="^")
 S X=%FILNM,%GBL=$P(%GBL,"^",2)
 S Y=$O(@("^[%THATUCI,%THATVOL]"_%GBL_"""B"","""_X_""","""")"))
 I Y="" W !,"File element does not exist in ["_%THATUCI_","_%THATVOL_"]"
 E  D
 .S %ROOT="^[%THATUCI,%THATVOL]"_%GBL
 .S %XIEN=Y,ND=%ROOT_Y_")"
 .S %UTL="^UTILITY(""INHSYS"","_$J_","""_%FIL_""","
 .F  S ND=$Q(@ND) Q:%XIEN'=+$P(ND,%GBL,2)  D
 ..S INY=@ND,GBL=%UTL_$P(ND,%GBL,2),@GBL=INY
 .D CMP(%NIEN,"^"_%GBL,%FIL,%XIEN)
 Q
CMP(%NIEN,%ROOT,%FL,%OIEN,%RSLV) ;Compare global entries
 ; %NIEN - ien of data in current environment
 ; %ROOT - Root node of file
 ; %FL - Fileman File number
 ; %OIEN - ien from other environment
 ; %RSLV - 1 - Resolve ptr values 0 - don't resolve
 N %UTILITY,%NODE,%L1,%L2,%P
 K ^UTILITY($J,%FL)
 S %RSLV=$G(%RSLV)
 ;Extract data from exisitng global
 D XTRK(%NIEN,%ROOT,"^UTILITY($J,"""_%FL_""",",%FL)
 ;resolve pointer values
 I %RSLV D EXPND^INHSYS09(%NIEN,%FL,%ROOT,%ROOT_%NIEN_",",1,%NIEN,0,%NIEN)
 ;Build temp storage for existing files
 S %NODE="^UTILITY($J,%FL,%NIEN)",%UTILITY(1,0)=0
 F  S %NODE=$Q(@%NODE) Q:'$L(%NODE)  Q:+$QS(%NODE,3)'=%NIEN  D
 .S %UTILITY(1,0)=%UTILITY(1,0)+1
 .S %UTILITY(1,%UTILITY(1,0))=$P(%NODE,",",4,999)_"="_@%NODE
 S %UTILITY(1,0)=%UTILITY(1,0)+1,%UTILITY(1,%UTILITY(1,0))=""
 ;Build temp storage for new files
 S %NODE="^UTILITY(""INHSYS"",$J,%FL,%OIEN)",%UTILITY(2,0)=0
 F  S %NODE=$Q(@%NODE) Q:'$L(%NODE)  Q:+$QS(%NODE,4)'=%OIEN  D
 .S %UTILITY(2,0)=%UTILITY(2,0)+1
 .S %UTILITY(2,%UTILITY(2,0))=$P(%NODE,",",5,999)_"="_@%NODE
 S %UTILITY(1,0)=%UTILITY(1,0)+1,%UTILITY(1,%UTILITY(1,0))=""
 D GCMP(.%UTILITY)
 K ^UTILITY($J)
 Q
GCMP(%UTILITY) ;Compare values from %UTILITY nodes
 ; Input:
 ; %UTILITY - Global with files to compare
 N %L1,%L2,%FOUND
 S (%L1,%L2)=1,%FOUND=0
 ;Determine differences
 F  Q:%UTILITY(1,0)<%L1!(%UTILITY(2,0)<%L2)  D
 .I %UTILITY(1,%L1)'=%UTILITY(2,%L2) D
 ..D PG
 ..I '%FOUND W !,"The following difference(s) appear for the above entry:",!
 ..S %FOUND=1
 ..D DIFF(.%L1,.%L2,.%UTILITY)
 .S %L1=%L1+1,%L2=%L2+1
 I '%FOUND W !,"No differences found",!
 Q
DIFF(%L1,%L2,%UTILITY) ;Diff found
 ;Input/Output:
 ; %L1 - Position in %UTILITY global node 1
 ; %L2 - Position in %UTILITY global node 2
 ;Establish point where diff took place
 S %P(1)=%L1,%P(2)=%L2,%P=0
 F  Q:'$$DL(.%P,.%L1,.%L2,.%UTILITY)
 Q
DL(%P,%L1,%L2,%UTILITY) ;
 ;%P - Position in Array
 ; %L1 - Position in %UTILITY global node 1
 ; %L2 - Position in %UTILITY global node 2
 N %A2,%A,%J,%K,%EXIT
 ;Increment %P by 1 and %A by %P and %P(%A) by 1
 S %P=%P+1#2,%A=%P+1,%P(%A)=%P(%A)+1
 S:%UTILITY(%A,0)'>%P(%A) %P(%A)=%UTILITY(%A,0)
 I %UTILITY(%A,%P(%A))="" D  Q 0
 .S %A2=%P+1#2+1,%P(%A2)=%UTILITY(%A2,0)
 .S %J=%P(1),%K=%P(2)
 .D WRITE
 S %EXIT=0
 ;loop and look for same values between utility globals
 S %J=%P(1) F %K=%L2:1:%P(2) I %UTILITY(1,%J)=%UTILITY(2,%K) D WRITE S %EXIT=1 Q
 Q:%EXIT 0
 S %K=%P(2) F %J=%L1:1:%P(1) I %UTILITY(1,%J)=%UTILITY(2,%K) D WRITE S %EXIT=1 Q
 Q '%EXIT
WRITE ;
 N %Z,%LI
 S %P(1)=%J,%P(2)=%K
 ;Write existing lines that are different
 W !,"Current Environment "_$G(^%ZOSF("VOL"))_"  ***********************",!
 F %Z=%L1:1:%P(1) I %UTILITY(1,%Z)'="" D
 .S %LI=%UTILITY(1,%Z)
 .D PG
 .W ?2,%Z,")",?7,%ROOT,%NIEN,",",%LI,!
 ;
 ;Write new lines that are different
 W !,"Other Environment  --------",!
 F %Z=%L2:1:%P(2) I %UTILITY(2,%Z)'="" D
 .S %LI=%UTILITY(2,%Z)
 .D PG
 .W ?2,%Z,")",?7,%ROOT,%OIEN,",",%LI,!
 W !,"***************",!
 ;set counters to new repositioned values
 S %L1=%P(1),%L2=%P(2)
 Q
XTRK(%XIEN,%ROOT,%UTL,%FILE) ;xtract existing global
 ; Input:
 ; %XIEN - ien of file extracting data from
 ; %ROOT - global root in fileman format
 ; %UTL - temporary storage buffer
 ; %FILE - file 4000,4005,4006,4004,4011,4010,4012,4090.2,4012.1,4020
 ; Output - ^UTILITY global
 N ND,INY,GBL
 S ND=%ROOT_%XIEN_")"
 F  S ND=$Q(@ND) Q:%XIEN'=+$P(ND,%ROOT,2)  D
 .S INY=@ND,GBL=%UTL_$P(ND,%ROOT,2),@GBL=INY
 Q
PG ;Page break
 I IOSL-5'>$Y D
 .I $E(IOST)="C",INCR,$$CR^UTSRD(0,IOSL-1)
 .W @IOF
 Q
GETFLE(%FIL,%NIEN,%FILNM) ;Get file entry
 ; Output:
 ;  %FIL - File Number
 ;  %NIEN - Entry in file
 ;  %FILNM - File name
 S DIC="^DIC(",DIC(0)="AEQ",DIC("A")="Enter File Name:  "
 D ^DIC
 Q:Y=-1 0
 S %FIL=+Y
 S (%GBL,DIC)=^DIC($P(Y,U),0,"GL"),DIC("A")="Enter File Element Name:  "
 D ^DIC
 Q:Y=-1 0
 S %NIEN=+Y,%FILNM=$P(Y,U,2)
 Q 1
