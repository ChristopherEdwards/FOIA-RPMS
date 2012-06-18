AVAPI006 ; ; 15-AUG-1995
 ;;93.2;PATCHES FOR VA SUPPPORT FILES;;AUG 15, 1995
 I DSEC F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DIC(200,0,"DD")
 ;;=#
 ;;^DIC(200,0,"DEL")
 ;;=#
 ;;^DIC(200,0,"LAYGO")
 ;;=#
 ;;^DIC(200,0,"RD")
 ;;=#
 ;;^DIC(200,0,"WR")
 ;;=#
