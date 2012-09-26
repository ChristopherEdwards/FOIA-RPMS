VEN8I025 ; IHS/OIT/GIS - DIFROM SUPPLIMENT TO KIDS ; 
 ;;2.6;PCC+;**1,3**;APR 03, 2012;Build 24
 I DSEC F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DIC(19707.17,0,"AUDIT")
 ;;=@
 ;;^DIC(19707.17,0,"DD")
 ;;=@
 ;;^DIC(19707.17,0,"DEL")
 ;;=@
 ;;^DIC(19707.17,0,"LAYGO")
 ;;=@
 ;;^DIC(19707.17,0,"RD")
 ;;=@
 ;;^DIC(19707.17,0,"WR")
 ;;=@
