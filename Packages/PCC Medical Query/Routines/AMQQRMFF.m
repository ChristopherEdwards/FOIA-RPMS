AMQQRMFF ; IHS/CMI/THL - ASCII FLAT FILE MAKER ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
CHECK S %=$$KEYCHECK^AMQQUTIL("AMQQZPROG")
 I '% W !!,"Sorry, you do not hold a Q-Man programmer access key.  Request denied!",*7 Q
 I ^DD("OS")'=8 W !!,"Sorry, this option is only available on systems which use Micronetics MUMPS",!,"Request denied!",*7 Q
 I AMQQCCLS'="P" W !!,"Sorry, this option available for searches that have a subject dealing with",!,"patients.",*7 Q
 W @IOF,!,?20,"*****  EXPORT ASCII FILE  *****",!!!
 F I=1:1 S X=$E($T(TEXT+I),4,99) Q:X=""  W !,X
 S AMQQFFF=""
 S AMQV("OPTION")="FF"
EXIT K %
 Q
 ;
TEXT ;
 ;;I will format the output as a flat ASCII file.  Each entry may be up to 256
 ;;characters in length.  The fields are variable length and '^' is used
 ;;as a delimiter.  In a moment, I will ask you for a device.  Queue the job to
 ;;the HOST FILE SERVER and, when prompted, enter the path/name of the file
 ;;which will be created in your directory.
 ;; 
 ;;Altos system users will have to use the "DOS" utilities to convert the file
 ;;to a DOS format when moving the file onto a floppy disk.
 ;;
OUTPUT ; ENTRY POINT FOR PRODUCING A FLAT FILE OUTPUT
 N X,Y,Z,%,A,I,AMQQFFI,AMQQFFX,AMQQFFZ
 I $G(AMQQFFF) G LIST
 S %="NAME^CHART #"
 S X=0
 F  S X=$O(^UTILITY("AMQQ",$J,"VAR NAME",X)) Q:'X  S Y=^(X),%=%_U_$P(^AMQQ(1,+Y,4,$P(Y,U,2),0),U)
 S AMQQFFF=1
 W %,!!
LIST I '$D(^DPT(AMQP(0),0)) Q
 S AMQQFFS=$P(^DPT(AMQP(0),0),U) ; save patient name rather than DFN
 S (AMQQFFS,AMQQFFZ)=AMQQFFS_U_$P($G(^AUPNPAT(AMQP(0),41,DUZ(2),0)),U,2) ; include chart #
 I $P(AMQQFFS,U,2)]"" S $P(AMQQFFS,U,2)=$P(^AUTTLOC(DUZ(2),0),U,7)_$P(AMQQFFS,U,2)
 I $G(AMQQMULL),$D(^UTILITY("AMQQ",$J,"AG",AMQQMULL)) D MLIST Q
 D LSET
 Q
 ;
LSET F AMQQFFI=9:0 S AMQQFFI=$O(^UTILITY("AMQQ",$J,"VAR NAME",AMQQFFI)) Q:'AMQQFFI  S Y=^(AMQQFFI),X=AMQP(AMQQFFI) D TRANS S AMQQFFS=AMQQFFS_U_X
 W AMQQFFS,!
 Q
 ;
TRANS I X="+"!(X="-")!(X="") Q
 I +Y=7 S X=(DT-X)\10000 Q
 I +Y,$P(Y,U,2),$D(^AMQQ(1,+Y,4,$P(Y,U,2),1)) N % X ^(1)
 Q
 ;
MLIST F AMQQHOLD=0:0 S AMQQHOLD=$O(^UTILITY("AMQQ",$J,"AG",AMQQMULL,AMQQHOLD)) Q:'AMQQHOLD  S AMQQFFAG=^(AMQQHOLD) D M1
 K AMQQHOLD,^UTILITY("AMQQ",$J,"AG",AMQQMULL),X,Y,A,I,%,AMQQFFAG
 Q
 ;
M1 S AMQQFFX=AMQQMUFV-1
 F AMQQFFI=1:1:AMQQMUNV S AMQQFFX=$O(^UTILITY("AMQQ",$J,"VAR NAME",AMQQFFX)) Q:'AMQQFFX  S Y=^(AMQQFFX),A=$P(Y,U,2) I A S AMQP(AMQQFFX)=$P(AMQQFFAG,U,A)
 S AMQQFFS=AMQQFFZ
 D LSET
 Q
 ;
