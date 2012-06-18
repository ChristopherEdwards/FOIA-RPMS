ABPAOC0A ;OPEN UNIX HFS DEVICE; [ 05/24/91  1:33 PM ]
 ;;1.4;AO PVT-INS TRACKING;*0*;IHS-OKC/KJR;JULY 25, 1991
A0 D DT^DICRW S:$D(EFLG)'=1 EFLG=0
 W !!,"Get input from:    [C]artridge   or   [F]ile     F// "
 R X:DTIME I $T=0 D  Q
 .S EMSG="<<< INVALID OR NO DEVICE SELECTED - JOB ABORTED >>>"
 .S EFLG=EFLG+1
 I X="" S X="F"
 I (X'["C")&(X'["F") D  Q
 .S EMSG="<<< INVALID OR NO DEVICE SELECTED - JOB ABORTED >>>"
 .S EFLG=EFLG+1
 ;
CART I X["C" K %DEV,%IN S %FN=""_"/dev/rct"_"" D OPEN D  Q
 .I +EFLG>0 D
 ..S EMSG="<<< DEVICE UNAVAILABLE - JOB ABORTED >>>",EFLG=EFLG+1
 ;
FILE W !! S ABPA("CMD")="cd /usr/spool/uucppublic; ls ABPV* | sort "
 S ABPA("CMD")=ABPA("CMD")_"> abpv.list; cd /usr/mumps"
 S X=$$TERMINAL^%HOSTCMD(ABPA("CMD"))
 K %DEV,%IN S %FN=""_"/usr/spool/uucppublic/abpv.list"_"" D OPEN
 I +EFLG>0 D  Q
 .S EMSG="<<< DEVICE UNAVAILABLE - JOB ABORTED >>>",EFLG=EFLG+1
 F I=1:1 U %DEV R X Q:X=""  S ABPAFILE(I)=X
 C %DEV U IO(0) I $D(ABPAFILE(1))'=1 D  Q
 .S EMSG="<<< NO FILES AVAILABLE TO MERGE - JOB ABORTED >>>"
 .S EFLG=EFLG+1
 F I=1:1 Q:$D(ABPAFILE(I))'=1  W !?10,I,".  ",ABPAFILE(I)
SELECT W !!,"Select the FILE to use (""^"" to CANCEL)// "
 R X:DTIME I $T=0!(X["^")!(X="") D  Q
 .S EMSG="<<< NO FILE SELECTED - JOB ABORTED >>>",EFLG=EFLG+1
 S X=$S($D(ABPAFILE(X))=1:ABPAFILE(X),1:"INVALID SELECTION") W "  ",X
 I X="INVALID SELECTION" G SELECT
 S %FN=""_"/usr/spool/uucppublic/"_X_""
 K %DEV,%IN D OPEN D  S:+EFLG'>0 IO=+%DEV Q
 .I +EFLG>0 D
 ..S EMSG="<<< DEVICE UNAVAILABLE - JOB ABORTED >>>",EFLG=EFLG+1
 ;
OPEN ;;VARIABLES USED FOR MSM HFS DEVICE OPEN UTILITY
 ;;   %DEV    -- DEVICE NUMBER, INITIALIZED TO 51
 ;;   %FN     -- UNIX FILE NAME (USING FULL PATH NAME)
 ;;   %IN     -- OPEN PARAMETER (DEFAULT = 1 - READ ONLY)
 ;;   %ZA     -- RESULT CODE (-1 = ERROR)
 I $D(%DEV)'=1 S %DEV=51
 I %DEV=55 S %DEV=51
 I $D(%IN)'=1 S %IN=1
 O @$S('$D(%DEVDLM):"%DEV:(%FN:$S(%IN:""R"",1:""M"")):0",1:"%DEV:(%FN:$S(%IN:""R"",1:""M"")::::%DEVDLM):0") E  S %DEV=%DEV+1 G:%DEV<55 OPEN
 E  S EFLG=EFLG+1 Q
 U %DEV S %ZA=$ZA I %ZA<0 C %DEV
 Q
