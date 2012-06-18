XPDPINIT ;SFISC/RSD - Load a Packman Message using KIDS ; 6 Feb 95 14:48 [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1005,1007**;APR 1, 2003 
 ;;8.0;KERNEL;**5**;Jul 10, 1995
 I '$D(^XMB(3.9,+$G(XMZ),0)) W !!,"NO message to install!!" Q
 I $T(^XPDIPM)="" W !!,"KIDS doesn't exist!!" Q
 G ^XPDIPM
