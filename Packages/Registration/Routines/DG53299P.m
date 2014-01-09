DG53299P ;ALB/DW - Environment check routine for patch DG299 ; 8/11/00
 ;;5.3;Registration;**299,1015**;Aug 13, 1993;Build 21
 ;
 I $G(DUZ(0))'="@" D
 . W $C(7),!,"DUZ(0) must equal ""@"" to insure the data dictionary changes",!,"contained in this patch to be installed correctly."
 . S XPDQUIT=2
 Q
