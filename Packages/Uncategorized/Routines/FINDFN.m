%FINDFN(FN,JOB,%DEV) ;BFH;RETURN FILE NAME FOR HFS DEVICE [ 04/02/2003   8:51 AM ]
 ;;KERNEL;8.0;**1001,1002,1003,1004,1005,1007**;APR 1, 2003
 ;Copyright Micronetics Design Corp. @1997
 ;
 ; /IHS/HQW/JLB  3/6/98  This routine to be used with MSM 4.3 or
 ; greater.  It will not work with MSM versions below 4.3.
 ;
 ; Usage:
 ;  I $$^%FINDFN(.F,J,51) ; returns file name for job J, dev 51 in F
 ;  ELSE  ; error, or file not found, or unsupported OS
 ;      or
 ;  U HFSDEV I $$^%FINDFN(.FN) ; returns file name for $I in FN
 ;
 S $ZT="ERR^%FINDFN"
 NEW %DDB,OS,PS
 S VER=$P($ZV,"ersion ",2)
 S OS=$V(0,-4,2)#16  ; 3=UNIX, 8=PC/PLUS, 10=NT
 S PS=$V(10,-4,2) ; word size
 I '$D(%DEV) S %DEV=$I ; must be an HFS device
 I '$D(JOB) S JOB=$J ; default to my $J
 I '$V($V(4*%DEV+$V(7,-5),-3,0)+12,-3,0) Q 0 ; device not in use
 S %DDB=$V(4*%DEV+$V(7,-5),-3,0) ; starting HFS ddb
 F  S %DDB=$V(%DDB+12,-3,0) Q:'%DDB  D HFS Q:%J
 I %J<1 Q 0  ; not found or unsupported OS
 Q 1
HFS ;
 S %J=$V(%DDB+16,-3,2)+$V(272,-4,4) ; job that owns this ddb
 I %J'=JOB S %J=0 Q  ; not our job
 ; our job found
 ; get current file name
 I VER<4.3,VER>3 S FN=$P($V(%DDB+52,-3,127,1),$C(0)) Q
 ; Version 4.3
 I OS=10 S FN=$P($V(%DDB+52,-3,261,9),$C(0)) Q  ; NT
 I OS=3,PS=8 S FN=$P($V(%DDB+32,-3,128,9),$C(0)) Q  ; Alpha UNIX
 I OS=3!(OS=8) S FN=$P($V(%DDB+52,-3,128,9),$C(0)) Q  ; the rest
 S %J=-1 ; not supported for this OS
 Q
ERR ;
 Q $ZE
