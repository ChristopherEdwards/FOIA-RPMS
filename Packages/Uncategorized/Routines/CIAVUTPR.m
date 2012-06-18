CIAVUTPR ;MSC/IND/DKM - Parameter management ;04-May-2006 08:19;DKM
 ;;1.1V2;VUECENTRIC FRAMEWORK;;Mar 20, 2007
 ;;Copyright 2000-2006, Medsphere Systems Corporation
 ;=================================================================
 ; Load a parameter template
GETTPL(DATA,TPL) ;
 N PAR,SEQ,CNT,LP,X0,X1
 S:TPL'=+TPL TPL=+$$FIND1^DIC(8989.52,,,TPL)
 I '$D(^XTV(8989.52,TPL,0)) S DATA(1)="-1^Not found" Q
 S CNT=1,SEQ="",X0=^XTV(8989.52,TPL,0),X1=+$P(X0,U,3)
 S X1=$S(X1=4:"DIV",X1=4.2:"SYS",X1=9.4:"PKG",X1=49:"SRV",X1=200:"USR",1:"")
 I '$L(X1) S DATA(1)="-2^Bad entity" Q
 S $P(X0,U,3)=X1,DATA(1)=TPL_U_X0
 F  S SEQ=$O(^XTV(8989.52,TPL,10,"B",SEQ)),LP=0 Q:'$L(SEQ)  D
 .F  S LP=$O(^XTV(8989.52,TPL,10,"B",SEQ,LP)) Q:'LP  D
 ..S PAR=+$P($G(^XTV(8989.52,TPL,10,LP,0)),U,2)
 ..S X0=$G(^XTV(8989.51,PAR,0)),X1=$G(^(1))
 ..S:$L(X0) CNT=CNT+1,DATA(CNT)=PAR_U_$P(X0,U)_U_$P(X0,U,2)_U_X1
 Q
